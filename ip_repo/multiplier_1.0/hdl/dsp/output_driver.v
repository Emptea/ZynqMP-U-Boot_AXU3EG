`timescale 1ps/1ps

module OutputDriver
	#(
		parameter BIT_WIDTH = 32,
		parameter LENGTH = 1024,
		parameter LENGTH_WIDTH = 11
	)
	(
(* mark_debug = "true" *)		
		input [BIT_WIDTH - 1: 0]i_data,
(* mark_debug = "true" *)		
		input i_data_valid,
		input i_start,
		input i_finished,

		input i_clock,
		input i_reset,

(* mark_debug = "true" *)		
		output reg [BIT_WIDTH - 1: 0] o_data,
(* mark_debug = "true" *)				
		output reg o_data_valid,
(* mark_debug = "true" *)				
		output reg o_data_last,
(* mark_debug = "true" *)				
		input i_awaiting_data,

		input [63: 0]i_input_frame_timestamp,
		input [31: 0]i_frame_number,

		input [15: 0]i_output_source,
		input [15: 0]i_output_source_channel,

		input [7: 0]i_last_on_packet_count,


(* mark_debug = "true" *)				
		output reg o_finished,

(* mark_debug = "true" *)				
		output reg o_enable_source_change

	);

	reg is_last_packet;

(* mark_debug = "true" *)		
	reg [BIT_WIDTH - 1: 0]data_to_mem;
(* mark_debug = "true" *)		
	wire [BIT_WIDTH - 1: 0]data_from_mem;
(* mark_debug = "true" *)		
	reg data_to_mem_valid;

(* mark_debug = "true" *)		
	reg [LENGTH_WIDTH - 1: 0]read_address;
(* mark_debug = "true" *)		
	reg [LENGTH_WIDTH - 1: 0]write_address;
(* mark_debug = "true" *)		
	reg [LENGTH_WIDTH - 1: 0]counter_save;

(* mark_debug = "true" *)		
	integer state;
	
	localparam e_wait = 0;
	localparam e_save = 1;
	localparam e_check_send = 2;
	localparam e_send = 3;
	localparam e_finish = 4;
	localparam e_pre_send_1 = 5;
	localparam e_pre_send_2 = 6;
	localparam e_check_send_header = 7;
	localparam e_send_header = 8;


	localparam DELIMITER_WIDTH = 64;
	localparam TIMESTAMP_WIDTH = 64;
	localparam FRAME_NUMBER_WIDTH = 32;
	localparam OUTPUT_SOURCE_WIDTH = 16;
	localparam OUTPUT_SOURCE_CHANNEL_WIDTH = 16;

	localparam HEADER_WIDTH = DELIMITER_WIDTH + TIMESTAMP_WIDTH + FRAME_NUMBER_WIDTH + OUTPUT_SOURCE_WIDTH + OUTPUT_SOURCE_CHANNEL_WIDTH;

	localparam HEADER_SIZE = HEADER_WIDTH / 32;

	reg [HEADER_WIDTH - 1: 0]header;
	integer header_counter;

	reg [63: 0]input_frame_timestamp;
	reg [31: 0]frame_number;
	reg [7: 0]counter_packets;

	v_ram_2_port
		#(
			.p_data_width(BIT_WIDTH),
			.p_word_count(LENGTH),
			.p_addr_width(LENGTH_WIDTH)
		)
		inst_storage
		(
			.i_data(data_to_mem),
			.i_data_valid(data_to_mem_valid),
			.i_read_addr(read_address),
			.i_write_addr(write_address),
			.i_read_clock(i_clock),
			.i_write_clock(i_clock),
			
			.o_data(data_from_mem)
		);

	always @(posedge i_clock)
	begin
		if(counter_packets == 0) o_enable_source_change <= 1;
		else o_enable_source_change <= 0;

		if(i_reset)
		begin
			state <= e_wait;
			o_data_valid <= 0;
			o_data_last <= 0;
			o_finished <= 0;
			counter_packets <= 0;
		end
		else
		begin
			case(state)
				e_wait:
				begin
					if(i_start) state <= e_save;
					if(i_start) counter_packets <= counter_packets + 1;

					counter_save <= 0;
					write_address <= 0;
					read_address <= 0;
					o_finished <= 0;

					header_counter = HEADER_SIZE;

					header <= {
						i_output_source,
						i_output_source_channel,
						i_input_frame_timestamp,
						i_frame_number,
						32'hfedcba98,
						32'h01234567
					};

				end

				e_save:
				begin
					if(data_to_mem_valid) write_address <= write_address + 1;
					data_to_mem <= i_data;
					data_to_mem_valid <= i_data_valid;

					if(i_data_valid) counter_save <= counter_save + 1;

					if(i_finished) state <= e_check_send_header;
				end

				e_check_send_header:
				begin
					if(counter_packets >= i_last_on_packet_count) is_last_packet <= 1;
					else is_last_packet <= 0;

					if(header_counter != 0) state <= e_send_header;
					else state <= e_pre_send_1;

					o_data_valid <= 0;
				end

				e_send_header:
				begin
					header_counter <= header_counter - 1;

					state <= e_check_send_header;

					o_data_valid <= 1;
					{header, o_data} <= header;
				end

				e_check_send:
				begin
					if(counter_save == 0) state <= e_finish;
					else if(i_awaiting_data) state <= e_pre_send_1;

					data_to_mem_valid <= 0;
					o_data_valid <= 0;
					o_data_last <= 0;
				end

				e_pre_send_1:
				begin
					state <= e_pre_send_2;
				end

				e_pre_send_2:
				begin
					state <= e_send;
				end

				e_send:
				begin
					o_data <= data_from_mem;
					read_address <= read_address + 1;
					counter_save <= counter_save - 1;
					state <= e_check_send;

					o_data_valid <= 1'b1;

					if(counter_save == 1) o_data_last <= is_last_packet;
				end

				e_finish:
				begin
					if(is_last_packet) counter_packets <= 0;
					
					state <= e_wait;

					o_finished <= 1'b1;
				end
			endcase
		end
	end
endmodule
