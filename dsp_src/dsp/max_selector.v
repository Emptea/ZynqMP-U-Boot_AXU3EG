module MaxSelector
	#(
		parameter SIGNAL_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8
	)
	(
		input [2 * CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]i_signal,
		input i_signal_start,
		input i_signal_valid,
		input i_signal_finished,
		input [7: 0]i_signal_time_num,
		input i_reset,
		input i_clock,

		output reg [2 * SIGNAL_WIDTH - 1: 0]o_max_value,
		output reg [7: 0]o_max_value_time_num,
		output reg [8: 0]o_max_value_frq_num,
		output reg [2: 0]o_max_value_channel_num
	);

	generate
		genvar i;
		for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
		begin: gen_channels
			multiplier
				#(
					.p_value_1_width(SIGNAL_WIDTH),
					.p_value_2_width(SIGNAL_WIDTH),
					.p_pipeline_mult_in(1),
					.p_pipeline_mult_out(1)
				)
				inst_mul_re_re
				(
					.i_value_1(channel_re),
					.i_value_2(channel_re),
				
					.i_reset(i_reset),
					.i_clock_enable(1'b1),
					.i_clock(i_clock),
				
					.o_value(channel_re_re)
				);	
	
			multiplier
				#(
					.p_value_1_width(SIGNAL_WIDTH),
					.p_value_2_width(SIGNAL_WIDTH),
					.p_pipeline_mult_in(1),
					.p_pipeline_mult_out(1)
				)
				inst_mul_im_im
				(
					.i_value_1(channel_im),
					.i_value_2(channel_im),
				
					.i_reset(i_reset),
					.i_clock_enable(1'b1),
					.i_clock(i_clock),
				
					.o_value(channel_im_im)
				);

			always @(posedge i_clock)
			begin
				channels[0][i] <= channel_im_im + channel_re_re;
				channel_nums[0][i] <= i;
			end
		end
	endgenerate

	localparam CHANNELS_DEPTH = clog2(CHANNEL_NUM);
	reg [2 * SIGNAL_WIDTH - 1: 0]channels[CHANNELS_DEPTH: 0][CHANNELS_NUM - 1: 0];
	reg [2: 0]channel_nums[CHANNELS_DEPTH: 0][CHANNELS_NUM - 1: 0];

	reg [2 * SIGNAL_WIDTH - 1: 0]max_diag_value;
	reg [2: 0]channel_nums;

	always @(posedge i_clock)
	begin
		if(i_reset)
		begin
		end
		else
		begin
			for(j = 1; j <= CHANNELS_DEPTH; j = j + 1)
			begin
				for(k = 0; k < CHANNELS_NUM >> i; k = k + 1)
				begin
					if(channels[j - 1][2 * k] > channels[j - 1][2 * k + 1])
					begin
						channels[j][k] <= channels[j - 1][2 * k];
						channel_nums[j][k] <= channel_nums[j - 1][2 * k];
					end
					else
					begin
						channels[j][k] <= channels[j - 1][2 * k + 1];
						channel_nums[j][k] <= channel_nums[j - 1][2 * k + 1];
					end
				end
			end
		end
	end

	assign max_diag_value = channels[CHANNELS_DEPTH][0];
	assign max_diag_channel = channel_nums[CHANNELS_DEPTH][0];

	always @(posedge i_clock)
	begin
		if(i_reset)
		begin
			state <= e_wait;
		end
		else
		begin
			case(state)
				e_wait:
				begin
					if(delayed_signal_start) state <= e_analyze;

					max_value <= 0;
					max_value_position <= 0;
				end

				e_analyze:
				begin
					if(delayed_signal_valid)
					begin
//						if(max_diag_value)
					end
				end


			endcase
		end
	end
endmodule