`timescale 1ps/1ps

module v_dsp
	#(
		parameter INPUT_DATA_WIDTH = 256,
		parameter OUTPUT_DATA_WIDTH = 256,
		parameter SIGNAL_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8,
		parameter DIAGRAM_NUMBER = 8,
		parameter COMPENSATION_COEF_WIDTH = 16,
		parameter DIAGRAM_COEF_WIDTH = 16,
		parameter COMPENSATION_COEF_LEVEL_ONE = 14,
		parameter DIAGRAM_COEF_LEVEL_ONE = 14
	)
	(
		input [2 * CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]i_data,
		input [CHANNEL_NUMBER - 1: 0]i_data_valid,
		input i_clock,
		input i_reset,

		input [BIT_WIDTH - 1: 0]i_compensation_calculation_reference,

		input i_compensation_mode,

		input [COMPENSATION_COEF_WIDTH * CHANNEL_NUMBER - 1: 0]i_manual_compensation_coefs,
		input [DIAGRA_COEFS_WIDTH * CHANNEL_NUMBER * DIAGRAM_NUMBER - 1: 0]i_diagram_coefs,

		output [CHANNEL_NUMBER - 1: 0]o_read_from_fifo,
		
		output [OUTPUT_DATA_WIDTH - 1: 0]o_data,
		output o_data_valid,
		input i_awaiting_data
	);

	wire aux_calculation_finished;

	wire [2 * CHANNEL_NUMBER * BIT_WIDTH - 1: 0]rxed_signal;
	wire [2 * CHANNEL_NUMBER * BIT_WIDTH - 1: 0]rxed_aux_signal;
	wire rxed_far_valid;
	wire rxed_close_valid;
	wire rxed_aux_valid;
	wire o_read_from_fifo;
	wire rxed_aux_finished;
	wire rx_started;

	signal_receiver
		#(
			.BIT_WIDTH(16),
			.CHANNEL_NUMBER(CHANNEL_NUMBER),
			.SIGNAL_LENGTH(INPUT_SIGNAL_LENGTH),
			.START_FAR(FAR_START),
			.START_CLOSE(CLOSE_START),
			.START_AUX(AUX_START),
			.LENGTH_FAR(FAR_LENGTH),
			.LENGTH_CLOSE(CLOSE_LENGTH),
			.LENGTH_AUX(AUX_LENGTH)
		)
		inst_signal_receiver
		(
			.i_signal(i_data_valid),
			.i_valid(i_data_valid),
		
			.i_start(start_receiving),
		
			.i_clock(i_clock),
			.i_reset(i_reset),
		
			.i_aux_finished(aux_calculation_finished),

			.o_signal(rxed_signal),
			.o_close_valid(rxed_close_valid),
			.o_far_valid(rxed_far_valid),
		
			.o_aux_start(rxed_aux_start),
			.o_aux_signal(rxed_aux_signal),
			.o_aux_signal_valid(rxed_aux_valid),
			.o_aux_finish(rxed_aux_finished),
		
			.o_finished(),
		
			.o_request(o_read_from_fifo)
		);
	
	wire [COMPENSATION_COEF_WIDTH * CHANNEL_NUMBER - 1: 0]automatic_compensation_coefs;

	CompensationCalculation
		#(
			.BIT_WIDTH(BIT_WIDTH),
			.LENGTH(AUX_LENGTH),
			.LENGTH_WIDTH(AUX_LENGTH_WIDTH),
			.REFERENCE_LEVEL(COMPENSATION_COEF_LEVEL_ONE)
		)
		inst_compensation_calculation
		(
			.i_signal(rxed_aux_signal),
			.i_start(rxed_aux_start),
			.i_signal_valid(rxed_aux_valid),
			.i_finish(rxed_aux_finished),
	
			.i_reference(i_compensation_calculation_reference),
	
			.i_reset(i_reset),
			.i_clock(i_clock),
	
			.o_coef(automatic_compensation_coefs),
			.o_finished(aux_calculation_finished)
		);	

	wire [COMPENSATION_COEF_WIDTH * CHANNEL_NUMBER - 1: 0]selected_compensation_coefs;

	CompesationCoefSelector
		#(
			.BIT_WIDTH(BIT_WIDTH),
			.CHANNEL_NUMBER(CHANNEL_NUMBER)
		)
		inst_compensation_coef_selector
		(
			.i_automatic_coefs(automatic_compensation_coefs),
			.i_manual_coefs(i_manual_compensation_coefs),
	
			.i_mode(i_compensation_mode),
	
			.i_clock(i_clock),
			.i_reset(i_reset),
	
			.o_coefs(selected_compensation_coefs)
		);

	wire [CHANNEL_NUMBER * BIT_WIDTH - 1: 0]compensated_signal;

	CompensationBlock
		#(
			.BIT_WIDTH(BIT_WIDTH),
			.CHANNEL_NUMBER(CHANNEL_NUMBER),
			.COEF_ONE_BIT_WIDTH(COMPENSATION_COEF_LEVEL_ONE)
		)
		(
			.i_signal(rxed_signal),
			.i_coefs(selected_compensation_coefs),
	
			.i_clock(i_clock),
			.i_reset(i_reset),
	
			.o_signal(compensated_signal)
		);

	wire [2 * BIT_WIDTH * DIAGRAM_NUMBER - 1: 0]diagram_signal;

	LouBlock
		#(
			.BIT_WIDTH(BIT_WIDTH),
			.CHANNEL_NUMBER(CHANNEL_NUMBER),
			.LOU_NUMBER(DIAGRAM_NUMBER)
		)
		inst_lou_block
		(
			.i_signal(compensated_siganl),
			.i_coefs(i_diagram_coefs),
			.i_reset(i_reset),
			.i_clock(i_clock),

			.o_signal(diagram_signal)
		);

	wire [2 * BIT_WIDTH * DIAGRAM_NUMBER - 1: 0]far_signal_for_filter;
	wire [2 * BIT_WIDTH * DIAGRAM_NUMBER - 1: 0]close_signal_for_filter;
	
	wire far_signal_for_filter_valid;
	wire close_signal_for_filter_valid;

	FilterSelecter
		#(
			.BIT_WIDTH(BIT_WIDTH),
			.CHANNEL_NUMBER(DIAGRAM_NUMBER)
		)
		inst_filter_selector
		(
			.i_signal(diagram_signal),
			.i_far_valid(rxed_far_valid),
			.i_close_valid(rxed_close_valid),
	
			.i_clock(i_clock),
			.i_reset(i_reset),
	
			.o_far_signal(far_signal_for_filter),
			.o_close_signal(close_signal_for_filter),
	
			.o_far_valid(far_signal_for_filter_valid),
			.o_close_valid(close_signal_for_filter_valid)
		);

	wire [2 * SIGNAL_WIDTH * DIAGRAM_NUNBER - 1 : 0]far_signal_filtered;
	wire far_signal_filtered_valid;

	FirBlock
	  #(
	    .CHANNEL_NUMBER(DIAGRAM_NUMBER),
	    .FILTER_LENGTH(FILTER_LENGTH),
	    .COEF_WIDTH(COEF_WIDTH),
	    .SIGNAL_WIDTH(SIGNAL_WIDTH),
	    .COEF_FILE(FAR_COEF_FILE)
	  )
	  inst_far_filter
	  (
	    .i_signal(far_signal_for_filter), 
	    .i_reset(i_reset), 
	    .i_clock(i_clock), 
	    .i_valid(far_signal_for_filter_valid),
	    .o_signal(far_signal_filtered),
	    .o_valid(far_signal_filtered_valid)
	  );	

	wire [2 * SIGNAL_WIDTH * DIAGRAM_NUNBER - 1 : 0]close_signal_filtered;
	wire close_signal_filtered_valid;

	FirBlock
	  #(
	    .CHANNEL_NUMBER(DIAGRAM_NUMBER),
	    .FILTER_LENGTH(FILTER_LENGTH),
	    .COEF_WIDTH(COEF_WIDTH),
	    .SIGNAL_WIDTH(SIGNAL_WIDTH),
	    .COEF_FILE(FAR_COEF_FILE)
	  )
	  inst_close_filter
	  (
	    .i_signal(close_signal_for_filter), 
	    .i_reset(i_reset), 
	    .i_clock(i_clock), 
	    .i_valid(close_signal_for_filter_valid),
	    .o_signal(close_signal_filtered),
	    .o_valid(close_signal_filtered_valid)
	  );

	reg [2 * SIGNAL_WIDTH * DIAGRAM_NUNBER - 1 : 0]signal_filtered;
	reg signal_filtered_valid;

	always @(posedge i_clock)
	begin
		if(close_signal_filtered_valid) signal_filtered <= close_signal_filtered;
		else if(far_signal_filtered_valid) signal_filtered <= far_signal_filtered;
		else signal_filtered <= 0;

		signal_filtered <= far_signal_filtered_valid | close_signal_filtered_valid;
	end	

	wire [2 * SIGNAL_WIDTH * DIAGRAM_NUNBER - 1 : 0]accumulator_signal;
	wire accumulator_signal_valid;
	wire accumulator_signal_start;
	wire accumulator_signal_finished;
	wire [7: 0]accumulator_signal_shift;

	AccumulatorBlock
		#(
			.SIGNAL_WIDTH(SIGNAL_WIDTH),
			.CHANNEL_NUMBER(DIAGRAM_NUMBER),
			.COEF_FILE(ACCUMULATOR_COEF_FILE)
		)
		inst_accumulator_block
		(
			.i_signal(signal_filtered),
			.i_valid(signal_filtered_valid),

			.i_start(start_tx),

			.i_reset(i_reset),
			.i_clock(i_clock),

			.o_signal(accumulator_signal),
			.o_signal_start(accumulator_signal_start),
			.o_signal_valid(accumulator_signal_valid),
			.o_signal_finished(accumulator_signal_finished),
			.o_signal_shift(accumulator_signal_shift)
		);

	wire [2 * SIGNAL_WIDTH * DIAGRAM_NUNBER - 1 : 0]fft_signal;
	wire fft_signal_valid;
	wire fft_signal_start;
	wire fft_signal_finished;
	wire [7: 0]fft_signal_shift;

	FftBlock
		#(
			.SIGNAL_WIDTH(accumulator_signal),
			.CHANNEL_NUMBER(DIAGRAM_NUMBER)
		)
		inst_fft_block
		(
			.i_signal(accumulator_signal),
			.i_signal_start(accumulator_signal_start),
			.i_signal_valid(accumulator_signal_valid),
			.i_signal_finished(accumulator_signal_finished),
			.i_signal_shift(accumulator_signal_shift), 
			.i_reset(i_reset),
			.i_clock(i_clock),

			.o_signal(fft_signal),
			.o_signal_valid(fft_signal_valid),
			.o_signal_start(fft_signal_start),
			.o_signal_start(fft_signal_finished),
			.o_signal_shift(fft_signal_shift)
		);

	MaxSelector
		#(
			.SIGNAL_WIDTH(SIGNAL_WIDTH),
			.COEF_FILE(MAX_SELECTOR_COEF_FILE)
		)
		inst_max_selector
		(
			.i_signal(fft_signal),
			.i_signal_valid(fft_signal_valid),
			.i_signal_start(fft_signal_start),
			.i_signal_start(fft_signal_finished),
			.i_signal_shift(fft_signal_shift),

			.i_reset(i_reset),
			.i_clock(i_clock),

			.o_max_value(max_value),
			.o_max_value_valud(max_value_valid),
			.o_max_value_time_num(max_value_time_num),
			.o_max_value_frq_num(max_value_time_num),
			.o_max_value_diag_num(max_value_diag_num)
		);
endmodule