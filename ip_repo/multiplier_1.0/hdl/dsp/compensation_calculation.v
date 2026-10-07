`timescale 1ps/1ps

module CompensationCalculation
	#(
		parameter CHANNEL_NUMBER = 8,
		parameter BIT_WIDTH = 16,
		parameter LENGTH = 32,
		parameter LENGTH_WIDTH = 5,
		parameter COMPENSATION_COEF_LEVEL_ONE = 14000,
		parameter AUX_LENGH = 40,
		parameter COEF_WIDTH = 16
	)
	(
		input [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal,
		input i_start,
		input i_signal_valid,
		input i_finish,

		input signed [BIT_WIDTH - 1: 0]i_reference,

		input i_reset,
		input i_clock,

		output reg [2 * COEF_WIDTH * CHANNEL_NUMBER - 1: 0]o_coefs,
(* mark_debug = "true" *)
		output reg o_finished,

		output reg [31: 0]o_debug_coef,
		output reg o_debug_coef_start,
		output reg o_debug_coef_valid,
		output reg o_debug_coef_finished
	);

	localparam ACCUMULATOR_WIDTH = BIT_WIDTH + LENGTH_WIDTH;
	localparam MUL_REFERENCE_WIDTH = ACCUMULATOR_WIDTH + COEF_WIDTH;
	localparam MUL_QUAD_WIDTH = MUL_REFERENCE_WIDTH + ACCUMULATOR_WIDTH;
	localparam SQR_WIDTH = 2 * ACCUMULATOR_WIDTH;

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
	localparam e_check_channel = 9;
	localparam e_set_channel = 10;
	localparam e_start_calc_sqr_re = 11;
	localparam e_start_calc_sqr_im = 12;
	localparam e_calc_sqr_re = 13;
	localparam e_calc_sqr_im = 14;
	localparam e_next_channel = 15;

	reg signed [ACCUMULATOR_WIDTH - 1: 0]accumulated_re;
	reg signed [ACCUMULATOR_WIDTH - 1: 0]accumulated_im;
	reg signed [ACCUMULATOR_WIDTH - 1: 0]accumulator_re[CHANNEL_NUMBER - 1: 0];
	reg signed [ACCUMULATOR_WIDTH - 1: 0]accumulator_im[CHANNEL_NUMBER - 1: 0];

	wire signed [BIT_WIDTH - 1: 0]signal_re[CHANNEL_NUMBER - 1: 0];
	wire signed [BIT_WIDTH - 1: 0]signal_im[CHANNEL_NUMBER - 1: 0];
	
	reg [2 * COEF_WIDTH - 1: 0]coef;


	generate
		genvar i_in;

		for(i_in = 0; i_in < CHANNEL_NUMBER; i_in = i_in + 1)
		begin: gen_input
			assign signal_re[i_in] = i_signal[i_in * 2 * BIT_WIDTH +: BIT_WIDTH];
			assign signal_im[i_in] = i_signal[i_in * 2 * BIT_WIDTH + BIT_WIDTH +: BIT_WIDTH];
		end
	endgenerate


(* mark_debug = "true" *) 
	wire signed [MUL_REFERENCE_WIDTH - 1: 0]muled_reference;
	reg signed [SQR_WIDTH - 1: 0]sqr_re, sqr_im, sqr;
	reg signed [MUL_QUAD_WIDTH - 1: 0]muled_re, muled_im;

	reg signed [MUL_QUAD_WIDTH - 1: 0]numerator;

(* mark_debug = "true" *) 
	reg signed [SQR_WIDTH - 1: 0]denominator;
(* mark_debug = "true" *) 
	reg start_div;

	wire finished_div;
	wire signed [MUL_QUAD_WIDTH - 1: 0]div_result;

	reg [ACCUMULATOR_WIDTH - 1: 0]sqr_value_in;
	wire [SQR_WIDTH - 1: 0]sqr_value_out;

	reg [ACCUMULATOR_WIDTH - 1: 0]mul_ref_value_in_2;
	wire signed [ACCUMULATOR_WIDTH + MUL_REFERENCE_WIDTH -1: 0] mul_ref_value_out;

	integer current_channel;

(* mark_debug = "true" *) 
	reg multiplier_on;
(* mark_debug = "true" *) 
	reg multiplier_on_delayed;
	reg [2: 0]multiplier_on_delay;

	initial
	begin
		multiplier_on = 0;
		multiplier_on_delayed = 0;
		multiplier_on_delay = 0;
	end

	multiplier
		#(
		  .p_value_1_width(ACCUMULATOR_WIDTH),
		  .p_value_2_width(ACCUMULATOR_WIDTH),
		  .p_pipeline_mult_in(1),
		  .p_pipeline_mult_out(1)
		)
		inst_sqr
		(
		  .i_value_1(sqr_value_in),
		  .i_value_2(sqr_value_in),
		
		  .i_reset(i_reset),
		  .i_clock_enable(1'b1),
		  .i_clock(i_clock),
		
		  .o_value(sqr_value_out)
		);  

	multiplier
		#(
		  .p_value_1_width(MUL_REFERENCE_WIDTH),
		  .p_value_2_width(ACCUMULATOR_WIDTH),
		  .p_pipeline_mult_in(1),
		  .p_pipeline_mult_out(1)
		)
		inst_mul_ref
		(
		  .i_value_1(muled_reference),
		  .i_value_2(mul_ref_value_in_2),
		
		  .i_reset(i_reset),
		  .i_clock_enable(1'b1),
		  .i_clock(i_clock),
		
		  .o_value(mul_ref_value_out)
		);  


	vRecDiv
		#(
			.n(MUL_QUAD_WIDTH),
			.m(SQR_WIDTH)
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
		
	integer i;
	  

	reg signed [MUL_REFERENCE_WIDTH - 1: 0]reference, accumulated_reference;
	reg [5: 0] counter_reference;
	
	assign muled_reference = accumulated_reference << COMPENSATION_COEF_LEVEL_ONE;

	always @(posedge i_clock)
	begin
		{multiplier_on_delayed, multiplier_on_delay} <= {multiplier_on_delay, multiplier_on};

		if(i_reset)
		begin
			state <= e_wait;
		end
		else
		begin
			case(state)
				e_wait:
				begin
					multiplier_on <= 0;
					
					for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
					begin
						accumulator_re[i] <= 0;
						accumulator_im[i] <= 0;
					end

					if(i_start) state <= e_accumulate;

					o_debug_coef_finished <= 0;

					o_finished <= 0;

					o_debug_coef_start <= i_start;
					accumulated_reference <= 0;
					reference <= i_reference;
				end

				e_accumulate:
				begin
					o_debug_coef_start <= 0;

					if(i_signal_valid)
					begin
						for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
						begin
							accumulator_re[i] <= accumulator_re[i] + signal_re[i];
							accumulator_im[i] <= accumulator_im[i] + signal_im[i];
						end

						accumulated_reference <= accumulated_reference + reference;
					end

					if(i_finish) state <= e_check_channel;

					current_channel <= 0;
				end

				e_check_channel:
				begin
					o_debug_coef_valid <= 0;
					if(current_channel >= CHANNEL_NUMBER) state <= e_finish;
					else state <= e_set_channel;
				end

				e_set_channel:
				begin
					accumulated_re <= accumulator_re[0];
					accumulated_im <= accumulator_im[0];

					$display("accu: %d %d %d %d", accumulator_re[0], accumulator_im[0], accumulated_reference, muled_reference);
					for(i = 1; i < CHANNEL_NUMBER; i = i + 1)
					begin
						accumulator_re[i - 1] <= accumulator_re[i];
						accumulator_im[i - 1] <= accumulator_im[i];
					end

					state <= e_start_calc_sqr_re;
				end

				e_start_calc_sqr_re:
				begin
					sqr_value_in <= accumulated_re;
					mul_ref_value_in_2 = accumulated_re;

					state <= e_start_calc_sqr_im;
					multiplier_on <= 1;
				end

				e_start_calc_sqr_im:
				begin
					sqr_value_in <= accumulated_im;
					mul_ref_value_in_2 = accumulated_im;

					state <= e_calc_sqr_re;
					multiplier_on <= 1;
				end

				e_calc_sqr_re:
				begin

					multiplier_on <= 0;

					if(multiplier_on_delayed) 
					begin
						sqr_re <= sqr_value_out;
						muled_re <= mul_ref_value_out;
						state <= e_calc_sqr_im;
					end
				end

				e_calc_sqr_im:
				begin
					if(multiplier_on_delayed) 
					begin
						sqr_im <= sqr_value_out;
						muled_im <= mul_ref_value_out;
						state <= e_calc_abs;
					end
				end

				e_calc_abs:
				begin
					sqr <= sqr_re + sqr_im;

					state <= e_start_div_1;
				end

				e_start_div_1:
				begin	
					$display("Sqr: %d %d %d %d %d", 
						sqr_re,
						sqr_im,
						sqr,
						muled_re,
						muled_im);

					numerator <= muled_re;
					if(sqr != 0) denominator <= sqr;
					else denominator <= 1;

					start_div <= 1;
					state <= e_wait_div_1;
				end

				e_wait_div_1:
				begin
					start_div <= 0;

					if(finished_div) 
					begin
						$display("coef re: %d", div_result);
						state <= e_start_div_2;
						o_debug_coef_valid <= 1;
//						$display("div_result %d %d %d", numerator, denominator, div_result);
					end

					coef[0 +: COEF_WIDTH] <= div_result;
					o_debug_coef <= div_result;
				end

				e_start_div_2:
				begin	
					numerator <= muled_im;
					if(sqr != 0) denominator <= sqr;
					else denominator <= 1;

					start_div <= 1;
					state <= e_wait_div_2;
					o_debug_coef_valid <= 0;
				end

				e_wait_div_2:
				begin
					start_div <= 0;

					if(finished_div) 
					begin
						state <= e_next_channel;
						o_debug_coef_valid <= 1;
						$display("coef im: %d", div_result);
//						$display("div_result %d %d %d", numerator, denominator, div_result);
					end

					coef[COEF_WIDTH +: COEF_WIDTH] <= -(div_result[0 +: COEF_WIDTH]);

					o_debug_coef <= div_result;
				end

				e_next_channel:
				begin
					o_debug_coef_valid <= 0;
					current_channel <= current_channel + 1;
					state <= e_check_channel;
					o_coefs <= {coef, o_coefs[2 * COEF_WIDTH +: 2 * CHANNEL_NUMBER * COEF_WIDTH - 2 * COEF_WIDTH]};
				end

				e_finish:
				begin
					o_debug_coef_finished <= 1;
					state <= e_wait;
					o_finished <= 1;
				end
			endcase
		end
	end
endmodule
