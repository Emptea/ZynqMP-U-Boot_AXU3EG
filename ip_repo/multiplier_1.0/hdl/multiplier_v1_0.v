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

  wire reset_from_control;
  wire apply_controls;

  wire [31:0] csr_compensation_mode_mode_out;
  wire [15:0] csr_manual_compensation_0_real_out;
  wire [15:0] csr_manual_compensation_0_imag_out;
  wire [15:0] csr_manual_compensation_1_real_out;
  wire [15:0] csr_manual_compensation_1_imag_out;
  wire [15:0] csr_manual_compensation_2_real_out;
  wire [15:0] csr_manual_compensation_2_imag_out;
  wire [15:0] csr_manual_compensation_3_real_out;
  wire [15:0] csr_manual_compensation_3_imag_out;
  wire [15:0] csr_manual_compensation_4_real_out;
  wire [15:0] csr_manual_compensation_4_imag_out;
  wire [15:0] csr_manual_compensation_5_real_out;
  wire [15:0] csr_manual_compensation_5_imag_out;
  wire [15:0] csr_manual_compensation_6_real_out;
  wire [15:0] csr_manual_compensation_6_imag_out;
  wire [15:0] csr_manual_compensation_7_real_out;
  wire [15:0] csr_manual_compensation_7_imag_out;
  wire [15:0] csr_diagram_0_0_real_out;
  wire [15:0] csr_diagram_0_0_imag_out;
  wire [15:0] csr_diagram_0_1_real_out;
  wire [15:0] csr_diagram_0_1_imag_out;
  wire [15:0] csr_diagram_0_2_real_out;
  wire [15:0] csr_diagram_0_2_imag_out;
  wire [15:0] csr_diagram_0_3_real_out;
  wire [15:0] csr_diagram_0_3_imag_out;
  wire [15:0] csr_diagram_0_4_real_out;
  wire [15:0] csr_diagram_0_4_imag_out;
  wire [15:0] csr_diagram_0_5_real_out;
  wire [15:0] csr_diagram_0_5_imag_out;
  wire [15:0] csr_diagram_0_6_real_out;
  wire [15:0] csr_diagram_0_6_imag_out;
  wire [15:0] csr_diagram_0_7_real_out;
  wire [15:0] csr_diagram_0_7_imag_out;
  wire [15:0] csr_diagram_1_0_real_out;
  wire [15:0] csr_diagram_1_0_imag_out;
  wire [15:0] csr_diagram_1_1_real_out;
  wire [15:0] csr_diagram_1_1_imag_out;
  wire [15:0] csr_diagram_1_2_real_out;
  wire [15:0] csr_diagram_1_2_imag_out;
  wire [15:0] csr_diagram_1_3_real_out;
  wire [15:0] csr_diagram_1_3_imag_out;
  wire [15:0] csr_diagram_1_4_real_out;
  wire [15:0] csr_diagram_1_4_imag_out;
  wire [15:0] csr_diagram_1_5_real_out;
  wire [15:0] csr_diagram_1_5_imag_out;
  wire [15:0] csr_diagram_1_6_real_out;
  wire [15:0] csr_diagram_1_6_imag_out;
  wire [15:0] csr_diagram_1_7_real_out;
  wire [15:0] csr_diagram_1_7_imag_out;
  wire [15:0] csr_diagram_2_0_real_out;
  wire [15:0] csr_diagram_2_0_imag_out;
  wire [15:0] csr_diagram_2_1_real_out;
  wire [15:0] csr_diagram_2_1_imag_out;
  wire [15:0] csr_diagram_2_2_real_out;
  wire [15:0] csr_diagram_2_2_imag_out;
  wire [15:0] csr_diagram_2_3_real_out;
  wire [15:0] csr_diagram_2_3_imag_out;
  wire [15:0] csr_diagram_2_4_real_out;
  wire [15:0] csr_diagram_2_4_imag_out;
  wire [15:0] csr_diagram_2_5_real_out;
  wire [15:0] csr_diagram_2_5_imag_out;
  wire [15:0] csr_diagram_2_6_real_out;
  wire [15:0] csr_diagram_2_6_imag_out;
  wire [15:0] csr_diagram_2_7_real_out;
  wire [15:0] csr_diagram_2_7_imag_out;
  wire [15:0] csr_diagram_3_0_real_out;
  wire [15:0] csr_diagram_3_0_imag_out;
  wire [15:0] csr_diagram_3_1_real_out;
  wire [15:0] csr_diagram_3_1_imag_out;
  wire [15:0] csr_diagram_3_2_real_out;
  wire [15:0] csr_diagram_3_2_imag_out;
  wire [15:0] csr_diagram_3_3_real_out;
  wire [15:0] csr_diagram_3_3_imag_out;
  wire [15:0] csr_diagram_3_4_real_out;
  wire [15:0] csr_diagram_3_4_imag_out;
  wire [15:0] csr_diagram_3_5_real_out;
  wire [15:0] csr_diagram_3_5_imag_out;
  wire [15:0] csr_diagram_3_6_real_out;
  wire [15:0] csr_diagram_3_6_imag_out;
  wire [15:0] csr_diagram_3_7_real_out;
  wire [15:0] csr_diagram_3_7_imag_out;
  wire [15:0] csr_diagram_4_0_real_out;
  wire [15:0] csr_diagram_4_0_imag_out;
  wire [15:0] csr_diagram_4_1_real_out;
  wire [15:0] csr_diagram_4_1_imag_out;
  wire [15:0] csr_diagram_4_2_real_out;
  wire [15:0] csr_diagram_4_2_imag_out;
  wire [15:0] csr_diagram_4_3_real_out;
  wire [15:0] csr_diagram_4_3_imag_out;
  wire [15:0] csr_diagram_4_4_real_out;
  wire [15:0] csr_diagram_4_4_imag_out;
  wire [15:0] csr_diagram_4_5_real_out;
  wire [15:0] csr_diagram_4_5_imag_out;
  wire [15:0] csr_diagram_4_6_real_out;
  wire [15:0] csr_diagram_4_6_imag_out;
  wire [15:0] csr_diagram_4_7_real_out;
  wire [15:0] csr_diagram_4_7_imag_out;
  wire [15:0] csr_diagram_5_0_real_out;
  wire [15:0] csr_diagram_5_0_imag_out;
  wire [15:0] csr_diagram_5_1_real_out;
  wire [15:0] csr_diagram_5_1_imag_out;
  wire [15:0] csr_diagram_5_2_real_out;
  wire [15:0] csr_diagram_5_2_imag_out;
  wire [15:0] csr_diagram_5_3_real_out;
  wire [15:0] csr_diagram_5_3_imag_out;
  wire [15:0] csr_diagram_5_4_real_out;
  wire [15:0] csr_diagram_5_4_imag_out;
  wire [15:0] csr_diagram_5_5_real_out;
  wire [15:0] csr_diagram_5_5_imag_out;
  wire [15:0] csr_diagram_5_6_real_out;
  wire [15:0] csr_diagram_5_6_imag_out;
  wire [15:0] csr_diagram_5_7_real_out;
  wire [15:0] csr_diagram_5_7_imag_out;
  wire [15:0] csr_diagram_6_0_real_out;
  wire [15:0] csr_diagram_6_0_imag_out;
  wire [15:0] csr_diagram_6_1_real_out;
  wire [15:0] csr_diagram_6_1_imag_out;
  wire [15:0] csr_diagram_6_2_real_out;
  wire [15:0] csr_diagram_6_2_imag_out;
  wire [15:0] csr_diagram_6_3_real_out;
  wire [15:0] csr_diagram_6_3_imag_out;
  wire [15:0] csr_diagram_6_4_real_out;
  wire [15:0] csr_diagram_6_4_imag_out;
  wire [15:0] csr_diagram_6_5_real_out;
  wire [15:0] csr_diagram_6_5_imag_out;
  wire [15:0] csr_diagram_6_6_real_out;
  wire [15:0] csr_diagram_6_6_imag_out;
  wire [15:0] csr_diagram_6_7_real_out;
  wire [15:0] csr_diagram_6_7_imag_out;
  wire [15:0] csr_diagram_7_0_real_out;
  wire [15:0] csr_diagram_7_0_imag_out;
  wire [15:0] csr_diagram_7_1_real_out;
  wire [15:0] csr_diagram_7_1_imag_out;
  wire [15:0] csr_diagram_7_2_real_out;
  wire [15:0] csr_diagram_7_2_imag_out;
  wire [15:0] csr_diagram_7_3_real_out;
  wire [15:0] csr_diagram_7_3_imag_out;
  wire [15:0] csr_diagram_7_4_real_out;
  wire [15:0] csr_diagram_7_4_imag_out;
  wire [15:0] csr_diagram_7_5_real_out;
  wire [15:0] csr_diagram_7_5_imag_out;
  wire [15:0] csr_diagram_7_6_real_out;
  wire [15:0] csr_diagram_7_6_imag_out;
  wire [15:0] csr_diagram_7_7_real_out;
  wire [15:0] csr_diagram_7_7_imag_out;
  wire [7:0] csr_motion_selector_filter_out;
  wire  csr_motion_selector_onoff_out;
  wire [31:0] csr_diagram_angle_0_angle_out;
  wire [31:0] csr_diagram_angle_1_angle_out;
  wire [31:0] csr_diagram_angle_2_angle_out;
  wire [31:0] csr_diagram_angle_3_angle_out;
  wire [31:0] csr_diagram_angle_4_angle_out;
  wire [31:0] csr_diagram_angle_5_angle_out;
  wire [31:0] csr_diagram_angle_6_angle_out;
  wire [31:0] csr_diagram_angle_7_angle_out;
  wire [15:0] csr_output_source_source_out;
  wire [15:0] csr_output_source_source_channel_out;
  wire [7:0] csr_apu_rank_rank_out;
  wire [7:0] csr_apu_rank_window_out;
  wire [31:0] csr_detector_level_0_level_out;
  wire [31:0] csr_detector_level_1_level_out;
  wire [31:0] csr_azimuth_angle_angle_out;
  wire  csr_apply_apply_out;
  wire [15:0] csr_compensation_reference_real_out;

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

      .csr_compensation_mode_mode_out(csr_compensation_mode_mode_out),
      .csr_manual_compensation_0_real_out(csr_manual_compensation_0_real_out),
      .csr_manual_compensation_0_imag_out(csr_manual_compensation_0_imag_out),
      .csr_manual_compensation_1_real_out(csr_manual_compensation_1_real_out),
      .csr_manual_compensation_1_imag_out(csr_manual_compensation_1_imag_out),
      .csr_manual_compensation_2_real_out(csr_manual_compensation_2_real_out),
      .csr_manual_compensation_2_imag_out(csr_manual_compensation_2_imag_out),
      .csr_manual_compensation_3_real_out(csr_manual_compensation_3_real_out),
      .csr_manual_compensation_3_imag_out(csr_manual_compensation_3_imag_out),
      .csr_manual_compensation_4_real_out(csr_manual_compensation_4_real_out),
      .csr_manual_compensation_4_imag_out(csr_manual_compensation_4_imag_out),
      .csr_manual_compensation_5_real_out(csr_manual_compensation_5_real_out),
      .csr_manual_compensation_5_imag_out(csr_manual_compensation_5_imag_out),
      .csr_manual_compensation_6_real_out(csr_manual_compensation_6_real_out),
      .csr_manual_compensation_6_imag_out(csr_manual_compensation_6_imag_out),
      .csr_manual_compensation_7_real_out(csr_manual_compensation_7_real_out),
      .csr_manual_compensation_7_imag_out(csr_manual_compensation_7_imag_out),
      .csr_diagram_0_0_real_out(csr_diagram_0_0_real_out),
      .csr_diagram_0_0_imag_out(csr_diagram_0_0_imag_out),
      .csr_diagram_0_1_real_out(csr_diagram_0_1_real_out),
      .csr_diagram_0_1_imag_out(csr_diagram_0_1_imag_out),
      .csr_diagram_0_2_real_out(csr_diagram_0_2_real_out),
      .csr_diagram_0_2_imag_out(csr_diagram_0_2_imag_out),
      .csr_diagram_0_3_real_out(csr_diagram_0_3_real_out),
      .csr_diagram_0_3_imag_out(csr_diagram_0_3_imag_out),
      .csr_diagram_0_4_real_out(csr_diagram_0_4_real_out),
      .csr_diagram_0_4_imag_out(csr_diagram_0_4_imag_out),
      .csr_diagram_0_5_real_out(csr_diagram_0_5_real_out),
      .csr_diagram_0_5_imag_out(csr_diagram_0_5_imag_out),
      .csr_diagram_0_6_real_out(csr_diagram_0_6_real_out),
      .csr_diagram_0_6_imag_out(csr_diagram_0_6_imag_out),
      .csr_diagram_0_7_real_out(csr_diagram_0_7_real_out),
      .csr_diagram_0_7_imag_out(csr_diagram_0_7_imag_out),
      .csr_diagram_1_0_real_out(csr_diagram_1_0_real_out),
      .csr_diagram_1_0_imag_out(csr_diagram_1_0_imag_out),
      .csr_diagram_1_1_real_out(csr_diagram_1_1_real_out),
      .csr_diagram_1_1_imag_out(csr_diagram_1_1_imag_out),
      .csr_diagram_1_2_real_out(csr_diagram_1_2_real_out),
      .csr_diagram_1_2_imag_out(csr_diagram_1_2_imag_out),
      .csr_diagram_1_3_real_out(csr_diagram_1_3_real_out),
      .csr_diagram_1_3_imag_out(csr_diagram_1_3_imag_out),
      .csr_diagram_1_4_real_out(csr_diagram_1_4_real_out),
      .csr_diagram_1_4_imag_out(csr_diagram_1_4_imag_out),
      .csr_diagram_1_5_real_out(csr_diagram_1_5_real_out),
      .csr_diagram_1_5_imag_out(csr_diagram_1_5_imag_out),
      .csr_diagram_1_6_real_out(csr_diagram_1_6_real_out),
      .csr_diagram_1_6_imag_out(csr_diagram_1_6_imag_out),
      .csr_diagram_1_7_real_out(csr_diagram_1_7_real_out),
      .csr_diagram_1_7_imag_out(csr_diagram_1_7_imag_out),
      .csr_diagram_2_0_real_out(csr_diagram_2_0_real_out),
      .csr_diagram_2_0_imag_out(csr_diagram_2_0_imag_out),
      .csr_diagram_2_1_real_out(csr_diagram_2_1_real_out),
      .csr_diagram_2_1_imag_out(csr_diagram_2_1_imag_out),
      .csr_diagram_2_2_real_out(csr_diagram_2_2_real_out),
      .csr_diagram_2_2_imag_out(csr_diagram_2_2_imag_out),
      .csr_diagram_2_3_real_out(csr_diagram_2_3_real_out),
      .csr_diagram_2_3_imag_out(csr_diagram_2_3_imag_out),
      .csr_diagram_2_4_real_out(csr_diagram_2_4_real_out),
      .csr_diagram_2_4_imag_out(csr_diagram_2_4_imag_out),
      .csr_diagram_2_5_real_out(csr_diagram_2_5_real_out),
      .csr_diagram_2_5_imag_out(csr_diagram_2_5_imag_out),
      .csr_diagram_2_6_real_out(csr_diagram_2_6_real_out),
      .csr_diagram_2_6_imag_out(csr_diagram_2_6_imag_out),
      .csr_diagram_2_7_real_out(csr_diagram_2_7_real_out),
      .csr_diagram_2_7_imag_out(csr_diagram_2_7_imag_out),
      .csr_diagram_3_0_real_out(csr_diagram_3_0_real_out),
      .csr_diagram_3_0_imag_out(csr_diagram_3_0_imag_out),
      .csr_diagram_3_1_real_out(csr_diagram_3_1_real_out),
      .csr_diagram_3_1_imag_out(csr_diagram_3_1_imag_out),
      .csr_diagram_3_2_real_out(csr_diagram_3_2_real_out),
      .csr_diagram_3_2_imag_out(csr_diagram_3_2_imag_out),
      .csr_diagram_3_3_real_out(csr_diagram_3_3_real_out),
      .csr_diagram_3_3_imag_out(csr_diagram_3_3_imag_out),
      .csr_diagram_3_4_real_out(csr_diagram_3_4_real_out),
      .csr_diagram_3_4_imag_out(csr_diagram_3_4_imag_out),
      .csr_diagram_3_5_real_out(csr_diagram_3_5_real_out),
      .csr_diagram_3_5_imag_out(csr_diagram_3_5_imag_out),
      .csr_diagram_3_6_real_out(csr_diagram_3_6_real_out),
      .csr_diagram_3_6_imag_out(csr_diagram_3_6_imag_out),
      .csr_diagram_3_7_real_out(csr_diagram_3_7_real_out),
      .csr_diagram_3_7_imag_out(csr_diagram_3_7_imag_out),
      .csr_diagram_4_0_real_out(csr_diagram_4_0_real_out),
      .csr_diagram_4_0_imag_out(csr_diagram_4_0_imag_out),
      .csr_diagram_4_1_real_out(csr_diagram_4_1_real_out),
      .csr_diagram_4_1_imag_out(csr_diagram_4_1_imag_out),
      .csr_diagram_4_2_real_out(csr_diagram_4_2_real_out),
      .csr_diagram_4_2_imag_out(csr_diagram_4_2_imag_out),
      .csr_diagram_4_3_real_out(csr_diagram_4_3_real_out),
      .csr_diagram_4_3_imag_out(csr_diagram_4_3_imag_out),
      .csr_diagram_4_4_real_out(csr_diagram_4_4_real_out),
      .csr_diagram_4_4_imag_out(csr_diagram_4_4_imag_out),
      .csr_diagram_4_5_real_out(csr_diagram_4_5_real_out),
      .csr_diagram_4_5_imag_out(csr_diagram_4_5_imag_out),
      .csr_diagram_4_6_real_out(csr_diagram_4_6_real_out),
      .csr_diagram_4_6_imag_out(csr_diagram_4_6_imag_out),
      .csr_diagram_4_7_real_out(csr_diagram_4_7_real_out),
      .csr_diagram_4_7_imag_out(csr_diagram_4_7_imag_out),
      .csr_diagram_5_0_real_out(csr_diagram_5_0_real_out),
      .csr_diagram_5_0_imag_out(csr_diagram_5_0_imag_out),
      .csr_diagram_5_1_real_out(csr_diagram_5_1_real_out),
      .csr_diagram_5_1_imag_out(csr_diagram_5_1_imag_out),
      .csr_diagram_5_2_real_out(csr_diagram_5_2_real_out),
      .csr_diagram_5_2_imag_out(csr_diagram_5_2_imag_out),
      .csr_diagram_5_3_real_out(csr_diagram_5_3_real_out),
      .csr_diagram_5_3_imag_out(csr_diagram_5_3_imag_out),
      .csr_diagram_5_4_real_out(csr_diagram_5_4_real_out),
      .csr_diagram_5_4_imag_out(csr_diagram_5_4_imag_out),
      .csr_diagram_5_5_real_out(csr_diagram_5_5_real_out),
      .csr_diagram_5_5_imag_out(csr_diagram_5_5_imag_out),
      .csr_diagram_5_6_real_out(csr_diagram_5_6_real_out),
      .csr_diagram_5_6_imag_out(csr_diagram_5_6_imag_out),
      .csr_diagram_5_7_real_out(csr_diagram_5_7_real_out),
      .csr_diagram_5_7_imag_out(csr_diagram_5_7_imag_out),
      .csr_diagram_6_0_real_out(csr_diagram_6_0_real_out),
      .csr_diagram_6_0_imag_out(csr_diagram_6_0_imag_out),
      .csr_diagram_6_1_real_out(csr_diagram_6_1_real_out),
      .csr_diagram_6_1_imag_out(csr_diagram_6_1_imag_out),
      .csr_diagram_6_2_real_out(csr_diagram_6_2_real_out),
      .csr_diagram_6_2_imag_out(csr_diagram_6_2_imag_out),
      .csr_diagram_6_3_real_out(csr_diagram_6_3_real_out),
      .csr_diagram_6_3_imag_out(csr_diagram_6_3_imag_out),
      .csr_diagram_6_4_real_out(csr_diagram_6_4_real_out),
      .csr_diagram_6_4_imag_out(csr_diagram_6_4_imag_out),
      .csr_diagram_6_5_real_out(csr_diagram_6_5_real_out),
      .csr_diagram_6_5_imag_out(csr_diagram_6_5_imag_out),
      .csr_diagram_6_6_real_out(csr_diagram_6_6_real_out),
      .csr_diagram_6_6_imag_out(csr_diagram_6_6_imag_out),
      .csr_diagram_6_7_real_out(csr_diagram_6_7_real_out),
      .csr_diagram_6_7_imag_out(csr_diagram_6_7_imag_out),
      .csr_diagram_7_0_real_out(csr_diagram_7_0_real_out),
      .csr_diagram_7_0_imag_out(csr_diagram_7_0_imag_out),
      .csr_diagram_7_1_real_out(csr_diagram_7_1_real_out),
      .csr_diagram_7_1_imag_out(csr_diagram_7_1_imag_out),
      .csr_diagram_7_2_real_out(csr_diagram_7_2_real_out),
      .csr_diagram_7_2_imag_out(csr_diagram_7_2_imag_out),
      .csr_diagram_7_3_real_out(csr_diagram_7_3_real_out),
      .csr_diagram_7_3_imag_out(csr_diagram_7_3_imag_out),
      .csr_diagram_7_4_real_out(csr_diagram_7_4_real_out),
      .csr_diagram_7_4_imag_out(csr_diagram_7_4_imag_out),
      .csr_diagram_7_5_real_out(csr_diagram_7_5_real_out),
      .csr_diagram_7_5_imag_out(csr_diagram_7_5_imag_out),
      .csr_diagram_7_6_real_out(csr_diagram_7_6_real_out),
      .csr_diagram_7_6_imag_out(csr_diagram_7_6_imag_out),
      .csr_diagram_7_7_real_out(csr_diagram_7_7_real_out),
      .csr_diagram_7_7_imag_out(csr_diagram_7_7_imag_out),
      .csr_motion_selector_filter_out(csr_motion_selector_filter_out),
      .csr_motion_selector_onoff_out(csr_motion_selector_onoff_out),
      .csr_diagram_angle_0_angle_out(csr_diagram_angle_0_angle_out),
      .csr_diagram_angle_1_angle_out(csr_diagram_angle_1_angle_out),
      .csr_diagram_angle_2_angle_out(csr_diagram_angle_2_angle_out),
      .csr_diagram_angle_3_angle_out(csr_diagram_angle_3_angle_out),
      .csr_diagram_angle_4_angle_out(csr_diagram_angle_4_angle_out),
      .csr_diagram_angle_5_angle_out(csr_diagram_angle_5_angle_out),
      .csr_diagram_angle_6_angle_out(csr_diagram_angle_6_angle_out),
      .csr_diagram_angle_7_angle_out(csr_diagram_angle_7_angle_out),
      .csr_output_source_source_out(csr_output_source_source_out),
      .csr_output_source_source_channel_out(csr_output_source_source_channel_out),
      .csr_apu_rank_rank_out(csr_apu_rank_rank_out),
      .csr_apu_rank_window_out(csr_apu_rank_window_out),
      .csr_detector_level_0_level_out(csr_detector_level_0_level_out),
      .csr_detector_level_1_level_out(csr_detector_level_1_level_out),
      .csr_azimuth_angle_angle_out(csr_azimuth_angle_angle_out),
      .csr_compensation_reference_real_out(csr_compensation_reference_real_out),

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
      .axil_rready                  (s00_axi_rready),

      .o_reset(reset_from_control),
      .o_apply(apply_controls)
  );

  localparam CHANNEL_NUMBER = 8;
  localparam BIT_WIDTH = 16;
  localparam DIAGRAM_NUMBER = 8;
  localparam ANGLE_WIDTH = 32;

  wire [15: 0]compensation_mode;
  wire [2 * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]manual_compensation_coefs;
  wire [2 * DIAGRAM_NUMBER * BIT_WIDTH * CHANNEL_NUMBER - 1: 0]diagram_coefs;
  wire [7:0] motion_selector_filter;
  wire motion_selector_onoff_out;
  wire [ANGLE_WIDTH * DIAGRAM_NUMBER - 1: 0]diagram_angle;
  wire [15: 0]output_source;
  wire [15: 0]output_source_channel;
  wire [7:0] apu_rank;
  wire [7:0] apu_window;
  wire [31:0] detector_level_0;
  wire [31:0] detector_level_1;
  wire [31:0] azimuth_angle;
  wire [15:0] auto_compensation_reference;


  assign compensation_mode = csr_compensation_mode_mode_out;
  
  assign manual_compensation_coefs = {
    csr_manual_compensation_7_imag_out,
    csr_manual_compensation_7_real_out,
    csr_manual_compensation_6_imag_out,
    csr_manual_compensation_6_real_out,
    csr_manual_compensation_5_imag_out,
    csr_manual_compensation_5_real_out,
    csr_manual_compensation_4_imag_out,
    csr_manual_compensation_4_real_out,
    csr_manual_compensation_3_imag_out,
    csr_manual_compensation_3_real_out,
    csr_manual_compensation_2_imag_out,
    csr_manual_compensation_2_real_out,
    csr_manual_compensation_1_imag_out,
    csr_manual_compensation_1_real_out,
    csr_manual_compensation_0_imag_out,
    csr_manual_compensation_0_real_out
  };

  assign diagram_coefs = {
      csr_diagram_7_7_imag_out,
      csr_diagram_7_7_real_out,
      csr_diagram_7_6_imag_out,
      csr_diagram_7_6_real_out,
      csr_diagram_7_5_imag_out,
      csr_diagram_7_5_real_out,
      csr_diagram_7_4_imag_out,
      csr_diagram_7_4_real_out,
      csr_diagram_7_3_imag_out,
      csr_diagram_7_3_real_out,
      csr_diagram_7_2_imag_out,
      csr_diagram_7_2_real_out,
      csr_diagram_7_1_imag_out,
      csr_diagram_7_1_real_out,
      csr_diagram_7_0_imag_out,
      csr_diagram_7_0_real_out,

      csr_diagram_6_7_imag_out,
      csr_diagram_6_7_real_out,
      csr_diagram_6_6_imag_out,
      csr_diagram_6_6_real_out,
      csr_diagram_6_5_imag_out,
      csr_diagram_6_5_real_out,
      csr_diagram_6_4_imag_out,
      csr_diagram_6_4_real_out,
      csr_diagram_6_3_imag_out,
      csr_diagram_6_3_real_out,
      csr_diagram_6_2_imag_out,
      csr_diagram_6_2_real_out,
      csr_diagram_6_1_imag_out,
      csr_diagram_6_1_real_out,
      csr_diagram_6_0_imag_out,
      csr_diagram_6_0_real_out,

      csr_diagram_5_7_imag_out,
      csr_diagram_5_7_real_out,
      csr_diagram_5_6_imag_out,
      csr_diagram_5_6_real_out,
      csr_diagram_5_5_imag_out,
      csr_diagram_5_5_real_out,
      csr_diagram_5_4_imag_out,
      csr_diagram_5_4_real_out,
      csr_diagram_5_3_imag_out,
      csr_diagram_5_3_real_out,
      csr_diagram_5_2_imag_out,
      csr_diagram_5_2_real_out,
      csr_diagram_5_1_imag_out,
      csr_diagram_5_1_real_out,
      csr_diagram_5_0_imag_out,
      csr_diagram_5_0_real_out,

      csr_diagram_4_7_imag_out,
      csr_diagram_4_7_real_out,
      csr_diagram_4_6_imag_out,
      csr_diagram_4_6_real_out,
      csr_diagram_4_5_imag_out,
      csr_diagram_4_5_real_out,
      csr_diagram_4_4_imag_out,
      csr_diagram_4_4_real_out,
      csr_diagram_4_3_imag_out,
      csr_diagram_4_3_real_out,
      csr_diagram_4_2_imag_out,
      csr_diagram_4_2_real_out,
      csr_diagram_4_1_imag_out,
      csr_diagram_4_1_real_out,
      csr_diagram_4_0_imag_out,
      csr_diagram_4_0_real_out,

      csr_diagram_3_7_imag_out,
      csr_diagram_3_7_real_out,
      csr_diagram_3_6_imag_out,
      csr_diagram_3_6_real_out,
      csr_diagram_3_5_imag_out,
      csr_diagram_3_5_real_out,
      csr_diagram_3_4_imag_out,
      csr_diagram_3_4_real_out,
      csr_diagram_3_3_imag_out,
      csr_diagram_3_3_real_out,
      csr_diagram_3_2_imag_out,
      csr_diagram_3_2_real_out,
      csr_diagram_3_1_imag_out,
      csr_diagram_3_1_real_out,
      csr_diagram_3_0_imag_out,
      csr_diagram_3_0_real_out,

      csr_diagram_2_7_imag_out,
      csr_diagram_2_7_real_out,
      csr_diagram_2_6_imag_out,
      csr_diagram_2_6_real_out,
      csr_diagram_2_5_imag_out,
      csr_diagram_2_5_real_out,
      csr_diagram_2_4_imag_out,
      csr_diagram_2_4_real_out,
      csr_diagram_2_3_imag_out,
      csr_diagram_2_3_real_out,
      csr_diagram_2_2_imag_out,
      csr_diagram_2_2_real_out,
      csr_diagram_2_1_imag_out,
      csr_diagram_2_1_real_out,
      csr_diagram_2_0_imag_out,
      csr_diagram_2_0_real_out,

      csr_diagram_1_7_imag_out,
      csr_diagram_1_7_real_out,
      csr_diagram_1_6_imag_out,
      csr_diagram_1_6_real_out,
      csr_diagram_1_5_imag_out,
      csr_diagram_1_5_real_out,
      csr_diagram_1_4_imag_out,
      csr_diagram_1_4_real_out,
      csr_diagram_1_3_imag_out,
      csr_diagram_1_3_real_out,
      csr_diagram_1_2_imag_out,
      csr_diagram_1_2_real_out,
      csr_diagram_1_1_imag_out,
      csr_diagram_1_1_real_out,
      csr_diagram_1_0_imag_out,
      csr_diagram_1_0_real_out,

      csr_diagram_0_7_imag_out,
      csr_diagram_0_7_real_out,
      csr_diagram_0_6_imag_out,
      csr_diagram_0_6_real_out,
      csr_diagram_0_5_imag_out,
      csr_diagram_0_5_real_out,
      csr_diagram_0_4_imag_out,
      csr_diagram_0_4_real_out,
      csr_diagram_0_3_imag_out,
      csr_diagram_0_3_real_out,
      csr_diagram_0_2_imag_out,
      csr_diagram_0_2_real_out,
      csr_diagram_0_1_imag_out,
      csr_diagram_0_1_real_out,
      csr_diagram_0_0_imag_out,
      csr_diagram_0_0_real_out
    };

    assign motion_selector_filter = csr_motion_selector_filter_out;

    assign diagram_angle = {
      csr_diagram_angle_7_angle_out,
      csr_diagram_angle_6_angle_out,
      csr_diagram_angle_5_angle_out,
      csr_diagram_angle_4_angle_out,
      csr_diagram_angle_3_angle_out,
      csr_diagram_angle_2_angle_out,
      csr_diagram_angle_1_angle_out,
      csr_diagram_angle_0_angle_out
    };

  assign output_source = csr_output_source_source_out;
  assign output_source_channel = csr_output_source_source_channel_out;
  assign apu_rank = csr_apu_rank_rank_out;
  assign apu_window = csr_apu_rank_window_out;
  assign detector_level_0 = csr_detector_level_0_level_out;
  assign detector_level_1 = csr_detector_level_1_level_out;
  assign azimuth_angle = csr_azimuth_angle_angle_out;
  assign auto_compensation_reference = csr_compensation_reference_real_out;

  axi_multiplier_8ch #(
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .DATA_WIDTH(DATA_WIDTH),
      .N_DATA_IN_PACK(N_DATA_IN_PACK),
      .AXIS_TDATA_WIDTH(AXIS_TDATA_WIDTH),
      .MULT_WIDTH(MULT_WIDTH),
      .DSP_DELAY(DSP_DELAY),
      .N_MULTS(N_MULTS),
      .CHANNEL_NUMBER(CHANNEL_NUMBER),
      .BIT_WIDTH(BIT_WIDTH),
      .DIAGRAM_NUMBER(DIAGRAM_NUMBER),
      .ANGLE_WIDTH(ANGLE_WIDTH)
  ) axi_multiplier_8ch_inst (
      .aclk(aclk),
      .aresetn(aresetn),
      .channel(channel),
      .mults(mults),

      .i_reset_from_controls(reset_from_control),
      .i_apply_controls(apply_controls),

      .i_compensation_mode(compensation_mode),
      .i_manual_compensation_coefs(manual_compensation_coefs),
      .i_diagram_coefs(diagram_coefs),
      .i_motion_selector_filter(motion_selector_filter),
      .i_motion_selector_onoff_out(motion_selector_onoff_out),
      .i_diagram_angle(diagram_angle),
      .i_output_source(output_source),
      .i_output_source_channel(output_source_channel),
      .i_apu_rank(apu_rank),
      .i_apu_window(apu_window),
      .i_detector_level_0(detector_level_0),
      .i_detector_level_1(detector_level_1),
      .i_azimuth_angle(azimuth_angle),
      .i_auto_compensation_reference(auto_compensation_reference),

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
