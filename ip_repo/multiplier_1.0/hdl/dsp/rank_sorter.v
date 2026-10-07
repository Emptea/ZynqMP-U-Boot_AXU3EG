`timescale 1ps/1ps

module RankSorter
	#(
		parameter DATA_WIDTH = 32,
		parameter ADDRESS_WIDTH = 5,
		parameter DEPTH = 15
	)
	(
		input [DATA_WIDTH - 1: 0]i_data,
		input i_data_valid,

		input [ADDRESS_WIDTH - 1: 0]i_rank,

		input i_reset,
		input i_clock,

		output reg [DATA_WIDTH - 1: 0] o_data,
		output reg o_data_valid,

		output reg o_ready
	);

	localparam STORAGE_WIDTH = ADDRESS_WIDTH + DATA_WIDTH;

	reg [ADDRESS_WIDTH - 1: 0]read_address, write_address;
	reg [STORAGE_WIDTH - 1: 0]data_to_storage;
	reg data_to_storage_valid;
	wire [STORAGE_WIDTH - 1: 0]data_from_storage;

	v_ram_2_port
		#(
			.p_data_width(STORAGE_WIDTH),
			.p_word_count(DEPTH),
			.p_addr_width(ADDRESS_WIDTH)
		)
		inst_storage
		(
			.i_data(data_to_storage),
			.i_data_valid(data_to_storage_valid),
			.i_read_addr(read_address),
			.i_write_addr(write_address),
			.i_read_clock(i_clock),
			.i_write_clock(i_clock),
			
			.o_data(data_from_storage)
		);	

	wire [DATA_WIDTH - 1: 0]data_from_mem;
	wire [ADDRESS_WIDTH - 1: 0]freshness_from_mem;

	assign {
		freshness_from_mem,
		data_from_mem
	} = data_from_storage;

	integer state;

	localparam e_reset = 0;
	localparam e_wait = 1;
	localparam e_check_counter = 2;
	localparam e_wait_read_1 = 3;
	localparam e_wait_read_2 = 4;
	localparam e_process_seek = 5;
	localparam e_process_switch = 6;
	localparam e_finish_switch = 7;
	localparam e_next = 8;
	localparam e_finish = 9;
	localparam e_start_rank = 10;
	localparam e_wait_rank_1 = 11;
	localparam e_wait_rank_2 = 12;

	reg mode;

	localparam e_seek = 0;
	localparam e_switch = 1;
	
	reg [ADDRESS_WIDTH: 0]counter_write;
	reg [DATA_WIDTH - 1: 0]current_data;
	reg [ADDRESS_WIDTH - 1: 0]current_freshness;
	
	wire [ADDRESS_WIDTH - 1: 0]updated_freshness_from_mem;
	
	assign updated_freshness_from_mem = freshness_from_mem - 1;

	always @(posedge i_clock)
	begin
		if(i_reset)
		begin
			state <= e_reset;
			write_address <= -1;
			counter_write <= 0;
			o_ready <= 0;
			o_data_valid <= 0;
			data_to_storage_valid <= 0;
		end
		else
		begin
			case(state)
				e_reset:
				begin
					data_to_storage_valid <= 1;
					data_to_storage <= {
						counter_write,
						32'b0
					};
					write_address <= write_address + 1;
					counter_write <= counter_write + 1;
	
					if(counter_write == DEPTH - 1) state <= e_wait;
					if(counter_write == DEPTH - 1) o_ready <= 1;
				end
	
				e_wait:
				begin
					o_data_valid <= 0;
					o_ready <= 0;
					counter_write <= 0;
					write_address <= 0;
					read_address <= 0;
					data_to_storage_valid <= 0;
	
					counter_write <= 0;

					mode <= e_seek;

					if(i_data_valid) state <= e_check_counter;

					current_data <= i_data;
					current_freshness <= DEPTH - 1;
				end

				e_check_counter:
				begin
					if(counter_write == DEPTH) state <= e_start_rank;
					else state <= e_wait_read_1;
				end

				e_wait_read_1:
				begin
					state <= e_wait_read_2;
				end

				e_wait_read_2:
				begin
					if(mode == e_seek) state <= e_process_seek;
					else if(mode == e_switch) state <= e_process_switch;
				end

				e_process_seek:
				begin
					state <= e_next;

					if(freshness_from_mem == 0)
					begin
						write_address <= read_address;
						data_to_storage <= {
							current_freshness,
							current_data
						};
						data_to_storage_valid <= 1;
						mode <= e_switch;
					end
					else if(current_data >= data_from_mem)
					begin
						write_address <= read_address;
						data_to_storage <= {
							updated_freshness_from_mem,
							data_from_mem
						};
						data_to_storage_valid <= 1;
					end
					else
					begin
						write_address <= read_address;
						data_to_storage <= {
							current_freshness,
							current_data
						};
						current_freshness <= updated_freshness_from_mem;
						current_data <= data_from_mem;

						data_to_storage_valid <= 1;
					end
				end

				e_process_switch:
				begin
					if(current_data >= data_from_mem)
					begin
						write_address <= read_address - 1;
						data_to_storage <= {
							updated_freshness_from_mem,
							data_from_mem
						};
						data_to_storage_valid <= 1;
						state <= e_finish_switch;
					end
					else
					begin
						write_address <= read_address;
						data_to_storage <= {
							updated_freshness_from_mem,
							data_from_mem
						};
						current_freshness <= updated_freshness_from_mem;
						current_data <= data_from_mem;
						data_to_storage_valid <= 1;
						state <= e_next;
					end
				end

				e_finish_switch:
				begin
					write_address <= read_address;
					data_to_storage <= {
						current_freshness,
						current_data
					};
					data_to_storage_valid <= 1;
					state <= e_next;					
				end

				e_next:
				begin
					data_to_storage_valid <= 0;
					read_address <= read_address + 1;
					counter_write <= counter_write + 1;
					state <= e_check_counter;
				end

				e_start_rank:
				begin
					read_address <= i_rank;
					state <= e_wait_rank_1;
				end

				e_wait_rank_1:
				begin
					state <= e_wait_rank_2;
				end

				e_wait_rank_2:
				begin
					state <= e_finish;
				end

				e_finish:
				begin
					o_data <= data_from_mem;
					o_data_valid <= 1;
					state <= e_wait;
				end
			endcase
		end
	end
endmodule