`timescale 1ps / 1ps

module signal_receiver
	#(
		BIT_WIDTH = 16,
		CHANNEL_NUMBER = 8,
		SIGNAL_LENGTH = 234,
		START_FAR = 1,
		START_CLOSE = 2,
		START_AUX = 3,
		LENGTH_FAR = 1,
		LENGTH_CLOSE = 2,
		LENGTH_AUX = 3
	)
	(
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal,
		input [CHANNEL_NUMBER  - 1: 0]i_valid,
		
		input i_start,
		
		input i_clock,
		input i_reset,
		
		input i_aux_finished,
		
		output reg [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]o_signal,
		output reg o_close_valid,
		output reg o_far_valid,
		
		output reg o_aux_start,
		output reg [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]o_aux_signal,
		output reg o_aux_signal_valid,
		output reg o_aux_finish,
		
		output reg o_finished,
		
		output reg [CHANNEL_NUMBER - 1: 0]o_request
	);

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
			of_aux_valid <= 0;
			o_request <= 0;
		end
		else
		begin
			case(state)
				e_wait:
				begin
					if(i_start) state <= e_wait_signal;
					
					o_finished <= 0;
					
					counter_rx <= 0;
					write_address <= 0;
					read_address <= 0;
				end
				
				e_wait_signal:
				begin
					if(|i_valid) state <= e_request;
				end
				
				e_request:
				begin
					o_request <= 16'hffff;
					data <= i_data;
					state <= e_process;
				end
				
				e_process:
				begin
					o_request <= 0;
					
					if(counter_rx >= START_FAR && counter_rx < END_FAR) state <= e_save;
					else if(counter_rx >= START_CLOSE && counter_rx < END_CLOSE) state <= e_save;
					else if(counter_rx >= START_AUX && counter_rx < END_AUX) state <= e_send_aux;
					
					state <= e_check_end;
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
				end
				
				e_wait_aux_finished:
				begin
					if(i_aux_finished) state <= e_send_data;
					counter_send <= 0;
				end
				
				e_send_data:
				begin
					read_address <= read_address + 1;
					
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
					
					o_close_valid <= close_valid;
					o_far_valid <= far_valid;
					
					if(counter_send == LENGTH_FAR + LENGTH_CLOSE) state <= e_finish;
				end
				
				e_finish:
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
