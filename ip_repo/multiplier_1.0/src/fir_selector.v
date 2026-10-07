`timescale 1ps/1ps

module FirSelector
	#(
		parameter SIGNAL_WIDTH = 16
	)
	(
		input [2 * SIGNAL_WIDTH - 1: 0]i_signal_far,
		input [2 * SIGNAL_WIDTH - 1: 0]i_signal_close,

		input i_signal_far_valid,
		input i_signal_close_valid,
		input [15: 0]i_diagram_number,
		input i_switch_diagram,
		input i_start,
		input i_finished,

		input i_clock,
		input i_reset,

		output reg [2 * SIGNAL_WIDTH - 1: 0]o_signal,

		output reg o_signal_far_valid,
		output reg o_signal_close_valid,
		output reg [15: 0]o_diagram_number,
		output reg o_switch_diagram,
		output reg o_start,
		output reg o_finished
	);

	always @(posedge i_clock)
	begin
		if(i_reset)
		begin
			o_signal_far_valid <= 0;
			o_signal_close_valid <= 0;
			o_diagram_number <= 0;
			o_switch_diagram <= 0;
			o_start <= 0;
			o_finished <= 0;
		end
		else
		begin
			if(i_signal_far_valid) o_signal <= i_signal_far;
			else if(i_signal_close_valid) o_signal <= i_signal_close;

			o_signal_far_valid <= i_signal_far_valid;
			o_signal_close_valid <= i_signal_close_valid;
			o_diagram_number <= i_diagram_number;
			o_switch_diagram <= i_switch_diagram;
			o_start <= i_start;
			o_finished <= i_finished;
		end
	end
endmodule
