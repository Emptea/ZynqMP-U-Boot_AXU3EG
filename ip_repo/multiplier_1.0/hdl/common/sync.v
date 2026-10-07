`timescale 1ps/1ps

module Sync
	#(
		parameter SYNC_LENGTH = 3
	)
	(
		input i_data,
		input i_dst_clock,

		output reg o_data
	);
	reg [SYNC_LENGTH - 1: 0]sync;

	always @(posedge i_dst_clock)
	begin
		{o_data, sync} <= {sync, i_data};
	end
endmodule

module SyncStart
	#(
		parameter SYNC_LENGTH = 3
	)
	(
		input i_start,
		input i_src_clock,
		input i_dst_clock,

		output reg o_start
	);
	reg start_src;
	reg [SYNC_LENGTH - 1: 0]sync_start_dst;
	reg start_dst;

	reg reset_dst;
	reg [SYNC_LENGTH -  1: 0]sync_reset_src;
	reg reset_src;

	reg prev_start_dst;

	always @(posedge i_src_clock)
	begin
		if(i_start) start_src <= 1;
		else if(reset_dst) start_src <= 0;

		{reset_src, sync_reset_src} <= {sync_reset_src, reset_dst};
	end

	always @(posedge i_dst_clock)
	begin
		{start_dst, sync_start_dst} <= {sync_start_dst, start_src};

		prev_start_dst <= start_dst;
		reset_dst <= start_dst;

		o_start <= start_dst & ~prev_start_dst;
	end
endmodule