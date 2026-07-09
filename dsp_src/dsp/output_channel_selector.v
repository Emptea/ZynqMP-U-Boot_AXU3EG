`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:54:40 06/02/2026 
// Design Name: 
// Module Name:    output_channel_selector 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module output_channel_selector(
	input [2 * CHANNEL_NUMBER * BIT_WIDTH - 1: 0]i_data,
	input [31: 0]i_channel_number,
	input i_data_valid,
	input i_clock,
	input i_reset,
	
	output reg [2 * BIT_WIDTH - 1: 0]o_data,
	output reg o_data_valid
);

	integer i;
	
	always @(posedge i_clock)
	begin
			for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
			begin
				if(i == i_channel_number) o_data = i_data;
			end			
			
			o_data_valid = i_data_valid;
	end
endmodule
