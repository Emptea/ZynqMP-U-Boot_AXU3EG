`timescale 1ps/1ps

module Dsp
	#(
		parameter WEIGHT_COEF_FILE = "",
		parameter REQUEST_COUNTER = 8840,
		parameter INPUT_DATA_WIDTH = 256,
		parameter OUTPUT_DATA_WIDTH = 256,
		parameter SIGNAL_WIDTH = 16,
		parameter CHANNEL_NUMBER = 8,
		parameter DIAGRAM_NUMBER = 8,
		parameter COMPENSATION_COEF_WIDTH = 24,
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
		parameter AUX_LENGTH_WIDTH = 6,
		parameter ANGLE_WIDTH = 32,
        parameter MEM_DATA_BITS          = 32,  //external memory user interface data width
        parameter ADDR_BITS              = 23,  //external memory user interface address width
        parameter BUSRT_BITS             = 10,  //external memory user interface burst width
        parameter BURST_SIZE             = 128, //burst size,
        parameter MEM_MASK_BITS          = 16
	)
	(
		input i_apply_controls, 

		input [2 * CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]i_data,
		input [CHANNEL_NUMBER - 1: 0]i_data_valid,
		input i_clock,
(* mark_debug = "true" *)		
		input i_reset,

        input [15: 0]i_compensation_mode,
        input [2 * SIGNAL_WIDTH * CHANNEL_NUMBER - 1: 0]i_manual_compensation_coefs,
        input [2 * DIAGRAM_NUMBER * SIGNAL_WIDTH * CHANNEL_NUMBER - 1: 0]i_diagram_coefs,
        input [7:0] i_motion_selector_filter,
        input i_motion_selector_onoff_out,
        input [ANGLE_WIDTH * DIAGRAM_NUMBER - 1: 0]i_diagram_angle,
        input [15: 0]i_output_source,
        input [15: 0]i_output_source_channel,
        input [7:0] i_apu_rank,
        input [7:0] i_apu_window,
        input [31:0] i_detector_level_0,
        input [31:0] i_detector_level_1,
        input [31:0] i_azimuth_angle,
        input [15:0] i_auto_compensation_reference,

		output [CHANNEL_NUMBER - 1: 0]o_read_from_fifo,
		
		output [OUTPUT_DATA_WIDTH - 1: 0]o_data,
		output o_data_valid,
		output o_data_last,
		input i_awaiting_data		,

        input                            mem_rst,
        input                            mem_clk,
        output                        rd_burst_req,
        output                        wr_burst_req,
        output [BUSRT_BITS - 1:0]     rd_burst_len,
        output [BUSRT_BITS - 1:0]     wr_burst_len,
        output [ADDR_BITS - 1:0]      rd_burst_addr,
        output [ADDR_BITS - 1:0]      wr_burst_addr,
        input                            rd_burst_data_valid,
        input                            wr_burst_data_req,
        input[MEM_DATA_BITS - 1:0]       rd_burst_data,
        output [MEM_DATA_BITS - 1:0]  wr_burst_data,
        output [MEM_MASK_BITS - 1:0]  wr_burst_mask,
        input                            rd_burst_finish,
        input                            wr_burst_finish,
        output                        heartbeat,

        input [7: 0]i_enabled_channels
	);

	localparam WEIGHT_COEF_WIDTH = 16;
	localparam WEIGHT_COEF_LEVEL_ONE = 14;
	localparam WEIGHT_COEF_DEPTH = 512;
	localparam WEIGHT_COEF_ADDRESS_WIDTH = 9;
	
	localparam COEF_SF_40 = {
	  16'd0, 16'd26214,
	  16'd2057, 16'd39403,
	  16'd57436, 16'd24931,
	  16'd17025, 16'd45603,
	  16'd40606, 16'd8101,
	  16'd24219, 16'd10032,
	  16'd57436, 16'd40606,
	  16'd48512, 16'd19934,
	  16'd24931, 16'd8101,
	  16'd2057, 16'd39403,
	  16'd39323, 16'd0,
	  16'd63480, 16'd26134,
	  16'd24931, 16'd8101,
	  16'd17025, 16'd45603,
	  16'd57436, 16'd40606,
	  16'd41318, 16'd55505,
	  16'd40606, 16'd8101,
	  16'd48512, 16'd19934,
	  16'd57436, 16'd24931,
	  16'd63480, 16'd26134,
	  16'd0, 16'd26214,
	  16'd63480, 16'd26134,
	  16'd57436, 16'd24931,
	  16'd48512, 16'd19934,
	  16'd40606, 16'd8101,
	  16'd41318, 16'd55505,
	  16'd57436, 16'd40606,
	  16'd17025, 16'd45603,
	  16'd24931, 16'd8101,
	  16'd63480, 16'd26134,
	  16'd39323, 16'd0,
	  16'd2057, 16'd39403,
	  16'd24931, 16'd8101,
	  16'd48512, 16'd19934,
	  16'd57436, 16'd40606,
	  16'd24219, 16'd10032,
	  16'd40606, 16'd8101,
	  16'd17025, 16'd45603,
	  16'd57436, 16'd24931,
	  16'd2057, 16'd39403
	};

	localparam COEF_SF_6 = {
	  16'd0, 16'd21845,
	  16'd10923, 16'd46618,
	  16'd46618, 16'd54614,
	  16'd43692, 16'd0,
	  16'd46618, 16'd54614,
	  16'd10923, 16'd46618
	};

	localparam LOU_SECTION_NUMBER = 2;
	localparam FRAME_LENGTH = 141;
	localparam CHANNEL_PER_CLOCK = 4;
	localparam FFT_DEPTH = 512;

(* mark_debug = "true" *)	
	wire aux_calculation_finished;

	wire [2 * SIGNAL_WIDTH - 1: 0]rxed_signal;
	wire [2 * CHANNEL_NUMBER * SIGNAL_WIDTH - 1: 0]rxed_aux_signal;

	wire [2 * SIGNAL_WIDTH - 1: 0]selected_data;
	wire selected_data_valid;
	wire selected_data_started;
	wire selected_data_finished;
	reg [15: 0]output_source_channel;
(* mark_debug = "true" *)
	reg [15: 0]output_source;
    reg [15: 0]compensation_mode;
    reg [2 * COMPENSATION_COEF_WIDTH * CHANNEL_NUMBER - 1: 0]manual_compensation_coefs;
    reg [2 * DIAGRAM_NUMBER * SIGNAL_WIDTH * CHANNEL_NUMBER - 1: 0]diagram_coefs;
    reg [2 * SIGNAL_WIDTH * CHANNEL_NUMBER - 1: 0]diagram_coefs_debug;
    reg [7:0] motion_selector_filter;
(* mark_debug = "true" *)
    reg motion_selector_onoff_out;
    reg [ANGLE_WIDTH * DIAGRAM_NUMBER - 1: 0]diagram_angle;
    reg [7:0] apu_rank;
    reg [7:0] apu_window;
    reg [31:0] detector_level_0;
    reg [31:0] detector_level_1;
    reg [31:0] azimuth_angle;
    reg [15:0] auto_compensation_reference;

(* mark_debug = "true" *)	
    wire enable_source_change;
(* mark_debug = "true" *)	
    reg [7: 0]last_on_packet_count;

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

	wire [2 * SIGNAL_WIDTH - 1: 0]rxed_data_debug;
	wire rxed_data_debug_valid;

(* mark_debug = "true" *)	
	reg [63: 0]timer;
(* mark_debug = "true" *)	
	reg [63: 0]timestamp;
(* mark_debug = "true" *)	
	integer frame_number;
	
	initial
	begin
		timer = 0;
		timestamp = 0;
		frame_number = 0;
	end

	always @(posedge i_clock)
	begin
		timer <= timer + 1;

		if(i_reset)
		begin
			timestamp <= 0;
			frame_number <= 0;		
		end
		else if(rx_started)
		begin
			timestamp <= timer;
			frame_number <= frame_number + 1;
		end
	end

	wire [15: 0]signal_channel_number;
	wire [15: 0]signal_diagram_number;
	wire [15: 0]compensated_channel_number;
	wire [15: 0]compensated_diagram_number;
	wire [15: 0]rxed_data_channel_number;

	wire rxed_close_mem_valid;
	wire rxed_far_mem_valid;

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
			.i_selected_channel_number(output_source_channel[2: 0]),
		
			.i_clock(i_clock),
			.i_reset(i_reset),
		
			.i_aux_finished(aux_calculation_finished),

			.o_signal_channel_number(signal_channel_number),
			.o_signal_diagram_number(signal_diagram_number),
			.o_signal(rxed_signal),
			.o_signal_started(rx_started),
			.o_close_valid(rxed_close_valid),
			.o_far_valid(rxed_far_valid),
			.o_close_mem_valid(rxed_close_mem_valid),
			.o_far_mem_valid(rxed_far_mem_valid),
		
			.o_aux_start(rxed_aux_start),
			.o_aux_signal(rxed_aux_signal),
			.o_aux_signal_valid(rxed_aux_valid),
			.o_aux_finish(rxed_aux_finished),
		
			.o_finished(rx_finished),
		
			.o_request(o_read_from_fifo),

			.o_rxed_data(rxed_data_debug),
			.o_rxed_data_valid(rxed_data_debug_valid),
			.o_rxed_data_started(rxed_data_debug_started),
			.o_rxed_data_finished(rxed_data_debug_finished),

			.o_rxed_data_channel_number(rxed_data_channel_number),

			.o_switch_signal(switch_signal),
			.o_switch_diagram(switch_diagram),

			.i_enabled_channels(i_enabled_channels)

		);

	integer counter;
	reg [2: 0]channel;
	
	always @(posedge i_clock)
	begin
		if(i_reset) start_receiving <= 0;
		else if(counter >= REQUEST_COUNTER) start_receiving <= 1;
		else start_receiving <= 0;

		if(i_reset) counter <= REQUEST_COUNTER - 2;
		else if(counter >= REQUEST_COUNTER) counter <= 0;
		else counter <= counter + 1;

		if(i_reset) channel <= 0;
		else if(start_receiving) channel <= channel + 1;


	end

	function [COMPENSATION_COEF_WIDTH - 1: 0]up_compensation(input signed [SIGNAL_WIDTH - 1: 0]i_data);
		reg signed [COMPENSATION_COEF_WIDTH - 1: 0]o_data;
		begin
			o_data = i_data;
			up_compensation = o_data;
		end
	endfunction

	integer i_comp;
	always @(posedge i_clock)
	begin
    	if(enable_source_change) 
    	begin
    		output_source <= i_output_source;
    		output_source_channel <= i_output_source_channel;

    		case(i_output_source)
    			1:
    			begin
    				last_on_packet_count <= 20;
    			end
    			2:
    			begin
    				last_on_packet_count <= 20;
    			end
    			3:
    			begin
    				last_on_packet_count <= 20;
    			end
    			4:
    			begin
    				last_on_packet_count <= 20;
    			end
    			5:
    			begin
    				last_on_packet_count <= 20;
    			end
    			12:
    			begin
    				last_on_packet_count <= 20;
    			end
    			14:
    			begin
    				last_on_packet_count <= 20;
    			end
    			default:
    			begin
    				last_on_packet_count <= 1;
    			end
    		endcase
    	end

		compensation_mode <= i_compensation_mode;
		for(i_comp = 0; i_comp < 2 * CHANNEL_NUMBER; i_comp = i_comp + 1)
		begin
			manual_compensation_coefs[i_comp * COMPENSATION_COEF_WIDTH +: COMPENSATION_COEF_WIDTH] <= 
				up_compensation(i_manual_compensation_coefs[i_comp * SIGNAL_WIDTH +: SIGNAL_WIDTH]);
		end
		diagram_coefs <= i_diagram_coefs;
		diagram_coefs_debug <= i_diagram_coefs;
		motion_selector_filter <= i_motion_selector_filter;
		motion_selector_onoff_out <= i_motion_selector_onoff_out;
		diagram_angle <= i_diagram_angle;
		apu_rank <= i_apu_rank;
		apu_window <= i_apu_window;
		detector_level_0 <= i_detector_level_0;
		detector_level_1 <= i_detector_level_1;
		azimuth_angle <= i_azimuth_angle;
	 	auto_compensation_reference <= i_auto_compensation_reference;
	end


	wire [2 * COMPENSATION_COEF_WIDTH * CHANNEL_NUMBER - 1: 0]automatic_compensation_coefs;

	wire [2 * SIGNAL_WIDTH - 1: 0]debug_coef;
	wire debug_coef_start;
	wire debug_coef_valid;
	wire debug_coef_finished;

	CompensationCalculation
		#(
			.BIT_WIDTH(SIGNAL_WIDTH),
			.LENGTH(AUX_LENGTH),
			.LENGTH_WIDTH(AUX_LENGTH_WIDTH),
			.COEF_WIDTH(COMPENSATION_COEF_WIDTH),
			.COMPENSATION_COEF_LEVEL_ONE(COMPENSATION_COEF_LEVEL_ONE),
			.CHANNEL_NUMBER(CHANNEL_NUMBER)
		)
		inst_compensation_calculation
		(
			.i_signal(rxed_aux_signal),
			.i_start(rxed_aux_start),
			.i_signal_valid(rxed_aux_valid),
			.i_finish(rxed_aux_finished),
	
			.i_reference(auto_compensation_reference),
	
			.i_reset(i_reset),
			.i_clock(i_clock),
	
			.o_coefs(automatic_compensation_coefs),
			.o_finished(aux_calculation_finished),

			.o_debug_coef(debug_coef),
			.o_debug_coef_start(debug_coef_start),
			.o_debug_coef_valid(debug_coef_valid),
			.o_debug_coef_finished(debug_coef_finished)

		);	

	wire [2 * COMPENSATION_COEF_WIDTH * CHANNEL_NUMBER - 1: 0]selected_compensation_coefs;


	CompesationCoefSelector
		#(
			.BIT_WIDTH(COMPENSATION_COEF_WIDTH),
			.CHANNEL_NUMBER(CHANNEL_NUMBER)
		)
		inst_compensation_coef_selector
		(
			.i_automatic_coefs(automatic_compensation_coefs),
			.i_manual_coefs(manual_compensation_coefs),
	
			.i_mode(compensation_mode),
	
			.i_clock(i_clock),
			.i_reset(i_reset),
	
			.o_coefs(selected_compensation_coefs)
		);

	wire [2 * SIGNAL_WIDTH - 1: 0]compensated_signal;
	wire compensation_far_mem_valid;
	wire compensation_close_mem_valid;

	CompensationBlock
		#(
			.BIT_WIDTH(SIGNAL_WIDTH),
			.CHANNEL_NUMBER(CHANNEL_NUMBER),
			.COEF_WIDTH(COMPENSATION_COEF_WIDTH),
			.COEF_ONE_BIT_WIDTH(COMPENSATION_COEF_LEVEL_ONE)
		)
		inst_compensation_block
		(
			.i_current_channel_number(signal_channel_number),
			.i_current_diagram_number(signal_diagram_number),

			.i_signal(rxed_signal),
			.i_coefs(selected_compensation_coefs),
	
			.i_clock(i_clock),
			.i_reset(i_reset),

			.i_switch_signal(switch_signal),
			.i_switch_diagram(switch_diagram),

	
			.o_signal(compensated_signal),

			.i_start(rx_started),
			.i_far_valid(rxed_far_valid),
			.i_close_valid(rxed_close_valid),
			.i_close_mem_valid(rxed_close_mem_valid),
			.i_far_mem_valid(rxed_far_mem_valid),
			.i_finished(rx_finished),

			.o_start(compensation_started),
			.o_far_valid(compensation_far_valid),
			.o_close_valid(compensation_close_valid),
			.o_finished(compensation_finished),

			.o_current_channel_number(compensated_channel_number),
			.o_current_diagram_number(compensated_diagram_number),

			.o_switch_signal(compensated_switch_signal),
			.o_switch_diagram(compensated_switch_diagram),

			.o_close_mem_valid(compensation_close_mem_valid),
			.o_far_mem_valid(compensation_far_mem_valid)

		);

	wire [2 * SIGNAL_WIDTH - 1: 0]diagram_signal[LOU_SECTION_NUMBER - 1: 0];
	wire [15: 0]lou_diagram_number[LOU_SECTION_NUMBER - 1: 0];

	wire lou_started[LOU_SECTION_NUMBER - 1: 0];
	wire lou_far_valid[LOU_SECTION_NUMBER - 1: 0];
	wire lou_close_valid[LOU_SECTION_NUMBER - 1: 0];
	wire lou_finished[LOU_SECTION_NUMBER - 1: 0];
	wire lou_far_mem_valid[LOU_SECTION_NUMBER - 1: 0];
	wire lou_close_mem_valid[LOU_SECTION_NUMBER - 1: 0];
	wire lou_switch_diagram[LOU_SECTION_NUMBER - 1: 0];

	wire [2 * SIGNAL_WIDTH - 1: 0]fir_signal[LOU_SECTION_NUMBER - 1: 0];
	wire [15: 0]fir_diagram_number[LOU_SECTION_NUMBER - 1: 0];

	wire fir_started[LOU_SECTION_NUMBER - 1: 0];
	wire fir_far_valid[LOU_SECTION_NUMBER - 1: 0];
	wire fir_close_valid[LOU_SECTION_NUMBER - 1: 0];
	wire fir_finished[LOU_SECTION_NUMBER - 1: 0];
	wire fir_switch_diagram[LOU_SECTION_NUMBER - 1: 0];
	wire fir_far_mem_valid[LOU_SECTION_NUMBER - 1: 0];
	wire fir_close_mem_valid[LOU_SECTION_NUMBER - 1: 0];

	(* mark_debug = "true" *)		
	wire [2 * SIGNAL_WIDTH - 1: 0]band_stop_signal[LOU_SECTION_NUMBER - 1: 0];
	(* mark_debug = "true" *)		
	wire [15: 0]band_stop_diagram_number[LOU_SECTION_NUMBER - 1: 0];

	(* mark_debug = "true" *)		
	wire band_stop_started[LOU_SECTION_NUMBER - 1: 0];
	(* mark_debug = "true" *)		
	wire band_stop_far_valid[LOU_SECTION_NUMBER - 1: 0];
	(* mark_debug = "true" *)		
	wire band_stop_close_valid[LOU_SECTION_NUMBER - 1: 0];
	(* mark_debug = "true" *)		
	wire band_stop_finished[LOU_SECTION_NUMBER - 1: 0];
	(* mark_debug = "true" *)		
	wire band_stop_switch_diagram[LOU_SECTION_NUMBER - 1: 0];
	(* mark_debug = "true" *)		
	wire band_stop_far_mem_valid[LOU_SECTION_NUMBER - 1: 0];
	(* mark_debug = "true" *)		
	wire band_stop_close_mem_valid[LOU_SECTION_NUMBER - 1: 0];

	wire [2 * SIGNAL_WIDTH - 1: 0]far_fir_signal[LOU_SECTION_NUMBER - 1: 0];
	wire [2 * SIGNAL_WIDTH - 1: 0]close_fir_signal[LOU_SECTION_NUMBER - 1: 0];
	wire [15: 0]pre_fir_diagram_number[LOU_SECTION_NUMBER - 1: 0];

	wire pre_fir_started[LOU_SECTION_NUMBER - 1: 0];
	wire pre_fir_finished[LOU_SECTION_NUMBER - 1: 0];
	wire pre_lou_switch_diagram[LOU_SECTION_NUMBER - 1: 0];
	wire pre_fir_switch_diagram[LOU_SECTION_NUMBER - 1: 0];
	wire pre_fir_far_mem_valid[LOU_SECTION_NUMBER - 1: 0];
	wire pre_fir_close_mem_valid[LOU_SECTION_NUMBER - 1: 0];
	
	generate
		genvar it_lou_section;

		for(it_lou_section = 0; it_lou_section < LOU_SECTION_NUMBER; it_lou_section = it_lou_section + 1)
		begin: gen_lou_sections
			localparam SECTION_DIAGRAM_NUMBER = DIAGRAM_NUMBER / LOU_SECTION_NUMBER;
			localparam SECTION_COEF_SIZE = 2 * SIGNAL_WIDTH * CHANNEL_NUMBER * SECTION_DIAGRAM_NUMBER;

			LouBlock
				#(
					.BIT_WIDTH(SIGNAL_WIDTH),
					.CHANNEL_NUMBER(CHANNEL_NUMBER),
					.LOU_NUMBER(SECTION_DIAGRAM_NUMBER)
				)
				inst_lou_block
				(
					.i_signal(compensated_signal),
					.i_coefs(diagram_coefs[SECTION_COEF_SIZE * it_lou_section +: SECTION_COEF_SIZE]),
					.i_reset(i_reset),
					.i_clock(i_clock),
					.i_current_diagram_number(compensated_diagram_number + it_lou_section * SECTION_DIAGRAM_NUMBER),
				
					.i_switch_signal(compensated_switch_signal),
					.i_switch_diagram(compensated_switch_diagram),
		
					.o_signal(diagram_signal[it_lou_section]),
		
		            .i_start(compensation_started),
		            .i_far_valid(compensation_far_valid),
		            .i_close_valid(compensation_close_valid),
		            .i_far_mem_valid(compensation_far_mem_valid),
					.i_close_mem_valid(compensation_close_mem_valid),
		            .i_finished(compensation_finished),
		
		            .o_start(lou_started[it_lou_section]),
		            .o_far_valid(lou_far_valid[it_lou_section]),
		            .o_close_valid(lou_close_valid[it_lou_section]),
		            .o_finished(lou_finished[it_lou_section]),
					.o_switch_signal(lou_switch_signal),
					.o_switch_diagram(lou_switch_diagram[it_lou_section]),
					.o_far_mem_valid(lou_far_mem_valid[it_lou_section]),
					.o_close_mem_valid(lou_close_mem_valid[it_lou_section]),
		
		            .o_current_diagram_number(lou_diagram_number[it_lou_section])
				);
		
			FirFilter
				#(
					.SIGNAL_WIDTH(SIGNAL_WIDTH),
					.FILTER_DEPTH(40),
					.COEF_WIDTH(16),
					.COEF_FILE(""),
					.PART_NUMBER(5),
					.PART_DEPTH(8),
					.ADD_WIDTH(6),
					.COEF_ONE_WIDTH(14),
					.COEFS(COEF_SF_40)
				)
				inst_fir_far
				(
					.i_signal(diagram_signal[it_lou_section]),
					
					.i_start(lou_started[it_lou_section]),
					.i_far_valid(lou_far_valid[it_lou_section]),
					.i_close_valid(1'b0),
					.i_finished(lou_finished[it_lou_section]),
					.i_diagram_number(lou_diagram_number[it_lou_section]),
					.i_far_mem_valid(lou_far_mem_valid[it_lou_section]),
					.i_close_mem_valid(1'b0),
		
					.i_switch_diagram(lou_switch_diagram[it_lou_section]),
					
					.i_reset(i_reset),
					.i_clock(i_clock),
			
			
					.o_signal(far_fir_signal[it_lou_section]),
			
					.o_start(pre_fir_started[it_lou_section]),
					.o_far_valid(),
					.o_close_valid(),
					.o_finished(pre_fir_finished[it_lou_section]),
					.o_diagram_number(pre_fir_diagram_number[it_lou_section]),
					.o_switch_diagram(pre_fir_switch_diagram[it_lou_section]),
					.o_far_mem_valid(pre_fir_far_mem_valid[it_lou_section]),
					.o_close_mem_valid()
				);

			FirFilter
				#(
					.SIGNAL_WIDTH(SIGNAL_WIDTH),
					.FILTER_DEPTH(6),
					.COEF_WIDTH(16),
					.COEF_FILE(""),
					.PART_NUMBER(1),
					.PART_DEPTH(8),
					.ADD_WIDTH(3),
					.COEF_ONE_WIDTH(14),
					.COEFS(COEF_SF_6)
				)
				inst_fir_close
				(
					.i_signal(diagram_signal[it_lou_section]),
					
					.i_start(lou_started[it_lou_section]),
					.i_far_valid(1'b0),
					.i_close_valid(lou_close_valid[it_lou_section]),
					.i_finished(lou_finished[it_lou_section]),
					.i_diagram_number(lou_diagram_number[it_lou_section]),
					.i_far_mem_valid(1'b0),
					.i_close_mem_valid(lou_close_mem_valid[it_lou_section]),
		
					.i_switch_diagram(lou_switch_diagram[it_lou_section]),
					
					.i_reset(i_reset),
					.i_clock(i_clock),
			
			
					.o_signal(close_fir_signal[it_lou_section]),
			
					.o_start(),
					.o_far_valid(),
					.o_close_valid(),
					.o_finished(),
					.o_diagram_number(),
					.o_switch_diagram(),
					.o_far_mem_valid(),
					.o_close_mem_valid(pre_fir_close_mem_valid[it_lou_section])
				);

			FirSelector
				#(
					.SIGNAL_WIDTH(SIGNAL_WIDTH)
				)
				inst_fir_selector
				(
					.i_signal_far(far_fir_signal[it_lou_section]),
					.i_signal_close(close_fir_signal[it_lou_section]),
			
					.i_signal_far_valid(pre_fir_far_mem_valid[it_lou_section]),
					.i_signal_close_valid(pre_fir_close_mem_valid[it_lou_section]),
					.i_diagram_number(pre_fir_diagram_number[it_lou_section]),
					.i_switch_diagram(pre_fir_switch_diagram[it_lou_section]),
					.i_start(pre_fir_started[it_lou_section]),
					.i_finished(pre_fir_finished[it_lou_section]),
			
					.i_clock(i_clock),
					.i_reset(i_reset),
			
					.o_signal(fir_signal[it_lou_section]),
					.o_signal_far_valid(fir_far_mem_valid[it_lou_section]),
					.o_signal_close_valid(fir_close_mem_valid[it_lou_section]),
					.o_diagram_number(fir_diagram_number[it_lou_section]),
					.o_switch_diagram(fir_switch_diagram[it_lou_section]),
					.o_start(fir_started[it_lou_section]),
					.o_finished(fir_finished[it_lou_section])
				);

			BandStopFilter
				#(
					.SIGNAL_WIDTH(SIGNAL_WIDTH),
					.FRAME_NUMBER(6),
					.FRAME_LENGTH(CLOSE_LENGTH),
					.MODE("filter"),
					.ADDRESS_WIDTH(8)
				)
				inst_band_stop
				(
					.i_signal(fir_signal[it_lou_section]),
					.i_far_valid(fir_far_mem_valid[it_lou_section]),
					.i_close_valid(fir_close_mem_valid[it_lou_section]),
					.i_start(fir_started[it_lou_section]),
					.i_finished(fir_finished[it_lou_section]),
					.i_switch_diagram(fir_switch_diagram[it_lou_section]),
					.i_diagram_number(fir_diagram_number[it_lou_section]),

					.i_enabled(i_motion_selector_onoff_out),
			
					.i_clock(i_clock),
					.i_reset(i_reset),
			
					.o_signal(band_stop_signal[it_lou_section]),
					.o_far_valid(band_stop_far_mem_valid[it_lou_section]),
					.o_close_valid(band_stop_close_mem_valid[it_lou_section]),
					.o_start(band_stop_started[it_lou_section]),
					.o_finished(band_stop_finished[it_lou_section]),
					.o_switch_diagram(band_stop_switch_diagram[it_lou_section]),
					.o_diagram_number(band_stop_diagram_number[it_lou_section])
				);
		end
	endgenerate

	reg [2 * SIGNAL_WIDTH - 1: 0]output_diagram_signal;
	reg [15: 0]output_lou_diagram_number;

	reg output_lou_started;
	reg output_lou_far_valid;
	reg output_lou_close_valid;
	reg output_lou_finished;

	reg [2 * SIGNAL_WIDTH - 1: 0]output_fir_signal;
	reg [15: 0]output_fir_diagram_number;

	reg output_fir_started;
	reg output_fir_far_valid;
	reg output_fir_close_valid;
	reg output_fir_finished;

	(* mark_debug = "true" *)		
	reg [2 * SIGNAL_WIDTH - 1: 0]output_band_stop_signal;
	reg [15: 0]output_band_stop_diagram_number;

	reg output_band_stop_started;
	reg output_band_stop_far_valid;
	(* mark_debug = "true" *)		
	reg output_band_stop_close_valid;
	reg output_band_stop_finished;

	always @(posedge i_clock)
	begin
		if(output_source_channel[2])
		begin
			output_diagram_signal <= diagram_signal[1];
			output_lou_diagram_number <= lou_diagram_number[1];
			output_lou_started <= lou_started[1];
			output_lou_far_valid <= lou_far_valid[1];
			output_lou_close_valid <= lou_close_valid[1];
			output_lou_finished <= lou_finished[1];
			output_fir_signal <= fir_signal[1];
			output_fir_diagram_number <= fir_diagram_number[1];
			output_fir_started <= fir_started[1];
			output_fir_far_valid <= fir_far_mem_valid[1];
			output_fir_close_valid <= fir_close_mem_valid[1];
			output_fir_finished <= fir_finished[1];
			output_band_stop_signal <= band_stop_signal[1];
			output_band_stop_diagram_number <= band_stop_diagram_number[1];
			output_band_stop_started <= band_stop_started[1];
			output_band_stop_far_valid <= band_stop_far_mem_valid[1];
			output_band_stop_close_valid <= band_stop_close_mem_valid[1];
			output_band_stop_finished <= band_stop_finished[1];

		end
		else
		begin
			output_diagram_signal <= diagram_signal[0];
			output_lou_diagram_number <= lou_diagram_number[0];
			output_lou_started <= lou_started[0];
			output_lou_far_valid <= lou_far_valid[0];
			output_lou_close_valid <= lou_close_valid[0];
			output_lou_finished <= lou_finished[0];
			output_fir_signal <= fir_signal[0];
			output_fir_diagram_number <= fir_diagram_number[0];
			output_fir_started <= fir_started[0];
			output_fir_far_valid <= fir_far_mem_valid[0];
			output_fir_close_valid <= fir_close_mem_valid[0];
			output_fir_finished <= fir_finished[0];
			output_band_stop_signal <= band_stop_signal[0];
			output_band_stop_diagram_number <= band_stop_diagram_number[0];
			output_band_stop_started <= band_stop_started[0];
			output_band_stop_far_valid <= band_stop_far_mem_valid[0];
			output_band_stop_close_valid <= band_stop_close_mem_valid[0];
			output_band_stop_finished <= band_stop_finished[0];
		end
	end

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

			.i_input_frame_timestamp(timestamp),
			.i_frame_number(frame_number),

			.i_output_source(output_source),
			.i_output_source_channel(output_source_channel),

			.i_clock(i_clock),
			.i_reset(i_reset),

			.o_data(o_data),
			.o_data_valid(o_data_valid),
			.o_data_last(o_data_last),
			.i_awaiting_data(i_awaiting_data),

			.o_enable_source_change(enable_source_change),
			.i_last_on_packet_count(last_on_packet_count)
		);

	wire [31: 0]output_data_before_fft;
	wire output_data_before_fft_valid;
	wire output_data_before_fft_last;
	wire output_data_before_fft_start;

	wire [31: 0]output_weighted_data_before_fft;
	wire output_weighted_data_before_fft_valid;
	wire output_weighted_data_before_fft_last;
	wire output_weighted_data_before_fft_start;

	wire [31: 0]output_data_after_fft;
	wire output_data_after_fft_valid;
	wire output_data_after_fft_last;
	wire output_data_after_fft_start;

	wire [31: 0]shoulder_data_from_processor;
	wire shoulder_data_from_processor_valid;
	wire shoulder_data_from_processor_start;
	wire shoulder_data_from_processor_finished;

	wire [31: 0]rank_sorter_data_from_processor;
	wire rank_sorter_data_from_processor_valid;
	wire rank_sorter_data_from_processor_start;
	wire rank_sorter_data_from_processor_finished;

	wire [31: 0]detection_data_from_processor;
	wire detection_data_from_processor_valid;
	wire detection_data_from_processor_start;
	wire detection_data_from_processor_finished;

	wire [31: 0]measured_data_from_processor;
	wire measured_data_from_processor_valid;
	wire measured_data_from_processor_start;
	wire measured_data_from_processor_finished;

	OutputSourceSelector
	    #(
	        .BIT_WIDTH(2 * SIGNAL_WIDTH),
			.SOURCE_NUMBER(15)
	    )
	    inst_source_selector
	    (
			.i_data(
				{
					output_band_stop_signal,
					output_weighted_data_before_fft,
					debug_coef,
					detection_data_from_processor,
					rank_sorter_data_from_processor,
					shoulder_data_from_processor,
					max_signal,
					output_data_after_fft,
					output_data_before_fft,
					output_fir_signal,
					output_diagram_signal,
					compensated_signal,
					rxed_signal,
					rxed_data_debug,
					measured_data_from_processor
				}
			),
			.i_data_valid(
				{
					output_band_stop_far_valid | output_band_stop_close_valid, 
					output_weighted_data_before_fft_valid,
					debug_coef_valid,
					detection_data_from_processor_valid,
					rank_sorter_data_from_processor_valid,
					shoulder_data_from_processor_valid,
					max_signal_valid,
					output_data_after_fft_valid,
					output_data_before_fft_valid,
					output_fir_far_valid | output_fir_close_valid,
					output_lou_close_valid | output_lou_far_valid,
					(compensation_close_valid | compensation_far_valid) & (compensated_diagram_number == 0),
					(rxed_far_valid | rxed_close_valid) & (signal_diagram_number == 0),
					rxed_data_debug_valid,
					measured_data_from_processor_valid
				}
			),
			.i_data_started(
				{
					rx_started,
					output_weighted_data_before_fft_start,
					debug_coef_start,
					detection_data_from_processor_start,
					rank_sorter_data_from_processor_start,
					shoulder_data_from_processor_start,
					max_frame_started,
					output_data_after_fft_start,
					output_data_before_fft_start,
					rx_started,
					rx_started,
					rx_started,
					rx_started,
					rxed_data_debug_started,
					measured_data_from_processor_start
				}
			),
			.i_data_finished(
				{
					output_band_stop_finished,
					output_weighted_data_before_fft_last,
					debug_coef_finished,
					detection_data_from_processor_finished,
					rank_sorter_data_from_processor_finished,
					shoulder_data_from_processor_finished,
					max_frame_finished,
					output_data_after_fft_last,
					output_data_before_fft_last,
					output_fir_finished,
					output_lou_finished,
					compensation_finished,
					rx_finished,
					rxed_data_debug_finished,
					measured_data_from_processor_finished
				}
			),
			.i_selected_channel_number(output_source_channel[2: 0]),
			.i_current_channel_number(
				{
					output_band_stop_diagram_number[2: 0],
					output_source_channel[2: 0],
					output_source_channel[2: 0],
					output_source_channel[2: 0],
					output_source_channel[2: 0],
					output_source_channel[2: 0],
					output_source_channel[2: 0],
					output_source_channel[2: 0],
					output_source_channel[2: 0],
					output_fir_diagram_number[2: 0],
					output_lou_diagram_number[2: 0],
					compensated_channel_number[2: 0],
					signal_channel_number[2: 0],					
					rxed_data_channel_number[2: 0],
					output_source_channel[2: 0]
				}
			),
			.i_source_number(output_source),
			.i_clock(i_clock),
			.i_reset(i_reset),
			
			.o_data(selected_data),
			.o_data_valid(selected_data_valid),
			.o_data_started(selected_data_started),
			.o_data_finished(selected_data_finished)
		);


	(* mark_debug = "true" *)		
	wire [3: 0]data_to_fft_ready;

	wire [2 * SIGNAL_WIDTH - 1: 0]data_to_fft[3: 0];
		
	wire data_to_fft_valid;
	wire data_to_fft_last;
		
	wire fft_package_start;
	wire fft_sequence_start;
	wire fft_sequence_finish;

	wire [2 * SIGNAL_WIDTH - 1: 0]weighted_data_to_fft[3: 0];
		
	wire weighted_data_to_fft_valid;
	wire weighted_data_to_fft_last;


`ifndef IS_SIM
	DdrDataStorageController
		#(
		          .MEM_DATA_BITS(MEM_DATA_BITS),
		          .ADDR_BITS(ADDR_BITS),
		          .BURST_BITS(BUSRT_BITS),
		          .BURST_SIZE(BURST_SIZE),
		          .MEM_MASK_BITS(MEM_MASK_BITS)
		)
		inst_ddr_data_storage_controller
		(
			.i_data_1(band_stop_signal[0]),
			.i_data_2(band_stop_signal[1]),
			.i_channel_number_1(band_stop_diagram_number[0]),
			.i_channel_number_2(band_stop_diagram_number[1]),	
			.i_data_valid(band_stop_far_mem_valid[0] | band_stop_close_mem_valid[0]),
			.i_start_receive(band_stop_started[0]),
			.i_finish_receive(band_stop_finished[0]),
			.i_switch_channel(band_stop_switch_diagram[0]),
			.i_reset(i_reset),
			.i_clock(i_clock),

			.i_output_data_enabled(data_to_fft_ready[0]),
			
			.rst(mem_rst),
			.mem_clk(mem_clk),
			.rd_burst_req(rd_burst_req),
			.wr_burst_req(wr_burst_req),
			.rd_burst_len(rd_burst_len),
			.wr_burst_len(wr_burst_len),
			.rd_burst_addr(rd_burst_addr),
			.wr_burst_addr(wr_burst_addr),
			.rd_burst_data_valid(rd_burst_data_valid),
			.wr_burst_data_req(wr_burst_data_req),
			.rd_burst_data(rd_burst_data),
			.wr_burst_data(wr_burst_data),
			.rd_burst_finish(rd_burst_finish),
			.wr_burst_finish(wr_burst_finish),
			.heartbeat(heartbeat),
			.wr_burst_mask(wr_burst_mask),

			.o_data_1(data_to_fft[0]),
			.o_data_2(data_to_fft[1]),
			.o_data_3(data_to_fft[2]),
			.o_data_4(data_to_fft[3]),
		
			.o_data_valid(data_to_fft_valid),
			.o_data_last(data_to_fft_last),
		
			.o_start(fft_package_start),
			.o_start_sequence(fft_sequence_start),
			.o_finish_sequence(fft_sequence_finish),
			.o_finish(fft_sequence_finish)
		);
