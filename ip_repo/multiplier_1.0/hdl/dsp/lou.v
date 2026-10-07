`timescale 1ps/1ps

module Lou
	#(
		parameter BIT_WIDTH = 16,
		parameter COEF_ONE_BIT_WIDTH = 14
	)
	(
		input [2 * BIT_WIDTH - 1: 0]i_signal,
		input [2 * BIT_WIDTH - 1: 0]i_coef,
		input i_switch_signal,
		input i_close_valid,
		input i_far_valid,
		input i_close_mem_valid,
		input i_far_mem_valid,
		input i_start,
		input i_reset,
		input i_clock,

		output reg [2 * BIT_WIDTH - 1: 0]o_signal,
		output reg o_far_valid,
		output reg o_close_valid,
		output reg o_far_mem_valid,
		output reg o_close_mem_valid
	);

	wire far_mem_valid;
	wire close_mem_valid;

	v_reg_delay
	  #(
	    .p_delay_length(7),
	    .p_bit_width(6)
	  )  
	  inst_delay
	  (
	    .i_data
	    (
	    	{
	    		i_far_mem_valid,
	    		i_close_mem_valid,
				i_start,
	    		i_switch_signal,
				i_far_valid,
				i_close_valid
			}
	    ),
	    .i_clock(i_clock),
	    .i_data_valid(1), // not used, compatibility purpose
	    .i_reset(i_reset), // not used, compatibility purpose
	    .o_data
	    (
	    	{
	    		far_mem_valid,
	    		close_mem_valid,
				start,
	    		switch_signal,
	    		far_valid,
	    		close_valid
			}
	    )
	  );

	assign o_switch_signal = switch_signal;

	localparam MUL_OUT_WIDTH = 2 * BIT_WIDTH;

	wire signed [MUL_OUT_WIDTH - 1: 0]mul_out[1: 0];
	reg signed [MUL_OUT_WIDTH + 2: 0]sum[1: 0];

	reg is_far, is_init, is_mem_valid;
	
	initial
	begin
		is_far = 0;
		is_init = 0;
		is_mem_valid = 0;
	end

	always @(posedge i_clock)
	begin
		if(start) is_init <= 0;
		else if(switch_signal) is_init <= 1;
		
		if(switch_signal) is_far <= 0;
		else if(far_valid) is_far <= 1;
		else if(close_valid) is_far <= 0;

		if(far_valid & far_mem_valid) is_mem_valid <= 1;
		else if(close_valid & close_mem_valid) is_mem_valid <= 1;
		else if(close_valid | far_valid) is_mem_valid <= 0;

		o_far_valid <= is_init & switch_signal & is_far;
		o_close_valid <= is_init & switch_signal & ~is_far;
		o_far_mem_valid <= is_init & switch_signal & is_far & is_mem_valid;
		o_close_mem_valid <= is_init & switch_signal & ~is_far & is_mem_valid;

		if(switch_signal)
		begin
			sum[0] <= 0;
			sum[1] <= 0;
		end
		else if(far_valid | close_valid)
		begin
			sum[0] <= sum[0] + mul_out[0];
			sum[1] <= sum[1] + mul_out[1];
		end

		o_signal[0 +: BIT_WIDTH] <= sum[0][COEF_ONE_BIT_WIDTH + 3 +: BIT_WIDTH] + sum[0][COEF_ONE_BIT_WIDTH + 2];
		o_signal[BIT_WIDTH +: BIT_WIDTH] <= sum[1][COEF_ONE_BIT_WIDTH + 3 +: BIT_WIDTH] + sum[1][COEF_ONE_BIT_WIDTH + 2];
	end



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
			
			.o_value_re(mul_out[0]),
			.o_value_im(mul_out[1])    
		);	
endmodule

module LouBlock
	#(
		parameter BIT_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8,
		parameter LOU_NUMBER = 8
	)
	(
		input [2 * BIT_WIDTH - 1: 0]i_signal,
		input [2 * BIT_WIDTH * CHANNEL_NUMBER * LOU_NUMBER - 1: 0]i_coefs,
		input i_reset,
		input i_clock,

		input [15: 0]i_current_diagram_number,

		output [2 * BIT_WIDTH - 1: 0]o_signal,

		input i_start,
		input i_far_valid,
		input i_close_valid,
		input i_far_mem_valid,
		input i_close_mem_valid,
		input i_finished,

		input i_switch_signal,
		input i_switch_diagram,

(* mark_debug = "true" *)	
        output  o_start,
(* mark_debug = "true" *)	
        output  o_far_valid,
(* mark_debug = "true" *)	
        output  o_close_valid,
(* mark_debug = "true" *)	
        output  o_far_mem_valid,
(* mark_debug = "true" *)	
        output  o_close_mem_valid,
(* mark_debug = "true" *)	
        output  o_finished,

		output [15: 0]o_current_diagram_number,
		output o_switch_diagram,
		output o_switch_signal
	);

	reg [2 * BIT_WIDTH * CHANNEL_NUMBER * (LOU_NUMBER - 1) - 1: 0]coefs;
	reg [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]current_coefs;

	Lou
		#(
			.BIT_WIDTH(BIT_WIDTH)
		)
		inst_lou
		(
			.i_signal(i_signal),
			.i_coef(current_coefs[0 +: 2 * BIT_WIDTH]),
			.i_start(i_start | i_switch_diagram),

			.i_switch_signal(i_switch_signal),
			.i_far_valid(i_far_valid),
			.i_close_valid(i_close_valid),
			.i_far_mem_valid(i_far_mem_valid),
			.i_close_mem_valid(i_close_mem_valid),

			.i_reset(i_reset),
			.i_clock(i_clock),

			.o_signal(o_signal),
			.o_far_valid(o_far_valid),
			.o_close_valid(o_close_valid),
			.o_far_mem_valid(o_far_mem_valid),
			.o_close_mem_valid(o_close_mem_valid)
		);

	always @(posedge i_clock)
	begin
		if(i_start)
		begin
			{coefs, current_coefs} <= i_coefs;
		end
		else if(i_switch_diagram)
		begin
			{coefs, current_coefs} <= coefs;
		end
		else if(i_close_valid | i_far_valid)
		begin
			current_coefs <= {
				current_coefs[0 +: 2 * BIT_WIDTH], 
				current_coefs[2 * BIT_WIDTH +: 2 * BIT_WIDTH * (CHANNEL_NUMBER - 1)]
			};			
		end
	end

	v_reg_delay
	  #(
	    .p_delay_length(8),
	    .p_bit_width(4 + 16)
	  )  
	  inst_delay
	  (
	    .i_data
	    (
	    	{
	    		i_current_diagram_number,
				i_start,
				i_finished,
				i_switch_diagram,
				i_switch_signal
			}
	    ),
	    .i_clock(i_clock),
	    .i_data_valid(1), // not used, compatibility purpose
	    .i_reset(i_reset), // not used, compatibility purpose
	    .o_data
	    (
	    	{
	    		o_current_diagram_number,
				o_start,
				o_finished,
				o_switch_diagram,
				o_switch_signal
			}
	    )
	  );
endmodule
