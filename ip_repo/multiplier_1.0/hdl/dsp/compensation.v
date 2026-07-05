`timescale 1ps/1ps

module Compensation
	#(
		parameter BIT_WIDTH = 16,
		parameter COEF_ONE_BIT_WIDTH = 14
	)
	(
		input [2 * BIT_WIDTH - 1: 0]i_signal,
		input [2 * BIT_WIDTH - 1: 0]i_coef,

		input i_clock,
		input i_reset,

		output [2 * BIT_WIDTH - 1: 0]o_signal
	);

	wire signed [2 * BIT_WIDTH - 1: 0]result_re, result_im;

	complex_multiplier
	  #(
	    .p_value_1_width(BIT_WIDTH),
	    .p_value_2_width(BIT_WIDTH),
	    .p_pipeline_mult_in(1),
	    .p_pipeline_mult_out(1),
	    .p_pipeline_add(1),
	    .p_reduce_mul_bus("NO")
	  )
	  inst_mul
	  (
	    .i_value_1_re(i_signal[0 +: BIT_WIDTH]),
	    .i_value_1_im(i_signal[BIT_WIDTH +: BIT_WIDTH]),
	
	    .i_value_2_re(i_coef[0 +: BIT_WIDTH]),
	    .i_value_2_im(i_coef[BIT_WIDTH +: BIT_WIDTH]),
	    
	    .i_reset(i_reset),
	    .i_clock_enable(1'b1),
	    .i_clock(i_clock),
	    
	    .o_value_re(result_re),
	    .o_value_im(result_im)    
	  );

	assign o_signal[0 +: BIT_WIDTH] = result_re[COEF_ONE_BIT_WIDTH +: BIT_WIDTH];
	assign o_signal[BIT_WIDTH +: BIT_WIDTH] = result_im[COEF_ONE_BIT_WIDTH +: BIT_WIDTH];

endmodule

module CompensationBlock
	#(
		parameter BIT_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8,
		parameter COEF_ONE_BIT_WIDTH = 14
	)
	(
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal,
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_coefs,

		input i_clock,
		input i_reset,

		output [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]o_signal,

		input i_start,
		input i_far_valid,
		input i_close_valid,
		input i_finished,

(* mark_debug = "true" *)	
		output reg o_start,
(* mark_debug = "true" *)	
		output reg o_far_valid,
(* mark_debug = "true" *)	
		output reg o_close_valid,
(* mark_debug = "true" *)	
		output reg o_finished
	);

	generate
		genvar i;

		for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
		begin: gen_comp
			Compensation
				#(
					.BIT_WIDTH(BIT_WIDTH),
					.COEF_ONE_BIT_WIDTH(COEF_ONE_BIT_WIDTH)
				)
				inst_compensation
				(
					.i_signal(i_signal[2 * BIT_WIDTH * i +: 2 * BIT_WIDTH]),
					.i_coef(i_coefs[2 * BIT_WIDTH * i +: 2 * BIT_WIDTH]),
					.i_clock(i_clock),
					.i_reset(i_reset),

					.o_signal(o_signal[2 * BIT_WIDTH * i +: 2 * BIT_WIDTH])

				);
		end
	endgenerate

	localparam DELAY = 6;
	
	reg [4 * DELAY - 1: 0]delay;

	always @(posedge i_clock)
	begin
		{
			o_start,
			o_far_valid,
			o_close_valid,
			o_finished,
			delay
		} <= {
			delay,
			i_start,
			i_far_valid,
			i_close_valid,
			i_finished
		};
	end
endmodule