`endif


	FftDataSelector
		#(
			.SIGNAL_WIDTH(SIGNAL_WIDTH),
			.CHANNEL_NUMBER(4),
			.DISTANCE_LENGTH(FRAME_LENGTH),
			.CHANNEL_SEQUENCE_NUMBER(4)
		)
		inst_data_before_fff_selector
		(
			.i_signal(
				{
					data_to_fft[3],
					data_to_fft[2],
					data_to_fft[1],
					data_to_fft[0]
				}
			),
			.i_signal_valid(
				{
					data_to_fft_valid & data_to_fft_ready[3],
					data_to_fft_valid & data_to_fft_ready[2],
					data_to_fft_valid & data_to_fft_ready[1],
					data_to_fft_valid & data_to_fft_ready[0]
				}
			),
			.i_signal_last(
				{
					data_to_fft_last,
					data_to_fft_last,
					data_to_fft_last,
					data_to_fft_last
				}
			),
			.i_selected_channel(output_source_channel[2: 0]),
			.i_selected_distance(output_source_channel[3 +: 8]),
	
			.i_reset(i_reset),
			.i_clock(i_clock),
	
			.o_signal(output_data_before_fft),
			.o_signal_valid(output_data_before_fft_valid),
			.o_signal_last(output_data_before_fft_last),
			.o_signal_start(output_data_before_fft_start)
		);

	WeightMultiplier
		#(
			.SIGNAL_WIDTH(SIGNAL_WIDTH),
			.COEF_WIDTH(WEIGHT_COEF_WIDTH),
			.COEF_LEVEL_ONE(WEIGHT_COEF_LEVEL_ONE),
			.COEF_DEPTH(WEIGHT_COEF_DEPTH),
			.COEF_FILE(WEIGHT_COEF_FILE),
			.CHANNEL_NUMBER(4),
			.ADDRESS_WIDTH(WEIGHT_COEF_ADDRESS_WIDTH)
		)
		inst_weight_multiplier
		(
			.i_signal(
				{
					data_to_fft[3],
					data_to_fft[2],
					data_to_fft[1],
					data_to_fft[0]
				}
			),
			.i_data_start(fft_package_start),
			.i_ready(data_to_fft_ready),
			.i_valid(data_to_fft_valid),
			.i_last(data_to_fft_last),

			.i_clock(i_clock),
			.i_reset(i_reset),

			.o_signal(
				{
					weighted_data_to_fft[3],
					weighted_data_to_fft[2],
					weighted_data_to_fft[1],
					weighted_data_to_fft[0]
				}
			),
			.o_valid(weighted_data_to_fft_valid),
			.o_last(weighted_data_to_fft_last)
		);

	FftDataSelector
		#(
			.SIGNAL_WIDTH(SIGNAL_WIDTH),
			.CHANNEL_NUMBER(4),
			.DISTANCE_LENGTH(FRAME_LENGTH),
			.CHANNEL_SEQUENCE_NUMBER(4)
		)
		inst_weighted_data_before_fff_selector
		(
			.i_signal(
				{
					weighted_data_to_fft[3],
					weighted_data_to_fft[2],
					weighted_data_to_fft[1],
					weighted_data_to_fft[0]
				}
			),
			.i_signal_valid(
				{
					weighted_data_to_fft_valid & data_to_fft_ready[3],
					weighted_data_to_fft_valid & data_to_fft_ready[2],
					weighted_data_to_fft_valid & data_to_fft_ready[1],
					weighted_data_to_fft_valid & data_to_fft_ready[0]
				}
			),
			.i_signal_last(
				{
					weighted_data_to_fft_last,
					weighted_data_to_fft_last,
					weighted_data_to_fft_last,
					weighted_data_to_fft_last
				}
			),
			.i_selected_channel(output_source_channel[2: 0]),
			.i_selected_distance(output_source_channel[3 +: 8]),
	
			.i_reset(i_reset),
			.i_clock(i_clock),
	
			.o_signal(output_weighted_data_before_fft),
			.o_signal_valid(output_weighted_data_before_fft_valid),
			.o_signal_last(output_weighted_data_before_fft_last),
			.o_signal_start(output_weighted_data_before_fft_start)
		);


	(* mark_debug = "true" *)		
	wire [2 * SIGNAL_WIDTH - 1: 0]data_from_fft[3: 0];
	(* mark_debug = "true" *)		
	wire [23: 0]data_from_fft_user[3: 0];
	(* mark_debug = "true" *)		
	wire [3: 0]data_from_fft_valid;
	(* mark_debug = "true" *)		
	wire [3: 0]data_from_fft_last;
	(* mark_debug = "true" *)		
	wire [3: 0]event_frame_started;
	(* mark_debug = "true" *)		
	wire [3: 0]event_tlast_unexpected;
	(* mark_debug = "true" *)		
	wire [3: 0]event_tlast_missing;
	(* mark_debug = "true" *)		
	wire [3: 0]event_fft_overflow;
	(* mark_debug = "true" *)		
	wire [3: 0]event_data_in_channel_halt;

`ifndef IS_SIM
	generate
		genvar ifft;

		for(ifft = 0; ifft < 4; ifft = ifft + 1)
		begin: genfft
			xfft_0
				inst_fft
				(
			    	.aclk(i_clock),
			    	.aresetn(~i_reset),
			    	.s_axis_config_tdata(0),
			    	.s_axis_config_tvalid(0),
			    	.s_axis_config_tready(0),
			    	.s_axis_data_tdata(weighted_data_to_fft[ifft]),
			    	.s_axis_data_tvalid(weighted_data_to_fft_valid),
			    	.s_axis_data_tlast(weighted_data_to_fft_last),
			    	.s_axis_data_tready(data_to_fft_ready[ifft]),
			    	.m_axis_data_tdata(data_from_fft[ifft]),
			    	.m_axis_data_tuser(data_from_fft_user[ifft]),
			    	.m_axis_data_tvalid(data_from_fft_valid[ifft]),
			    	.m_axis_data_tlast(data_from_fft_last[ifft]),
			    	.m_axis_status_tdata(),
			    	.m_axis_status_tvalid(),
			    	.event_frame_started(event_frame_started[ifft]),
			    	.event_tlast_unexpected(event_tlast_unexpected[ifft]),
			    	.event_tlast_missing(event_tlast_missing[ifft]),
			    	.event_fft_overflow(event_fft_overflow[ifft]),
			    	.event_data_in_channel_halt(event_data_in_channel_halt[ifft])
				);
		end
	endgenerate
