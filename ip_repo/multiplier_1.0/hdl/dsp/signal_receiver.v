`timescale 1ps / 1ps

module signal_receiver
	#(
		parameter BIT_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8,
		parameter SIGNAL_LENGTH = 234,
		parameter START_FAR = 1,
		parameter START_CLOSE = 2,
		parameter START_AUX = 3,
		parameter LENGTH_FAR = 1,
		parameter LENGTH_CLOSE = 2,
		parameter LENGTH_AUX = 3,
		parameter TIMEOUT_LIMIT = 20000
	)
	(
                (* mark_debug = "true" *)
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal,
                (* mark_debug = "true" *)
		input [CHANNEL_NUMBER  - 1: 0]i_valid,
		
		input i_start,
		
		input i_clock,
		input i_reset,
		
		input i_aux_finished,

 (* mark_debug = "true" *)
		output reg o_signal_started,		
		output reg [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]o_signal,
 (* mark_debug = "true" *)
		output reg o_close_valid,
 (* mark_debug = "true" *)
		output reg o_far_valid,
		
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

		output reg [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]o_rxed_data,
		(* mark_debug = "true" *)
		output reg o_rxed_data_valid,
		(* mark_debug = "true" *)
		output reg o_rxed_data_started,
		(* mark_debug = "true" *)
		output reg o_rxed_data_finished
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

	initial
	begin
		o_rxed_data = 0;
		o_rxed_data_valid = 0;
	end

	integer timeout;

	reg delay_close, delay_far;

(* mark_debug = "true" *)	
	integer state;
	reg close_valid, far_valid;
(* mark_debug = "true" *)
	integer counter_send;
(* mark_debug = "true" *)
	integer counter_rx;

	reg [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]write_data, data;
	wire [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]read_data, data_from_memory;

(* mark_debug = "true" *)
	integer read_address;
(* mark_debug = "true" *)
	integer write_address;
	reg write_data_valid;

	integer timeout_counter;

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

	reg all_present;

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
			all_present <= 0;
			o_signal_started <= 0;
		end
		else
		begin
			case(state)
				e_wait:
				begin
					all_present <= &i_valid;
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
					all_present <= i_valid;
					o_rxed_data_started <= 0;

					if(all_present) state <= e_request;
				end
				
				e_request:
				begin
					all_present <= 0;
					
					o_request <= 16'hffff;
					data <= i_signal;
					state <= e_process;

					o_rxed_data <= i_signal;
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

					if(i_aux_finished) state <= e_send_data;
					else if(timeout_counter == TIMEOUT_LIMIT) state <= e_timeout;

					counter_send <= 0;

					o_signal_started <= i_aux_finished;

					timeout_counter <= timeout_counter + 1;

					delay_close <= 0;
					delay_far <= 0;
				end
				
				e_send_data:
				begin
					o_signal_started <= 0;

					read_address <= read_address + 1;
					
					o_signal <= data_from_memory;

					if(START_FAR < START_CLOSE)
					begin
						if(read_address < LENGTH_FAR) 
						begin
							far_valid <= 1'b1;
							close_valid <= 1'b0;
						end
						else if(read_address < LENGTH_FAR + LENGTH_CLOSE)
						begin
							close_valid <= 1'b1;
							far_valid <= 1'b0;
						end
						else
						begin
							close_valid <= 1'b0;
							far_valid <= 1'b0;
						end
					end
					else
					begin
						if(read_address < LENGTH_CLOSE) 
						begin
							far_valid <= 1'b1;
							close_valid <= 1'b0;
						end
						else if(read_address < LENGTH_FAR + LENGTH_CLOSE)
						begin
							close_valid <= 1'b1;
							far_valid <= 1'b0;
						end
						else
						begin
							close_valid <= 1'b0;
							far_valid <= 1'b0;
						end
					end
					
					if(o_close_valid | o_far_valid) counter_send <= counter_send + 1;
					
					{o_close_valid, delay_close} <= {delay_close, close_valid};
					{o_far_valid, delay_far} <= {delay_far, far_valid};
					
					if(counter_send == LENGTH_FAR + LENGTH_CLOSE) state <= e_finish;
				end
				
				e_finish:
				begin
					o_close_valid <= 1'b0;
					o_far_valid <= 1'b0;
					o_finished <= 1'b1;
					
					state <= e_wait;
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
