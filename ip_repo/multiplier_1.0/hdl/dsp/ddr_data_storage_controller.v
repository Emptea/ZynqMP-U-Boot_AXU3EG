//////////////////////////////////////////////////////////////////////////////////
//   The external memory test module writes the address as data and compares    //
//   it to the address                                                          //
//  Author: meisq                                                               //
//          msq@qq.com                                                          //
//          ALINX(shanghai) Technology Co.,Ltd                                  //
//          heijin                                                              //
//     WEB: http://www.alinx.cn/                                                //
//     BBS: http://www.heijin.org/                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
// Copyright (c) 2017,ALINX(shanghai) Technology Co.,Ltd                        //
//                    All rights reserved                                       //
//                                                                              //
// This source file may be used and distributed without restriction provided    //
// that this copyright statement is not removed from the file and that any      //
// derivative work contains the original copyright notice and the associated    //
// disclaimer.                                                                  //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////

//================================================================================
//  Revision History:
//  Date          By            Revision    Change Description
//--------------------------------------------------------------------------------
//2017/6/28                    1.0          Original
//*******************************************************************************/
`timescale 1ps/1ps

module DdrDataStorageController
#(
	parameter SKIP_RESET = "FALSE",
	parameter DATA_WIDTH = 16,
	parameter DATA_LENGTH = 141,
	parameter OUT_DATA_LENGTH = 512,
	parameter CHANNEL_NUMBER = 8,
	parameter MEM_DATA_BITS          = 32,  //external memory user interface data width
	parameter ADDR_BITS              = 23,  //external memory user interface address width
	parameter BURST_BITS             = 10,  //external memory user interface burst width
	parameter BURST_SIZE             = 128, //burst size,
	parameter MEM_MASK_BITS          = 16
)
(
	(*mark_debug = "true"*)
	input [2 * DATA_WIDTH - 1: 0]i_data_1,
	(*mark_debug = "true"*)
	input [2 * DATA_WIDTH - 1: 0]i_data_2,
	(*mark_debug = "true"*)
	input [2: 0]i_channel_number_1,
	(*mark_debug = "true"*)
	input [2: 0]i_channel_number_2,	
	(*mark_debug = "true"*)
	input i_data_valid,
	(*mark_debug = "true"*)
	input i_start_receive,
	(*mark_debug = "true"*)
	input i_finish_receive,
	(*mark_debug = "true"*)
	input i_switch_channel,

	input i_reset,
	input i_clock,

	input i_output_data_enabled,

	(*mark_debug = "true"*)
	output reg [2 * DATA_WIDTH - 1: 0]o_data_1,
	(*mark_debug = "true"*)
	output reg [2 * DATA_WIDTH - 1: 0]o_data_2,
	(*mark_debug = "true"*)
	output reg [2 * DATA_WIDTH - 1: 0]o_data_3,
	(*mark_debug = "true"*)
	output reg [2 * DATA_WIDTH - 1: 0]o_data_4,

	(*mark_debug = "true"*)
	output reg o_data_valid,	

	(*mark_debug = "true"*)
	output reg o_data_last,

	output reg o_start,
	(*mark_debug = "true"*)
	output reg o_start_sequence,
	(*mark_debug = "true"*)
	output reg o_finish_sequence,	
	(*mark_debug = "true"*)
	output reg o_finish,

	input                            rst,
	input                            mem_clk,                             // external memory controller user interface clock
	(*mark_debug = "true"*)
	output reg                       rd_burst_req,                        // to external memory controller,send out a burst read request
	(*mark_debug = "true"*)
	output reg                       wr_burst_req,                        // to external memory controller,send out a burst write request
	(*mark_debug = "true"*)
	output reg[BURST_BITS - 1:0]     rd_burst_len,                        // to external memory controller,data length of the burst read request, not bytes
	(*mark_debug = "true"*)
	output reg[BURST_BITS - 1:0]     wr_burst_len,                        // to external memory controller,data length of the burst write request, not bytes
	(*mark_debug = "true"*)
	output reg[ADDR_BITS - 1:0]      rd_burst_addr,                       // to external memory controller,base address of the burst read request 
	(*mark_debug = "true"*)
	output reg[ADDR_BITS - 1:0]      wr_burst_addr,                       // to external memory controller,base address of the burst write request 
	(*mark_debug = "true"*)
	input                            rd_burst_data_valid,                 // from external memory controller,read data valid 
	(*mark_debug = "true"*)
	input                            wr_burst_data_req,                   // from external memory controller,write data request ,before data 1 clock
	(*mark_debug = "true"*)
	input[MEM_DATA_BITS - 1:0]       rd_burst_data,                       // from external memory controller,read request data
	(*mark_debug = "true"*)
	output reg[MEM_DATA_BITS - 1:0]  wr_burst_data,                       // to external memory controller,write data
	(*mark_debug = "true"*)
	output reg[MEM_MASK_BITS - 1:0]  wr_burst_mask,                       // to external memory controller,write data
	(*mark_debug = "true"*)
	input                            rd_burst_finish,                     // from external memory controller,burst read finish
	(*mark_debug = "true"*)
	input                            wr_burst_finish,                     // from external memory controller,burst write finish
	output reg                       heartbeat
);

localparam STEP = 1024;
localparam OUT_FRAME_BUFFER_LENGTH = 2;
localparam OUTPUT_BUFFER_ADDRESS_WIDTH = 10;

//state machine code
localparam IDLE                      = 3'd0;
localparam MEM_READ                  = 3'd1;  //read state
localparam MEM_WRITE                 = 3'd2;  //write state

localparam ONE                       = 512'd1; //512 bit '1' , ONE[n-1:0] for n bit '1'
localparam ZERO                      = 512'd0; //512 bit '0'
(*mark_debug = "true"*)
integer      state;
reg[31:0]                            heartbeat_cnt;   //heartbeat counter
(*mark_debug = "true"*)
reg[127:0] next_wr_burst_data;
(*mark_debug = "true"*)
reg[127:0] next_wr_burst_data_2;
(*mark_debug = "true"*)
reg[127:0] next_wr_burst_data_3;
(*mark_debug = "true"*)
reg[127:0] next_wr_burst_data_4;


//generate heartbeat signal
always@(posedge mem_clk or posedge rst)
begin
	if(rst == 1'b1)
		heartbeat_cnt  <= 32'd0;
	else if(rd_burst_data_valid == 1'b1 || wr_burst_data_req == 1'b1)
		heartbeat_cnt  <=  (heartbeat_cnt > 32'd99_999_999) ? 32'd0 : heartbeat_cnt + 32'd1;
end
always@(posedge mem_clk or posedge rst)
begin
	if(rst == 1'b1)
		heartbeat  <= 1'b0;
	else if(heartbeat_cnt > 32'd99_999_999)
		heartbeat <= ~heartbeat;
end

//wr_burst_data = write address
always@(posedge mem_clk or posedge rst)
begin
	if(rst == 1'b1)
		wr_burst_data <= ZERO[MEM_DATA_BITS - 1:0]; //wr_burst_data <= 0;
	else if(wr_burst_data_req == 1'b1)
		wr_burst_data <= next_wr_burst_data;
end
reg [15: 0]current_data;
reg [15: 0]write_count;

reg [ADDR_BITS - 1: 0]write_address;

localparam e_wait = 0;
localparam e_check_write = 1;
localparam e_start_write = 2;
localparam e_write = 3;
localparam e_finish_write = 4;
localparam e_check_read = 5;
localparam e_start_read = 6;
localparam e_read = 7;
localparam e_finish_read = 8;

localparam e_receive = 9;
localparam e_finish_receive = 10;
localparam e_finish_sequence_out = 11;

localparam e_check_reset = 12;
localparam e_start_reset = 13;
localparam e_reset = 14;


integer read_address;

localparam START_READ_PERIOD = 20 * 232 * 266 / 5;

reg should_write;

(*mark_debug = "true"*)
integer counter_write_time;
reg r_should_write;

(*mark_debug = "true"*)
integer counter_read_time;

(*mark_debug = "true"*)
integer total_read_time;
(*mark_debug = "true"*)
integer total_write_time;

(*mark_debug = "true"*)
integer total_read_count;

(*mark_debug = "true"*)
integer read_count;

(*mark_debug = "true"*)
reg start_read;

reg start_reset;
reg start_read_reset;

(*mark_debug = "true"*)
reg is_writing;
(*mark_debug = "true"*)
reg is_reading;
(*mark_debug = "true"*)
reg reset_total_time;

(*mark_debug = "true"*)
reg should_read;

(*mark_debug = "true"*)
integer total_write_count;
(*mark_debug = "true"*)
integer total_write_burst_count;
(*mark_debug = "true"*)
integer total_read_burst_count;

(*mark_debug = "true"*)
integer total_idle_time;

reg is_idle;

localparam MEM_MUX = 4;
localparam WRITE_FRAME_COUNTER_WIDTH = 2;
localparam COUNTER_FRAMES_WRITTEN = 20 / MEM_MUX;


reg [2 * DATA_WIDTH - 1: 0]in_buffer_data[MEM_MUX * CHANNEL_NUMBER - 1: 0];
reg [MEM_MUX * CHANNEL_NUMBER - 1: 0]in_buffer_data_valid;
reg [8: 0]in_buffer_read_address, in_buffer_write_address, start_in_buffer_write_address;
wire [2 * DATA_WIDTH - 1: 0]in_buffer_out[MEM_MUX * CHANNEL_NUMBER - 1: 0];

generate
	genvar i;
	for(i = 0; i < MEM_MUX * CHANNEL_NUMBER; i = i + 1)
	begin: gen_rams
		v_ram_2_port
		#(
			.p_data_width(2 * DATA_WIDTH),
			.p_word_count(DATA_LENGTH * 2),
			.p_addr_width(9)
		)
		inst_storage
		(	
			.i_data(in_buffer_data[i]),
			.i_data_valid(in_buffer_data_valid[i]),
			.i_read_addr(in_buffer_read_address),
			.i_write_addr(in_buffer_write_address),
			.i_read_clock(mem_clk),
			.i_write_clock(i_clock),
		
			.o_data(in_buffer_out[i])
		);
	end
endgenerate

reg [WRITE_FRAME_COUNTER_WIDTH -1 : 0]write_frame_counter;
(*mark_debug = "true"*)
integer state_in;

reg should_write_high_mem_src;
wire should_write_high_mem;

Sync
	#(
		.SYNC_LENGTH(3)
	)
	inst_sync_to_mem
	(
		.i_data(should_write_high_mem_src),
		.i_dst_clock(mem_clk),

		.o_data(should_write_high_mem)
	);

reg [8 * DATA_WIDTH - 1: 0]out_buffer_data;
reg out_buffer_data_valid;

wire [8 * DATA_WIDTH - 1: 0]out_buffer_out;

reg [OUTPUT_BUFFER_ADDRESS_WIDTH - 1: 0]out_buffer_read_address, out_buffer_write_address, out_buffer_read_address_current;

v_ram_2_port_ena
	#(
		.p_data_width(8 * DATA_WIDTH),
		.p_word_count(OUT_DATA_LENGTH * OUT_FRAME_BUFFER_LENGTH),
		.p_addr_width(OUTPUT_BUFFER_ADDRESS_WIDTH)
	)
	inst_out_storage
	(	
		.i_data(out_buffer_data),
		.i_data_valid(out_buffer_data_valid),
		.i_read_addr(out_buffer_read_address),
		.i_write_addr(out_buffer_write_address),
		.i_write_clock_enable(1'b1),
		.i_read_clock_enable(i_output_data_enabled),
		.i_read_clock(i_clock),
		.i_write_clock(mem_clk),
	
		.o_data(out_buffer_out)
	);

integer it_in;
reg is_second_package;
reg delayed_data_valid;
always @(posedge i_clock)
begin
	if(i_reset)
	begin
		state_in <= e_wait;
		write_frame_counter <= 0;
		in_buffer_write_address <= 0;
		start_in_buffer_write_address <= 0;
		should_write_high_mem_src <= 0;
		is_second_package <= 0;
		delayed_data_valid <= 0;
		in_buffer_data_valid <= 0;
	end
	else
	begin
		delayed_data_valid <= i_data_valid;
		
		case(state_in)
			e_wait:
			begin
				if(i_start_receive) state_in <= e_receive;

				in_buffer_write_address <= start_in_buffer_write_address;
			end

			e_receive:
			begin
				for(it_in = 0; it_in < CHANNEL_NUMBER * MEM_MUX; it_in = it_in + 1)
				begin
					if({write_frame_counter, i_channel_number_1} == it_in) in_buffer_data[it_in] <= i_data_1;
					else if({write_frame_counter, i_channel_number_2} == it_in) in_buffer_data[it_in] <= i_data_2;

					if({write_frame_counter, i_channel_number_1} == it_in) in_buffer_data_valid[it_in] <= i_data_valid;
					else if({write_frame_counter, i_channel_number_2} == it_in) in_buffer_data_valid[it_in] <= i_data_valid;
					else in_buffer_data_valid[it_in] <= 0;
				end

				if(i_switch_channel) in_buffer_write_address <= start_in_buffer_write_address;
				else if(delayed_data_valid)  in_buffer_write_address <= in_buffer_write_address + 1;

				if(i_finish_receive)
				begin
					state_in <= e_finish_receive;
				end
			end

			e_finish_receive:
			begin
				in_buffer_data_valid <= 0;
				
				{is_second_package, write_frame_counter} <= {is_second_package, write_frame_counter} + 1;

				if(is_second_package == 0 && write_frame_counter == MEM_MUX - 1)
				begin
					start_in_buffer_write_address <= DATA_LENGTH;
					should_write_high_mem_src <= 0;
				end
				else if(is_second_package == 1 && write_frame_counter == MEM_MUX - 1)
				begin
					start_in_buffer_write_address <= 0;
					should_write_high_mem_src <= 1;
				end

				state_in <= e_wait;
			end
		endcase
	end
end

(*mark_debug = "true"*)
reg [WRITE_FRAME_COUNTER_WIDTH - 1: 0]prev_write_frame_counter;
(*mark_debug = "true"*)
reg write_frames_written;

always @(posedge i_clock)
begin
	prev_write_frame_counter <= write_frame_counter;

	if(write_frame_counter == 0 && prev_write_frame_counter != 0)
	begin
		write_frames_written <= 1;
	end
	else
	begin
		write_frames_written <= 0;
	end
end

wire start_write;

SyncStart
	#(
		.SYNC_LENGTH(3)
	)
	inst_sync_start_write
	(
		.i_start(write_frames_written),
		.i_src_clock(i_clock),
		.i_dst_clock(mem_clk),

		.o_start(start_write)
	);

(*mark_debug = "true"*)
reg reg_start_write;

reg [2: 0]write_channel_number;
wire [2: 0]next_write_channel_number_1;
wire [2: 0]next_write_channel_number_2;
wire [2: 0]next_write_channel_number_3;

assign next_write_channel_number_1 = write_channel_number + 1;
assign next_write_channel_number_2 = write_channel_number + 2;
assign next_write_channel_number_3 = write_channel_number + 3;

reg new_frame_out_mem;

reg [4: 0]counter_frames_written;

wire finish_sequence_mem;

reg [3: 0]counter_out_frames_in_buffer;

wire out_frame_buffer_free;

assign out_frame_buffer_free = (counter_out_frames_in_buffer < OUT_FRAME_BUFFER_LENGTH) ? 1: 0;

reg [9: 0]start_address_offset;
reg [ADDR_BITS - 1: 0] min_read_address, max_read_address, next_read_address, reset_address;
reg [10: 0]leftover_size;
reg [BURST_BITS :0] read_size, read_length;

(*mark_debug = "true"*)
reg [3: 0]ddr_process_pending_counter;

(*mark_debug = "true"*)
reg started_processing;

(*mark_debug = "true"*)
reg prev_should_read;

(*mark_debug = "true"*)
integer total_procesing_time;

always @(posedge mem_clk or posedge rst)
begin
	if(rst == 1'b1) counter_out_frames_in_buffer <= 0;
	else if(finish_sequence_mem & new_frame_out_mem) counter_out_frames_in_buffer <= counter_out_frames_in_buffer;
	else if(finish_sequence_mem) counter_out_frames_in_buffer <= counter_out_frames_in_buffer - 1;
	else if(new_frame_out_mem) counter_out_frames_in_buffer <= counter_out_frames_in_buffer + 1;

	reg_start_write <= start_write;
	
	if(rst == 1'b1)
	begin
		should_write <= 1'b0;
	end
	else
	begin
		if(start_write) should_write <= 1;
		else if(r_should_write) should_write <= 0;
	end

	if(rst == 1'b1)
	begin
		counter_write_time <= 0;
	end
	else
	begin
		if(is_writing)
		begin
			counter_write_time <= counter_write_time + 1;
		end
		else
		begin
			counter_write_time <= 0;
		end
	end


	if(rst == 1'b1)
	begin
		total_read_time <= 0;
		total_write_time <= 0;
		total_idle_time <= 0;
	end
	else
	begin
		if(reset_total_time)
		begin
			total_idle_time <= 0;
		end
		else if(is_idle)
		begin
			total_idle_time <= total_idle_time + 1;
		end

		if(reset_total_time)
		begin
			total_read_time <= 0;
		end
		else if(is_reading)
		begin
			total_read_time <= total_read_time + 1;
		end

		if(reset_total_time)
		begin
			total_write_time <= 0;
		end
		else if(is_writing)
		begin
			total_write_time <= total_write_time + 1;
		end
	end


	if(rst == 1'b1)
	begin
		counter_read_time <= 0;
	end
	else
	begin
		case (state)
			e_wait:
			begin
				counter_read_time <= 0;
			end

			default:
			begin
				counter_read_time <= counter_read_time + 1;
			end
		endcase
	end

	if(rst == 1'b1)
	begin
		if(SKIP_RESET == "TRUE") state <= e_wait;
		else state <= e_check_reset;

		wr_burst_req <= 1'b0;
		rd_burst_req <= 1'b0;
		rd_burst_len <= BURST_SIZE[BURST_BITS - 1:0];
		wr_burst_len <= BURST_SIZE[BURST_BITS - 1:0];
		rd_burst_addr <= ZERO[ADDR_BITS - 1:0]; // rd_burst_addr <= 0;
		wr_burst_addr <= ZERO[ADDR_BITS - 1:0]; // wr_burst_addr <= 0
		current_data <= 0;
		write_address <= 0;
		wr_burst_mask <= 16'h0000;
		read_count <= 0;
		read_address <= 0;
		r_should_write <= 0;
		total_read_count <= 0;
		total_write_count <= 0;
		is_writing <= 0;
		is_reading <= 0;
		reset_total_time <= 0;
		should_read <= 0;
		total_read_burst_count <= 0;
		total_write_burst_count <= 0;
		is_idle <= 0;
		out_buffer_write_address <= 0;
		start_read <= 0;
		new_frame_out_mem <= 0;
		counter_frames_written <= 0;
		start_address_offset <= 0;
		reset_address <= 0;
		ddr_process_pending_counter <= 0;
		started_processing <= 0;
		prev_should_read <= 0;
		next_wr_burst_data_4 <= 0;
		next_wr_burst_data_3 <= 0;
		next_wr_burst_data_2 <= 0;
		next_wr_burst_data <= 0;
		total_procesing_time <= 0;
	end
	
	else
	begin
		if(start_read) ddr_process_pending_counter <= ddr_process_pending_counter + 1;
		else if(started_processing) ddr_process_pending_counter <= ddr_process_pending_counter - 1;

		prev_should_read <= should_read;

		started_processing <= should_read & ~prev_should_read;

		if(should_read) total_procesing_time <= total_procesing_time + 1;
		else total_procesing_time <= 0;

		case(state)
			e_check_reset:
			begin
				if(reset_address < STEP * 141 * 2)
				begin
					state <= e_start_reset;
				end
				else
				begin
					state <= e_wait;
				end
			end
			e_start_reset:
			begin
				reset_address <= reset_address + 128;
				wr_burst_addr <= reset_address;
				wr_burst_len <= 128;
				wr_burst_req <= 1;
				next_wr_burst_data <= 0;
				state <= e_reset;
			end
			e_reset:
			begin
				if(wr_burst_finish) state <= e_check_reset;

				if(wr_burst_finish) wr_burst_req <= 0;
			end
			e_wait:
			begin
				new_frame_out_mem <= 0;

				write_address <= current_data;

				start_read <= 0;

				if(should_read == 0 && ddr_process_pending_counter != 0) 
				begin
					should_read <= 1;
					total_read_count <= 0;
				end

				write_channel_number <= 0;

				if(~should_write_high_mem) in_buffer_read_address <= 0;
				else in_buffer_read_address <= DATA_LENGTH;

				if(should_write)
				begin
					r_should_write <= 1;
					state <= e_check_write;
				end
				else if(should_read & out_frame_buffer_free & ~new_frame_out_mem)
				begin
					leftover_size <= STEP - start_address_offset;
					read_address <= min_read_address + start_address_offset;
					state <= e_check_read;
				end

				is_idle <= 1;

				is_writing <= 0;
				is_reading <= 0;

				if(should_read == 0 && ddr_process_pending_counter != 0) 
				begin
					min_read_address <= 0;
					max_read_address <= STEP;
					total_read_count <= 0;
					total_write_count <= 0;
					total_write_burst_count <= 0;
					total_read_burst_count <= 0;
					read_address <= 0;
					reset_total_time <= 1;
					start_address_offset <= current_data - OUT_DATA_LENGTH;
					$display("start address: %x, %x %x", current_data, OUT_DATA_LENGTH, current_data - OUT_DATA_LENGTH);
				end
				else
				begin
					reset_total_time <= 0;
				end

				read_size <= OUT_DATA_LENGTH;

				read_count <= 0;

				write_count <= 0;
			end

			e_check_read:
			begin
				reset_total_time <= 0;

				is_idle <= 0;
				is_reading <= 1;

				if(read_size == 0)
				begin
					state <= e_finish_read;
				end
				else
				begin
					state <= e_start_read;
				end

				if(leftover_size > BURST_SIZE)
				begin
					if(read_size > BURST_SIZE) 
					begin
						read_length <= BURST_SIZE;
						next_read_address <= read_address + BURST_SIZE;
						leftover_size <= leftover_size - BURST_SIZE;
					end
					else 
					begin
						read_length <= read_size;
						next_read_address <= read_address + read_size;
						leftover_size <= leftover_size - read_size;
					end
				end
				else
				begin
					if(read_size > leftover_size) 
					begin
						read_length <= leftover_size;
						next_read_address <= min_read_address;
						leftover_size <= STEP;
					end
					else 
					begin
						read_length <= read_size;
						next_read_address <= read_address + leftover_size;
						leftover_size <= leftover_size - read_size;
					end
				end
			end

			e_start_read:
			begin
				rd_burst_req <= 1;
				rd_burst_len <= read_length;
				rd_burst_addr <= read_address;
				state <= e_read;
				read_size <= read_size - read_length;
			end

			e_read:
			begin
				if(rd_burst_finish) 
				begin
					rd_burst_req <= 0;
					state <= e_check_read;
					read_address <= next_read_address;
					read_count <= read_count + 1;
				end

				if(rd_burst_data_valid) total_read_count <= total_read_count + 1;

				out_buffer_data <= rd_burst_data; 
				out_buffer_data_valid <= rd_burst_data_valid;

				if(out_buffer_data_valid) out_buffer_write_address <= out_buffer_write_address + 1;
			end

			e_finish_read:
			begin
				total_read_burst_count <= total_read_burst_count + 1;

				if(total_read_burst_count == DATA_LENGTH * 2 - 1) should_read <= 0;

				new_frame_out_mem <= 1;

				min_read_address <= min_read_address + STEP;
				max_read_address <= max_read_address + STEP;

				state <= e_wait;
			end

			e_check_write:
			begin
				reset_total_time <= 0;

				is_idle <= 0;
				is_writing <= 1;
				r_should_write <= 0;

				if(write_count == DATA_LENGTH * 2)
				begin
					state <= e_finish_write;
				end
				else
				begin
					state <= e_start_write;
				end
			end

			e_start_write:
			begin
				wr_burst_req <= 1'b1;
				wr_burst_len <= MEM_MUX;
				wr_burst_addr <= write_address;

				next_wr_burst_data <= {
					in_buffer_out[{2'b0, next_write_channel_number_3}],
					in_buffer_out[{2'b0, next_write_channel_number_2}],
					in_buffer_out[{2'b0, next_write_channel_number_1}],
					in_buffer_out[{2'b0, write_channel_number}]
				};

				next_wr_burst_data_2 <= {
					in_buffer_out[{2'b1, next_write_channel_number_3}],
					in_buffer_out[{2'b1, next_write_channel_number_2}],
					in_buffer_out[{2'b1, next_write_channel_number_1}],
					in_buffer_out[{2'b1, write_channel_number}]
				};

				next_wr_burst_data_3 <= {
					in_buffer_out[{2'b10, next_write_channel_number_3}],
					in_buffer_out[{2'b10, next_write_channel_number_2}],
					in_buffer_out[{2'b10, next_write_channel_number_1}],
					in_buffer_out[{2'b10, write_channel_number}]
				};

				next_wr_burst_data_4 <= {
					in_buffer_out[{2'b11, next_write_channel_number_3}],
					in_buffer_out[{2'b11, next_write_channel_number_2}],
					in_buffer_out[{2'b11, next_write_channel_number_1}],
					in_buffer_out[{2'b11, write_channel_number}]
				};


				{in_buffer_read_address, write_channel_number} <= {in_buffer_read_address, write_channel_number} + 4;
				state <= e_write;
			end

			e_write:
			begin
				if(wr_burst_data_req) total_write_count <= total_write_count + 1;

				if(wr_burst_data_req)
				begin
					{
						next_wr_burst_data,
						next_wr_burst_data_2,
						next_wr_burst_data_3
					} <= 
					{
						next_wr_burst_data_2,
						next_wr_burst_data_3,
						next_wr_burst_data_4
					};
				end

				if(wr_burst_finish == 1'b1)
				begin
					wr_burst_req <= 1'b0;
					write_count <= write_count + 1;
					state <= e_check_write;

					write_address <= write_address + STEP;
				end
			end

			e_finish_write:
			begin
				total_write_burst_count <= total_write_burst_count + 1;
				
				if(current_data == STEP - MEM_MUX) current_data <= 0;
				else current_data <= current_data + MEM_MUX;

				if(counter_frames_written == COUNTER_FRAMES_WRITTEN - 1) start_read <= 1;

				if(counter_frames_written == COUNTER_FRAMES_WRITTEN - 1) counter_frames_written <= 0;
				else counter_frames_written <= counter_frames_written + 1;

				state <= e_wait;
			end

		endcase
	end
end

(*mark_debug = "true"*)
integer state_out;

wire new_frame_out;

SyncStart
	#(
		.SYNC_LENGTH(3)
	)
	inst_sync_new_frame_out
	(
		.i_start(new_frame_out_mem),
		.i_src_clock(mem_clk),
		.i_dst_clock(i_clock),

		.o_start(new_frame_out)
	);

reg [2: 0] counter_frames_out;
reg [OUTPUT_BUFFER_ADDRESS_WIDTH - 1: 0] counter_data_out;

SyncStart
	#(
		.SYNC_LENGTH(3)
	)
	inst_sync_finish_sequence_mem
	(
		.i_start(o_finish_sequence),
		.i_src_clock(i_clock),
		.i_dst_clock(mem_clk),

		.o_start(finish_sequence_mem)
	);

always @(posedge i_clock)
begin
	if(i_reset) counter_frames_out <= 0;
	else if(new_frame_out & o_finish_sequence) counter_frames_out <= counter_frames_out;
	else if(new_frame_out) counter_frames_out <= counter_frames_out + 1;
	else if(o_finish_sequence) counter_frames_out <= counter_frames_out - 1;

	if(i_reset)
	begin
		state_out <= e_wait;

		o_data_valid <= 0;

		o_start <= 0;
		o_start_sequence <= 0;
		o_finish_sequence <= 0;
		o_finish <= 0;
		o_data_last <= 0;

		out_buffer_read_address_current <= 0;
	end
	else
	begin
		case(state_out)
			e_wait:
			begin
				if(counter_frames_out != 0 && o_finish_sequence == 0) state_out <= e_read;

				if(counter_frames_out != 0) o_start_sequence <= 1;
				else o_start_sequence <= 0;

				o_data_valid <= 0;

				o_start <= 0;
				
				o_finish_sequence <= 0;
				o_finish <= 0;

				counter_data_out <= 0;

				out_buffer_read_address <= out_buffer_read_address_current;
			end

			e_read:
			begin
				if(i_output_data_enabled)
				begin
					o_start_sequence <= 0;

					{
						o_data_4,
						o_data_3,
						o_data_2,
						o_data_1
					} <= out_buffer_out;

					if(counter_data_out > 1) 
					begin
						o_data_valid <= 1;
					end

					if(counter_data_out == OUT_DATA_LENGTH + 1) 
					begin
						state_out <= e_finish_sequence_out;
						o_data_last <= 1;
					end

					counter_data_out <= counter_data_out + 1;

					out_buffer_read_address <= out_buffer_read_address + 1;
				end
			end

			e_finish_sequence_out:
			begin
				state_out <= e_wait;
				o_finish_sequence <= 1;

				o_data_valid <= 0;
				o_data_last <= 0;

				out_buffer_read_address_current <= out_buffer_read_address_current + OUT_DATA_LENGTH;
			end
		endcase
	end
end
endmodule