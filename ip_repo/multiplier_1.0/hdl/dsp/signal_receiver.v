`timescale 1ps / 1ps

module signal_receiver
	#(
		parameter DIAGRAM_NUMBER = 4,
		parameter BIT_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8,
		parameter SIGNAL_LENGTH = 234,
		parameter START_FAR = 1,
		parameter START_CLOSE = 2,
		parameter START_AUX = 3,
		parameter LENGTH_FAR = 1,
		parameter LENGTH_CLOSE = 2,
		parameter LENGTH_AUX = 3,
		parameter TIMEOUT_LIMIT = 20000,
		parameter FAR_FILL_SIZE = 20,
		parameter CLOSE_FILL_SIZE = 3
	)
	(
(* mark_debug = "true" *)
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal,
(* mark_debug = "true" *)
		input [CHANNEL_NUMBER  - 1: 0]i_valid,
		
		input i_start,
		
		input i_clock,
		input i_reset,

		input [15: 0]i_selected_channel_number,
		
		input i_aux_finished,

 (* mark_debug = "true" *)
		output reg o_signal_started,		
		output reg [2 * BIT_WIDTH - 1: 0]o_signal,
		output reg [15: 0]o_signal_channel_number,
		output reg [15: 0]o_signal_diagram_number,
 (* mark_debug = "true" *)
		output reg o_close_valid,
 (* mark_debug = "true" *)
		output reg o_far_valid,
 (* mark_debug = "true" *)
		output reg o_close_mem_valid,
 (* mark_debug = "true" *)
		output reg o_far_mem_valid,
		
 (* mark_debug = "true" *)
		output reg o_aux_start,
		output reg [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]o_aux_signal,
 (* mark_debug = "true" *)
		output reg o_aux_signal_valid,
(* mark_debug = "true" *)
		output reg o_aux_finish,
		
 (* mark_debug = "true" *)
		output reg o_finished,
		
		output reg [CHANNEL_NUMBER - 1: 0]o_request,

		output reg [2 * BIT_WIDTH - 1: 0]o_rxed_data,
		output reg [15: 0]o_rxed_data_channel_number,
(* mark_debug = "true" *)
		output reg o_rxed_data_valid,
(* mark_debug = "true" *)
		output reg o_rxed_data_started,
(* mark_debug = "true" *)
		output reg o_rxed_data_finished,

		output reg o_switch_signal,
		output reg o_switch_diagram,

(* mark_debug = "true" *)
		input [7: 0]i_enabled_channels
	);

	localparam END_FAR = START_FAR + LENGTH_FAR;
	localparam END_CLOSE = START_CLOSE + LENGTH_CLOSE;
	localparam END_AUX = START_AUX + LENGTH_AUX;


	localparam e_wait = 0;
	localparam e_wait_signal = 1;
	localparam e_request = 2;
	localparam e_process = 3;
	localparam e_save = 4;
	localparam e_finish_save = 5;
	localparam e_send_aux = 6;
	localparam e_finish_send_aux = 7;
	localparam e_check_end = 8;
	localparam e_finish_rx = 9;
	localparam e_wait_aux_finished = 10;
	localparam e_send_data = 11;
	localparam e_finish = 12;
	localparam e_timeout = 13;
	localparam e_start_diagram = 14;
	localparam e_wait_diagram_1 = 15;
	localparam e_read_data_for_send = 16;
	localparam e_check_diagram = 17;
	localparam e_fill_data = 18;

	initial
	begin
		o_rxed_data = 0;
		o_rxed_data_valid = 0;
	end

	integer timeout;

	reg delay_close, delay_far;

(* mark_debug = "true" *)	
	integer state;
(* mark_debug = "true" *)	
	integer next_state;

	reg close_valid, far_valid;
(* mark_debug = "true" *)
	integer counter_send;
(* mark_debug = "true" *)
	integer counter_rx;

	reg enable_mem_save;

	reg [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]write_data, data, saved_data_from_memory;
	wire [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]read_data, data_from_memory;

(* mark_debug = "true" *)
	integer read_address;
(* mark_debug = "true" *)
	integer write_address;
	reg write_data_valid;

	integer timeout_counter;

	reg [15: 0]signal_channel_number;

(* mark_debug = "true" *)
	reg [7: 0]counter_fill;

	v_ram_2_port
		#(
			.p_data_width(2 * BIT_WIDTH * CHANNEL_NUMBER),
			.p_word_count(SIGNAL_LENGTH),
			.p_addr_width(8)
		)
		inst_storage
		(
			.i_data(write_data),
			.i_data_valid(write_data_valid),
			.i_read_addr(read_address),
			.i_write_addr(write_address),
			.i_read_clock(i_clock),
			.i_write_clock(i_clock),
			
			.o_data(data_from_memory)
		);

(* mark_debug = "true" *)
	reg all_present;

(* mark_debug = "true" *)
	reg [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]preprocessed_signal;

	integer i;
	always @(i_signal or i_enabled_channels)
	begin
		preprocessed_signal = i_signal;

		for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
		begin
			if(~i_enabled_channels[i]) preprocessed_signal[2 * BIT_WIDTH * i +: 2 * BIT_WIDTH] = 0;
		end
	end

	wire any_channel_selected;
	wire all_selected_valid;

	assign any_channel_selected = |i_enabled_channels;
	assign all_selected_valid = &(i_valid | ~i_enabled_channels);

	always @(posedge i_clock)
	begin
		if(i_reset)
		begin
			state <= e_wait;
			o_close_valid <= 0;
			o_far_valid <= 0;
			o_finished <= 0;
			o_aux_start <= 0;
			o_aux_finish <= 0;
			o_aux_signal_valid <= 0;
			o_request <= 0;
			o_rxed_data_started <= 0;
			o_rxed_data_finished <= 0;
			o_signal_started <= 0;
			o_switch_signal <= 0;
			o_switch_diagram <= 0;
			all_present <= 0;
		end
		else
		begin
			case(state)
				e_wait:
				begin
					all_present <= all_selected_valid & any_channel_selected;
					if(i_start & all_present) state <= e_wait_signal;
					
					o_finished <= 0;
					
					counter_rx <= 0;
					write_address <= 0;
					read_address <= 0;
					o_signal_started <= 0;

					o_rxed_data_started <= i_start & all_present;
				end
				
				e_wait_signal:
				begin
					all_present <= all_selected_valid & any_channel_selected;
					o_rxed_data_started <= 0;

					if(all_present) state <= e_request;

					o_rxed_data_channel_number <= i_selected_channel_number[2: 0];
				end
				
				e_request:
				begin
					all_present <= 0;
					
					o_request <= 16'hffff;
					data <= preprocessed_signal;
					state <= e_process;

					o_rxed_data <= preprocessed_signal >> (o_rxed_data_channel_number << 5);
					o_rxed_data_valid <= 1'b1;
				end
				
				e_process:
				begin
					o_request <= 0;
					
					if(counter_rx >= START_FAR && counter_rx < END_FAR) state <= e_save;
					else if(counter_rx >= START_CLOSE && counter_rx < END_CLOSE) state <= e_save;
					else if(counter_rx >= START_AUX && counter_rx < END_AUX) state <= e_send_aux;
					else state <= e_check_end;

					if(counter_rx == START_AUX) o_aux_start <= 1'b1;
					else o_aux_start <= 1'b0;

					o_rxed_data_valid <= 1'b0;
				end
				
				e_save:
				begin
					write_data <= data;
					write_data_valid <= 1'b1;
					state <= e_finish_save;
				end
				
				e_finish_save:
				begin
					write_data_valid <= 0;
					write_address <= write_address + 1;
					state <= e_check_end;
				end
				
				e_send_aux:
				begin
					o_aux_start <= 1'b0;
					o_aux_signal <= data;
					o_aux_signal_valid <= 1'b1;
					state <= e_finish_send_aux;
				end
				
				e_finish_send_aux:
				begin
					o_aux_signal_valid <= 0;
					state <= e_check_end;
				end
				
				e_check_end:
				begin
					if(counter_rx == SIGNAL_LENGTH - 1) state <= e_finish_rx;
					else state <= e_wait_signal;
					
					counter_rx <= counter_rx + 1;
				end
				
				e_finish_rx:
				begin
					o_aux_finish <= 1'b1;
					state <= e_wait_aux_finished;

					o_rxed_data_finished <= 1'b1;

					timeout_counter <= 0;
				end
				
				e_wait_aux_finished:
				begin
					o_aux_finish <= 1'b0;
					o_rxed_data_finished <= 0;

					if(i_aux_finished) state <= e_start_diagram;
					else if(timeout_counter == TIMEOUT_LIMIT) state <= e_timeout;

					counter_send <= 0;

					o_signal_started <= i_aux_finished;

					timeout_counter <= timeout_counter + 1;

					delay_close <= 0;
					delay_far <= 0;

					o_signal_diagram_number <= 0;
				end

				e_start_diagram:
				begin
					o_signal_started <= 0;

					read_address <= 0;

					state <= e_wait_diagram_1;
					o_switch_diagram <= 0;
				end

				e_wait_diagram_1:
				begin
					state <= e_read_data_for_send;
				end
				
				e_read_data_for_send:
				begin
					signal_channel_number <= 0;
					read_address <= read_address + 1;
					saved_data_from_memory <= data_from_memory;
					o_far_valid <= 0;
					o_close_valid <= 0;
					o_far_mem_valid <= 0;
					o_close_mem_valid <= 0;

					if(read_address == LENGTH_FAR + LENGTH_CLOSE) state <= e_check_diagram;
					else state <= e_send_data;

					o_switch_signal <= 1;

					if(read_address == LENGTH_FAR - 1) next_state <= e_fill_data;
					else if(read_address == LENGTH_FAR + LENGTH_CLOSE - 1) next_state <= e_fill_data;
					else next_state <= e_read_data_for_send;

					if(read_address == LENGTH_FAR - 1) counter_fill <= FAR_FILL_SIZE;
					else if(read_address == LENGTH_FAR + LENGTH_CLOSE - 1) counter_fill <= CLOSE_FILL_SIZE;

					if(read_address < FAR_FILL_SIZE) enable_mem_save <= 0;
					else if(read_address < LENGTH_FAR) enable_mem_save <= 1;
					else if(read_address < LENGTH_FAR + CLOSE_FILL_SIZE) enable_mem_save <= 0;
					else enable_mem_save <= 1;
				end

				e_fill_data:
				begin
					signal_channel_number <= 0;
					if(counter_fill == 1) next_state <= e_read_data_for_send;

					o_switch_signal <= 1;
					saved_data_from_memory <= 0;

					counter_fill <= counter_fill - 1;
					state <= e_send_data;

					o_far_valid <= 0;
					o_close_valid <= 0;
					o_far_mem_valid <= 0;
					o_close_mem_valid <= 0;
					o_switch_signal <= 1;
				end

				e_check_diagram:
				begin
					o_signal_diagram_number <= o_signal_diagram_number + 1;

					o_switch_signal <= 0;
					o_switch_diagram <= 1;
					read_address <= 0;

					if(o_signal_diagram_number == DIAGRAM_NUMBER - 1) state <= e_finish;
					else state <= e_start_diagram;
				end

				e_send_data:
				begin
					o_switch_signal <= 0;
					
					if(signal_channel_number == 7) state <= next_state;

					signal_channel_number <= signal_channel_number + 1;
					o_signal_channel_number <= signal_channel_number;

					{saved_data_from_memory, o_signal} <= {32'b0, saved_data_from_memory};

					if(START_FAR < START_CLOSE)
					begin
						if(read_address <= LENGTH_FAR) 
						begin
							o_far_valid <= 1'b1;
							o_far_mem_valid <= enable_mem_save;
							o_close_valid <= 1'b0;
							o_close_mem_valid <= 1'b0;
						end
						else if(read_address <= LENGTH_FAR + LENGTH_CLOSE)
						begin
							o_close_valid <= 1'b1;
							o_close_mem_valid <= enable_mem_save;
							o_far_valid <= 1'b0;
							o_far_mem_valid <= 1'b0;
						end
						else
						begin
							o_close_valid <= 1'b0;
							o_close_mem_valid <= 1'b0;
							o_far_valid <= 1'b0;
							o_far_mem_valid <= 1'b0;
						end
					end
					else
					begin
						if(read_address <= LENGTH_CLOSE) 
						begin
							o_far_valid <= 1'b1;
							o_far_mem_valid <= enable_mem_save;
							o_close_valid <= 1'b0;
							o_close_mem_valid <= 1'b0;
						end
						else if(read_address <= LENGTH_FAR + LENGTH_CLOSE)
						begin
							o_close_valid <= 1'b1;
							o_close_mem_valid <= enable_mem_save;
							o_far_valid <= 1'b0;
							o_far_mem_valid <= 1'b0;
						end
						else
						begin
							o_close_valid <= 1'b0;
							o_close_mem_valid <= 1'b0;
							o_far_valid <= 1'b0;
							o_far_mem_valid <= 1'b0;
						end
					end
				end
				
				e_finish:
				begin
					o_close_valid <= 1'b0;
					o_close_mem_valid <= 1'b0;
					o_far_valid <= 1'b0;
					o_far_mem_valid <= 1'b0;
					o_finished <= 1'b1;
					
					state <= e_wait;

					o_switch_diagram <= 0;
				end

				e_timeout:
				begin
					o_close_valid <= 1'b0;
					o_far_valid <= 1'b0;
					o_finished <= 1'b1;
					
					state <= e_wait;
				end
				
			endcase
		end
	end
endmodule
