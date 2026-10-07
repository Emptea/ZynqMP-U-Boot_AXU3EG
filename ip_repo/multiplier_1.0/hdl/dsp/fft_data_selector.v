`timescale 1ps/1ps

module FftDataSelector
	#(
		parameter SIGNAL_WIDTH = 16,
		parameter CHANNEL_NUMBER = 4,
		parameter DISTANCE_LENGTH = 141,
		parameter CHANNEL_SEQUENCE_NUMBER = 2
	)
	(
		input [2 * SIGNAL_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal,
		input [CHANNEL_NUMBER - 1: 0]i_signal_valid,
		input [CHANNEL_NUMBER - 1: 0]i_signal_last,
		input [2: 0]i_selected_channel,
		input [7: 0]i_selected_distance,

		input i_reset,
		input i_clock,

	(* mark_debug = "true" *)		
		output reg [2 * SIGNAL_WIDTH - 1: 0]o_signal,
	(* mark_debug = "true" *)		
		output reg o_signal_valid,
	(* mark_debug = "true" *)		
		output reg o_signal_last,
	(* mark_debug = "true" *)		
		output reg o_signal_start
	);

	wire [2 * SIGNAL_WIDTH - 1: 0]signal[CHANNEL_NUMBER - 1: 0];
	wire signal_valid[CHANNEL_NUMBER - 1: 0];
	wire signal_last[CHANNEL_NUMBER - 1: 0];
	wire signal_start[CHANNEL_NUMBER - 1: 0];

	generate
		genvar i;

		for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
		begin: gen_elem
			FftDataSelectorElement
				#(
					.SIGNAL_WIDTH(SIGNAL_WIDTH),
					.DISTANCE_LENGTH(DISTANCE_LENGTH),
					.CHANNEL_SEQUENCE_NUMBER(CHANNEL_SEQUENCE_NUMBER),
					.CHANNEL(i)
				)
				inst_fft_data_selector_elemnent
				(
					.i_signal(i_signal[2 * SIGNAL_WIDTH * i +: 2 * SIGNAL_WIDTH]),
					.i_signal_valid(i_signal_valid[i]),
					.i_signal_last(i_signal_last[i]),
			
					.i_selected_channel(i_selected_channel),
					.i_selected_distance(i_selected_distance),
					.i_reset(i_reset),
					.i_clock(i_clock),
			
					.o_signal(signal[i]),
					.o_signal_start(signal_start[i]),
					.o_signal_valid(signal_valid[i]),
					.o_signal_last(signal_last[i])
				);
		end
	endgenerate

	integer k;

	always @(posedge i_clock)
	begin
		o_signal = 0;
		o_signal_start = 0;
		o_signal_valid = 0;
		o_signal_last = 0;

		for(k = 0; k < CHANNEL_NUMBER; k = k + 1)
		begin
			o_signal = o_signal | signal[k];
			o_signal_start = o_signal_start | signal_start[k];
			o_signal_valid = o_signal_valid | signal_valid[k];
			o_signal_last = o_signal_last | signal_last[k];
		end
	end
endmodule

module FftDataSelectorElement
	#(
		parameter SIGNAL_WIDTH = 16,
		parameter DISTANCE_LENGTH = 141,
		parameter CHANNEL_SEQUENCE_NUMBER = 2,
		parameter [1: 0]CHANNEL = 0
	)
	(

	(* mark_debug = "true" *)		
		input [2 * SIGNAL_WIDTH - 1: 0]i_signal,
	(* mark_debug = "true" *)		
		input i_signal_valid,
	(* mark_debug = "true" *)		
		input i_signal_last,
	(* mark_debug = "true" *)		
		input [2: 0]i_selected_channel,
	(* mark_debug = "true" *)		
		input [7: 0]i_selected_distance,

		input i_reset,
		input i_clock,

	(* mark_debug = "true" *)		
		output reg [2 * SIGNAL_WIDTH - 1: 0]o_signal,
	(* mark_debug = "true" *)		
		output reg o_signal_start,
	(* mark_debug = "true" *)		
		output reg o_signal_valid,
	(* mark_debug = "true" *)		
		output reg o_signal_last
	);

	(* mark_debug = "true" *)		
	reg is_selected;
	(* mark_debug = "true" *)		
	reg [7: 0]distance;
	(* mark_debug = "true" *)		
	reg is_high_channel;
	(* mark_debug = "true" *)		
	reg is_selected_channel;
	
	reg signal_valid;

	initial
	begin
		signal_valid = 0;
	end
	
	reg [2 * SIGNAL_WIDTH - 1: 0]signal;
	reg signal_last, signal_last_2;
	
	always @(posedge i_clock)
	begin
		signal_valid <= i_signal_valid;
		signal <= i_signal;
		signal_last <= i_signal_last & i_signal_valid;
		signal_last_2 <= signal_last;

		if(is_selected_channel)
		begin
			o_signal <= signal;
			o_signal_start <= i_signal_valid & ~signal_valid;
			o_signal_valid <= signal_valid;
			o_signal_last <= signal_last_2;
		end
		else
		begin
			o_signal <= 0;
			o_signal_start <= 0;
			o_signal_valid <= 0;
			o_signal_last <= 0;
		end

		if(i_reset) {distance, is_high_channel} <= 0;
		else if(signal_last)
		begin
			if(distance == (DISTANCE_LENGTH - 1) && is_high_channel) {distance, is_high_channel} <= 0;
			else {distance, is_high_channel} <= {distance, is_high_channel} + 1;
		end

		if(i_reset) is_selected_channel <= 0;
		else if(distance == i_selected_distance && {is_high_channel, CHANNEL} == i_selected_channel) is_selected_channel <= 1;
		else is_selected_channel <= 0;
	end
endmodule
