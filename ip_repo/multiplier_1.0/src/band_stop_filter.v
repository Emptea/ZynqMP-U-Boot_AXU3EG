`timescale 1ps/1ps

module BandStopFilter
	#(
		parameter SIGNAL_WIDTH = 16,
		parameter FRAME_NUMBER = 6,
		parameter FRAME_LENGTH = 40,
		parameter MODE = "filter",
		parameter ADDRESS_WIDTH = 8
	)
	(
		input [2 * SIGNAL_WIDTH - 1: 0]i_signal,
		input i_far_valid,
		input i_close_valid,
		input i_start,
		input i_finished,
		input i_switch_diagram,
		input [15: 0]i_diagram_number,

		input is_enabled,

		input i_clock,
		input i_reset,

		output reg [2 * SIGNAL_WIDTH - 1: 0]o_signal,
		output reg o_far_valid,
		output reg o_close_valid,
		output reg o_start,
		output reg o_finished,
		output reg o_switch_diagram,
		output reg [15: 0]o_diagram_number
	);

	localparam DEPTH = FRAME_NUMBER * FRAME_LENGTH;

	reg is_initialized;

	reg [2 * SIGNAL_WIDTH - 1: 0]data_to_mem;
	reg data_to_mem_valid;
	reg [ADDRESS_WIDTH - 1: 0]write_address, read_address;
	wire [2 * SIGNAL_WIDTH - 1: 0]data_from_mem;

	v_ram_2_port
		#(
			.p_data_width(2 * SIGNAL_WIDTH),
			.p_word_count(DEPTH),
			.p_addr_width(ADDRESS_WIDTH)
		)
		inst_ram
		(
			.i_data(data_to_mem),
			.i_data_valid(data_to_mem_valid),
			.i_read_addr(read_address),
			.i_write_addr(write_address),
			.i_read_clock(i_clock),
			.i_write_clock(i_clock),
			
			.o_data(data_from_mem)
		);

	integer state;

	localparam e_reset = 0;
	localparam e_init = 1;
	localparam e_work = 2;

	always @(posedge i_clock)
	begin
		if(i_reset) 
		begin
			is_initialized <= 0;
			state <= e_reset;
			write_address <= -1;
			data_to_mem_valid <= 0;
		end
		else if(MODE == "filter")
		begin
			case(state)
				e_reset:
				begin
					write_address <= write_address + 1;
					data_to_mem_valid <= 1;
					data_to_mem <= 0;

					if(write_address == DEPTH - 1) state <= e_init;
				end

				e_init:
				begin
					data_to_mem_valid <= 0;
					write_address <= -1;
					state <= e_work;
					is_initialized <= 1;
				end

				e_work:
				begin
					if(i_diagram_number == 0 && i_close_valid == 1)
					begin
						if(write_address == DEPTH - 1) write_address <= 0;
						else write_address <= write_address + 1;

						data_to_mem_valid <= 1;
						data_to_mem <= i_signal;
					end
					else
					begin
						data_to_mem_valid <= 0;
					end
				end
			endcase
		end

		if(i_reset)
		begin
			read_address <= 0;
		end
		else if(is_initialized == 1 && i_diagram_number == 0 && is_enabled == 1 && i_close_valid == 1 && MODE == "filter")
		begin
			if(read_address == DEPTH - 1) read_address <= 0;
			else read_address <= read_address + 1;
		end

		if(is_initialized == 1 && i_diagram_number == 0 && is_enabled == 1 && MODE == "filter" && i_close_valid == 1) 
		begin
			o_signal[0 +: SIGNAL_WIDTH] <= i_signal[0 +: SIGNAL_WIDTH] - data_from_mem[0 +: SIGNAL_WIDTH];
			o_signal[SIGNAL_WIDTH +: SIGNAL_WIDTH] <= i_signal[SIGNAL_WIDTH +: SIGNAL_WIDTH] - data_from_mem[SIGNAL_WIDTH +: SIGNAL_WIDTH];
		end
		else
		begin
			o_signal <= i_signal;
		end

		o_far_valid <= i_far_valid;
		o_close_valid <= i_close_valid;
		o_switch_diagram <= i_switch_diagram;
		o_diagram_number <= i_diagram_number;
		o_start <= i_start;
		o_finished <= i_finished;
	end
endmodule
