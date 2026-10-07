`timescale 1ps/1ps

module FftFrameProcessor
	#(
		parameter CHANNEL_NUMBER = 8,
		parameter CHANNEL_PER_CLOCK = 4,
		parameter SIGNAL_WIDTH = 16,
		parameter FFT_DEPTH = 512,
		parameter FRAME_LENGTH = 141
	)
	(
		input [CHANNEL_PER_CLOCK * 2 * SIGNAL_WIDTH - 1: 0]i_signal,

		input i_signal_valid,
		input i_signal_finished,

		input i_clock,
		input i_reset,

		output [2 * SIGNAL_WIDTH - 1: 0]o_signal,
		output [2 * SIGNAL_WIDTH - 1: 0]o_signal_aux,
		output [2: 0]o_signal_channel,
		output o_signal_aux_channel,
		output [8: 0]o_signal_frq_channel,
		output o_signal_valid,
		output o_frame_started,
		output o_frame_finished
	);

	reg [2 * SIGNAL_WIDTH - 1: 0]in_buffer_data[CHANNEL_NUMBER - 1: 0];
	reg [CHANNEL_NUMBER - 1: 0]in_buffer_data_valid;
	reg [9: 0]in_buffer_write_address;
	reg [9: 0]start_write_address[1: 0];
	(* mark_debug = "true" *)		
	reg [9: 0]read_address;
	reg [2 * SIGNAL_WIDTH - 1: 0]power[CHANNEL_PER_CLOCK - 1: 0];

	generate
		genvar imul;

		for(imul = 0; imul < CHANNEL_PER_CLOCK; imul = imul + 1)
		begin: gen_muls
			wire [2 * SIGNAL_WIDTH - 1: 0]re, im;

			multiplier
			  #(
			    .p_value_1_width(SIGNAL_WIDTH),
			    .p_value_2_width(SIGNAL_WIDTH),
			    .p_pipeline_mult_in(1),
			    .p_pipeline_mult_out(1)
			  )
			  inst_re
			  (
			    .i_value_1(i_signal[imul * 2 * SIGNAL_WIDTH +: SIGNAL_WIDTH]),
			    .i_value_2(i_signal[imul * 2 * SIGNAL_WIDTH +: SIGNAL_WIDTH]),
			    
			    .i_reset(i_reset),
			    .i_clock_enable(1'b1),
			    .i_clock(i_clock),
			    
			    .o_value(re)
			  );

			multiplier
			  #(
			    .p_value_1_width(SIGNAL_WIDTH),
			    .p_value_2_width(SIGNAL_WIDTH),
			    .p_pipeline_mult_in(1),
			    .p_pipeline_mult_out(1)
			  )
			  inst_im
			  (
			    .i_value_1(i_signal[imul * 2 * SIGNAL_WIDTH + SIGNAL_WIDTH +: SIGNAL_WIDTH]),
			    .i_value_2(i_signal[imul * 2 * SIGNAL_WIDTH + SIGNAL_WIDTH +: SIGNAL_WIDTH]),
			    
			    .i_reset(i_reset),
			    .i_clock_enable(1'b1),
			    .i_clock(i_clock),
			    
			    .o_value(im)
			  );

			always @(posedge i_clock)
			begin
				power[imul] <= re + im;
			end
		end
	endgenerate

	wire [2 * SIGNAL_WIDTH * CHANNEL_NUMBER - 1: 0]signal_to_max;

	generate
		genvar imem;

		for(imem = 0; imem < CHANNEL_NUMBER; imem = imem + 1)
		begin: gen_storage
			v_ram_2_port
			#(
				.p_data_width(2 * SIGNAL_WIDTH),
				.p_word_count(FFT_DEPTH * 2),
				.p_addr_width(10)
			)
			inst_storage
			(	
				.i_data(in_buffer_data[imem]),
				.i_data_valid(in_buffer_data_valid[imem]),
				.i_write_addr(in_buffer_write_address),
				.i_read_addr(read_address),
				.i_read_clock(i_clock),
				.i_write_clock(i_clock),
		
				.o_data(signal_to_max[imem * 2 * SIGNAL_WIDTH +: 2 * SIGNAL_WIDTH])
			);
		end
	endgenerate

	wire signal_valid;
	wire signal_finished;

	v_reg_delay
	  #(
	    .p_delay_length(5),
	    .p_bit_width(2)
	  )  
	  inst_input_delay
	  (
	    .i_data(
	    	{
	    		i_signal_valid,
	    		i_signal_finished & i_signal_valid
	    	}
	    ),
	    .i_clock(i_clock),
	    .i_data_valid(1'b1),
	    .i_reset(i_reset),
	    .o_data(
	    	{
				signal_valid,
				signal_finished
	    	}
	    )
	  );
	integer i;
	
	(* mark_debug = "true" *)		
	reg is_high_channel_number;
	(* mark_debug = "true" *)		
	reg start_processing;


	always @(posedge i_clock)
	begin
		if(i_reset)
		begin
			start_write_address[0] <= 0;
			start_write_address[1] <= 0;
			is_high_channel_number <= 0;
			start_processing <= 0;
		end
		else
		begin
			for(i = 0; i < CHANNEL_PER_CLOCK; i = i + 1)
			begin
				in_buffer_data[i] <= power[i];
				in_buffer_data[i + CHANNEL_PER_CLOCK] <= power[i];
				in_buffer_data_valid[i] <= signal_valid & ~is_high_channel_number;
				in_buffer_data_valid[i + CHANNEL_PER_CLOCK] <= signal_valid & is_high_channel_number;
			end

			in_buffer_write_address <= start_write_address[is_high_channel_number];

			if(signal_valid & ~is_high_channel_number) start_write_address[0] <= start_write_address[0] + 1;
			if(signal_valid & is_high_channel_number) start_write_address[1] <= start_write_address[1] + 1;

			if(signal_finished) is_high_channel_number <= ~is_high_channel_number;

			if(signal_finished & is_high_channel_number)  start_processing <= 1;
			else start_processing <= 0;
		end
	end

	(* mark_debug = "true" *)		
	integer state;

	localparam e_wait = 0;
	localparam e_process = 1;

	reg [7: 0]counter_frame;
	
	reg reset_processing;
	(* mark_debug = "true" *)		
	reg output_signal_finished;
	(* mark_debug = "true" *)		
	reg output_signal_valid;
	(* mark_debug = "true" *)		
	reg frame_finished;
	(* mark_debug = "true" *)		
	reg should_process;
	(* mark_debug = "true" *)		
	reg [9: 0]max_address;


	always @(posedge i_clock)
	begin
		if(i_reset) should_process <= 0;
		else if(start_processing) should_process <= 1;
		else if(reset_processing) should_process <= 0;

		if(i_reset)
		begin
			state <= e_wait;
			counter_frame <= 0;
			reset_processing <= 0;
			read_address <= 0;
		end
		else
		begin
			case(state)
				e_wait:
				begin
					if(should_process) 
					begin
						state <= e_process;
						reset_processing <= 1;
					end

					max_address <= read_address + FFT_DEPTH - 1;
					output_signal_finished <= 0;
					output_signal_valid <= 0;
					frame_finished <= 0;
				end

				e_process:
				begin
					reset_processing <= 0;

					read_address <= read_address + 1;
					output_signal_valid <= 1;

					if(read_address == max_address) 
					begin
						state <= e_wait;

						output_signal_finished <= 1;

						if(counter_frame == FRAME_LENGTH - 1)
						begin
							counter_frame <= 0;
							frame_finished <= 1;
						end
						else
						begin
							counter_frame <= counter_frame + 1;
						end
					end
				end
			endcase
		end
	end

	v_reg_delay
	  #(
	    .p_delay_length(1),
	    .p_bit_width(4)
	  )  
	  inst_output_delay
	  (
	    .i_data(
	    	{
	    		reset_processing,
	    		output_signal_valid,
	    		output_signal_finished,
	    		frame_finished
	    	}
	    ),
	    .i_clock(i_clock),
	    .i_data_valid(1'b1),
	    .i_reset(i_reset),
	    .o_data(
	    	{
	    		delayed_reset_processing,
	    		delayed_output_signal_valid,
				delayed_signal_finished,
				delayed_frame_finished
	    	}
	    )
	  );


	MaxSelector
		#(
			.SIGNAL_WIDTH(2 * SIGNAL_WIDTH),
			.CHANNEL_NUMBER(CHANNEL_NUMBER)
		)
		inst_max_selector
		(
			.i_signal(signal_to_max),
			.i_signal_valid(delayed_output_signal_valid),
			.i_signal_finished(delayed_signal_finished),
			.i_frame_finished(delayed_frame_finished),
			.i_reset(delayed_reset_processing),
			.i_clock(i_clock),
	
			.o_signal(o_signal),
			.o_signal_aux(o_signal_aux),
			.o_signal_channel(o_signal_channel),
			.o_signal_aux_channel(o_signal_aux_channel),
			.o_signal_valid(o_signal_valid),
			.o_signal_frq_channel(o_signal_frq_channel),
			.o_frame_finished(o_frame_finished),
			.o_frame_started(o_frame_started)
		);
endmodule

module MaxSelector
	#(
		parameter SIGNAL_WIDTH = 32,
		parameter CHANNEL_NUMBER = 8
	)
	(
		input [CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]i_signal,
	(* mark_debug = "true" *)		
		input i_signal_valid,
	(* mark_debug = "true" *)		
		input i_signal_finished,
	(* mark_debug = "true" *)		
		input i_frame_finished,
	(* mark_debug = "true" *)		
		input i_reset,
		input i_clock,

		output reg [SIGNAL_WIDTH - 1: 0]o_signal,
		output reg [SIGNAL_WIDTH - 1: 0]o_signal_aux,
		output reg [2: 0]o_signal_channel,
		output reg o_signal_aux_channel,
		output reg [8: 0]o_signal_frq_channel,
	(* mark_debug = "true" *)		
		output reg o_signal_valid,
	(* mark_debug = "true" *)		
		output reg o_frame_finished,
	(* mark_debug = "true" *)		
		output reg o_frame_started
	);

	reg [SIGNAL_WIDTH - 1: 0]input_signal[CHANNEL_NUMBER - 1: 0];
	reg [SIGNAL_WIDTH - 1: 0]signal[3: 0][CHANNEL_NUMBER - 1: 0];
	reg [SIGNAL_WIDTH - 1: 0]signal_aux[3: 0][CHANNEL_NUMBER - 1: 0];
	reg signal_aux_channel[3: 0][CHANNEL_NUMBER - 1: 0];
	reg [2: 0]signal_channel[3: 0][CHANNEL_NUMBER - 1: 0];

	integer i;
	always @(i_signal)
	begin
		for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
		begin
			input_signal[i] <= i_signal[i * SIGNAL_WIDTH +: SIGNAL_WIDTH];
		end
	end

	integer j;

	always @(posedge i_clock)
	begin
		for(j = 0; j < CHANNEL_NUMBER; j = j + 1)
		begin
			signal[0][j] <= input_signal[j];
			signal_channel[0][j] <= j;

			if(j == 0)
			begin
				signal_aux[0][j] <= input_signal[j + 1];
				signal_aux_channel[0][j] <= 1;
			end
			else if(j == CHANNEL_NUMBER - 1)
			begin
				signal_aux[0][j] <= input_signal[j - 1];
				signal_aux_channel[0][j] <= 0;
			end
			else
			begin
				if(input_signal[j - 1] > input_signal[j + 1])
				begin
					signal_aux[0][j] <= input_signal[j - 1];
					signal_aux_channel[0][j] <= 0;	
				end
				else
				begin
					signal_aux[0][j] <= input_signal[j + 1];
					signal_aux_channel[0][j] <= 1;	
				end
			end
		end
	end
	
	generate
		genvar k;

		for(k = 1; k < 4; k = k + 1)
		begin: genlayer
			integer m;
			
			always @(posedge i_clock)
			begin
				for(m = 0; m < CHANNEL_NUMBER; m = m + 1)
				begin
					if(signal[k - 1][2 * m] > signal[k - 1][2 * m + 1])
					begin
						signal[k][m] <= signal[k - 1][2 * m];
						signal_aux[k][m] <= signal_aux[k - 1][2 * m];
						signal_aux_channel[k][m] <= signal_aux_channel[k - 1][2 * m];
						signal_channel[k][m] <= signal_channel[k - 1][2 * m];
					end
					else
					begin
						signal[k][m] <= signal[k - 1][2 * m + 1];
						signal_aux[k][m] <= signal_aux[k - 1][2 * m + 1];
						signal_aux_channel[k][m] <= signal_aux_channel[k - 1][2 * m + 1];
						signal_channel[k][m] <= signal_channel[k - 1][2 * m + 1];
					end
				end
			end
		end
	endgenerate

	wire [SIGNAL_WIDTH - 1: 0]current_max_signal;
	wire [SIGNAL_WIDTH - 1: 0]current_max_signal_aux;
	(* mark_debug = "true" *)		
	wire [2: 0]current_max_signal_channel;
	(* mark_debug = "true" *)		
	wire current_max_signal_aux_channel;

	assign current_max_signal = signal[3][0];
	assign current_max_signal_aux = signal_aux[3][0];
	assign current_max_signal_aux_channel = signal_aux_channel[3][0];
	assign current_max_signal_channel = signal_channel[3][0];

	reg [SIGNAL_WIDTH - 1: 0]max_signal;
	reg [SIGNAL_WIDTH - 1: 0]max_signal_aux;
	reg [SIGNAL_WIDTH - 1: 0]max_signal_aux_channel;
	reg [SIGNAL_WIDTH - 1: 0]max_signal_channel;
	reg [SIGNAL_WIDTH - 1: 0]max_signal_frq_channel;
	reg [8: 0]current_frq_channel;

	v_reg_delay
	  #(
	    .p_delay_length(4),
	    .p_bit_width(4)
	  )  
	  inst_input_delay
	  (
	    .i_data(
	    	{
				i_signal_valid,
				i_signal_finished,
				i_frame_finished,
				i_reset
	    	}
	    ),
	    .i_clock(i_clock),
	    .i_data_valid(1'b1),
	    .i_reset(i_reset),
	    .o_data(
	    	{
				signal_valid,
				signal_finished,
				frame_finished,
				reset
	    	}
	    )
	  );

	reg delayed_frame_finished;

	initial
	begin
		delayed_frame_finished = 0;
	end

	(* mark_debug = "true" *)		
	reg frame_started;

	always @(posedge i_clock)
	begin
		if(reset)
		begin
			max_signal <= 0;
			max_signal_aux <= 0;
			max_signal_channel <= 0;
			max_signal_aux_channel <= 0;
			max_signal_frq_channel <= 0;
			current_frq_channel <= 0;
			frame_started <= 1;
		end
		else if(signal_valid)
		begin
			frame_started <= 0;
			if(max_signal < current_max_signal)
			begin
				max_signal <= current_max_signal;
				max_signal_aux <= current_max_signal_aux;
				max_signal_channel <= current_max_signal_channel;
				max_signal_aux_channel <= current_max_signal_aux_channel;
				max_signal_frq_channel <= current_frq_channel;
			end

			current_frq_channel <= current_frq_channel + 1;
		end

		if(signal_finished)
		begin
			o_signal <= max_signal;
			o_signal_aux <= max_signal_aux;
			o_signal_channel <= max_signal_channel;
			o_signal_aux_channel <= max_signal_aux_channel;
			o_signal_frq_channel <= max_signal_frq_channel;
		end

		o_signal_valid <= signal_finished;

		{o_frame_finished, delayed_frame_finished} <= {delayed_frame_finished, frame_finished};
		o_frame_started <= frame_started & signal_valid;
	end
endmodule