`else 
	
`endif

`ifndef IS_SIM
	FftDataSelector
		#(
			.SIGNAL_WIDTH(SIGNAL_WIDTH),
			.CHANNEL_NUMBER(4),
			.DISTANCE_LENGTH(FRAME_LENGTH),
			.CHANNEL_SEQUENCE_NUMBER(4)
		)
		inst_data_after_fft_selector
		(
			.i_signal(
				{
					data_from_fft[3],
					data_from_fft[2],
					data_from_fft[1],
					data_from_fft[0]
				}
			),
			.i_signal_valid(
				{
					data_from_fft_valid[3],
					data_from_fft_valid[2],
					data_from_fft_valid[1],
					data_from_fft_valid[0]
				}
			),
			.i_signal_last(
				{
					data_from_fft_last[3],
					data_from_fft_last[2],
					data_from_fft_last[1],
					data_from_fft_last[0]
				}
			),
			.i_selected_channel(output_source_channel[2: 0]),
			.i_selected_distance(output_source_channel[3 +: 8]),
	
			.i_reset(i_reset),
			.i_clock(i_clock),
	
			.o_signal(output_data_after_fft),
			.o_signal_valid(output_data_after_fft_valid),
			.o_signal_last(output_data_after_fft_last),
			.o_signal_start(output_data_after_fft_start)
		);
`else
`endif

	wire [2 * SIGNAL_WIDTH - 1: 0]max_signal;
	wire [2 * SIGNAL_WIDTH - 1: 0]max_signal_aux;
	wire [2: 0]max_signal_channel;
	wire max_signal_aux_channel;
	wire [8: 0]max_signal_frq_channel;
	wire max_signal_valid;
	wire max_frame_finished;
	wire max_frame_started;

`ifndef IS_SIM
	FftFrameProcessor
		#(
			.CHANNEL_NUMBER(CHANNEL_NUMBER),
			.CHANNEL_PER_CLOCK(CHANNEL_PER_CLOCK),
			.SIGNAL_WIDTH(SIGNAL_WIDTH),
			.FFT_DEPTH(FFT_DEPTH),
			.FRAME_LENGTH(FRAME_LENGTH)
		)
		inst_fft_frame_processor
		(
			.i_signal(
				{
					data_from_fft[3],
					data_from_fft[2],
					data_from_fft[1],
					data_from_fft[0]
				}
			),
	
			.i_signal_valid(data_from_fft_valid[0]),
			.i_signal_finished(data_from_fft_last[0]),
	
			.i_clock(i_clock),
			.i_reset(i_reset),
	
			.o_signal(max_signal),
			.o_signal_aux(max_signal_aux),
			.o_signal_channel(max_signal_channel),
			.o_signal_aux_channel(max_signal_aux_channel),
			.o_signal_frq_channel(max_signal_frq_channel),
			.o_signal_valid(max_signal_valid),
			.o_frame_finished(max_frame_finished),
			.o_frame_started(max_frame_started)
		);
