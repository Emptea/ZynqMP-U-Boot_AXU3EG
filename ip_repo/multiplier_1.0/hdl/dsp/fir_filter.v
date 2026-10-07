`timescale 1ps/1ps

module FirFilter
	#(
		parameter SIGNAL_WIDTH = 16,
		parameter FILTER_DEPTH = 35,
		parameter COEF_WIDTH = 16,
		parameter COEF_FILE = "",
		parameter PART_NUMBER = 5,
		parameter PART_DEPTH = 8,
		parameter ADD_WIDTH = 6,
		parameter COEF_ONE_WIDTH = 14,
		parameter [2 * COEF_WIDTH * FILTER_DEPTH - 1: 0] COEFS = 8'h0
	)
	(
		input [2 * SIGNAL_WIDTH - 1: 0]i_signal,
			
		input i_start,
		input i_far_valid,
		input i_close_valid,
		input i_far_mem_valid,
		input i_close_mem_valid,
		input i_finished,
		input [15: 0]i_diagram_number,
		input i_switch_diagram,
			
		input i_reset,
		input i_clock,

		output [2 * SIGNAL_WIDTH - 1: 0]o_signal,

		output o_start,
		output o_far_valid,
		output o_close_valid,
		output o_far_mem_valid,
		output o_close_mem_valid,
		output o_finished,
		output [15: 0]o_diagram_number,
		output o_switch_diagram
	);

	localparam MUL_WIDTH = COEF_WIDTH + SIGNAL_WIDTH;
	localparam ACCUM_WIDTH = MUL_WIDTH + ADD_WIDTH;


	wire [2 * SIGNAL_WIDTH - 1: 0]transfer[PART_NUMBER: 0];
	reg signed [ACCUM_WIDTH - 1: 0]accumulator[PART_NUMBER - 1: 0][1: 0];

	assign transfer[0] = i_signal;

	wire valid;
	assign valid = i_far_valid | i_close_valid;

	wire signed [SIGNAL_WIDTH - 1: 0]mul_signal_re[PART_NUMBER - 1: 0];
	wire signed [SIGNAL_WIDTH - 1: 0]mul_signal_im[PART_NUMBER - 1: 0];
	wire signed [COEF_WIDTH - 1: 0]mul_coef_re[PART_NUMBER - 1: 0];
	wire signed [SIGNAL_WIDTH - 1: 0]mul_coef_im[PART_NUMBER - 1: 0];

	wire internal_switch_diagram;

	v_reg_delay
	  #(
	    .p_delay_length(PART_DEPTH +1),
	    .p_bit_width(1)
	  )  
	  local_delay_switch_diagram
	  (
	    .i_data(i_switch_diagram),
	    .i_clock(i_clock),
	    .i_data_valid(1), // not used, compatibility purpose
	    .i_reset(i_reset), // not used, compatibility purpose
	    .o_data(internal_switch_diagram)
	  );
	wire debug_valids[PART_NUMBER - 1: 0];
	generate
		genvar part;

		for(part = 0; part < PART_NUMBER; part = part + 1)
		begin: gen_part
			localparam DEPTH = (FILTER_DEPTH - part * PART_DEPTH >= PART_DEPTH)? PART_DEPTH : (FILTER_DEPTH - part * PART_DEPTH);

			reg [2 * SIGNAL_WIDTH * DEPTH - 1: 0]data;
			reg [2 * COEF_WIDTH * DEPTH - 1: 0]coefs;
			reg [DEPTH - 1: 0]valids;

			assign transfer[part + 1] = data[2 * SIGNAL_WIDTH * (DEPTH - 1) +: 2 * SIGNAL_WIDTH];

			reg [2 * SIGNAL_WIDTH - 1: 0]out_part;
			
			assign debug_valids[part] = valids[0];

			always @(posedge i_clock)
			begin
				if(i_reset | internal_switch_diagram)
				begin
					data <= 0;
					out_part <= 0;
					valids <= 0;
				end
				else if(valid)
				begin
					{out_part, data} <= {data, transfer[part]};
					coefs <= COEFS[2 * COEF_WIDTH * PART_DEPTH * part +: 2 * COEF_WIDTH * DEPTH];
					valids <= 16'hffff;
				end
				else if(valids[0])
				begin
					data <= {data[0 +: 2 * SIGNAL_WIDTH], data[2 * SIGNAL_WIDTH +: 2 * SIGNAL_WIDTH * (DEPTH - 1)]};
					coefs <= {coefs[0 +: 2 * COEF_WIDTH], coefs[2 * COEF_WIDTH +: 2 * COEF_WIDTH * (DEPTH - 1)]};
					valids <= {1'b0, valids[DEPTH - 1: 1]};
				end
			end

			wire signed [MUL_WIDTH - 1: 0]mul_re, mul_im;

			assign mul_signal_re[part] = data[0 +: SIGNAL_WIDTH],
				mul_signal_im[part] = data[SIGNAL_WIDTH +: SIGNAL_WIDTH],
				mul_coef_re[part] = coefs[0 +: COEF_WIDTH],
				mul_coef_im[part] = coefs[COEF_WIDTH +: COEF_WIDTH];
				
			complex_multiplier
			  #(
			    .p_value_1_width(SIGNAL_WIDTH),
			    .p_value_2_width(COEF_WIDTH),
			    .p_pipeline_mult_in(1),
			    .p_pipeline_mult_out(1),
			    .p_pipeline_add(1),
			    .p_reduce_mul_bus("NO")
			  )
			  inst_mul
			  (
			    .i_value_1_re(mul_signal_re[part]),
			    .i_value_1_im(mul_signal_im[part]),
			
			    .i_value_2_re(mul_coef_re[part]),
			    .i_value_2_im(mul_coef_im[part]),
			    
			    .i_reset(i_reset),
			    .i_clock_enable(1'b1),
			    .i_clock(i_clock),
			    
			    .o_value_re(mul_re),
			    .o_value_im(mul_im)
			  );	

			wire valids_out, valid_out;

			always @(posedge i_clock)
			begin
				if(valid_out)
				begin
					accumulator[part][0] <= 0;
					accumulator[part][1] <= 0;
				end
				else
				begin
					if(valids_out)
					begin
						accumulator[part][0] <= accumulator[part][0] + mul_re;
						accumulator[part][1] <= accumulator[part][1] + mul_im;
					end
				end
			end
		
			v_reg_delay
			  #(
			    .p_delay_length(7),
			    .p_bit_width(2)
			  )  
			  local_delay
			  (
			    .i_data
			    (
			    	{
						valids[0],
						valid
					}
			    ),
			    .i_clock(i_clock),
			    .i_data_valid(1), // not used, compatibility purpose
			    .i_reset(i_reset), // not used, compatibility purpose
			    .o_data
			    (
			    	{
			    		valids_out,
			    		valid_out
					}
			    )
			  );
		end
	endgenerate

	reg [ACCUM_WIDTH - 1: 0]result[1: 0];
	integer i;

	always @(posedge i_clock)
	begin
		result[0] = 0;
		result[1] = 0;

		for(i = 0; i < PART_NUMBER; i = i + 1)
		begin
			result[0] = result[0] + accumulator[i][0];
			result[1] = result[1] + accumulator[i][1];
		end
	end

	assign o_signal[0 +: SIGNAL_WIDTH] = result[0][ADD_WIDTH + COEF_ONE_WIDTH +: SIGNAL_WIDTH] + result[0][ADD_WIDTH + COEF_ONE_WIDTH - 1];
	assign o_signal[SIGNAL_WIDTH +: SIGNAL_WIDTH] = result[1][ADD_WIDTH + COEF_ONE_WIDTH +: SIGNAL_WIDTH] + result[1][ADD_WIDTH + COEF_ONE_WIDTH - 1];	


	v_reg_delay
	  #(
	    .p_delay_length(17),
	    .p_bit_width(5 + 16 + 2)
	  )  
	  inst_delay
	  (
	    .i_data
	    (
	    	{
	    		i_far_mem_valid,
	    		i_close_mem_valid,
				i_switch_diagram,
				i_start,
				i_far_valid,
				i_close_valid,
				i_finished,
				i_diagram_number
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
				o_switch_diagram,
				o_start,
				o_far_valid,
				o_close_valid,
				o_finished,
				o_diagram_number
			}
	    )
	  );

endmodule