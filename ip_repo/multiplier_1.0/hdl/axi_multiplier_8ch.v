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
    reg mux_tvalid;
    reg mux_tlast;
    reg [AXIS_TDATA_WIDTH-1:0] mux_tdata;
    wire [N_MULTS-1:0] mults_tready;
    
    assign s00_axis_tready = mults_tready[0];
    assign s01_axis_tready = mults_tready[1];
    assign s02_axis_tready = mults_tready[2];
    assign s03_axis_tready = mults_tready[3];
    assign s04_axis_tready = mults_tready[4];
    assign s05_axis_tready = mults_tready[5];
    assign s06_axis_tready = mults_tready[6];
    assign s07_axis_tready = mults_tready[7];
    
    assign m_axis_tvalid = mux_tvalid;
    assign m_axis_tlast = mux_tlast;
    assign m_axis_tdata = mux_tdata;
    
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
                .s00_axis_tready     (mults_tready[i]),
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
    
endmodule