`else
	assign max_signal = 0;
	assign max_signal_valid = 0;
	assign max_frame_finished = 0;
	assign max_frame_started = 0;
`endif


`ifndef IS_SIM
	DspDataProcessor
		#(
			.SIGNAL_WIDTH(2 * SIGNAL_WIDTH),
			.FRAME_LENGTH(FRAME_LENGTH),
			.SEQUENCE_NUMBER(26),
			.SORTER_DEPTH(15),
			.COEF_WIDTH(32),
			.SORTER_ADDRESS_WIDTH(5),
			.LOCAL_STORAGE_ADDRESS_WIDTH(8),
			.COEF_LEVEL_ONE(24),
			.FAR_LENGTH(101),
			.CLOSE_LENGTH(40)
		)
		inst_data_processor
		(
			.i_signal(max_signal),
			.i_signal_aux(max_signal_aux),
			.i_signal_channel(max_signal_channel),
			.i_signal_aux_channel(max_signal_aux_channel),
			.i_signal_frq_channel(max_signal_frq_channel),
			.i_signal_valid(max_signal_valid),
			.i_start_processing(max_frame_finished),
			.i_reset(i_reset),
			.i_clock(i_clock),
	
			.i_selected_rank(i_apu_rank),
			.i_threshold(i_detector_level_1),
			.i_coef(i_detector_level_0),
	
			.o_shoulder_data(shoulder_data_from_processor),
			.o_shoulder_data_start(shoulder_data_from_processor_start),
			.o_shoulder_data_valid(shoulder_data_from_processor_valid),
			.o_shoulder_data_finish(shoulder_data_from_processor_finished),
	
			.o_rank_sorter_data(rank_sorter_data_from_processor),
			.o_rank_sorter_data_start(rank_sorter_data_from_processor_start),
			.o_rank_sorter_data_valid(rank_sorter_data_from_processor_valid),
			.o_rank_sorter_data_finish(rank_sorter_data_from_processor_finished),
	
			.o_detection_data(detection_data_from_processor),
			.o_detection_data_start(detection_data_from_processor_start),
			.o_detection_data_valid(detection_data_from_processor_valid),
			.o_detection_data_finish(detection_data_from_processor_finished),
	
			.o_data(measured_data_from_processor),
			.o_data_start(measured_data_from_processor_start),
			.o_data_valid(measured_data_from_processor_valid),
			.o_data_finish(measured_data_from_processor_finished),
			
			.o_ready()
	
		);
`else
	assign shoulder_data_from_processor = 0;
	assign shoulder_data_from_processor_start = 0;
	assign shoulder_data_from_processor_valid = 0;
	assign shoulder_data_from_processor_finished = 0;
	
	assign rank_sorter_data_from_processor = 0;
	assign rank_sorter_data_from_processor_start = 0;
	assign rank_sorter_data_from_processor_valid = 0;
	assign rank_sorter_data_from_processor_finished = 0;
	
	assign detection_data_from_processor = 0;
	assign detection_data_from_processor_start = 0;
	assign detection_data_from_processor_valid = 0;
	assign detection_data_from_processor_finished = 0;
	
	assign measured_data_from_processor = 0;
	assign measured_data_from_processor_start = 0;
	assign measured_data_from_processor_valid = 0;
	assign measured_data_from_processor_finished = 0;

`endif

endmodule
