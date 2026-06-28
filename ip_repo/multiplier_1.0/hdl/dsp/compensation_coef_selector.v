`timescale 1ps/1ps

module CompesationCoefSelector
	#(
		parameter BIT_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8
	)
	(
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_automatic_coefs,
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_manual_coefs,

		input i_mode,

		input i_clock,
		input i_reset,

		output reg [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]o_coefs
	);

	localparam AUTOMATIC_COMPENSATION_MODE = 0;
	localparam MANUAL_COMPENSATION_MODE = 1;

	always @(posedge i_clock)
	begin
		if(i_reset) 
		begin
			o_coefs <= 0;
		end
		else
		begin
			if(i_mode == MANUAL_COMPENSATION_MODE) o_coefs <= i_manual_coefs;
			else if(i_mode == AUTOMATIC_COMPENSATION_MODE) o_coefs <= i_automatic_coefs;
			else o_coefs <= 0;
		end
	end
endmodule