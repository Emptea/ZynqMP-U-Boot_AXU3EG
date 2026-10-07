`timescale 1ps/1ps

module WeightMultiplier
	#(
		parameter SIGNAL_WIDTH = 16,
		parameter COEF_WIDTH = 16,
		parameter COEF_LEVEL_ONE = 14,
		parameter COEF_DEPTH = 512,
		parameter COEF_FILE = "",
		parameter CHANNEL_NUMBER = 4,
		parameter ADDRESS_WIDTH = 9
	)
	(
		input [2 * CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]i_signal,
		input i_data_start,
		input [CHANNEL_NUMBER - 1: 0]i_ready,
		input i_valid,
		input i_last,

		input i_clock,
		input i_reset,

		output reg [2 * CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]o_signal,
		output o_valid,
		output o_last
	);
	wire [COEF_WIDTH - 1: 0]coef;
	reg [ADDRESS_WIDTH - 1: 0]address;
	wire clock_enable;

	wire [2 * CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]signal;
	wire valid;
	wire last;

	assign clock_enable = &i_ready;



	v_ram_2_port_ena
		#(
			.p_data_width(COEF_WIDTH),
			.p_word_count(COEF_DEPTH),
			.p_addr_width(ADDRESS_WIDTH),
			.p_init_file(COEF_FILE)
		)
		inst_coefs
		(
			.i_data(),
			.i_read_clock_enable(clock_enable),
			.i_write_clock_enable(0),
			.i_data_valid(0),
			.i_read_addr(address),
			.i_write_addr(0),
			.i_read_clock(i_clock),
			.i_write_clock(i_clock),
	    
	    	.o_data(coef)
		);

	always @(posedge i_clock)
	begin
		if(i_data_start) address <= 0;
		else if(clock_enable & i_valid) address <= address + 1;
	end  


	v_reg_delay
	  #(
	    .p_delay_length(2),
	    .p_bit_width(2 * SIGNAL_WIDTH * CHANNEL_NUMBER + 2),
	    .CLOCK_ENABLE("YES")
	  )
	  inst_delay_for_ram
	  (
	    .i_data(
	    	{
	    		i_signal,
	    		i_valid,
	    		i_last
	    	}
	    ),
	    .i_clock(i_clock),
	    .i_data_valid(clock_enable), // not used, compatibility purpose
	    .i_reset(i_reset), // not used, compatibility purpose
	    .i_clock_enable(clock_enable),
	    .o_data(
	    	{
	    		signal,
	    		valid,
	    		last
	    	}
	    )
	  );	

	v_reg_delay
	  #(
	    .p_delay_length(5),
	    .p_bit_width(2),
	    .CLOCK_ENABLE("YES")
	  )
	  inst_delay_for_mul
	  (
	    .i_data(
	    	{
	    		valid,
	    		last
	    	}
	    ),
	    .i_clock(i_clock),
	    .i_data_valid(clock_enable), // not used, compatibility purpose
	    .i_reset(i_reset), // not used, compatibility purpose
	    .i_clock_enable(clock_enable),
	    .o_data(
	    	{
	    		o_valid,
	    		o_last
	    	}
	    )
	  );

	
	generate
		genvar i;

		for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
		begin: gen_muls
			wire signed [SIGNAL_WIDTH - 1: 0]input_re, input_im;
			wire signed [SIGNAL_WIDTH + COEF_WIDTH - 1: 0]muled_re, muled_im;
			
			assign input_re = signal[i * 2 * SIGNAL_WIDTH +: SIGNAL_WIDTH];
			assign input_im = signal[i * 2 * SIGNAL_WIDTH + SIGNAL_WIDTH +: SIGNAL_WIDTH];

			multiplier
			  #(
			    .p_value_1_width(SIGNAL_WIDTH),
			    .p_value_2_width(COEF_WIDTH),
			    .p_pipeline_mult_in(1),
			    .p_pipeline_mult_out(1)
			  )
			  inst_re
			  (
			    .i_value_1(input_re),
			    .i_value_2(coef),
			    
			    .i_reset(i_reset),
			    .i_clock_enable(clock_enable),
			    .i_clock(i_clock),
			    
			    .o_value(muled_re)
			  );

			multiplier
			  #(
			    .p_value_1_width(SIGNAL_WIDTH),
			    .p_value_2_width(COEF_WIDTH),
			    .p_pipeline_mult_in(1),
			    .p_pipeline_mult_out(1)
			  )
			  inst_im
			  (
			    .i_value_1(input_im),
			    .i_value_2(coef),
			    
			    .i_reset(i_reset),
			    .i_clock_enable(clock_enable),
			    .i_clock(i_clock),
			    
			    .o_value(muled_im)
			  );

			always @(posedge i_clock)
			begin
				if(clock_enable)
				begin
					o_signal[i * 2 * SIGNAL_WIDTH +: SIGNAL_WIDTH] <= muled_re[COEF_LEVEL_ONE +: SIGNAL_WIDTH] + muled_re[COEF_LEVEL_ONE - 1];
					o_signal[i * 2 * SIGNAL_WIDTH + SIGNAL_WIDTH +: SIGNAL_WIDTH] <= muled_im[COEF_LEVEL_ONE +: SIGNAL_WIDTH] + muled_im[COEF_LEVEL_ONE - 1];
				end
			end
		end
	endgenerate
endmodule
