`timescale 1ps/1ps

module CompensationCalculation
	#(
		parameter BIT_WIDTH = 16,
		parameter LENGTH = 32,
		parameter LENGTH_WIDTH = 5,
		parameter REFERENCE_LEVEL = 14000
	)
	(
		input [2 * BIT_WIDTH - 1: 0]i_signal,
		input i_start,
		input i_signal_valid,
		input i_finish,

		input signed [BIT_WIDTH - 1: 0]i_reference,

		input i_reset,
		input i_clock,

		output reg [2 * BIT_WIDTH - 1: 0]o_coef,
(* mark_debug = "true" *)
		output reg o_finished
	);

	localparam ACCUMULATOR_WIDTH = BIT_WIDTH + LENGTH_WIDTH;
	localparam MUL_REFERENCE_WIDTH = 2 * BIT_WIDTH;
	localparam MUL_QUAD_WIDTH = MUL_REFERENCE_WIDTH + BIT_WIDTH;
	localparam SQR_WIDTH = 2 * BIT_WIDTH;

(* mark_debug = "true" *) integer state;

	localparam e_wait = 0;
	localparam e_accumulate = 1;
	localparam e_calc_sqr = 2;
	localparam e_calc_abs = 3;
	localparam e_start_div_1 = 4;
	localparam e_wait_div_1 = 5;
	localparam e_start_div_2 = 6;
	localparam e_wait_div_2 = 7;
	localparam e_finish = 8;

	wire signed [BIT_WIDTH - 1: 0]accumulated_re, accumulated_im;
	wire signed [BIT_WIDTH - 1: 0]signal_re, signal_im;
	reg signed [ACCUMULATOR_WIDTH - 1: 0]accumulator_re, accumulator_im;

	assign accumulated_re = accumulator_re >> LENGTH_WIDTH;
	assign accumulated_im = accumulator_im >> LENGTH_WIDTH;

	assign signal_re = i_signal[0 +: BIT_WIDTH];
	assign signal_im = i_signal[BIT_WIDTH +: BIT_WIDTH];

	reg signed [MUL_REFERENCE_WIDTH - 1: 0]muled_reference;
	reg signed [SQR_WIDTH - 1: 0]sqr_re, sqr_im, sqr;
	reg signed [MUL_QUAD_WIDTH - 1: 0]muled_re, muled_im;

	reg signed [MUL_QUAD_WIDTH - 1: 0]numerator;

(* mark_debug = "true" *) 
	reg signed [SQR_WIDTH - 1: 0]denominator;
(* mark_debug = "true" *) 
	reg start_div;

	wire finished_div;
	wire [MUL_QUAD_WIDTH - 1: 0]div_result;

	vRecDiv
		#(
			.n(MUL_QUAD_WIDTH),
			.m(2 * BIT_WIDTH)
		)
		inst_rec
		(
			.iNum(numerator), 
			.iDeNom(denominator), 
			.iStart(start_div), 
			.C(i_clock), 
			.oDiv(div_result), 
			.oRem(), 
			.oRdy(finished_div)
		);
	  
	
	always @(posedge i_clock)
	begin
		muled_reference <= i_reference * (1 << (BIT_WIDTH - 2));

		if(i_reset)
		begin
			state <= e_wait;
		end
		else
		begin
			case(state)
				e_wait:
				begin
					accumulator_re <= 0;
					accumulator_im <= 0;

					if(i_start) state <= e_accumulate;

					o_finished <= 0;
				end

				e_accumulate:
				begin
					if(i_signal_valid)
					begin
						accumulator_re <= accumulator_re + signal_re;
						accumulator_im <= accumulator_im + signal_im;
					end

					if(i_finish) state <= e_calc_sqr;
				end

				e_calc_sqr:
				begin
					sqr_re <= accumulated_re * accumulated_re;
					sqr_im <= accumulated_im * accumulated_im;

					muled_re <= muled_reference * accumulated_re;
					muled_im <= muled_reference * accumulated_im;

					state <= e_calc_abs;
				end

				e_calc_abs:
				begin
					sqr <= sqr_re + sqr_im;

					state <= e_start_div_1;
				end

				e_start_div_1:
				begin	
					numerator <= muled_re;
					if(sqr != 0) denominator <= sqr;
					else denominator <= 1;

					start_div <= 1;
					state <= e_wait_div_1;
				end

				e_wait_div_1:
				begin
					start_div <= 0;

					if(finished_div) state <= e_start_div_2;

					o_coef[0 +: BIT_WIDTH] <= div_result;
				end

				e_start_div_2:
				begin	
					numerator <= muled_im;
					if(sqr != 0) denominator <= sqr;
					else denominator <= 1;

					start_div <= 1;
					state <= e_wait_div_2;
				end

				e_wait_div_2:
				begin
					start_div <= 0;

					if(finished_div) state <= e_finish;

					o_coef[BIT_WIDTH +: BIT_WIDTH] <= div_result;
				end

				e_finish:
				begin
					state <= e_wait;
					o_finished <= 1;
				end
			endcase
		end
	end
endmodule

module CompensationCalculationBlock
	#(
		parameter BIT_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8,
		parameter LENGTH = 32,
		parameter LENGTH_WIDTH = 5,
		parameter REFERENCE_LEVEL = 14000
	)
	(
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal,
		input i_start,
		input i_signal_valid,
		input i_finish,

		input signed [BIT_WIDTH - 1: 0]i_reference,

		input i_reset,
		input i_clock,

		output [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]o_coefs,
		output o_compensation_calculation_finished
	);

	generate
		genvar i;

		for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
		begin: gen_calc
			wire finished;
			
			CompensationCalculation
				#(
					.BIT_WIDTH(BIT_WIDTH),
					.LENGTH(LENGTH),
					.LENGTH_WIDTH(LENGTH_WIDTH),
					.REFERENCE_LEVEL(REFERENCE_LEVEL)
				)
				inst_compensation_calculation
				(
					.i_signal(i_signal[2 * BIT_WIDTH * i +: 2 * BIT_WIDTH]),
					.i_start(i_start),
					.i_signal_valid(i_signal_valid),
					.i_finish(i_finish),
					.i_reference(i_reference),

					.i_reset(i_reset),
					.i_clock(i_clock),

					.o_coef(o_coefs[2 * BIT_WIDTH * i +: 2 * BIT_WIDTH]),
					.o_finished(finished)
				);

			if(i == 0)
			begin
				assign o_compensation_calculation_finished = finished;
			end
		end
	endgenerate
endmodule
