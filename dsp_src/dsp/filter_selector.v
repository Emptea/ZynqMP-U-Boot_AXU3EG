`timescale 1ps/1ps

module FilterSelecter
	#(
		parameter BIT_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8
	)
	(
		input [BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal,
		input i_far_valid,
		input i_close_valid,

		input i_clock,
		input i_reset,

		output reg [BIT_WIDTH * CHANNEL_NUMBER - 1: 0]o_far_signal,
		output reg [BIT_WIDTH * CHANNEL_NUMBER - 1: 0]o_close_signal,

		output reg o_far_valid,
		output reg o_close_valid
	);

	always @(posedge i_clock)
	begin
		if(i_reset)
		begin
			o_far_signal <= 0;
			o_close_signal <= 0;
			o_far_valid <= 0;
			o_close_valid <= 0;
		end
		else
		begin
			o_far_valid <= i_far_valid;
			o_close_valid <= i_close_valid;

			if(i_far_valid) o_far_signal <= i_signal;
			else o_far_signal <= 0;

			if(i_close_valid) o_close_signal <= i_signal;
			else o_close_signal <= 0;
		end
	end
endmodule
