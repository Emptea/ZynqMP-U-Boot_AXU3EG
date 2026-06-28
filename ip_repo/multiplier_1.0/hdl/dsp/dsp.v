`timescale 1ps/1ps

module Dsp
	#(
		parameter INPUT_DATA_WIDTH = 256,
		parameter OUTPUT_DATA_WIDTH = 256,
		parameter SIGNAL_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8,
		parameter DIAGRAM_NUMBER = 8,
		parameter COMPENSATION_COEF_WIDTH = 16,
		parameter DIAGRAM_COEF_WIDTH = 16,
		parameter COMPENSATION_COEF_LEVEL_ONE = 14,
		parameter DIAGRAM_COEF_LEVEL_ONE = 14,
		parameter INPUT_SIGNAL_LENGTH = 232,
		parameter FAR_START = 40,
		parameter FAR_LENGTH = 101,
		parameter CLOSE_START = 147,
		parameter CLOSE_LENGTH = 40,
		parameter AUX_START = 187,
		parameter AUX_LENGTH = 40,
		parameter AUX_LENGTH_WIDTH = 6
	)
	(
		input i_apply_controls, 

		input [2 * CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]i_data,
		input [CHANNEL_NUMBER - 1: 0]i_data_valid,
		input i_clock,
(* mark_debug = "true" *)		
		input i_reset,

		input [INPUT_DATA_WIDTH - 1: 0]i_compensation_calculation_reference,

		input i_compensation_mode,
		input [15: 0]i_output_source,
		input [15: 0]i_output_source_channel,

		input [COMPENSATION_COEF_WIDTH * CHANNEL_NUMBER - 1: 0]i_manual_compensation_coefs,
		input [DIAGRAM_COEF_WIDTH * CHANNEL_NUMBER * DIAGRAM_NUMBER - 1: 0]i_diagram_coefs,

		output [CHANNEL_NUMBER - 1: 0]o_read_from_fifo,
		
		output [OUTPUT_DATA_WIDTH - 1: 0]o_data,
		output o_data_valid,
		output o_data_last,
		input i_awaiting_data
	);

(* mark_debug = "true" *)	
	wire aux_calculation_finished;

	wire [2 * CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]rxed_signal;
	wire [2 * CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]rxed_aux_signal;
(* mark_debug = "true" *)	
	wire rxed_far_valid;
(* mark_debug = "true" *)	
	wire rxed_close_valid;
(* mark_debug = "true" *)	
	wire rxed_aux_valid;
(* mark_debug = "true" *)	
	wire rxed_aux_finished;
(* mark_debug = "true" *)	
	wire rx_started;

(* mark_debug = "true" *)	
	reg start_receiving;

	wire [2 * SIGNAL_WIDTH * CHANNEL_NUMBER - 1: 0]rxed_data_debug;
	wire rxed_data_debug_valid;

	signal_receiver
		#(
			.BIT_WIDTH(SIGNAL_WIDTH),
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
			.i_signal(i_data),
			.i_valid(i_data_valid),
		
			.i_start(start_receiving),
		
			.i_clock(i_clock),
			.i_reset(i_reset),
		
			.i_aux_finished(aux_calculation_finished),

			.o_signal(rxed_signal),
			.o_signal_started(rx_started),
			.o_close_valid(rxed_close_valid),
			.o_far_valid(rxed_far_valid),
		
			.o_aux_start(rxed_aux_start),
			.o_aux_signal(rxed_aux_signal),
			.o_aux_signal_valid(rxed_aux_valid),
			.o_aux_finish(rxed_aux_finished),
		
			.o_finished(rx_finished),
		
			.o_request(o_read_from_fifo),

			.o_rxed_data(rxed_data_debug),
			.o_rxed_data_valid(rxed_data_debug_valid),
			.o_rxed_data_started(rxed_data_debug_started),
			.o_rxed_data_finished(rxed_data_debug_finished)
		);

(* mark_debug = "true" *)	
	integer counter;
	reg [2: 0]channel;

	always @(posedge i_clock)
	begin
		if(i_reset) start_receiving <= 0;
		else if(counter >= 10000000) start_receiving <= 1;
		else start_receiving <= 0;

		if(i_reset) counter <= 0;
		else if(counter >= 10000000) counter <= 0;
		else counter <= counter + 1;

		if(i_reset) channel <= 0;
		else if(start_receiving) channel <= channel + 1;


	end

	wire [2 * SIGNAL_WIDTH - 1: 0]selected_data;
	wire selected_data_valid;
	wire selected_data_started;
	wire selected_data_finished;
(* mark_debug = "true" *)
	reg [15: 0]output_source_channel;
(* mark_debug = "true" *)
	reg [15: 0]output_source;

	always @(posedge i_clock)
	begin
		output_source_channel <= i_output_source_channel;
		output_source <= i_output_source;
	end


	wire [COMPENSATION_COEF_WIDTH * CHANNEL_NUMBER - 1: 0]automatic_compensation_coefs;

	CompensationCalculation
		#(
			.BIT_WIDTH(SIGNAL_WIDTH),
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
			.BIT_WIDTH(SIGNAL_WIDTH),
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

	wire [CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]compensated_signal;

	CompensationBlock
		#(
			.BIT_WIDTH(SIGNAL_WIDTH),
			.CHANNEL_NUMBER(CHANNEL_NUMBER),
			.COEF_ONE_BIT_WIDTH(COMPENSATION_COEF_LEVEL_ONE)
		)
		inst_compensation_block
		(
			.i_signal(rxed_signal),
			.i_coefs(selected_compensation_coefs),
	
			.i_clock(i_clock),
			.i_reset(i_reset),
	
			.o_signal(compensated_signal)
		);

	wire [2 * SIGNAL_WIDTH * DIAGRAM_NUMBER - 1: 0]diagram_signal;

	LouBlock
		#(
			.BIT_WIDTH(SIGNAL_WIDTH),
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

	wire [2 * SIGNAL_WIDTH * DIAGRAM_NUMBER - 1: 0]far_signal_for_filter;
	wire [2 * SIGNAL_WIDTH * DIAGRAM_NUMBER - 1: 0]close_signal_for_filter;
	
	wire far_signal_for_filter_valid;
	wire close_signal_for_filter_valid;

	FilterSelecter
		#(
			.BIT_WIDTH(SIGNAL_WIDTH),
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

	wire [2 * SIGNAL_WIDTH * DIAGRAM_NUMBER - 1 : 0]far_signal_filtered;
	wire far_signal_filtered_valid;

	OutputDriver
		#(
			.BIT_WIDTH(32),
			.LENGTH(1024),
			.LENGTH_WIDTH(11)
		)
		inst_output_driver
		(
			.i_data(selected_data),
			.i_data_valid(selected_data_valid),
			.i_start(selected_data_started),
			.i_finished(selected_data_finished),

			.i_clock(i_clock),
			.i_reset(i_reset),

			.o_data(o_data),
			.o_data_valid(o_data_valid),
			.o_data_last(o_data_last),
			.i_awaiting_data(i_awaiting_data)
		);
		
/*
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

	wire [2 * SIGNAL_WIDTH * DIAGRAM_NUMBER - 1 : 0]close_signal_filtered;
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

	reg [2 * SIGNAL_WIDTH * DIAGRAM_NUMBER - 1 : 0]signal_filtered;
	reg signal_filtered_valid;

	always @(posedge i_clock)
	begin
		if(close_signal_filtered_valid) signal_filtered <= close_signal_filtered;
		else if(far_signal_filtered_valid) signal_filtered <= far_signal_filtered;
		else signal_filtered <= 0;

		signal_filtered <= far_signal_filtered_valid | close_signal_filtered_valid;
	end	
*/

	OutputSourceSelector
	    #(
	        .CHANNEL_NUMBER(CHANNEL_NUMBER),
	        .BIT_WIDTH(2 * SIGNAL_WIDTH),
		.SOURCE_NUMBER(4)
	    )
	    inst_source_selector
	    (
			.i_data(
				{
					compensated_signal,
					compensated_signal,
					rxed_signal,
					rxed_data_debug
				}
			),
			.i_data_valid(
				{
					rxed_far_valid | rxed_close_valid,
					rxed_far_valid | rxed_close_valid,
					rxed_far_valid | rxed_close_valid,
					rxed_data_debug_valid
				}
			),
			.i_data_started(
				{
					rx_started,
					rx_started,
					rx_started,
					rxed_data_debug_started
				}
			),
			.i_data_finished(
				{
					rx_finished,
					rx_finished,
					rx_finished,
					rxed_data_debug_finished
				}
			),
			.i_channel_number(output_source_channel),
			.i_source_number(output_source),
			.i_clock(i_clock),
			.i_reset(i_reset),
			
			.o_data(selected_data),
			.o_data_valid(selected_data_valid),
			.o_data_started(selected_data_started),
			.o_data_finished(selected_data_finished)
		);

endmodule
