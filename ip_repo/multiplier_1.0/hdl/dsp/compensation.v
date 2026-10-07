`timescale 1ps/1ps

module Compensation
	#(
		parameter BIT_WIDTH = 16,
		parameter COEF_WIDTH = 16,
		parameter COEF_ONE_BIT_WIDTH = 14
	)
	(
		input [2 * BIT_WIDTH - 1: 0]i_signal,
		input [2 * COEF_WIDTH - 1: 0]i_coef,

		input i_clock,
		input i_reset,

		output [2 * BIT_WIDTH - 1: 0]o_signal
	);

	wire signed [COEF_WIDTH + BIT_WIDTH - 1: 0]result_re, result_im;

	complex_multiplier
	  #(
	    .p_value_1_width(BIT_WIDTH),
	    .p_value_2_width(COEF_WIDTH),
	    .p_pipeline_mult_in(1),
	    .p_pipeline_mult_out(1),
	    .p_pipeline_add(1),
	    .p_reduce_mul_bus("NO")
	  )
	  inst_mul
	  (
	    .i_value_1_re(i_signal[0 +: BIT_WIDTH]),
	    .i_value_1_im(i_signal[BIT_WIDTH +: BIT_WIDTH]),
	
	    .i_value_2_re(i_coef[0 +: COEF_WIDTH]),
	    .i_value_2_im(i_coef[COEF_WIDTH +: COEF_WIDTH]),
	    
	    .i_reset(i_reset),
	    .i_clock_enable(1'b1),
	    .i_clock(i_clock),
	    
	    .o_value_re(result_re),
	    .o_value_im(result_im)    
	  );

	assign o_signal[0 +: BIT_WIDTH] = result_re[COEF_ONE_BIT_WIDTH +: BIT_WIDTH] + result_re[COEF_ONE_BIT_WIDTH - 1];
	assign o_signal[BIT_WIDTH +: BIT_WIDTH] = result_im[COEF_ONE_BIT_WIDTH +: BIT_WIDTH] + result_im[COEF_ONE_BIT_WIDTH - 1];

endmodule

module CompensationBlock
	#(
		parameter BIT_WIDTH = 16,
		parameter COEF_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8,
		parameter COEF_ONE_BIT_WIDTH = 14
	)
	(
		input [2 * BIT_WIDTH - 1: 0]i_signal,
		input [2 * COEF_WIDTH * CHANNEL_NUMBER - 1: 0]i_coefs,

		input [15: 0]i_current_channel_number,
		input [15: 0]i_current_diagram_number,

		input i_clock,
		input i_reset,

		input i_switch_signal,
		input i_switch_diagram,

		output [2 * BIT_WIDTH - 1: 0]o_signal,

		input i_start,
		input i_far_valid,
		input i_close_valid,
		input i_finished,
		input i_far_mem_valid,
		input i_close_mem_valid,


(* mark_debug = "true" *)	
		output o_start,
(* mark_debug = "true" *)	
		output o_far_valid,
(* mark_debug = "true" *)	
		output o_close_valid,
(* mark_debug = "true" *)	
		output o_finished,
(* mark_debug = "true" *)	
		output o_far_mem_valid,
(* mark_debug = "true" *)	
		output o_close_mem_valid,

		output [15: 0]o_current_channel_number,
		output [15: 0]o_current_diagram_number,

		output o_switch_signal,
		output o_switch_diagram	
	);

	reg [2 * COEF_WIDTH * CHANNEL_NUMBER - 1: 0]coefs;

	Compensation
		#(
			.BIT_WIDTH(BIT_WIDTH),
			.COEF_WIDTH(COEF_WIDTH),
			.COEF_ONE_BIT_WIDTH(COEF_ONE_BIT_WIDTH)
		)
		inst_compensation
		(
			.i_signal(i_signal),
			.i_coef(coefs[0 +: 2 * COEF_WIDTH]),
			.i_clock(i_clock),
			.i_reset(i_reset),

			.o_signal(o_signal)
		);

	always @(posedge i_clock)
	begin
		if(i_start)
		begin
			coefs <= i_coefs;
		end
		else if(i_far_valid | i_close_valid)
		begin
			coefs <= {
				coefs[0 +: 2 * COEF_WIDTH], 
				coefs[2 * COEF_WIDTH +: 2 * COEF_WIDTH * (CHANNEL_NUMBER - 1)]
			};
		end
	end

	v_reg_delay
	  #(
	    .p_delay_length(7),
	    .p_bit_width(4 + 32 + 2 + 2)
	  )  
	  inst_delay
	  (
	    .i_data
	    (
	    	{
	    		i_far_mem_valid,
	    		i_close_mem_valid,
	    		i_switch_signal,
	    		i_switch_diagram,
	    		i_current_diagram_number,
	    		i_current_channel_number,
				i_start,
				i_far_valid,
				i_close_valid,
				i_finished
			}
	    ),
	    .i_clock(i_clock),
	    .i_data_valid(1), // not used, compatibility purpose
	    .i_reset(i_reset), // not used, compatibility purpose
	    .o_data
	    (
	    	{
	    		o_far_mem_valid,
	    		o_close_mem_valid,
	    		o_switch_signal,
	    		o_switch_diagram,
	    		o_current_diagram_number,
	    		o_current_channel_number,
				o_start,
				o_far_valid,
				o_close_valid,
				o_finished
			}
	    )
	  );

endmodule
