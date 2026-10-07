`timescale 1ps/1ps

module OutputSourceSelector
	#(
		parameter BIT_WIDTH = 32,
		parameter SOURCE_NUMBER = 8,
		parameter CHANNEL_NUMBER = 8
	)
	(
		input [BIT_WIDTH * CHANNEL_NUMBER * SOURCE_NUMBER - 1: 0]i_data,
		input [SOURCE_NUMBER - 1: 0]i_data_started,
		input [SOURCE_NUMBER - 1: 0]i_data_finished,
		input [SOURCE_NUMBER - 1: 0]i_data_valid,

		input [15: 0]i_channel_number,
		input [15: 0]i_source_number,

		input i_clock,
		input i_reset,

		output reg [BIT_WIDTH - 1: 0]o_data,
		output reg o_data_valid,
		output reg o_data_started,
		output reg o_data_finished
	);

	localparam FULL_WIDTH = BIT_WIDTH * CHANNEL_NUMBER;

	wire [BIT_WIDTH - 1: 0]selected_data[SOURCE_NUMBER - 1: 0];
	wire selected_data_valid[SOURCE_NUMBER - 1: 0];
	wire selected_data_started[SOURCE_NUMBER - 1: 0];
	wire selected_data_finished[SOURCE_NUMBER - 1: 0];

	generate
		genvar i;

		for(i = 0; i < SOURCE_NUMBER; i = i + 1)
		begin: gen_channel_selector
			OutputChannelSelector
			    #(
			        .CHANNEL_NUMBER(CHANNEL_NUMBER),
			        .BIT_WIDTH(BIT_WIDTH)
			    )
			    inst_output_selector
			    (
					.i_data(i_data[FULL_WIDTH * i +: FULL_WIDTH]),
					.i_channel_number(i_channel_number),
					.i_data_valid(i_data_valid[i]),
					.i_data_started(i_data_started[i]),
					.i_data_finished(i_data_finished[i]),
					.i_clock(i_clock),
					.i_reset(i_reset),
					
					.o_data(selected_data[i]),
					.o_data_valid(selected_data_valid[i]),
					.o_data_started(selected_data_started[i]),
					.o_data_finished(selected_data_finished[i])
				);

		end
	endgenerate

	integer k;

	always @(posedge i_clock)
	begin
		if(i_reset)
		begin
			o_data = 0;
			o_data_valid = 0;
			o_data_started = 0;
			o_data_finished = 0;
		end
		else
		begin
			o_data = 0;
			o_data_valid = 0;
			o_data_started = 0;
			o_data_finished = 0;
	
			for(k = 0; k < SOURCE_NUMBER; k = k + 1)
			begin
				if(k + 1 == i_source_number)
				begin
					o_data = selected_data[k];
					o_data_valid = selected_data_valid[k];
					o_data_started = selected_data_started[k];
					o_data_finished = selected_data_finished[k];
				end
			end
		end

	end
endmodule
