`timescale 1ps/1ps

module Lou
	#(
		parameter BIT_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8
	)
	(
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal,
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_coefs,
		input i_reset,
		input i_clock,

		output [2 * BIT_WIDTH - 1: 0]o_signal
	);

	localparam MUL_OUT_WIDTH = 2 * BIT_WIDTH;

	wire signed [MUL_OUT_WIDTH - 1: 0]mul_out[CHANNEL_NUMBER - 1: 0][1: 0];

	reg signed [MUL_OUT_WIDTH + 2: 0]sum_12[1: 0];
	reg signed [MUL_OUT_WIDTH + 2: 0]sum_34[1: 0];
	reg signed [MUL_OUT_WIDTH + 2: 0]sum_56[1: 0];
	reg signed [MUL_OUT_WIDTH + 2: 0]sum_78[1: 0];
	reg signed [MUL_OUT_WIDTH + 2: 0]sum_1234[1: 0];
	reg signed [MUL_OUT_WIDTH + 2: 0]sum_5678[1: 0];
	reg signed [MUL_OUT_WIDTH + 2: 0]sum[1: 0];

	always @(posedge i_clock)
	begin
		sum_12[0] <= mul_out[0][0] + mul_out[1][0];
		sum_12[1] <= mul_out[0][1] + mul_out[1][1];

		sum_34[0] <= mul_out[2][0] + mul_out[3][0];
		sum_34[1] <= mul_out[2][1] + mul_out[3][1];

		sum_56[0] <= mul_out[4][0] + mul_out[5][0];
		sum_56[1] <= mul_out[4][1] + mul_out[5][1];

		sum_78[0] <= mul_out[6][0] + mul_out[7][0];
		sum_78[1] <= mul_out[6][1] + mul_out[7][1];

		sum_1234[0] <= sum_12[0][0] + sum_34[1][0];
		sum_1234[1] <= sum_12[0][1] + sum_34[1][1];

		sum_5678[0] <= sum_56[0][0] + sum_78[1][0];
		sum_5678[1] <= sum_56[0][1] + sum_78[1][1];

		sum[0] <= sum_1234[0][0] + sum_5678[1][0];
		sum[1] <= sum_1234[0][1] + sum_5678[1][1];
	end

	assign o_signal[0 +: BIT_WIDTH] = sum[BIT_WIDTH + 2 +: BIT_WIDTH];
	assign o_signal[BIT_WIDTH +: BIT_WIDTH] = sum[BIT_WIDTH + 2 +: BIT_WIDTH];

	generate
		genvar i;

		for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
		begin: gen_loop
			wire signed [BIT_WIDTH - 1: 0]input_signal_re, input_signal_im, coef_re, coef_im;

			assign input_signal_re = i_signal[2 * i * BIT_WIDTH +: BIT_WIDTH];
			assign input_signal_im = i_signal[2 * i * BIT_WIDTH + BIT_WIDTH +: BIT_WIDTH];
			assign coef_re = i_coefs[2 * i * BIT_WIDTH +: BIT_WIDTH];
			assign coef_im = i_coefs[2 * i * BIT_WIDTH + BIT_WIDTH +: BIT_WIDTH];


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
			    .i_value_1_re(input_signal_re),
			    .i_value_1_im(input_signal_im),
			
			    .i_value_2_re(coef_re),
			    .i_value_2_im(coef_im),
			    
			    .i_reset(i_reset),
			    .i_clock_enable(1'b1),
			    .i_clock(i_clock),
			    
			    .o_value_re(mul_out[i][0]),
			    .o_value_im(mul_out[i][1])    
			  );	
		end
	endgenerate
endmodule

module LouBlock
	#(
		parameter BIT_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8,
		parameter LOU_NUMBER = 8
	)
	(
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal,
		input [2 * BIT_WIDTH * CHANNEL_NUMBER * LOU_NUMBER - 1: 0]i_coefs,
		input i_reset,
		input i_clock,

		output [2 * BIT_WIDTH * LOU_NUMBER - 1: 0]o_signal
	);

	generate
		genvar i;

		for(i = 0; i < LOU_NUMBER; i = i + 1)
		begin
			Lou
				#(
					.BIT_WIDTH(BIT_WIDTH),
					.CHANNEL_NUMBER(CHANNEL_NUMBER)
				)
				inst_lou
				(
					.i_signal(i_signal),
					.i_coefs(i_coefs[2 * BIT_WIDTH * CHANNEL_NUMBER * i +: 2 * BIT_WIDTH * CHANNEL_NUMBER]),

					.i_reset(i_reset),
					.i_clock(i_clock),

					.o_signal(o_signal[2 * BIT_WIDTH * i +: 2 * BIT_WIDTH])
				);
		end
	endgenerate
endmodule