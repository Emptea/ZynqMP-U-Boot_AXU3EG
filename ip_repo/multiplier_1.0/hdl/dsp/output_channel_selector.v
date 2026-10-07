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
module OutputChannelSelector
    #(
        parameter CHANNEL_NUMBER = 8,
        parameter BIT_WIDTH = 16
    )
    (
	input [BIT_WIDTH - 1: 0]i_data,
	input [2: 0]i_current_channel_number,
	input [2: 0]i_selected_channel_number,
	input i_data_started,
	input i_data_finished,
	input i_data_valid,
	input i_clock,
	input i_reset,
	
	output reg o_data_started,
	output reg o_data_finished,
	output reg [BIT_WIDTH - 1: 0]o_data,
	output reg o_data_valid
);


	always @(posedge i_clock)
	begin
		if(i_current_channel_number == i_selected_channel_number) 
		begin
			o_data = i_data;
			o_data_valid = i_data_valid;
		end
		else
		begin
			o_data = 0;
			o_data_valid = 0;
		end
	end

	always @(posedge i_clock)
	begin
			o_data_started <= i_data_started;
			o_data_finished <= i_data_finished;
	end
endmodule
