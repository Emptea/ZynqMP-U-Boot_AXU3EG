
`timescale 1 ns / 1 ps

module multiplier_v1_0 #(
    parameter integer AXI_DATA_WIDTH = 32,
    parameter integer AXI_ADDR_WIDTH = 11,
    parameter integer DATA_WIDTH = 16,
    parameter integer N_DATA_IN_PACK = 2,
    parameter integer AXIS_TDATA_WIDTH = DATA_WIDTH * N_DATA_IN_PACK,
    parameter integer MULT_WIDTH = 16,
    parameter integer DSP_DELAY = 3,
    parameter integer N_MULTS = 8
) (
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF s00_axi, ASSOCIATED_RESET s00_axi_aresetn" *)
    input wire s00_axi_aclk,
    input wire s00_axi_aresetn,
    input wire [AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
    input wire [2 : 0] s00_axi_awprot,
    input wire s00_axi_awvalid,
    output wire s00_axi_awready,
    input wire [AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
    input wire [(AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
    input wire s00_axi_wvalid,
    output wire s00_axi_wready,
    output wire [1 : 0] s00_axi_bresp,
    output wire s00_axi_bvalid,
    input wire s00_axi_bready,
    input wire [AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
    input wire [2 : 0] s00_axi_arprot,
    input wire s00_axi_arvalid,
    output wire s00_axi_arready,
    output wire [AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
    output wire [1 : 0] s00_axi_rresp,
    output wire s00_axi_rvalid,
    input wire s00_axi_rready, 

                         (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 aclk CLK" *)
                         (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF m_axis:s00_axis:s01_axis:s02_axis:s03_axis:s04_axis:s05_axis:s06_axis:s07_axis, ASSOCIATED_RESET aresetn" *)
    input wire aclk, (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
    input wire aresetn,

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
    input wire s07_axis_tvalid
);


  wire [MULT_WIDTH * N_MULTS - 1 : 0] mults;
  wire [AXI_DATA_WIDTH - 1:0] ip_ver;
  wire kill;
  wire [2:0] test_point;
  wire [2:0] channel;
  wire [15:0] mult0;
  wire [15:0] mult1;
  wire [15:0] mult2;
  wire [15:0] mult4;
  wire [15:0] mult5;
  wire [15:0] mult6;
  wire [15:0] mult7;

  // Instantiation of Axi Bus Interface S00_AXI
  regs #(
      .ADDR_W(AXI_ADDR_WIDTH),
      .DATA_W(AXI_DATA_WIDTH),
      .STRB_W(AXI_DATA_WIDTH / 8)
  ) regs_inst (
      .clk                          (s00_axi_aclk),
      .rst                          (s00_axi_aresetn),
      .csr_kill_kill_out            (kill),
      .csr_test_point_test_point_out(test_point),
      .csr_channel_test_point_out   (channel),
      .csr_mult0_mult0_out(mults[0+:MULT_WIDTH]),
      .csr_mult1_mult1_out          (mults[MULT_WIDTH+:MULT_WIDTH]),
      .csr_mult2_mult2_out          (mults[MULT_WIDTH*2+:MULT_WIDTH]),
      .csr_mult3_mult3_out          (mults[MULT_WIDTH*3+:MULT_WIDTH]),
      .csr_mult4_mult4_out          (mults[MULT_WIDTH*4+:MULT_WIDTH]),
      .csr_mult5_mult5_out          (mults[MULT_WIDTH*5+:MULT_WIDTH]),
      .csr_mult6_mult6_out          (mults[MULT_WIDTH*6+:MULT_WIDTH]),
      .csr_mult7_mult7_out          (mults[MULT_WIDTH*7+:MULT_WIDTH]),
      .axil_awaddr                  (s00_axi_awaddr),
      .axil_awprot                  (s00_axi_awprot),
      .axil_awvalid                 (s00_axi_awvalid),
      .axil_awready                 (s00_axi_awready),
      .axil_wdata                   (s00_axi_wdata),
      .axil_wstrb                   (s00_axi_wstrb),
      .axil_wvalid                  (s00_axi_wvalid),
      .axil_wready                  (s00_axi_wready),
      .axil_bresp                   (s00_axi_bresp),
      .axil_bvalid                  (s00_axi_bvalid),
      .axil_bready                  (s00_axi_bready),
      .axil_araddr                  (s00_axi_araddr),
      .axil_arprot                  (s00_axi_arprot),
      .axil_arvalid                 (s00_axi_arvalid),
      .axil_arready                 (s00_axi_arready),
      .axil_rdata                   (s00_axi_rdata),
      .axil_rresp                   (s00_axi_rresp),
      .axil_rvalid                  (s00_axi_rvalid),
      .axil_rready                  (s00_axi_rready)
  );

  axi_multiplier_8ch #(
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .N_DATA_IN_PACK(N_DATA_IN_PACK),
      .AXIS_TDATA_WIDTH(AXIS_TDATA_WIDTH),
      .MULT_WIDTH(MULT_WIDTH),
      .DSP_DELAY(DSP_DELAY),
      .N_MULTS(N_MULTS)
  ) axi_multiplier_8ch_inst (
      .aclk(aclk),
      .aresetn(aresetn),
      .channel(channel),
      .mults(mults),
      .m_axis_tvalid(m_axis_tvalid),
      .m_axis_tdata(m_axis_tdata),
      .m_axis_tlast(m_axis_tlast),
      .m_axis_tready(m_axis_tready),
      .s00_axis_tready(s00_axis_tready),
      .s00_axis_tdata(s00_axis_tdata),
      .s00_axis_tlast(s00_axis_tlast),
      .s00_axis_tvalid(s00_axis_tvalid),
      .s01_axis_tready(s01_axis_tready),
      .s01_axis_tdata(s01_axis_tdata),
      .s01_axis_tlast(s01_axis_tlast),
      .s01_axis_tvalid(s01_axis_tvalid),
      .s02_axis_tready(s02_axis_tready),
      .s02_axis_tdata(s02_axis_tdata),
      .s02_axis_tlast(s02_axis_tlast),
      .s02_axis_tvalid(s02_axis_tvalid),
      .s03_axis_tready(s03_axis_tready),
      .s03_axis_tdata(s03_axis_tdata),
      .s03_axis_tlast(s03_axis_tlast),
      .s03_axis_tvalid(s03_axis_tvalid),
      .s04_axis_tready(s04_axis_tready),
      .s04_axis_tdata(s04_axis_tdata),
      .s04_axis_tlast(s04_axis_tlast),
      .s04_axis_tvalid(s04_axis_tvalid),
      .s05_axis_tready(s05_axis_tready),
      .s05_axis_tdata(s05_axis_tdata),
      .s05_axis_tlast(s05_axis_tlast),
      .s05_axis_tvalid(s05_axis_tvalid),
      .s06_axis_tready(s06_axis_tready),
      .s06_axis_tdata(s06_axis_tdata),
      .s06_axis_tlast(s06_axis_tlast),
      .s06_axis_tvalid(s06_axis_tvalid),
      .s07_axis_tready(s07_axis_tready),
      .s07_axis_tdata(s07_axis_tdata),
      .s07_axis_tlast(s07_axis_tlast),
      .s07_axis_tvalid(s07_axis_tvalid)
  );

endmodule
