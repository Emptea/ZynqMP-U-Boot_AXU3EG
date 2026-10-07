`timescale 1ps/1ps

module DspDataProcessor
	#(
		parameter SIGNAL_WIDTH = 32,
		parameter FRAME_LENGTH = 141,
		parameter SEQUENCE_NUMBER = 26,
		parameter SORTER_DEPTH = 15,
		parameter COEF_WIDTH = 16,
		parameter SORTER_ADDRESS_WIDTH = 5,
		parameter LOCAL_STORAGE_ADDRESS_WIDTH = 8,
		parameter COEF_LEVEL_ONE = 12,
		parameter FAR_LENGTH = 101,
		parameter CLOSE_LENGTH = 40
	)
	(
		input [SIGNAL_WIDTH - 1: 0]i_signal,
		input [SIGNAL_WIDTH - 1: 0]i_signal_aux,
		input [2: 0]i_signal_channel,
		input i_signal_aux_channel,
		input [8: 0]i_signal_frq_channel,
		input i_signal_valid,
		input i_start_processing,

		input [4: 0]i_selected_rank,
		input [SIGNAL_WIDTH - 1: 0]i_threshold,
		input [COEF_WIDTH - 1: 0]i_coef,

		input i_reset,
		input i_clock,

		output reg [31: 0]o_shoulder_data,
		output reg o_shoulder_data_start,
		output reg o_shoulder_data_valid,
		output reg o_shoulder_data_finish,

		output reg [31: 0]o_rank_sorter_data,
		output reg o_rank_sorter_data_start,
		output reg o_rank_sorter_data_valid,
		output reg o_rank_sorter_data_finish,

		output reg [31: 0]o_detection_data,
		output reg o_detection_data_start,
		output reg o_detection_data_valid,
		output reg o_detection_data_finish,

		output reg [31: 0]o_data,
		output reg o_data_start,
		output reg o_data_valid,
		output reg o_data_finish,
		
		output reg o_ready

	);

	localparam BUS_WIDTH =  2 * SIGNAL_WIDTH + 3 + 1 + 9;
	localparam MEASURED_WIDTH = BUS_WIDTH  + 8;
	localparam DATA_SIZE = FRAME_LENGTH * SEQUENCE_NUMBER;
	localparam CURRENT_OFFSET = FRAME_LENGTH * SEQUENCE_NUMBER / 2 - FRAME_LENGTH;
	localparam ADDRESS_SIZE = 13;
	//localparam MEM_SIZE = DATA_SIZE + FRAME_LENGTH;
	localparam MEM_SIZE = 1 << ADDRESS_SIZE;

	localparam FAR_MEDIAN_LENGTH = (FAR_LENGTH & 1) ? (FAR_LENGTH / 2 + 1) : (FAR_LENGTH / 2);
	localparam CLOSE_MEDIAN_LENGTH = (CLOSE_LENGTH & 1) ? (CLOSE_LENGTH / 2 + 1) : (CLOSE_LENGTH / 2);

	reg [ADDRESS_SIZE - 1: 0]read_address, write_address,
		write_detected_address, read_detected_address,
		final_address, start_address, last_address, 
		prestart_address, prelast_address, working_address;

(* mark_debug = "true" *)		
	reg signed[SIGNAL_WIDTH - 1: 0] threshold;

(* mark_debug = "true" *)		
	reg [COEF_WIDTH - 1: 0] coef;

(* mark_debug = "true" *)		
	wire [SIGNAL_WIDTH - 1: 0]signal;
(* mark_debug = "true" *)		
	wire [SIGNAL_WIDTH - 1: 0]signal_aux;
(* mark_debug = "true" *)		
	wire [2: 0]signal_channel;
(* mark_debug = "true" *)		
	wire signal_aux_channel;
(* mark_debug = "true" *)		
	wire [8: 0]signal_frq_channel;

	reg [BUS_WIDTH - 1: 0]data_to_storage;
	reg data_to_storage_valid;
	wire [BUS_WIDTH - 1: 0]data_from_storage;
	
	reg [5 * ADDRESS_SIZE - 1: 0]addresses;
	reg [5 * SIGNAL_WIDTH - 1: 0]read_signals;

	reg [SIGNAL_WIDTH: 0]accumulator;
	
	reg signed [SIGNAL_WIDTH - 1: 0]current_delta, prev_delta;

	v_ram_2_port
		#(
			.p_data_width(BUS_WIDTH),
			.p_word_count(MEM_SIZE),
			.p_addr_width(ADDRESS_SIZE)
		)
		inst_storage
		(	
			.i_data(data_to_storage),
			.i_data_valid(data_to_storage_valid),
			.i_write_addr(write_address),
			.i_read_addr(read_address),
			.i_read_clock(i_clock),
			.i_write_clock(i_clock),
		
			.o_data(data_from_storage)
		);

	assign {
		signal,
		signal_aux,
		signal_channel,
		signal_aux_channel,
		signal_frq_channel				
	} = data_from_storage;

(* mark_debug = "true" *)		
	reg data_to_detection;
(* mark_debug = "true" *)		
	reg data_to_detection_valid;
(* mark_debug = "true" *)		
	reg [LOCAL_STORAGE_ADDRESS_WIDTH - 1: 0]detection_write_address;
(* mark_debug = "true" *)		
	reg [LOCAL_STORAGE_ADDRESS_WIDTH - 1: 0]detection_read_address;
(* mark_debug = "true" *)		
	wire data_from_detection;
	

	wire current_detected;

	v_ram_2_port
		#(
			.p_data_width(1),
			.p_word_count(FRAME_LENGTH),
			.p_addr_width(LOCAL_STORAGE_ADDRESS_WIDTH)
		)
		inst_detection_storage
		(	
			.i_data(data_to_detection),
			.i_data_valid(data_to_detection_valid),
			.i_write_addr(detection_write_address),
			.i_read_addr(detection_read_address),
			.i_read_clock(i_clock),
			.i_write_clock(i_clock),
			.o_data(data_from_detection)
		);

	reg [SIGNAL_WIDTH - 1: 0]data_to_median_storage;
	reg data_to_median_storage_valid;
	reg [LOCAL_STORAGE_ADDRESS_WIDTH - 1: 0]median_storage_write_address;
	reg [LOCAL_STORAGE_ADDRESS_WIDTH - 1: 0]median_storage_read_address;
	wire [SIGNAL_WIDTH - 1: 0]data_from_median_storage;

	v_ram_2_port
		#(
			.p_data_width(SIGNAL_WIDTH),
			.p_word_count(FRAME_LENGTH),
			.p_addr_width(LOCAL_STORAGE_ADDRESS_WIDTH)
		)
		inst_median_storage
		(	
			.i_data(data_to_median_storage),
			.i_data_valid(data_to_median_storage_valid),
			.i_write_addr(median_storage_write_address),
			.i_read_addr(median_storage_read_address),
			.i_read_clock(i_clock),
			.i_write_clock(i_clock),
			.o_data(data_from_median_storage)
		);

	reg [MEASURED_WIDTH - 1: 0]data_to_measured;
	reg data_to_measured_valid;
	reg [LOCAL_STORAGE_ADDRESS_WIDTH - 1: 0]measured_storage_write_address;
	reg [LOCAL_STORAGE_ADDRESS_WIDTH - 1: 0]measured_storage_read_address;
	wire [MEASURED_WIDTH - 1: 0]data_from_measured;

	wire [SIGNAL_WIDTH - 1: 0]measured_signal;
	wire [SIGNAL_WIDTH - 1: 0]measured_signal_aux;
	wire [2: 0]measured_signal_channel;
	wire measured_signal_aux_channel;
	wire [8: 0]measured_signal_frq_channel;
	wire [7: 0]measured_time;

	assign {
		measured_time,
		measured_signal,
		measured_signal_aux,
		measured_signal_channel,
		measured_signal_aux_channel,
		measured_signal_frq_channel
	} = data_from_measured;
	
	v_ram_2_port
		#(
			.p_data_width(MEASURED_WIDTH),
			.p_word_count(FRAME_LENGTH),
			.p_addr_width(LOCAL_STORAGE_ADDRESS_WIDTH)
		)
		inst_measured_storage
		(	
			.i_data(data_to_measured),
			.i_data_valid(data_to_measured_valid),
			.i_write_addr(measured_storage_write_address),
			.i_read_addr(measured_storage_read_address),
			.i_read_clock(i_clock),
			.i_write_clock(i_clock),
			.o_data(data_from_measured)
		);

	reg [SIGNAL_WIDTH - 1: 0]prev_signal_1, prev_signal_2;
	reg left_max, right_max, local_threshold_passed;
	
	integer state_write;

	localparam e_write_process_reset = 0;
	localparam e_write_process_start = 1;
	localparam e_write_process_run = 2;


	integer counter_written_reset;

	always @(posedge i_clock)
	begin
		if(i_reset)
		begin
			write_address <= 0;
			counter_written_reset <= 0;
			state_write <= e_write_process_reset;
			data_to_storage_valid <= 0;


			o_ready <= 0;
		end
		else 
		begin
			case(state_write)
				e_write_process_reset:
				begin
					data_to_storage_valid <= 1;
					data_to_storage <= 0;
					if(data_to_storage_valid) 
					begin
						write_address <= write_address + 1;
						counter_written_reset <= counter_written_reset + 1;
					end

					if(counter_written_reset == MEM_SIZE) state_write <= e_write_process_start;
					o_ready <= 0;
				end

				e_write_process_start:
				begin
					o_ready <= 1;
					write_address <= 0;
					data_to_storage_valid <= 0;
					state_write <= e_write_process_run;
				end

				e_write_process_run:
				begin
					data_to_storage <= {
						i_signal,
						i_signal_aux,
						i_signal_channel,
						i_signal_aux_channel,
						i_signal_frq_channel
					};

					data_to_storage_valid <= i_signal_valid;

					if(data_to_storage_valid) write_address <= write_address + 1;
				end
			endcase

		end
	end

	wire [SIGNAL_WIDTH - 1: 0]data_for_sorter;
	reg data_for_sorter_valid;
	wire data_from_sorter_valid;
	wire [SIGNAL_WIDTH - 1: 0]data_from_sorter;
	wire median_sorter_ready;

	assign data_for_sorter = (accumulator[SIGNAL_WIDTH: 1] == 0) ? 1 : accumulator[SIGNAL_WIDTH: 1];
	
	reg reset_median_sorter;
	RankSorter
		#(
			.DATA_WIDTH(SIGNAL_WIDTH),
			.ADDRESS_WIDTH(SORTER_ADDRESS_WIDTH),
			.DEPTH(SORTER_DEPTH)
		)
		inst_sorter
		(
			.i_data(data_for_sorter),
			.i_data_valid(data_for_sorter_valid),
	
			.i_rank(i_selected_rank),
	
			.i_reset(reset_median_sorter),
			.i_clock(i_clock),
			
			.o_data(data_from_sorter),
			.o_data_valid(data_from_sorter_valid),
			
			.o_ready(median_sorter_ready)
		);		

	integer state;

	localparam e_wait = 0;
	localparam e_reset_far_median_sorter = 1;
	localparam e_wait_reset_far_median_sorter = 2;
	localparam e_check_fill_median_far = 3;
	localparam e_read_for_median_far = 4;
	localparam e_wait_for_median_far_1 = 5;
	localparam e_wait_for_median_far_2 = 6;
	localparam e_start_median_far_1 = 7;
	localparam e_wait_median_far = 8;
	localparam e_save_median_far_1 = 9;
	localparam e_reset_close_median_sorter = 10;
	localparam e_wait_reset_close_median_sorter = 11;
	localparam e_check_fill_median_close = 12;
	localparam e_read_for_median_close = 13;
	localparam e_wait_for_median_close_1 = 14;
	localparam e_wait_for_median_close_2 = 15;
	localparam e_start_median_close_1 = 16;
	localparam e_wait_median_close = 17;
	localparam e_save_median_close_1 = 18;
	localparam e_start_detection = 19;
	localparam e_check_detection = 20;
	localparam e_read_for_detection = 21;
	localparam e_wait_read_for_detection = 22;
	localparam e_calc_detection_1 = 23;
	localparam e_calc_detection_2 = 24;
	localparam e_start_measure_data = 25;
	localparam e_check_measure_data = 26;
	localparam e_read_measure = 27;
	localparam e_wait_read_measure_1 = 28;
	localparam e_wait_read_measure_2 = 29;
	localparam e_save_measure = 30;
	localparam e_process_measure_1 = 31;
	localparam e_process_measure_2 = 32;
	localparam e_process_measure_3 = 33;
	localparam e_finish = 34;
	localparam e_save_data = 35;
	localparam e_send_time = 36;
	localparam e_send_count = 37;
	localparam e_check_send = 38;
	localparam e_wait_read_measured_1 = 39;
	localparam e_wait_read_measured_2 = 40;
	localparam e_send_data_1 = 41;
	localparam e_send_data_2 = 42;
	localparam e_send_data_3 = 43;
	localparam e_start_median_far_2 = 44;
	localparam e_save_median_far_2 = 45;
	localparam e_start_median_close_2 = 46;
	localparam e_save_median_close_2 = 47;
	localparam e_send_data_4 = 48;



	wire [COEF_WIDTH + SIGNAL_WIDTH - 1: 0]multiplier_data_out;
	wire [SIGNAL_WIDTH - 1: 0]local_threshold;

	multiplier
	  #(
	    .p_value_1_width(SIGNAL_WIDTH),
	    .p_value_2_width(COEF_WIDTH),
	    .p_pipeline_mult_in(1),
	    .p_pipeline_mult_out(1)
	  )
	  inst_mul
	  (
	    .i_value_1(data_from_median_storage),
	    .i_value_2(coef),
	    
	    .i_reset(i_reset),
	    .i_clock_enable(1),
	    .i_clock(i_clock),
	    
	    .o_value(multiplier_data_out)
	  );

	assign local_threshold = multiplier_data_out[COEF_LEVEL_ONE +: SIGNAL_WIDTH];

	reg [31: 0]counter_rxed_frames;
	reg [31 :0]counter_measured_data;
	
	reg signed [LOCAL_STORAGE_ADDRESS_WIDTH: 0]read_offset;
	reg signed [LOCAL_STORAGE_ADDRESS_WIDTH: 0]write_offset;
	
	reg [5: 0]counter_wait;
	
	reg [3: 0]counter_read;
	
	wire [SIGNAL_WIDTH - 1: 0]last_signal, prelast_signal, start_signal, prestart_signal;
	reg current_delta_passed, prev_delta_passed;


	assign {
		last_signal,
		prelast_signal,
		start_signal,
		prestart_signal
	} = read_signals[0 +: 4 * SIGNAL_WIDTH];

	reg [4: 0]delay_start;
	reg start_processing;

	always @(posedge i_clock)
	begin
		if(i_reset) {start_processing, delay_start} <= 0;
		else {start_processing, delay_start} <= {delay_start, i_start_processing};

		if(i_reset)
		begin
			state <= e_wait;
			write_detected_address <= 0;
			read_detected_address <= 0;
			data_for_sorter_valid <= 0;
			counter_rxed_frames <= 0;

			o_shoulder_data_start <= 0;
			o_shoulder_data_valid <= 0;
			o_shoulder_data_finish <= 0;

			o_rank_sorter_data_start <= 0;
			o_rank_sorter_data_valid <= 0;
			o_rank_sorter_data_finish <= 0;

			o_detection_data_start <= 0;
			o_detection_data_valid <= 0;
			o_detection_data_finish <= 0;

			o_data_start <= 0;
			o_data_valid <= 0;
			o_data_finish <= 0;			
		end
		else
		begin
			case(state)
				e_wait:
				begin
					threshold <= i_threshold;
					coef <= i_coef;

					counter_measured_data <= 0;

					if(start_processing) state <= e_reset_far_median_sorter;

					final_address <= write_address; 
					start_address <= write_address - DATA_SIZE - FRAME_LENGTH;  // i - M
					prestart_address <= write_address - DATA_SIZE - 2 * FRAME_LENGTH; // i - M - 1
					last_address <= write_address - FRAME_LENGTH; // i 
					prelast_address <= write_address - 2 * FRAME_LENGTH; // i - 1
					working_address <= write_address - DATA_SIZE / 2 - FRAME_LENGTH; // i - M / 2

					o_data_finish <= 0;
					o_data_start <= start_processing;

					o_shoulder_data_finish <= 0;
					o_shoulder_data_start <= start_processing;

					o_rank_sorter_data_finish <= 0;
					o_rank_sorter_data_start <= start_processing;

					o_detection_data_finish <= 0;
					o_detection_data_start <= start_processing;


					if(start_processing) counter_rxed_frames <= counter_rxed_frames + 20;
				end

				e_reset_far_median_sorter:
				begin
					o_data_start <= 0;
					o_shoulder_data_start <= 0;
					o_rank_sorter_data_start <= 0;
					o_detection_data_start <= 0;

					reset_median_sorter = 1;
					state <= e_wait_reset_far_median_sorter;
				end

				e_wait_reset_far_median_sorter:
				begin
					reset_median_sorter = 0;

					if(median_sorter_ready) state <= e_check_fill_median_far;					

					read_offset <= 0;
					write_offset <= -SORTER_DEPTH / 2;
				end

				e_check_fill_median_far:
				begin
					if(write_offset == FAR_MEDIAN_LENGTH) state <= e_reset_close_median_sorter;
					else state <= e_read_for_median_far;

					data_to_median_storage_valid <= 0;
					o_rank_sorter_data_valid <= 0;

					accumulator <= 0;
				end

				e_read_for_median_far:
				begin
					if(read_offset < FAR_LENGTH) read_address <= working_address + read_offset;
					else read_address <= working_address + 2 * (FAR_LENGTH ^ 1)  - read_offset;

					state <= e_wait_for_median_far_1;
				end

				e_wait_for_median_far_1:
				begin
					read_address <= read_address + 1;
					state <= e_wait_for_median_far_2;
				end

				e_wait_for_median_far_2:
				begin
					state <= e_start_median_far_1;
				end

				e_start_median_far_1:
				begin
					accumulator <= {1'b0, signal};

					state <= e_start_median_far_2;
				end

				e_start_median_far_2:
				begin
					if(read_offset != FAR_LENGTH - 1) accumulator <= accumulator + {1'b0, signal};
					else accumulator <= accumulator + accumulator;

					data_for_sorter_valid <= 1;

					state <= e_wait_median_far;
				end

				e_wait_median_far:
				begin
					data_for_sorter_valid <= 0;

					if(data_from_sorter_valid) state <= e_save_median_far_1;
				end

				e_save_median_far_1:
				begin
					if(write_offset >= 0 && {write_offset, 1'b0} < FAR_LENGTH)
					begin
						data_to_median_storage <= data_from_sorter;
						data_to_median_storage_valid <= 1;

						o_rank_sorter_data <= data_from_sorter;
						o_rank_sorter_data_valid <= 1;

						median_storage_write_address <= {write_offset, 1'b0};
					end
					else
					begin
						data_to_median_storage_valid <= 0;
						o_rank_sorter_data_valid <= 0;
					end

					state <= e_save_median_far_2;
				end

				e_save_median_far_2:
				begin
					if(write_offset >= 0 && {write_offset, 1'b1} < FAR_LENGTH)
					begin
						data_to_median_storage <= data_from_sorter;
						data_to_median_storage_valid <= 1;

						o_rank_sorter_data <= data_from_sorter;
						o_rank_sorter_data_valid <= 1;

						median_storage_write_address <= {write_offset, 1'b1};
					end
					else
					begin
						data_to_median_storage_valid <= 0;
						o_rank_sorter_data_valid <= 0;
					end

					read_offset <= read_offset + 2;
					write_offset <= write_offset + 1;
					state <= e_check_fill_median_far;
				end

				e_reset_close_median_sorter:
				begin
					reset_median_sorter = 1;
					state <= e_wait_reset_close_median_sorter;
				end

				e_wait_reset_close_median_sorter:
				begin
					reset_median_sorter = 0;

					if(median_sorter_ready) state <= e_check_fill_median_close;

					read_offset <= 0;
					write_offset <= - SORTER_DEPTH / 2;
					prev_signal_1 <= 0;
				end

				e_check_fill_median_close:
				begin
					data_to_median_storage_valid <= 0;
					o_rank_sorter_data_valid <= 0;

					if(write_offset == CLOSE_MEDIAN_LENGTH) state <= e_start_detection;
					else state <= e_read_for_median_close;

					accumulator <= 0;
				end

				e_read_for_median_close:
				begin
					if(read_offset < CLOSE_LENGTH) read_address <= working_address + read_offset  + FAR_LENGTH;
					else read_address <= working_address + 2 * (CLOSE_LENGTH ^ 1)  - read_offset  + FAR_LENGTH;

					state <= e_wait_for_median_close_1;
				end

				e_wait_for_median_close_1:
				begin
					read_address <= read_address + 1;
					state <= e_wait_for_median_close_2;
				end

				e_wait_for_median_close_2:
				begin
					state <= e_start_median_close_1;
				end

				e_start_median_close_1:
				begin
					accumulator <= {1'b0, signal};

					state <= e_start_median_close_2;
				end

				e_start_median_close_2:
				begin
					if(read_offset != CLOSE_LENGTH - 1) accumulator <= accumulator + {1'b0, signal};
					else accumulator <= accumulator + accumulator;

					data_for_sorter_valid <= 1;

					state <= e_wait_median_close;
				end

				e_wait_median_close:
				begin
					data_for_sorter_valid <= 0;

					if(data_from_sorter_valid) state <= e_save_median_close_1;
				end

				e_save_median_close_1:
				begin
					if(write_offset >= 0)
					begin
						data_to_median_storage <= data_from_sorter;
						data_to_median_storage_valid <= 1;

						o_rank_sorter_data <= data_from_sorter;
						o_rank_sorter_data_valid <= 1;

						median_storage_write_address <= {write_offset, 1'b0} + FAR_LENGTH;
					end

					state <= e_save_median_close_2;
				end

				e_save_median_close_2:
				begin
					if(write_offset >= 0)
					begin
						data_to_median_storage <= data_from_sorter;
						data_to_median_storage_valid <= 1;

						o_rank_sorter_data <= data_from_sorter;
						o_rank_sorter_data_valid <= 1;

						median_storage_write_address <= {write_offset, 1'b1} + FAR_LENGTH;
					end

					write_offset <= write_offset + 1;
					read_offset <= read_offset + 2;

					state <= e_check_fill_median_close;
				end

				e_start_detection:
				begin
					read_offset <= 0;
					write_offset <= -1;
					state <= e_check_detection;
					prev_signal_1 <= 0;
					prev_signal_2 <= 0;
				end

				e_check_detection:
				begin
					if(write_offset == FRAME_LENGTH) state <= e_start_measure_data;
					else state <= e_read_for_detection;
					
					data_to_detection_valid <= 0;
					o_detection_data_valid <= 0;
				end

				e_read_for_detection:
				begin
					read_address <= working_address + read_offset;
					median_storage_read_address <= read_offset - 1;
					state <= e_wait_read_for_detection;
					counter_wait <= 0;
				end

				e_wait_read_for_detection:
				begin
					counter_wait <= counter_wait + 1;
					if(counter_wait == 8) state <= e_calc_detection_1;
				end

				e_calc_detection_1:
				begin
					if(prev_signal_1 > prev_signal_2) right_max <= 1;
					else right_max <= 0;

					if(prev_signal_1 >= signal) left_max <= 1;
					else left_max <= 0;

					if(prev_signal_1 >= local_threshold) local_threshold_passed <= 1;
					else local_threshold_passed <= 0;

					prev_signal_1 <= signal;
					prev_signal_2 <= prev_signal_1;

					state <= e_calc_detection_2;
				end

				e_calc_detection_2:
				begin
					if(write_offset >= 0)
					begin
						data_to_detection <= right_max & left_max & local_threshold_passed;
						data_to_detection_valid <= 1;

						o_detection_data <= right_max & left_max & local_threshold_passed;
						o_detection_data_valid <= 1;

						detection_write_address <= write_offset;
					end

					write_offset <= write_offset + 1;
					read_offset <= read_offset + 1;

					state <= e_check_detection;
				end

				e_start_measure_data:
				begin
					read_offset <= 0;
					state <= e_check_measure_data;

				end

				e_check_measure_data:
				begin
					data_to_measured_valid <= 0;

					if(data_to_measured_valid ) measured_storage_write_address <= measured_storage_write_address + 1;

					if(read_offset == FRAME_LENGTH) state <= e_send_time;
					else state <= e_read_measure;

					addresses <= {
						working_address,
						last_address,
						prelast_address,
						start_address,
						prestart_address
					};

					counter_read <= 0;
				end

				e_read_measure:
				begin
					o_shoulder_data_valid <= 0;

					addresses <= addresses[ADDRESS_SIZE +: 4 * ADDRESS_SIZE];
					read_address <= addresses[ADDRESS_SIZE - 1: 0] + read_offset;
					state <= e_wait_read_measure_1;
					detection_read_address <= read_offset;

					counter_read <= counter_read + 1;
				end

				e_wait_read_measure_1:
				begin
					state <= e_wait_read_measure_2;
				end

				e_wait_read_measure_2:
				begin
					state <= e_save_measure;
				end

				e_save_measure:
				begin
					if(counter_read == 5) state <= e_process_measure_1;
					else state <= e_read_measure;

					o_shoulder_data <= signal;
					o_shoulder_data_valid <= 1;

					read_signals <= {signal, read_signals[SIGNAL_WIDTH +: 4 * SIGNAL_WIDTH]};
					read_address <= start_address + read_offset;
				end

				e_process_measure_1:
				begin
					o_shoulder_data_valid <= 0;

					state <= e_process_measure_2;

					read_offset <= read_offset + 1;

					current_delta <= last_signal - start_signal;
					prev_delta <= prelast_signal - prestart_signal;
				end

				e_process_measure_2:
				begin
					if(current_delta < threshold) current_delta_passed <= 1;
					else current_delta_passed <= 0;

					if(prev_delta >= threshold) prev_delta_passed <= 1;
					else prev_delta_passed <= 0;					

					state <= e_process_measure_3;
				end

				e_process_measure_3:
				begin
					if(data_from_detection & prev_delta_passed & current_delta_passed) state <= e_save_data;
					else state <= e_check_measure_data;
				end

				e_save_data:
				begin
					counter_measured_data <= counter_measured_data + 1;
					data_to_measured <= {
						read_offset - 1'b1,
						data_from_storage
					};
					data_to_measured_valid <= 1'b1;
					state <= e_check_measure_data;
				end

				e_send_time:
				begin
					o_data <= counter_rxed_frames - SEQUENCE_NUMBER * 20;
					o_data_valid <= 1;
					state <= e_send_count;
				end

				e_send_count:
				begin
					o_data <= counter_measured_data;
					o_data_valid <= 1;
					state <= e_check_send;
					measured_storage_read_address <= 0;
				end

				e_check_send:
				begin
					o_data_valid <= 0;

					if(counter_measured_data > 0) state <= e_wait_read_measured_1;
					else state <= e_finish;
				end

				e_wait_read_measured_1:
				begin
					state <= e_wait_read_measured_2;
				end

				e_wait_read_measured_2:
				begin
					state <= e_send_data_1;
				end

				e_send_data_1:
				begin
					median_storage_read_address <= measured_time;
					o_data <= measured_signal;
					o_data_valid <= 1;
					state <= e_send_data_2;
				end

				e_send_data_2:
				begin
					o_data <= measured_signal_aux;
					o_data_valid <= 1;
					state <= e_send_data_3;
				end

				e_send_data_3:
				begin
					o_data <= {
						measured_signal_frq_channel,
						measured_signal_aux_channel,
						measured_signal_channel,
						measured_time
					};
					o_data_valid <= 1;
					state <= e_send_data_4;
					measured_storage_read_address <= measured_storage_read_address + 1;
					counter_measured_data <= counter_measured_data - 1;
				end

				e_send_data_4:
				begin
					o_data <= data_from_median_storage;
					o_data_valid <= 1;
					state <= e_check_send;
				end

				e_finish:
				begin
					o_data_finish <= 1;
					o_shoulder_data_finish <= 1;
					o_rank_sorter_data_finish <= 1;
					o_detection_data_finish <= 1;

					state <= e_wait;
				end

			endcase
		end
	end
endmodule