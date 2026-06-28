`timescale 1 ns / 1 ps

module axi_multiplier_8ch #(parameter integer AXI_DATA_WIDTH     = 32,
                         parameter integer AXI_ADDR_WIDTH    = 11,
                         parameter integer DATA_WIDTH = 16,
                         parameter integer N_DATA_IN_PACK = 2,
                         parameter integer AXIS_TDATA_WIDTH  = DATA_WIDTH * N_DATA_IN_PACK,
                         parameter integer MULT_WIDTH = 16,
                         parameter integer DSP_DELAY = 3,
                         parameter integer N_MULTS = 8)
                        (

                        input i_reset_from_controls,
                        input i_apply_controls,
                         input [15: 0]i_output_source,
                         input [15: 0]i_output_source_channel,


                         input wire aclk,
                         input wire aresetn,
                         input wire [2:0] channel,
                         input wire [MULT_WIDTH * N_MULTS - 1 : 0] mults,

                         output wire m_axis_tvalid,
                         output wire [AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata, 
                         output wire m_axis_tlast, 
                         input wire m_axis_tready, 
                         
                         output wire s00_axis_tready, 
                         input wire [AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata, 
                         input wire s00_axis_tlast, 
                         input wire s00_axis_tvalid,
                         
                         output wire s01_axis_tready, 
                         input wire [AXIS_TDATA_WIDTH-1 : 0] s01_axis_tdata, 
                         input wire s01_axis_tlast, 
                         input wire s01_axis_tvalid,
                         
                         output wire s02_axis_tready, 
                         input wire [AXIS_TDATA_WIDTH-1 : 0] s02_axis_tdata, 
                         input wire s02_axis_tlast, 
                         input wire s02_axis_tvalid,
                         
                          output wire s03_axis_tready, 
                         input wire [AXIS_TDATA_WIDTH-1 : 0] s03_axis_tdata, 
                         input wire s03_axis_tlast, 
                         input wire s03_axis_tvalid,
                         
                          output wire s04_axis_tready, 
                         input wire [AXIS_TDATA_WIDTH-1 : 0] s04_axis_tdata, 
                         input wire s04_axis_tlast, 
                         input wire s04_axis_tvalid,
                         
                         output wire s05_axis_tready, 
                         input wire [AXIS_TDATA_WIDTH-1 : 0] s05_axis_tdata, 
                         input wire s05_axis_tlast, 
                         input wire s05_axis_tvalid,
                         
                         output wire s06_axis_tready, 
                         input wire [AXIS_TDATA_WIDTH-1 : 0] s06_axis_tdata, 
                         input wire s06_axis_tlast, 
                         input wire s06_axis_tvalid,
                         
                         output wire s07_axis_tready, 
                         input wire [AXIS_TDATA_WIDTH-1 : 0] s07_axis_tdata, 
                         input wire s07_axis_tlast, 
                         input wire s07_axis_tvalid);
                         
    wire [N_MULTS-1:0] mults_output_tvalid;
    wire [N_MULTS-1:0] mults_output_tlast;
    wire [AXIS_TDATA_WIDTH-1:0] mults_output_tdata [0:N_MULTS-1];
    wire dsp_data_last;
    
    
    assign m_axis_tlast = dsp_data_last;
    /*
    genvar i;
    generate
        for (i = 0; i < N_MULTS; i = i + 1) begin : gen_axi_multiplier
            axi_multiplier #(
                .DATA_WIDTH(DATA_WIDTH),
                .MULT_WIDTH(MULT_WIDTH),
                .N_DATA_IN_PACK(N_DATA_IN_PACK),
                .AXIS_TDATA_WIDTH(AXIS_TDATA_WIDTH),
                .DSP_DELAY(DSP_DELAY)
            ) axi_multiplier_inst (
                .aclk                (aclk),
                .aresetn             (aresetn),
                .mult (mults[MULT_WIDTH*i +: MULT_WIDTH]),
                .s00_axis_tdata      (i == 0 ? s00_axis_tdata :
                                     i == 1 ? s01_axis_tdata :
                                     i == 2 ? s02_axis_tdata :
                                     i == 3 ? s03_axis_tdata :
                                     i == 4 ? s04_axis_tdata :
                                     i == 5 ? s05_axis_tdata :
                                     i == 6 ? s06_axis_tdata :
                                     i == 7 ? s07_axis_tdata : {AXIS_TDATA_WIDTH{1'b0}}),
                .s00_axis_tvalid     (i == 0 ? s00_axis_tvalid :
                                     i == 1 ? s01_axis_tvalid :
                                     i == 2 ? s02_axis_tvalid :
                                     i == 3 ? s03_axis_tvalid :
                                     i == 4 ? s04_axis_tvalid :
                                     i == 5 ? s05_axis_tvalid :
                                     i == 6 ? s06_axis_tvalid :
                                     i == 7 ? s07_axis_tvalid : 1'b0),
                .s00_axis_tlast      (i == 0 ? s00_axis_tlast :
                                     i == 1 ? s01_axis_tlast :
                                     i == 2 ? s02_axis_tlast :
                                     i == 3 ? s03_axis_tlast :
                                     i == 4 ? s04_axis_tlast :
                                     i == 5 ? s05_axis_tlast :
                                     i == 6 ? s06_axis_tlast :
                                     i == 7 ? s07_axis_tlast : 1'b0),
                .s00_axis_tready     (i == 0 ? s00_axis_tready :
                                     i == 1 ? s01_axis_tready :
                                     i == 2 ? s02_axis_tready :
                                     i == 3 ? s03_axis_tready :
                                     i == 4 ? s04_axis_tready :
                                     i == 5 ? s05_axis_tready :
                                     i == 6 ? s06_axis_tready :
                                     i == 7 ? s07_axis_tready : 1'b0),
                .m00_axis_tready     (m_axis_tready),
                .m00_axis_tdata      (mults_output_tdata[i]),
                .m00_axis_tvalid     (mults_output_tvalid[i]),
                .m00_axis_tlast      (mults_output_tlast[i])
            );
        
        end
    endgenerate

    always @( posedge aclk )
    begin
        if ( aresetn == 1'b0 ) begin
            mux_tvalid  <= 0;
            mux_tlast <= 0;
            mux_tdata <= 0;
        end else begin
            mux_tdata <= mults_output_tdata[channel];
            mux_tvalid <= mults_output_tvalid[channel];
            mux_tlast <= mults_output_tlast[channel];
        end
    end    
*/    

    localparam SIGNAL_WIDTH = 16;
    localparam CHANNEL_NUMBER = 8;
    localparam INPUT_DATA_WIDTH = 2 * SIGNAL_WIDTH * CHANNEL_NUMBER;
    localparam OUTPUT_DATA_WIDTH = 2 * SIGNAL_WIDTH;
    localparam DIAGRAM_NUMBER = 8;
    localparam COMPENSATION_COEF_WIDTH = 16;
    localparam DIAGRAM_COEF_WIDTH = 16;
    localparam COMPENSATION_COEF_LEVEL_ONE = 14;
    localparam DIAGRAM_COEF_LEVEL_ONE = 14;

    wire [CHANNEL_NUMBER - 1: 0]request_data_from_fifo;

    wire [INPUT_DATA_WIDTH - 1: 0]input_data;
    wire [CHANNEL_NUMBER - 1: 0]request_data_from_fifo;
    wire [CHANNEL_NUMBER - 1: 0]input_data_valid;

    assign input_data = {
        s07_axis_tdata,
        s06_axis_tdata,
        s05_axis_tdata,
        s04_axis_tdata,
        s03_axis_tdata,
        s02_axis_tdata,
        s01_axis_tdata,
        s00_axis_tdata
    };

    assign input_data_valid = {
        s07_axis_tvalid,
        s06_axis_tvalid,
        s05_axis_tvalid,
        s04_axis_tvalid,
        s03_axis_tvalid,
        s02_axis_tvalid,
        s01_axis_tvalid,
        s00_axis_tvalid
    };

    Dsp
        #(
            .INPUT_DATA_WIDTH(INPUT_DATA_WIDTH),
            .OUTPUT_DATA_WIDTH(OUTPUT_DATA_WIDTH),
            .SIGNAL_WIDTH(SIGNAL_WIDTH),
            .CHANNEL_NUMBER(CHANNEL_NUMBER),
            .DIAGRAM_NUMBER(DIAGRAM_NUMBER),
            .COMPENSATION_COEF_WIDTH(COMPENSATION_COEF_WIDTH),
            .DIAGRAM_COEF_WIDTH(DIAGRAM_COEF_WIDTH),
            .COMPENSATION_COEF_LEVEL_ONE(COMPENSATION_COEF_LEVEL_ONE),
            .DIAGRAM_COEF_LEVEL_ONE(DIAGRAM_COEF_LEVEL_ONE)
        )
        inst_dsp
        (
            .i_data(input_data),
            .i_data_valid(input_data_valid),
            .i_clock(aclk),
            .i_reset(i_reset_from_controls | ~aresetn),

            .i_apply_controls(i_apply_controls),
            .i_output_source(i_output_source),
            .i_output_source_channel(i_output_source_channel),
    
            .i_compensation_calculation_reference(1 << 14),
    
            .i_compensation_mode(0),
    
            .i_manual_compensation_coefs(0),
            .i_diagram_coefs(0),
    
            .o_read_from_fifo(request_data_from_fifo),
            
            .o_data(m_axis_tdata),
            .o_data_valid(m_axis_tvalid),
            .i_awaiting_data(m_axis_tready),
            .o_data_last(dsp_data_last)
        );


    assign
        {
            s07_axis_tready,
            s06_axis_tready,
            s05_axis_tready,
            s04_axis_tready,
            s03_axis_tready,
            s02_axis_tready,
            s01_axis_tready,
            s00_axis_tready
        } = request_data_from_fifo;

endmodule
