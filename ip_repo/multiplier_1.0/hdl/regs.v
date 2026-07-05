// Created with Corsair v1.0.4

module regs #(
    parameter ADDR_W = 11,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    // System
    input clk,
    input rst,

    output reg o_reset,
    output reg o_apply,
    // ip_ver.min_ver
    // ip_ver.maj_ver

    // kill.kill
    output  csr_kill_kill_out,

    // test_point.test_point
    output [2:0] csr_test_point_test_point_out,

    // channel.test_point
    output [2:0] csr_channel_test_point_out,

    // compensation_mode.mode
    output [31:0] csr_compensation_mode_mode_out,

    // manual_compensation_0.real
    output [15:0] csr_manual_compensation_0_real_out,
    // manual_compensation_0.imag
    output [15:0] csr_manual_compensation_0_imag_out,

    // manual_compensation_1.real
    output [15:0] csr_manual_compensation_1_real_out,
    // manual_compensation_1.imag
    output [15:0] csr_manual_compensation_1_imag_out,

    // manual_compensation_2.real
    output [15:0] csr_manual_compensation_2_real_out,
    // manual_compensation_2.imag
    output [15:0] csr_manual_compensation_2_imag_out,

    // manual_compensation_3.real
    output [15:0] csr_manual_compensation_3_real_out,
    // manual_compensation_3.imag
    output [15:0] csr_manual_compensation_3_imag_out,

    // manual_compensation_4.real
    output [15:0] csr_manual_compensation_4_real_out,
    // manual_compensation_4.imag
    output [15:0] csr_manual_compensation_4_imag_out,

    // manual_compensation_5.real
    output [15:0] csr_manual_compensation_5_real_out,
    // manual_compensation_5.imag
    output [15:0] csr_manual_compensation_5_imag_out,

    // manual_compensation_6.real
    output [15:0] csr_manual_compensation_6_real_out,
    // manual_compensation_6.imag
    output [15:0] csr_manual_compensation_6_imag_out,

    // manual_compensation_7.real
    output [15:0] csr_manual_compensation_7_real_out,
    // manual_compensation_7.imag
    output [15:0] csr_manual_compensation_7_imag_out,

    // diagram_0_0.real
    output [15:0] csr_diagram_0_0_real_out,
    // diagram_0_0.imag
    output [15:0] csr_diagram_0_0_imag_out,

    // diagram_0_1.real
    output [15:0] csr_diagram_0_1_real_out,
    // diagram_0_1.imag
    output [15:0] csr_diagram_0_1_imag_out,

    // diagram_0_2.real
    output [15:0] csr_diagram_0_2_real_out,
    // diagram_0_2.imag
    output [15:0] csr_diagram_0_2_imag_out,

    // diagram_0_3.real
    output [15:0] csr_diagram_0_3_real_out,
    // diagram_0_3.imag
    output [15:0] csr_diagram_0_3_imag_out,

    // diagram_0_4.real
    output [15:0] csr_diagram_0_4_real_out,
    // diagram_0_4.imag
    output [15:0] csr_diagram_0_4_imag_out,

    // diagram_0_5.real
    output [15:0] csr_diagram_0_5_real_out,
    // diagram_0_5.imag
    output [15:0] csr_diagram_0_5_imag_out,

    // diagram_0_6.real
    output [15:0] csr_diagram_0_6_real_out,
    // diagram_0_6.imag
    output [15:0] csr_diagram_0_6_imag_out,

    // diagram_0_7.real
    output [15:0] csr_diagram_0_7_real_out,
    // diagram_0_7.imag
    output [15:0] csr_diagram_0_7_imag_out,

    // diagram_1_0.real
    output [15:0] csr_diagram_1_0_real_out,
    // diagram_1_0.imag
    output [15:0] csr_diagram_1_0_imag_out,

    // diagram_1_1.real
    output [15:0] csr_diagram_1_1_real_out,
    // diagram_1_1.imag
    output [15:0] csr_diagram_1_1_imag_out,

    // diagram_1_2.real
    output [15:0] csr_diagram_1_2_real_out,
    // diagram_1_2.imag
    output [15:0] csr_diagram_1_2_imag_out,

    // diagram_1_3.real
    output [15:0] csr_diagram_1_3_real_out,
    // diagram_1_3.imag
    output [15:0] csr_diagram_1_3_imag_out,

    // diagram_1_4.real
    output [15:0] csr_diagram_1_4_real_out,
    // diagram_1_4.imag
    output [15:0] csr_diagram_1_4_imag_out,

    // diagram_1_5.real
    output [15:0] csr_diagram_1_5_real_out,
    // diagram_1_5.imag
    output [15:0] csr_diagram_1_5_imag_out,

    // diagram_1_6.real
    output [15:0] csr_diagram_1_6_real_out,
    // diagram_1_6.imag
    output [15:0] csr_diagram_1_6_imag_out,

    // diagram_1_7.real
    output [15:0] csr_diagram_1_7_real_out,
    // diagram_1_7.imag
    output [15:0] csr_diagram_1_7_imag_out,

    // diagram_2_0.real
    output [15:0] csr_diagram_2_0_real_out,
    // diagram_2_0.imag
    output [15:0] csr_diagram_2_0_imag_out,

    // diagram_2_1.real
    output [15:0] csr_diagram_2_1_real_out,
    // diagram_2_1.imag
    output [15:0] csr_diagram_2_1_imag_out,

    // diagram_2_2.real
    output [15:0] csr_diagram_2_2_real_out,
    // diagram_2_2.imag
    output [15:0] csr_diagram_2_2_imag_out,

    // diagram_2_3.real
    output [15:0] csr_diagram_2_3_real_out,
    // diagram_2_3.imag
    output [15:0] csr_diagram_2_3_imag_out,

    // diagram_2_4.real
    output [15:0] csr_diagram_2_4_real_out,
    // diagram_2_4.imag
    output [15:0] csr_diagram_2_4_imag_out,

    // diagram_2_5.real
    output [15:0] csr_diagram_2_5_real_out,
    // diagram_2_5.imag
    output [15:0] csr_diagram_2_5_imag_out,

    // diagram_2_6.real
    output [15:0] csr_diagram_2_6_real_out,
    // diagram_2_6.imag
    output [15:0] csr_diagram_2_6_imag_out,

    // diagram_2_7.real
    output [15:0] csr_diagram_2_7_real_out,
    // diagram_2_7.imag
    output [15:0] csr_diagram_2_7_imag_out,

    // diagram_3_0.real
    output [15:0] csr_diagram_3_0_real_out,
    // diagram_3_0.imag
    output [15:0] csr_diagram_3_0_imag_out,

    // diagram_3_1.real
    output [15:0] csr_diagram_3_1_real_out,
    // diagram_3_1.imag
    output [15:0] csr_diagram_3_1_imag_out,

    // diagram_3_2.real
    output [15:0] csr_diagram_3_2_real_out,
    // diagram_3_2.imag
    output [15:0] csr_diagram_3_2_imag_out,

    // diagram_3_3.real
    output [15:0] csr_diagram_3_3_real_out,
    // diagram_3_3.imag
    output [15:0] csr_diagram_3_3_imag_out,

    // diagram_3_4.real
    output [15:0] csr_diagram_3_4_real_out,
    // diagram_3_4.imag
    output [15:0] csr_diagram_3_4_imag_out,

    // diagram_3_5.real
    output [15:0] csr_diagram_3_5_real_out,
    // diagram_3_5.imag
    output [15:0] csr_diagram_3_5_imag_out,

    // diagram_3_6.real
    output [15:0] csr_diagram_3_6_real_out,
    // diagram_3_6.imag
    output [15:0] csr_diagram_3_6_imag_out,

    // diagram_3_7.real
    output [15:0] csr_diagram_3_7_real_out,
    // diagram_3_7.imag
    output [15:0] csr_diagram_3_7_imag_out,

    // diagram_4_0.real
    output [15:0] csr_diagram_4_0_real_out,
    // diagram_4_0.imag
    output [15:0] csr_diagram_4_0_imag_out,

    // diagram_4_1.real
    output [15:0] csr_diagram_4_1_real_out,
    // diagram_4_1.imag
    output [15:0] csr_diagram_4_1_imag_out,

    // diagram_4_2.real
    output [15:0] csr_diagram_4_2_real_out,
    // diagram_4_2.imag
    output [15:0] csr_diagram_4_2_imag_out,

    // diagram_4_3.real
    output [15:0] csr_diagram_4_3_real_out,
    // diagram_4_3.imag
    output [15:0] csr_diagram_4_3_imag_out,

    // diagram_4_4.real
    output [15:0] csr_diagram_4_4_real_out,
    // diagram_4_4.imag
    output [15:0] csr_diagram_4_4_imag_out,

    // diagram_4_5.real
    output [15:0] csr_diagram_4_5_real_out,
    // diagram_4_5.imag
    output [15:0] csr_diagram_4_5_imag_out,

    // diagram_4_6.real
    output [15:0] csr_diagram_4_6_real_out,
    // diagram_4_6.imag
    output [15:0] csr_diagram_4_6_imag_out,

    // diagram_4_7.real
    output [15:0] csr_diagram_4_7_real_out,
    // diagram_4_7.imag
    output [15:0] csr_diagram_4_7_imag_out,

    // diagram_5_0.real
    output [15:0] csr_diagram_5_0_real_out,
    // diagram_5_0.imag
    output [15:0] csr_diagram_5_0_imag_out,

    // diagram_5_1.real
    output [15:0] csr_diagram_5_1_real_out,
    // diagram_5_1.imag
    output [15:0] csr_diagram_5_1_imag_out,

    // diagram_5_2.real
    output [15:0] csr_diagram_5_2_real_out,
    // diagram_5_2.imag
    output [15:0] csr_diagram_5_2_imag_out,

    // diagram_5_3.real
    output [15:0] csr_diagram_5_3_real_out,
    // diagram_5_3.imag
    output [15:0] csr_diagram_5_3_imag_out,

    // diagram_5_4.real
    output [15:0] csr_diagram_5_4_real_out,
    // diagram_5_4.imag
    output [15:0] csr_diagram_5_4_imag_out,

    // diagram_5_5.real
    output [15:0] csr_diagram_5_5_real_out,
    // diagram_5_5.imag
    output [15:0] csr_diagram_5_5_imag_out,

    // diagram_5_6.real
    output [15:0] csr_diagram_5_6_real_out,
    // diagram_5_6.imag
    output [15:0] csr_diagram_5_6_imag_out,

    // diagram_5_7.real
    output [15:0] csr_diagram_5_7_real_out,
    // diagram_5_7.imag
    output [15:0] csr_diagram_5_7_imag_out,

    // diagram_6_0.real
    output [15:0] csr_diagram_6_0_real_out,
    // diagram_6_0.imag
    output [15:0] csr_diagram_6_0_imag_out,

    // diagram_6_1.real
    output [15:0] csr_diagram_6_1_real_out,
    // diagram_6_1.imag
    output [15:0] csr_diagram_6_1_imag_out,

    // diagram_6_2.real
    output [15:0] csr_diagram_6_2_real_out,
    // diagram_6_2.imag
    output [15:0] csr_diagram_6_2_imag_out,

    // diagram_6_3.real
    output [15:0] csr_diagram_6_3_real_out,
    // diagram_6_3.imag
    output [15:0] csr_diagram_6_3_imag_out,

    // diagram_6_4.real
    output [15:0] csr_diagram_6_4_real_out,
    // diagram_6_4.imag
    output [15:0] csr_diagram_6_4_imag_out,

    // diagram_6_5.real
    output [15:0] csr_diagram_6_5_real_out,
    // diagram_6_5.imag
    output [15:0] csr_diagram_6_5_imag_out,

    // diagram_6_6.real
    output [15:0] csr_diagram_6_6_real_out,
    // diagram_6_6.imag
    output [15:0] csr_diagram_6_6_imag_out,

    // diagram_6_7.real
    output [15:0] csr_diagram_6_7_real_out,
    // diagram_6_7.imag
    output [15:0] csr_diagram_6_7_imag_out,

    // diagram_7_0.real
    output [15:0] csr_diagram_7_0_real_out,
    // diagram_7_0.imag
    output [15:0] csr_diagram_7_0_imag_out,

    // diagram_7_1.real
    output [15:0] csr_diagram_7_1_real_out,
    // diagram_7_1.imag
    output [15:0] csr_diagram_7_1_imag_out,

    // diagram_7_2.real
    output [15:0] csr_diagram_7_2_real_out,
    // diagram_7_2.imag
    output [15:0] csr_diagram_7_2_imag_out,

    // diagram_7_3.real
    output [15:0] csr_diagram_7_3_real_out,
    // diagram_7_3.imag
    output [15:0] csr_diagram_7_3_imag_out,

    // diagram_7_4.real
    output [15:0] csr_diagram_7_4_real_out,
    // diagram_7_4.imag
    output [15:0] csr_diagram_7_4_imag_out,

    // diagram_7_5.real
    output [15:0] csr_diagram_7_5_real_out,
    // diagram_7_5.imag
    output [15:0] csr_diagram_7_5_imag_out,

    // diagram_7_6.real
    output [15:0] csr_diagram_7_6_real_out,
    // diagram_7_6.imag
    output [15:0] csr_diagram_7_6_imag_out,

    // diagram_7_7.real
    output [15:0] csr_diagram_7_7_real_out,
    // diagram_7_7.imag
    output [15:0] csr_diagram_7_7_imag_out,

    // motion_selector.filter
    output [7:0] csr_motion_selector_filter_out,
    // motion_selector.onoff
    output  csr_motion_selector_onoff_out,

    // diagram_angle_0.angle
    output [31:0] csr_diagram_angle_0_angle_out,

    // diagram_angle_1.angle
    output [31:0] csr_diagram_angle_1_angle_out,

    // diagram_angle_2.angle
    output [31:0] csr_diagram_angle_2_angle_out,

    // diagram_angle_3.angle
    output [31:0] csr_diagram_angle_3_angle_out,

    // diagram_angle_4.angle
    output [31:0] csr_diagram_angle_4_angle_out,

    // diagram_angle_5.angle
    output [31:0] csr_diagram_angle_5_angle_out,

    // diagram_angle_6.angle
    output [31:0] csr_diagram_angle_6_angle_out,

    // diagram_angle_7.angle
    output [31:0] csr_diagram_angle_7_angle_out,

    // output_source.source
    output [15:0] csr_output_source_source_out,
    // output_source.source_channel
    output [15:0] csr_output_source_source_channel_out,

    // apu_rank.rank
    output [7:0] csr_apu_rank_rank_out,
    // apu_rank.window
    output [7:0] csr_apu_rank_window_out,

    // detector_level_0.level
    output [31:0] csr_detector_level_0_level_out,

    // detector_level_1.level
    output [31:0] csr_detector_level_1_level_out,

    // azimuth_angle.angle
    output [31:0] csr_azimuth_angle_angle_out,

    // apply.apply
    output  csr_apply_apply_out,

    // compensation_reference.real
    output [15:0] csr_compensation_reference_real_out,

    // AXI
    input  [ADDR_W-1:0] axil_awaddr,
    input  [2:0]        axil_awprot,
    input               axil_awvalid,
    output              axil_awready,
    input  [DATA_W-1:0] axil_wdata,
    input  [STRB_W-1:0] axil_wstrb,
    input               axil_wvalid,
    output              axil_wready,
    output [1:0]        axil_bresp,
    output              axil_bvalid,
    input               axil_bready,

    input  [ADDR_W-1:0] axil_araddr,
    input  [2:0]        axil_arprot,
    input               axil_arvalid,
    output              axil_arready,
    output [DATA_W-1:0] axil_rdata,
    output [1:0]        axil_rresp,
    output              axil_rvalid,
    input               axil_rready
);
wire              wready;
wire [ADDR_W-1:0] waddr;
wire [DATA_W-1:0] wdata;
wire              wen;
wire [STRB_W-1:0] wstrb;
wire [DATA_W-1:0] rdata;
wire              rvalid;
wire [ADDR_W-1:0] raddr;
wire              ren;
    reg [ADDR_W-1:0] waddr_int;
    reg [ADDR_W-1:0] raddr_int;
    reg [DATA_W-1:0] wdata_int;
    reg [STRB_W-1:0] strb_int;
    reg              awflag;
    reg              wflag;
    reg              arflag;
    reg              rflag;

    reg              axil_bvalid_int;
    reg [DATA_W-1:0] axil_rdata_int;
    reg              axil_rvalid_int;

    assign axil_awready = ~awflag;
    assign axil_wready  = ~wflag;
    assign axil_bvalid  = axil_bvalid_int;
    assign waddr        = waddr_int;
    assign wdata        = wdata_int;
    assign wstrb        = strb_int;
    assign wen          = awflag && wflag;
    assign axil_bresp   = 'd0; // always okay

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            waddr_int       <= 'd0;
            wdata_int       <= 'd0;
            strb_int        <= 'd0;
            awflag          <= 1'b0;
            wflag           <= 1'b0;
            axil_bvalid_int <= 1'b0;
        end else begin
            if (axil_awvalid == 1'b1 && awflag == 1'b0) begin
                awflag    <= 1'b1;
                waddr_int <= axil_awaddr;
            end else if (wen == 1'b1 && wready == 1'b1) begin
                awflag    <= 1'b0;
            end

            if (axil_wvalid == 1'b1 && wflag == 1'b0) begin
                wflag     <= 1'b1;
                wdata_int <= axil_wdata;
                strb_int  <= axil_wstrb;
            end else if (wen == 1'b1 && wready == 1'b1) begin
                wflag     <= 1'b0;
            end

            if (axil_bvalid_int == 1'b1 && axil_bready == 1'b1) begin
                axil_bvalid_int <= 1'b0;
            end else if ((axil_wvalid == 1'b1 && awflag == 1'b1) || (axil_awvalid == 1'b1 && wflag == 1'b1) || (wflag == 1'b1 && awflag == 1'b1)) begin
                axil_bvalid_int <= wready;
            end
        end
    end

    assign axil_arready = ~arflag;
    assign axil_rdata   = axil_rdata_int;
    assign axil_rvalid  = axil_rvalid_int;
    assign raddr        = raddr_int;
    assign ren          = arflag && ~rflag;
    assign axil_rresp   = 'd0; // always okay

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            raddr_int       <= 'd0;
            arflag          <= 1'b0;
            rflag           <= 1'b0;
            axil_rdata_int  <= 'd0;
            axil_rvalid_int <= 1'b0;
        end else begin
            if (axil_arvalid == 1'b1 && arflag == 1'b0) begin
                arflag    <= 1'b1;
                raddr_int <= axil_araddr;
            end else if (axil_rvalid_int == 1'b1 && axil_rready == 1'b1) begin
                arflag    <= 1'b0;
            end

            if (rvalid == 1'b1 && ren == 1'b1 && rflag == 1'b0) begin
                rflag <= 1'b1;
            end else if (axil_rvalid_int == 1'b1 && axil_rready == 1'b1) begin
                rflag <= 1'b0;
            end

            if (rvalid == 1'b1 && axil_rvalid_int == 1'b0) begin
                axil_rdata_int  <= rdata;
                axil_rvalid_int <= 1'b1;
            end else if (axil_rvalid_int == 1'b1 && axil_rready == 1'b1) begin
                axil_rvalid_int <= 1'b0;
            end
        end
    end

//------------------------------------------------------------------------------
// CSR:
// [0x0] - ip_ver - IP version
//------------------------------------------------------------------------------
wire [31:0] csr_ip_ver_rdata;


wire csr_ip_ver_ren;
assign csr_ip_ver_ren = ren && (raddr == 11'h0);
reg csr_ip_ver_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_ip_ver_ren_ff <= 1'b0;
    end else begin
        csr_ip_ver_ren_ff <= csr_ip_ver_ren;
    end
end
//---------------------
// Bit field:
// ip_ver[15:0] - min_ver - Minor IP version
// access: ro, hardware: f
//---------------------
reg [15:0] csr_ip_ver_min_ver_ff;

assign csr_ip_ver_rdata[15:0] = csr_ip_ver_min_ver_ff;


always @(posedge clk) begin
    if (!rst) begin
        csr_ip_ver_min_ver_ff <= 16'h0;
    end else  begin
      begin
            csr_ip_ver_min_ver_ff <= csr_ip_ver_min_ver_ff;
        end
    end
end


//---------------------
// Bit field:
// ip_ver[31:16] - maj_ver - Major IP version
// access: ro, hardware: f
//---------------------
reg [15:0] csr_ip_ver_maj_ver_ff;

assign csr_ip_ver_rdata[31:16] = csr_ip_ver_maj_ver_ff;


always @(posedge clk) begin
    if (!rst) begin
        csr_ip_ver_maj_ver_ff <= 16'h2;
    end else  begin
      begin
            csr_ip_ver_maj_ver_ff <= csr_ip_ver_maj_ver_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x4] - kill - Synchronous reset register
//------------------------------------------------------------------------------
wire [31:0] csr_kill_rdata;
assign csr_kill_rdata[31:1] = 31'h0;

wire csr_kill_wen;
assign csr_kill_wen = wen && (waddr == 11'h4);

wire csr_kill_ren;
assign csr_kill_ren = ren && (raddr == 11'h4);
reg csr_kill_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_kill_ren_ff <= 1'b0;
    end else begin
        csr_kill_ren_ff <= csr_kill_ren;
    end
end
//---------------------
// Bit field:
// kill[0] - kill - Kill
// access: rw, hardware: o
//---------------------
reg  csr_kill_kill_ff;

assign csr_kill_rdata[0] = csr_kill_kill_ff;

assign csr_kill_kill_out = csr_kill_kill_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_kill_kill_ff <= 1'b0;
        o_reset <= 0;
    end else  begin
     if (csr_kill_wen) begin
            if (wstrb[0]) begin
                csr_kill_kill_ff <= wdata[0];
                o_reset <= 1;
            end
        end else begin
            csr_kill_kill_ff <= csr_kill_kill_ff;
            o_reset <= 0;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x8] - test_point - Test point control register
//------------------------------------------------------------------------------
wire [31:0] csr_test_point_rdata;
assign csr_test_point_rdata[31:3] = 29'h0;

wire csr_test_point_wen;
assign csr_test_point_wen = wen && (waddr == 11'h8);

wire csr_test_point_ren;
assign csr_test_point_ren = ren && (raddr == 11'h8);
reg csr_test_point_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_test_point_ren_ff <= 1'b0;
    end else begin
        csr_test_point_ren_ff <= csr_test_point_ren;
    end
end
//---------------------
// Bit field:
// test_point[2:0] - test_point - Test point
// access: rw, hardware: o
//---------------------
reg [2:0] csr_test_point_test_point_ff;

assign csr_test_point_rdata[2:0] = csr_test_point_test_point_ff;

assign csr_test_point_test_point_out = csr_test_point_test_point_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_test_point_test_point_ff <= 3'h0;
    end else  begin
     if (csr_test_point_wen) begin
            if (wstrb[0]) begin
                csr_test_point_test_point_ff[2:0] <= wdata[2:0];
            end
        end else begin
            csr_test_point_test_point_ff <= csr_test_point_test_point_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xc] - channel - Output channel control register
//------------------------------------------------------------------------------
wire [31:0] csr_channel_rdata;
assign csr_channel_rdata[31:3] = 29'h0;

wire csr_channel_wen;
assign csr_channel_wen = wen && (waddr == 11'hc);

wire csr_channel_ren;
assign csr_channel_ren = ren && (raddr == 11'hc);
reg csr_channel_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_channel_ren_ff <= 1'b0;
    end else begin
        csr_channel_ren_ff <= csr_channel_ren;
    end
end
//---------------------
// Bit field:
// channel[2:0] - test_point - Test point
// access: rw, hardware: o
//---------------------
reg [2:0] csr_channel_test_point_ff;

assign csr_channel_rdata[2:0] = csr_channel_test_point_ff;

assign csr_channel_test_point_out = csr_channel_test_point_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_channel_test_point_ff <= 3'h0;
    end else  begin
     if (csr_channel_wen) begin
            if (wstrb[0]) begin
                csr_channel_test_point_ff[2:0] <= wdata[2:0];
            end
        end else begin
            csr_channel_test_point_ff <= csr_channel_test_point_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x10] - compensation_mode - 
//------------------------------------------------------------------------------
wire [31:0] csr_compensation_mode_rdata;

wire csr_compensation_mode_wen;
assign csr_compensation_mode_wen = wen && (waddr == 11'h10);

wire csr_compensation_mode_ren;
assign csr_compensation_mode_ren = ren && (raddr == 11'h10);
reg csr_compensation_mode_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_compensation_mode_ren_ff <= 1'b0;
    end else begin
        csr_compensation_mode_ren_ff <= csr_compensation_mode_ren;
    end
end
//---------------------
// Bit field:
// compensation_mode[31:0] - mode - Compensation mode
// access: rw, hardware: o
//---------------------
reg [31:0] csr_compensation_mode_mode_ff;

assign csr_compensation_mode_rdata[31:0] = csr_compensation_mode_mode_ff;

assign csr_compensation_mode_mode_out = csr_compensation_mode_mode_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_compensation_mode_mode_ff <= 32'h0;
    end else  begin
     if (csr_compensation_mode_wen) begin
            if (wstrb[0]) begin
                csr_compensation_mode_mode_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_compensation_mode_mode_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_compensation_mode_mode_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_compensation_mode_mode_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_compensation_mode_mode_ff <= csr_compensation_mode_mode_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x14] - manual_compensation_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_manual_compensation_0_rdata;

wire csr_manual_compensation_0_wen;
assign csr_manual_compensation_0_wen = wen && (waddr == 11'h14);

wire csr_manual_compensation_0_ren;
assign csr_manual_compensation_0_ren = ren && (raddr == 11'h14);
reg csr_manual_compensation_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_0_ren_ff <= 1'b0;
    end else begin
        csr_manual_compensation_0_ren_ff <= csr_manual_compensation_0_ren;
    end
end
//---------------------
// Bit field:
// manual_compensation_0[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_0_real_ff;

assign csr_manual_compensation_0_rdata[15:0] = csr_manual_compensation_0_real_ff;

assign csr_manual_compensation_0_real_out = csr_manual_compensation_0_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_0_real_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_0_wen) begin
            if (wstrb[0]) begin
                csr_manual_compensation_0_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_manual_compensation_0_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_manual_compensation_0_real_ff <= csr_manual_compensation_0_real_ff;
        end
    end
end


//---------------------
// Bit field:
// manual_compensation_0[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_0_imag_ff;

assign csr_manual_compensation_0_rdata[31:16] = csr_manual_compensation_0_imag_ff;

assign csr_manual_compensation_0_imag_out = csr_manual_compensation_0_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_0_imag_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_0_wen) begin
            if (wstrb[2]) begin
                csr_manual_compensation_0_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_manual_compensation_0_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_manual_compensation_0_imag_ff <= csr_manual_compensation_0_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x18] - manual_compensation_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_manual_compensation_1_rdata;

wire csr_manual_compensation_1_wen;
assign csr_manual_compensation_1_wen = wen && (waddr == 11'h18);

wire csr_manual_compensation_1_ren;
assign csr_manual_compensation_1_ren = ren && (raddr == 11'h18);
reg csr_manual_compensation_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_1_ren_ff <= 1'b0;
    end else begin
        csr_manual_compensation_1_ren_ff <= csr_manual_compensation_1_ren;
    end
end
//---------------------
// Bit field:
// manual_compensation_1[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_1_real_ff;

assign csr_manual_compensation_1_rdata[15:0] = csr_manual_compensation_1_real_ff;

assign csr_manual_compensation_1_real_out = csr_manual_compensation_1_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_1_real_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_1_wen) begin
            if (wstrb[0]) begin
                csr_manual_compensation_1_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_manual_compensation_1_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_manual_compensation_1_real_ff <= csr_manual_compensation_1_real_ff;
        end
    end
end


//---------------------
// Bit field:
// manual_compensation_1[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_1_imag_ff;

assign csr_manual_compensation_1_rdata[31:16] = csr_manual_compensation_1_imag_ff;

assign csr_manual_compensation_1_imag_out = csr_manual_compensation_1_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_1_imag_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_1_wen) begin
            if (wstrb[2]) begin
                csr_manual_compensation_1_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_manual_compensation_1_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_manual_compensation_1_imag_ff <= csr_manual_compensation_1_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x1c] - manual_compensation_2 - 
//------------------------------------------------------------------------------
wire [31:0] csr_manual_compensation_2_rdata;

wire csr_manual_compensation_2_wen;
assign csr_manual_compensation_2_wen = wen && (waddr == 11'h1c);

wire csr_manual_compensation_2_ren;
assign csr_manual_compensation_2_ren = ren && (raddr == 11'h1c);
reg csr_manual_compensation_2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_2_ren_ff <= 1'b0;
    end else begin
        csr_manual_compensation_2_ren_ff <= csr_manual_compensation_2_ren;
    end
end
//---------------------
// Bit field:
// manual_compensation_2[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_2_real_ff;

assign csr_manual_compensation_2_rdata[15:0] = csr_manual_compensation_2_real_ff;

assign csr_manual_compensation_2_real_out = csr_manual_compensation_2_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_2_real_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_2_wen) begin
            if (wstrb[0]) begin
                csr_manual_compensation_2_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_manual_compensation_2_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_manual_compensation_2_real_ff <= csr_manual_compensation_2_real_ff;
        end
    end
end


//---------------------
// Bit field:
// manual_compensation_2[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_2_imag_ff;

assign csr_manual_compensation_2_rdata[31:16] = csr_manual_compensation_2_imag_ff;

assign csr_manual_compensation_2_imag_out = csr_manual_compensation_2_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_2_imag_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_2_wen) begin
            if (wstrb[2]) begin
                csr_manual_compensation_2_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_manual_compensation_2_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_manual_compensation_2_imag_ff <= csr_manual_compensation_2_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x20] - manual_compensation_3 - 
//------------------------------------------------------------------------------
wire [31:0] csr_manual_compensation_3_rdata;

wire csr_manual_compensation_3_wen;
assign csr_manual_compensation_3_wen = wen && (waddr == 11'h20);

wire csr_manual_compensation_3_ren;
assign csr_manual_compensation_3_ren = ren && (raddr == 11'h20);
reg csr_manual_compensation_3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_3_ren_ff <= 1'b0;
    end else begin
        csr_manual_compensation_3_ren_ff <= csr_manual_compensation_3_ren;
    end
end
//---------------------
// Bit field:
// manual_compensation_3[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_3_real_ff;

assign csr_manual_compensation_3_rdata[15:0] = csr_manual_compensation_3_real_ff;

assign csr_manual_compensation_3_real_out = csr_manual_compensation_3_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_3_real_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_3_wen) begin
            if (wstrb[0]) begin
                csr_manual_compensation_3_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_manual_compensation_3_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_manual_compensation_3_real_ff <= csr_manual_compensation_3_real_ff;
        end
    end
end


//---------------------
// Bit field:
// manual_compensation_3[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_3_imag_ff;

assign csr_manual_compensation_3_rdata[31:16] = csr_manual_compensation_3_imag_ff;

assign csr_manual_compensation_3_imag_out = csr_manual_compensation_3_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_3_imag_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_3_wen) begin
            if (wstrb[2]) begin
                csr_manual_compensation_3_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_manual_compensation_3_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_manual_compensation_3_imag_ff <= csr_manual_compensation_3_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x24] - manual_compensation_4 - 
//------------------------------------------------------------------------------
wire [31:0] csr_manual_compensation_4_rdata;

wire csr_manual_compensation_4_wen;
assign csr_manual_compensation_4_wen = wen && (waddr == 11'h24);

wire csr_manual_compensation_4_ren;
assign csr_manual_compensation_4_ren = ren && (raddr == 11'h24);
reg csr_manual_compensation_4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_4_ren_ff <= 1'b0;
    end else begin
        csr_manual_compensation_4_ren_ff <= csr_manual_compensation_4_ren;
    end
end
//---------------------
// Bit field:
// manual_compensation_4[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_4_real_ff;

assign csr_manual_compensation_4_rdata[15:0] = csr_manual_compensation_4_real_ff;

assign csr_manual_compensation_4_real_out = csr_manual_compensation_4_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_4_real_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_4_wen) begin
            if (wstrb[0]) begin
                csr_manual_compensation_4_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_manual_compensation_4_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_manual_compensation_4_real_ff <= csr_manual_compensation_4_real_ff;
        end
    end
end


//---------------------
// Bit field:
// manual_compensation_4[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_4_imag_ff;

assign csr_manual_compensation_4_rdata[31:16] = csr_manual_compensation_4_imag_ff;

assign csr_manual_compensation_4_imag_out = csr_manual_compensation_4_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_4_imag_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_4_wen) begin
            if (wstrb[2]) begin
                csr_manual_compensation_4_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_manual_compensation_4_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_manual_compensation_4_imag_ff <= csr_manual_compensation_4_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x28] - manual_compensation_5 - 
//------------------------------------------------------------------------------
wire [31:0] csr_manual_compensation_5_rdata;

wire csr_manual_compensation_5_wen;
assign csr_manual_compensation_5_wen = wen && (waddr == 11'h28);

wire csr_manual_compensation_5_ren;
assign csr_manual_compensation_5_ren = ren && (raddr == 11'h28);
reg csr_manual_compensation_5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_5_ren_ff <= 1'b0;
    end else begin
        csr_manual_compensation_5_ren_ff <= csr_manual_compensation_5_ren;
    end
end
//---------------------
// Bit field:
// manual_compensation_5[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_5_real_ff;

assign csr_manual_compensation_5_rdata[15:0] = csr_manual_compensation_5_real_ff;

assign csr_manual_compensation_5_real_out = csr_manual_compensation_5_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_5_real_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_5_wen) begin
            if (wstrb[0]) begin
                csr_manual_compensation_5_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_manual_compensation_5_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_manual_compensation_5_real_ff <= csr_manual_compensation_5_real_ff;
        end
    end
end


//---------------------
// Bit field:
// manual_compensation_5[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_5_imag_ff;

assign csr_manual_compensation_5_rdata[31:16] = csr_manual_compensation_5_imag_ff;

assign csr_manual_compensation_5_imag_out = csr_manual_compensation_5_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_5_imag_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_5_wen) begin
            if (wstrb[2]) begin
                csr_manual_compensation_5_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_manual_compensation_5_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_manual_compensation_5_imag_ff <= csr_manual_compensation_5_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x2c] - manual_compensation_6 - 
//------------------------------------------------------------------------------
wire [31:0] csr_manual_compensation_6_rdata;

wire csr_manual_compensation_6_wen;
assign csr_manual_compensation_6_wen = wen && (waddr == 11'h2c);

wire csr_manual_compensation_6_ren;
assign csr_manual_compensation_6_ren = ren && (raddr == 11'h2c);
reg csr_manual_compensation_6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_6_ren_ff <= 1'b0;
    end else begin
        csr_manual_compensation_6_ren_ff <= csr_manual_compensation_6_ren;
    end
end
//---------------------
// Bit field:
// manual_compensation_6[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_6_real_ff;

assign csr_manual_compensation_6_rdata[15:0] = csr_manual_compensation_6_real_ff;

assign csr_manual_compensation_6_real_out = csr_manual_compensation_6_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_6_real_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_6_wen) begin
            if (wstrb[0]) begin
                csr_manual_compensation_6_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_manual_compensation_6_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_manual_compensation_6_real_ff <= csr_manual_compensation_6_real_ff;
        end
    end
end


//---------------------
// Bit field:
// manual_compensation_6[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_6_imag_ff;

assign csr_manual_compensation_6_rdata[31:16] = csr_manual_compensation_6_imag_ff;

assign csr_manual_compensation_6_imag_out = csr_manual_compensation_6_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_6_imag_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_6_wen) begin
            if (wstrb[2]) begin
                csr_manual_compensation_6_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_manual_compensation_6_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_manual_compensation_6_imag_ff <= csr_manual_compensation_6_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x30] - manual_compensation_7 - 
//------------------------------------------------------------------------------
wire [31:0] csr_manual_compensation_7_rdata;

wire csr_manual_compensation_7_wen;
assign csr_manual_compensation_7_wen = wen && (waddr == 11'h30);

wire csr_manual_compensation_7_ren;
assign csr_manual_compensation_7_ren = ren && (raddr == 11'h30);
reg csr_manual_compensation_7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_7_ren_ff <= 1'b0;
    end else begin
        csr_manual_compensation_7_ren_ff <= csr_manual_compensation_7_ren;
    end
end
//---------------------
// Bit field:
// manual_compensation_7[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_7_real_ff;

assign csr_manual_compensation_7_rdata[15:0] = csr_manual_compensation_7_real_ff;

assign csr_manual_compensation_7_real_out = csr_manual_compensation_7_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_7_real_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_7_wen) begin
            if (wstrb[0]) begin
                csr_manual_compensation_7_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_manual_compensation_7_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_manual_compensation_7_real_ff <= csr_manual_compensation_7_real_ff;
        end
    end
end


//---------------------
// Bit field:
// manual_compensation_7[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_manual_compensation_7_imag_ff;

assign csr_manual_compensation_7_rdata[31:16] = csr_manual_compensation_7_imag_ff;

assign csr_manual_compensation_7_imag_out = csr_manual_compensation_7_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_manual_compensation_7_imag_ff <= 16'h0;
    end else  begin
     if (csr_manual_compensation_7_wen) begin
            if (wstrb[2]) begin
                csr_manual_compensation_7_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_manual_compensation_7_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_manual_compensation_7_imag_ff <= csr_manual_compensation_7_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x34] - diagram_0_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_0_0_rdata;

wire csr_diagram_0_0_wen;
assign csr_diagram_0_0_wen = wen && (waddr == 11'h34);

wire csr_diagram_0_0_ren;
assign csr_diagram_0_0_ren = ren && (raddr == 11'h34);
reg csr_diagram_0_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_0_ren_ff <= 1'b0;
    end else begin
        csr_diagram_0_0_ren_ff <= csr_diagram_0_0_ren;
    end
end
//---------------------
// Bit field:
// diagram_0_0[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_0_real_ff;

assign csr_diagram_0_0_rdata[15:0] = csr_diagram_0_0_real_ff;

assign csr_diagram_0_0_real_out = csr_diagram_0_0_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_0_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_0_wen) begin
            if (wstrb[0]) begin
                csr_diagram_0_0_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_0_0_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_0_0_real_ff <= csr_diagram_0_0_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_0_0[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_0_imag_ff;

assign csr_diagram_0_0_rdata[31:16] = csr_diagram_0_0_imag_ff;

assign csr_diagram_0_0_imag_out = csr_diagram_0_0_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_0_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_0_wen) begin
            if (wstrb[2]) begin
                csr_diagram_0_0_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_0_0_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_0_0_imag_ff <= csr_diagram_0_0_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x38] - diagram_0_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_0_1_rdata;

wire csr_diagram_0_1_wen;
assign csr_diagram_0_1_wen = wen && (waddr == 11'h38);

wire csr_diagram_0_1_ren;
assign csr_diagram_0_1_ren = ren && (raddr == 11'h38);
reg csr_diagram_0_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_1_ren_ff <= 1'b0;
    end else begin
        csr_diagram_0_1_ren_ff <= csr_diagram_0_1_ren;
    end
end
//---------------------
// Bit field:
// diagram_0_1[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_1_real_ff;

assign csr_diagram_0_1_rdata[15:0] = csr_diagram_0_1_real_ff;

assign csr_diagram_0_1_real_out = csr_diagram_0_1_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_1_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_1_wen) begin
            if (wstrb[0]) begin
                csr_diagram_0_1_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_0_1_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_0_1_real_ff <= csr_diagram_0_1_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_0_1[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_1_imag_ff;

assign csr_diagram_0_1_rdata[31:16] = csr_diagram_0_1_imag_ff;

assign csr_diagram_0_1_imag_out = csr_diagram_0_1_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_1_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_1_wen) begin
            if (wstrb[2]) begin
                csr_diagram_0_1_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_0_1_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_0_1_imag_ff <= csr_diagram_0_1_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x3c] - diagram_0_2 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_0_2_rdata;

wire csr_diagram_0_2_wen;
assign csr_diagram_0_2_wen = wen && (waddr == 11'h3c);

wire csr_diagram_0_2_ren;
assign csr_diagram_0_2_ren = ren && (raddr == 11'h3c);
reg csr_diagram_0_2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_2_ren_ff <= 1'b0;
    end else begin
        csr_diagram_0_2_ren_ff <= csr_diagram_0_2_ren;
    end
end
//---------------------
// Bit field:
// diagram_0_2[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_2_real_ff;

assign csr_diagram_0_2_rdata[15:0] = csr_diagram_0_2_real_ff;

assign csr_diagram_0_2_real_out = csr_diagram_0_2_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_2_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_2_wen) begin
            if (wstrb[0]) begin
                csr_diagram_0_2_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_0_2_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_0_2_real_ff <= csr_diagram_0_2_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_0_2[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_2_imag_ff;

assign csr_diagram_0_2_rdata[31:16] = csr_diagram_0_2_imag_ff;

assign csr_diagram_0_2_imag_out = csr_diagram_0_2_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_2_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_2_wen) begin
            if (wstrb[2]) begin
                csr_diagram_0_2_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_0_2_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_0_2_imag_ff <= csr_diagram_0_2_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x40] - diagram_0_3 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_0_3_rdata;

wire csr_diagram_0_3_wen;
assign csr_diagram_0_3_wen = wen && (waddr == 11'h40);

wire csr_diagram_0_3_ren;
assign csr_diagram_0_3_ren = ren && (raddr == 11'h40);
reg csr_diagram_0_3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_3_ren_ff <= 1'b0;
    end else begin
        csr_diagram_0_3_ren_ff <= csr_diagram_0_3_ren;
    end
end
//---------------------
// Bit field:
// diagram_0_3[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_3_real_ff;

assign csr_diagram_0_3_rdata[15:0] = csr_diagram_0_3_real_ff;

assign csr_diagram_0_3_real_out = csr_diagram_0_3_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_3_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_3_wen) begin
            if (wstrb[0]) begin
                csr_diagram_0_3_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_0_3_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_0_3_real_ff <= csr_diagram_0_3_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_0_3[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_3_imag_ff;

assign csr_diagram_0_3_rdata[31:16] = csr_diagram_0_3_imag_ff;

assign csr_diagram_0_3_imag_out = csr_diagram_0_3_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_3_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_3_wen) begin
            if (wstrb[2]) begin
                csr_diagram_0_3_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_0_3_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_0_3_imag_ff <= csr_diagram_0_3_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x44] - diagram_0_4 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_0_4_rdata;

wire csr_diagram_0_4_wen;
assign csr_diagram_0_4_wen = wen && (waddr == 11'h44);

wire csr_diagram_0_4_ren;
assign csr_diagram_0_4_ren = ren && (raddr == 11'h44);
reg csr_diagram_0_4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_4_ren_ff <= 1'b0;
    end else begin
        csr_diagram_0_4_ren_ff <= csr_diagram_0_4_ren;
    end
end
//---------------------
// Bit field:
// diagram_0_4[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_4_real_ff;

assign csr_diagram_0_4_rdata[15:0] = csr_diagram_0_4_real_ff;

assign csr_diagram_0_4_real_out = csr_diagram_0_4_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_4_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_4_wen) begin
            if (wstrb[0]) begin
                csr_diagram_0_4_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_0_4_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_0_4_real_ff <= csr_diagram_0_4_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_0_4[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_4_imag_ff;

assign csr_diagram_0_4_rdata[31:16] = csr_diagram_0_4_imag_ff;

assign csr_diagram_0_4_imag_out = csr_diagram_0_4_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_4_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_4_wen) begin
            if (wstrb[2]) begin
                csr_diagram_0_4_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_0_4_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_0_4_imag_ff <= csr_diagram_0_4_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x48] - diagram_0_5 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_0_5_rdata;

wire csr_diagram_0_5_wen;
assign csr_diagram_0_5_wen = wen && (waddr == 11'h48);

wire csr_diagram_0_5_ren;
assign csr_diagram_0_5_ren = ren && (raddr == 11'h48);
reg csr_diagram_0_5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_5_ren_ff <= 1'b0;
    end else begin
        csr_diagram_0_5_ren_ff <= csr_diagram_0_5_ren;
    end
end
//---------------------
// Bit field:
// diagram_0_5[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_5_real_ff;

assign csr_diagram_0_5_rdata[15:0] = csr_diagram_0_5_real_ff;

assign csr_diagram_0_5_real_out = csr_diagram_0_5_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_5_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_5_wen) begin
            if (wstrb[0]) begin
                csr_diagram_0_5_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_0_5_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_0_5_real_ff <= csr_diagram_0_5_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_0_5[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_5_imag_ff;

assign csr_diagram_0_5_rdata[31:16] = csr_diagram_0_5_imag_ff;

assign csr_diagram_0_5_imag_out = csr_diagram_0_5_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_5_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_5_wen) begin
            if (wstrb[2]) begin
                csr_diagram_0_5_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_0_5_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_0_5_imag_ff <= csr_diagram_0_5_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x4c] - diagram_0_6 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_0_6_rdata;

wire csr_diagram_0_6_wen;
assign csr_diagram_0_6_wen = wen && (waddr == 11'h4c);

wire csr_diagram_0_6_ren;
assign csr_diagram_0_6_ren = ren && (raddr == 11'h4c);
reg csr_diagram_0_6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_6_ren_ff <= 1'b0;
    end else begin
        csr_diagram_0_6_ren_ff <= csr_diagram_0_6_ren;
    end
end
//---------------------
// Bit field:
// diagram_0_6[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_6_real_ff;

assign csr_diagram_0_6_rdata[15:0] = csr_diagram_0_6_real_ff;

assign csr_diagram_0_6_real_out = csr_diagram_0_6_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_6_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_6_wen) begin
            if (wstrb[0]) begin
                csr_diagram_0_6_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_0_6_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_0_6_real_ff <= csr_diagram_0_6_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_0_6[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_6_imag_ff;

assign csr_diagram_0_6_rdata[31:16] = csr_diagram_0_6_imag_ff;

assign csr_diagram_0_6_imag_out = csr_diagram_0_6_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_6_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_6_wen) begin
            if (wstrb[2]) begin
                csr_diagram_0_6_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_0_6_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_0_6_imag_ff <= csr_diagram_0_6_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x50] - diagram_0_7 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_0_7_rdata;

wire csr_diagram_0_7_wen;
assign csr_diagram_0_7_wen = wen && (waddr == 11'h50);

wire csr_diagram_0_7_ren;
assign csr_diagram_0_7_ren = ren && (raddr == 11'h50);
reg csr_diagram_0_7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_7_ren_ff <= 1'b0;
    end else begin
        csr_diagram_0_7_ren_ff <= csr_diagram_0_7_ren;
    end
end
//---------------------
// Bit field:
// diagram_0_7[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_7_real_ff;

assign csr_diagram_0_7_rdata[15:0] = csr_diagram_0_7_real_ff;

assign csr_diagram_0_7_real_out = csr_diagram_0_7_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_7_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_7_wen) begin
            if (wstrb[0]) begin
                csr_diagram_0_7_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_0_7_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_0_7_real_ff <= csr_diagram_0_7_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_0_7[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_0_7_imag_ff;

assign csr_diagram_0_7_rdata[31:16] = csr_diagram_0_7_imag_ff;

assign csr_diagram_0_7_imag_out = csr_diagram_0_7_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_0_7_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_0_7_wen) begin
            if (wstrb[2]) begin
                csr_diagram_0_7_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_0_7_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_0_7_imag_ff <= csr_diagram_0_7_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x54] - diagram_1_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_1_0_rdata;

wire csr_diagram_1_0_wen;
assign csr_diagram_1_0_wen = wen && (waddr == 11'h54);

wire csr_diagram_1_0_ren;
assign csr_diagram_1_0_ren = ren && (raddr == 11'h54);
reg csr_diagram_1_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_0_ren_ff <= 1'b0;
    end else begin
        csr_diagram_1_0_ren_ff <= csr_diagram_1_0_ren;
    end
end
//---------------------
// Bit field:
// diagram_1_0[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_0_real_ff;

assign csr_diagram_1_0_rdata[15:0] = csr_diagram_1_0_real_ff;

assign csr_diagram_1_0_real_out = csr_diagram_1_0_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_0_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_0_wen) begin
            if (wstrb[0]) begin
                csr_diagram_1_0_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_1_0_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_1_0_real_ff <= csr_diagram_1_0_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_1_0[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_0_imag_ff;

assign csr_diagram_1_0_rdata[31:16] = csr_diagram_1_0_imag_ff;

assign csr_diagram_1_0_imag_out = csr_diagram_1_0_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_0_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_0_wen) begin
            if (wstrb[2]) begin
                csr_diagram_1_0_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_1_0_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_1_0_imag_ff <= csr_diagram_1_0_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x58] - diagram_1_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_1_1_rdata;

wire csr_diagram_1_1_wen;
assign csr_diagram_1_1_wen = wen && (waddr == 11'h58);

wire csr_diagram_1_1_ren;
assign csr_diagram_1_1_ren = ren && (raddr == 11'h58);
reg csr_diagram_1_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_1_ren_ff <= 1'b0;
    end else begin
        csr_diagram_1_1_ren_ff <= csr_diagram_1_1_ren;
    end
end
//---------------------
// Bit field:
// diagram_1_1[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_1_real_ff;

assign csr_diagram_1_1_rdata[15:0] = csr_diagram_1_1_real_ff;

assign csr_diagram_1_1_real_out = csr_diagram_1_1_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_1_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_1_wen) begin
            if (wstrb[0]) begin
                csr_diagram_1_1_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_1_1_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_1_1_real_ff <= csr_diagram_1_1_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_1_1[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_1_imag_ff;

assign csr_diagram_1_1_rdata[31:16] = csr_diagram_1_1_imag_ff;

assign csr_diagram_1_1_imag_out = csr_diagram_1_1_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_1_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_1_wen) begin
            if (wstrb[2]) begin
                csr_diagram_1_1_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_1_1_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_1_1_imag_ff <= csr_diagram_1_1_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x5c] - diagram_1_2 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_1_2_rdata;

wire csr_diagram_1_2_wen;
assign csr_diagram_1_2_wen = wen && (waddr == 11'h5c);

wire csr_diagram_1_2_ren;
assign csr_diagram_1_2_ren = ren && (raddr == 11'h5c);
reg csr_diagram_1_2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_2_ren_ff <= 1'b0;
    end else begin
        csr_diagram_1_2_ren_ff <= csr_diagram_1_2_ren;
    end
end
//---------------------
// Bit field:
// diagram_1_2[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_2_real_ff;

assign csr_diagram_1_2_rdata[15:0] = csr_diagram_1_2_real_ff;

assign csr_diagram_1_2_real_out = csr_diagram_1_2_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_2_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_2_wen) begin
            if (wstrb[0]) begin
                csr_diagram_1_2_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_1_2_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_1_2_real_ff <= csr_diagram_1_2_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_1_2[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_2_imag_ff;

assign csr_diagram_1_2_rdata[31:16] = csr_diagram_1_2_imag_ff;

assign csr_diagram_1_2_imag_out = csr_diagram_1_2_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_2_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_2_wen) begin
            if (wstrb[2]) begin
                csr_diagram_1_2_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_1_2_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_1_2_imag_ff <= csr_diagram_1_2_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x60] - diagram_1_3 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_1_3_rdata;

wire csr_diagram_1_3_wen;
assign csr_diagram_1_3_wen = wen && (waddr == 11'h60);

wire csr_diagram_1_3_ren;
assign csr_diagram_1_3_ren = ren && (raddr == 11'h60);
reg csr_diagram_1_3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_3_ren_ff <= 1'b0;
    end else begin
        csr_diagram_1_3_ren_ff <= csr_diagram_1_3_ren;
    end
end
//---------------------
// Bit field:
// diagram_1_3[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_3_real_ff;

assign csr_diagram_1_3_rdata[15:0] = csr_diagram_1_3_real_ff;

assign csr_diagram_1_3_real_out = csr_diagram_1_3_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_3_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_3_wen) begin
            if (wstrb[0]) begin
                csr_diagram_1_3_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_1_3_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_1_3_real_ff <= csr_diagram_1_3_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_1_3[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_3_imag_ff;

assign csr_diagram_1_3_rdata[31:16] = csr_diagram_1_3_imag_ff;

assign csr_diagram_1_3_imag_out = csr_diagram_1_3_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_3_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_3_wen) begin
            if (wstrb[2]) begin
                csr_diagram_1_3_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_1_3_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_1_3_imag_ff <= csr_diagram_1_3_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x64] - diagram_1_4 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_1_4_rdata;

wire csr_diagram_1_4_wen;
assign csr_diagram_1_4_wen = wen && (waddr == 11'h64);

wire csr_diagram_1_4_ren;
assign csr_diagram_1_4_ren = ren && (raddr == 11'h64);
reg csr_diagram_1_4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_4_ren_ff <= 1'b0;
    end else begin
        csr_diagram_1_4_ren_ff <= csr_diagram_1_4_ren;
    end
end
//---------------------
// Bit field:
// diagram_1_4[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_4_real_ff;

assign csr_diagram_1_4_rdata[15:0] = csr_diagram_1_4_real_ff;

assign csr_diagram_1_4_real_out = csr_diagram_1_4_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_4_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_4_wen) begin
            if (wstrb[0]) begin
                csr_diagram_1_4_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_1_4_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_1_4_real_ff <= csr_diagram_1_4_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_1_4[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_4_imag_ff;

assign csr_diagram_1_4_rdata[31:16] = csr_diagram_1_4_imag_ff;

assign csr_diagram_1_4_imag_out = csr_diagram_1_4_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_4_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_4_wen) begin
            if (wstrb[2]) begin
                csr_diagram_1_4_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_1_4_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_1_4_imag_ff <= csr_diagram_1_4_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x68] - diagram_1_5 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_1_5_rdata;

wire csr_diagram_1_5_wen;
assign csr_diagram_1_5_wen = wen && (waddr == 11'h68);

wire csr_diagram_1_5_ren;
assign csr_diagram_1_5_ren = ren && (raddr == 11'h68);
reg csr_diagram_1_5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_5_ren_ff <= 1'b0;
    end else begin
        csr_diagram_1_5_ren_ff <= csr_diagram_1_5_ren;
    end
end
//---------------------
// Bit field:
// diagram_1_5[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_5_real_ff;

assign csr_diagram_1_5_rdata[15:0] = csr_diagram_1_5_real_ff;

assign csr_diagram_1_5_real_out = csr_diagram_1_5_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_5_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_5_wen) begin
            if (wstrb[0]) begin
                csr_diagram_1_5_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_1_5_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_1_5_real_ff <= csr_diagram_1_5_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_1_5[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_5_imag_ff;

assign csr_diagram_1_5_rdata[31:16] = csr_diagram_1_5_imag_ff;

assign csr_diagram_1_5_imag_out = csr_diagram_1_5_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_5_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_5_wen) begin
            if (wstrb[2]) begin
                csr_diagram_1_5_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_1_5_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_1_5_imag_ff <= csr_diagram_1_5_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x6c] - diagram_1_6 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_1_6_rdata;

wire csr_diagram_1_6_wen;
assign csr_diagram_1_6_wen = wen && (waddr == 11'h6c);

wire csr_diagram_1_6_ren;
assign csr_diagram_1_6_ren = ren && (raddr == 11'h6c);
reg csr_diagram_1_6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_6_ren_ff <= 1'b0;
    end else begin
        csr_diagram_1_6_ren_ff <= csr_diagram_1_6_ren;
    end
end
//---------------------
// Bit field:
// diagram_1_6[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_6_real_ff;

assign csr_diagram_1_6_rdata[15:0] = csr_diagram_1_6_real_ff;

assign csr_diagram_1_6_real_out = csr_diagram_1_6_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_6_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_6_wen) begin
            if (wstrb[0]) begin
                csr_diagram_1_6_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_1_6_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_1_6_real_ff <= csr_diagram_1_6_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_1_6[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_6_imag_ff;

assign csr_diagram_1_6_rdata[31:16] = csr_diagram_1_6_imag_ff;

assign csr_diagram_1_6_imag_out = csr_diagram_1_6_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_6_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_6_wen) begin
            if (wstrb[2]) begin
                csr_diagram_1_6_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_1_6_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_1_6_imag_ff <= csr_diagram_1_6_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x70] - diagram_1_7 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_1_7_rdata;

wire csr_diagram_1_7_wen;
assign csr_diagram_1_7_wen = wen && (waddr == 11'h70);

wire csr_diagram_1_7_ren;
assign csr_diagram_1_7_ren = ren && (raddr == 11'h70);
reg csr_diagram_1_7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_7_ren_ff <= 1'b0;
    end else begin
        csr_diagram_1_7_ren_ff <= csr_diagram_1_7_ren;
    end
end
//---------------------
// Bit field:
// diagram_1_7[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_7_real_ff;

assign csr_diagram_1_7_rdata[15:0] = csr_diagram_1_7_real_ff;

assign csr_diagram_1_7_real_out = csr_diagram_1_7_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_7_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_7_wen) begin
            if (wstrb[0]) begin
                csr_diagram_1_7_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_1_7_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_1_7_real_ff <= csr_diagram_1_7_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_1_7[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_1_7_imag_ff;

assign csr_diagram_1_7_rdata[31:16] = csr_diagram_1_7_imag_ff;

assign csr_diagram_1_7_imag_out = csr_diagram_1_7_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_1_7_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_1_7_wen) begin
            if (wstrb[2]) begin
                csr_diagram_1_7_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_1_7_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_1_7_imag_ff <= csr_diagram_1_7_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x74] - diagram_2_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_2_0_rdata;

wire csr_diagram_2_0_wen;
assign csr_diagram_2_0_wen = wen && (waddr == 11'h74);

wire csr_diagram_2_0_ren;
assign csr_diagram_2_0_ren = ren && (raddr == 11'h74);
reg csr_diagram_2_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_0_ren_ff <= 1'b0;
    end else begin
        csr_diagram_2_0_ren_ff <= csr_diagram_2_0_ren;
    end
end
//---------------------
// Bit field:
// diagram_2_0[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_0_real_ff;

assign csr_diagram_2_0_rdata[15:0] = csr_diagram_2_0_real_ff;

assign csr_diagram_2_0_real_out = csr_diagram_2_0_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_0_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_0_wen) begin
            if (wstrb[0]) begin
                csr_diagram_2_0_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_2_0_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_2_0_real_ff <= csr_diagram_2_0_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_2_0[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_0_imag_ff;

assign csr_diagram_2_0_rdata[31:16] = csr_diagram_2_0_imag_ff;

assign csr_diagram_2_0_imag_out = csr_diagram_2_0_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_0_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_0_wen) begin
            if (wstrb[2]) begin
                csr_diagram_2_0_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_2_0_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_2_0_imag_ff <= csr_diagram_2_0_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x78] - diagram_2_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_2_1_rdata;

wire csr_diagram_2_1_wen;
assign csr_diagram_2_1_wen = wen && (waddr == 11'h78);

wire csr_diagram_2_1_ren;
assign csr_diagram_2_1_ren = ren && (raddr == 11'h78);
reg csr_diagram_2_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_1_ren_ff <= 1'b0;
    end else begin
        csr_diagram_2_1_ren_ff <= csr_diagram_2_1_ren;
    end
end
//---------------------
// Bit field:
// diagram_2_1[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_1_real_ff;

assign csr_diagram_2_1_rdata[15:0] = csr_diagram_2_1_real_ff;

assign csr_diagram_2_1_real_out = csr_diagram_2_1_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_1_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_1_wen) begin
            if (wstrb[0]) begin
                csr_diagram_2_1_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_2_1_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_2_1_real_ff <= csr_diagram_2_1_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_2_1[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_1_imag_ff;

assign csr_diagram_2_1_rdata[31:16] = csr_diagram_2_1_imag_ff;

assign csr_diagram_2_1_imag_out = csr_diagram_2_1_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_1_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_1_wen) begin
            if (wstrb[2]) begin
                csr_diagram_2_1_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_2_1_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_2_1_imag_ff <= csr_diagram_2_1_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x7c] - diagram_2_2 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_2_2_rdata;

wire csr_diagram_2_2_wen;
assign csr_diagram_2_2_wen = wen && (waddr == 11'h7c);

wire csr_diagram_2_2_ren;
assign csr_diagram_2_2_ren = ren && (raddr == 11'h7c);
reg csr_diagram_2_2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_2_ren_ff <= 1'b0;
    end else begin
        csr_diagram_2_2_ren_ff <= csr_diagram_2_2_ren;
    end
end
//---------------------
// Bit field:
// diagram_2_2[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_2_real_ff;

assign csr_diagram_2_2_rdata[15:0] = csr_diagram_2_2_real_ff;

assign csr_diagram_2_2_real_out = csr_diagram_2_2_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_2_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_2_wen) begin
            if (wstrb[0]) begin
                csr_diagram_2_2_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_2_2_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_2_2_real_ff <= csr_diagram_2_2_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_2_2[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_2_imag_ff;

assign csr_diagram_2_2_rdata[31:16] = csr_diagram_2_2_imag_ff;

assign csr_diagram_2_2_imag_out = csr_diagram_2_2_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_2_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_2_wen) begin
            if (wstrb[2]) begin
                csr_diagram_2_2_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_2_2_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_2_2_imag_ff <= csr_diagram_2_2_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x80] - diagram_2_3 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_2_3_rdata;

wire csr_diagram_2_3_wen;
assign csr_diagram_2_3_wen = wen && (waddr == 11'h80);

wire csr_diagram_2_3_ren;
assign csr_diagram_2_3_ren = ren && (raddr == 11'h80);
reg csr_diagram_2_3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_3_ren_ff <= 1'b0;
    end else begin
        csr_diagram_2_3_ren_ff <= csr_diagram_2_3_ren;
    end
end
//---------------------
// Bit field:
// diagram_2_3[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_3_real_ff;

assign csr_diagram_2_3_rdata[15:0] = csr_diagram_2_3_real_ff;

assign csr_diagram_2_3_real_out = csr_diagram_2_3_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_3_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_3_wen) begin
            if (wstrb[0]) begin
                csr_diagram_2_3_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_2_3_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_2_3_real_ff <= csr_diagram_2_3_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_2_3[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_3_imag_ff;

assign csr_diagram_2_3_rdata[31:16] = csr_diagram_2_3_imag_ff;

assign csr_diagram_2_3_imag_out = csr_diagram_2_3_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_3_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_3_wen) begin
            if (wstrb[2]) begin
                csr_diagram_2_3_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_2_3_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_2_3_imag_ff <= csr_diagram_2_3_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x84] - diagram_2_4 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_2_4_rdata;

wire csr_diagram_2_4_wen;
assign csr_diagram_2_4_wen = wen && (waddr == 11'h84);

wire csr_diagram_2_4_ren;
assign csr_diagram_2_4_ren = ren && (raddr == 11'h84);
reg csr_diagram_2_4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_4_ren_ff <= 1'b0;
    end else begin
        csr_diagram_2_4_ren_ff <= csr_diagram_2_4_ren;
    end
end
//---------------------
// Bit field:
// diagram_2_4[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_4_real_ff;

assign csr_diagram_2_4_rdata[15:0] = csr_diagram_2_4_real_ff;

assign csr_diagram_2_4_real_out = csr_diagram_2_4_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_4_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_4_wen) begin
            if (wstrb[0]) begin
                csr_diagram_2_4_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_2_4_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_2_4_real_ff <= csr_diagram_2_4_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_2_4[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_4_imag_ff;

assign csr_diagram_2_4_rdata[31:16] = csr_diagram_2_4_imag_ff;

assign csr_diagram_2_4_imag_out = csr_diagram_2_4_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_4_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_4_wen) begin
            if (wstrb[2]) begin
                csr_diagram_2_4_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_2_4_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_2_4_imag_ff <= csr_diagram_2_4_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x88] - diagram_2_5 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_2_5_rdata;

wire csr_diagram_2_5_wen;
assign csr_diagram_2_5_wen = wen && (waddr == 11'h88);

wire csr_diagram_2_5_ren;
assign csr_diagram_2_5_ren = ren && (raddr == 11'h88);
reg csr_diagram_2_5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_5_ren_ff <= 1'b0;
    end else begin
        csr_diagram_2_5_ren_ff <= csr_diagram_2_5_ren;
    end
end
//---------------------
// Bit field:
// diagram_2_5[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_5_real_ff;

assign csr_diagram_2_5_rdata[15:0] = csr_diagram_2_5_real_ff;

assign csr_diagram_2_5_real_out = csr_diagram_2_5_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_5_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_5_wen) begin
            if (wstrb[0]) begin
                csr_diagram_2_5_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_2_5_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_2_5_real_ff <= csr_diagram_2_5_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_2_5[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_5_imag_ff;

assign csr_diagram_2_5_rdata[31:16] = csr_diagram_2_5_imag_ff;

assign csr_diagram_2_5_imag_out = csr_diagram_2_5_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_5_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_5_wen) begin
            if (wstrb[2]) begin
                csr_diagram_2_5_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_2_5_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_2_5_imag_ff <= csr_diagram_2_5_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x8c] - diagram_2_6 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_2_6_rdata;

wire csr_diagram_2_6_wen;
assign csr_diagram_2_6_wen = wen && (waddr == 11'h8c);

wire csr_diagram_2_6_ren;
assign csr_diagram_2_6_ren = ren && (raddr == 11'h8c);
reg csr_diagram_2_6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_6_ren_ff <= 1'b0;
    end else begin
        csr_diagram_2_6_ren_ff <= csr_diagram_2_6_ren;
    end
end
//---------------------
// Bit field:
// diagram_2_6[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_6_real_ff;

assign csr_diagram_2_6_rdata[15:0] = csr_diagram_2_6_real_ff;

assign csr_diagram_2_6_real_out = csr_diagram_2_6_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_6_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_6_wen) begin
            if (wstrb[0]) begin
                csr_diagram_2_6_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_2_6_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_2_6_real_ff <= csr_diagram_2_6_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_2_6[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_6_imag_ff;

assign csr_diagram_2_6_rdata[31:16] = csr_diagram_2_6_imag_ff;

assign csr_diagram_2_6_imag_out = csr_diagram_2_6_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_6_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_6_wen) begin
            if (wstrb[2]) begin
                csr_diagram_2_6_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_2_6_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_2_6_imag_ff <= csr_diagram_2_6_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x90] - diagram_2_7 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_2_7_rdata;

wire csr_diagram_2_7_wen;
assign csr_diagram_2_7_wen = wen && (waddr == 11'h90);

wire csr_diagram_2_7_ren;
assign csr_diagram_2_7_ren = ren && (raddr == 11'h90);
reg csr_diagram_2_7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_7_ren_ff <= 1'b0;
    end else begin
        csr_diagram_2_7_ren_ff <= csr_diagram_2_7_ren;
    end
end
//---------------------
// Bit field:
// diagram_2_7[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_7_real_ff;

assign csr_diagram_2_7_rdata[15:0] = csr_diagram_2_7_real_ff;

assign csr_diagram_2_7_real_out = csr_diagram_2_7_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_7_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_7_wen) begin
            if (wstrb[0]) begin
                csr_diagram_2_7_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_2_7_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_2_7_real_ff <= csr_diagram_2_7_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_2_7[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_2_7_imag_ff;

assign csr_diagram_2_7_rdata[31:16] = csr_diagram_2_7_imag_ff;

assign csr_diagram_2_7_imag_out = csr_diagram_2_7_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_2_7_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_2_7_wen) begin
            if (wstrb[2]) begin
                csr_diagram_2_7_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_2_7_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_2_7_imag_ff <= csr_diagram_2_7_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x94] - diagram_3_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_3_0_rdata;

wire csr_diagram_3_0_wen;
assign csr_diagram_3_0_wen = wen && (waddr == 11'h94);

wire csr_diagram_3_0_ren;
assign csr_diagram_3_0_ren = ren && (raddr == 11'h94);
reg csr_diagram_3_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_0_ren_ff <= 1'b0;
    end else begin
        csr_diagram_3_0_ren_ff <= csr_diagram_3_0_ren;
    end
end
//---------------------
// Bit field:
// diagram_3_0[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_0_real_ff;

assign csr_diagram_3_0_rdata[15:0] = csr_diagram_3_0_real_ff;

assign csr_diagram_3_0_real_out = csr_diagram_3_0_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_0_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_0_wen) begin
            if (wstrb[0]) begin
                csr_diagram_3_0_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_3_0_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_3_0_real_ff <= csr_diagram_3_0_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_3_0[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_0_imag_ff;

assign csr_diagram_3_0_rdata[31:16] = csr_diagram_3_0_imag_ff;

assign csr_diagram_3_0_imag_out = csr_diagram_3_0_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_0_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_0_wen) begin
            if (wstrb[2]) begin
                csr_diagram_3_0_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_3_0_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_3_0_imag_ff <= csr_diagram_3_0_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x98] - diagram_3_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_3_1_rdata;

wire csr_diagram_3_1_wen;
assign csr_diagram_3_1_wen = wen && (waddr == 11'h98);

wire csr_diagram_3_1_ren;
assign csr_diagram_3_1_ren = ren && (raddr == 11'h98);
reg csr_diagram_3_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_1_ren_ff <= 1'b0;
    end else begin
        csr_diagram_3_1_ren_ff <= csr_diagram_3_1_ren;
    end
end
//---------------------
// Bit field:
// diagram_3_1[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_1_real_ff;

assign csr_diagram_3_1_rdata[15:0] = csr_diagram_3_1_real_ff;

assign csr_diagram_3_1_real_out = csr_diagram_3_1_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_1_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_1_wen) begin
            if (wstrb[0]) begin
                csr_diagram_3_1_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_3_1_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_3_1_real_ff <= csr_diagram_3_1_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_3_1[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_1_imag_ff;

assign csr_diagram_3_1_rdata[31:16] = csr_diagram_3_1_imag_ff;

assign csr_diagram_3_1_imag_out = csr_diagram_3_1_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_1_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_1_wen) begin
            if (wstrb[2]) begin
                csr_diagram_3_1_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_3_1_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_3_1_imag_ff <= csr_diagram_3_1_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x9c] - diagram_3_2 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_3_2_rdata;

wire csr_diagram_3_2_wen;
assign csr_diagram_3_2_wen = wen && (waddr == 11'h9c);

wire csr_diagram_3_2_ren;
assign csr_diagram_3_2_ren = ren && (raddr == 11'h9c);
reg csr_diagram_3_2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_2_ren_ff <= 1'b0;
    end else begin
        csr_diagram_3_2_ren_ff <= csr_diagram_3_2_ren;
    end
end
//---------------------
// Bit field:
// diagram_3_2[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_2_real_ff;

assign csr_diagram_3_2_rdata[15:0] = csr_diagram_3_2_real_ff;

assign csr_diagram_3_2_real_out = csr_diagram_3_2_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_2_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_2_wen) begin
            if (wstrb[0]) begin
                csr_diagram_3_2_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_3_2_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_3_2_real_ff <= csr_diagram_3_2_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_3_2[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_2_imag_ff;

assign csr_diagram_3_2_rdata[31:16] = csr_diagram_3_2_imag_ff;

assign csr_diagram_3_2_imag_out = csr_diagram_3_2_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_2_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_2_wen) begin
            if (wstrb[2]) begin
                csr_diagram_3_2_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_3_2_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_3_2_imag_ff <= csr_diagram_3_2_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xa0] - diagram_3_3 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_3_3_rdata;

wire csr_diagram_3_3_wen;
assign csr_diagram_3_3_wen = wen && (waddr == 11'ha0);

wire csr_diagram_3_3_ren;
assign csr_diagram_3_3_ren = ren && (raddr == 11'ha0);
reg csr_diagram_3_3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_3_ren_ff <= 1'b0;
    end else begin
        csr_diagram_3_3_ren_ff <= csr_diagram_3_3_ren;
    end
end
//---------------------
// Bit field:
// diagram_3_3[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_3_real_ff;

assign csr_diagram_3_3_rdata[15:0] = csr_diagram_3_3_real_ff;

assign csr_diagram_3_3_real_out = csr_diagram_3_3_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_3_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_3_wen) begin
            if (wstrb[0]) begin
                csr_diagram_3_3_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_3_3_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_3_3_real_ff <= csr_diagram_3_3_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_3_3[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_3_imag_ff;

assign csr_diagram_3_3_rdata[31:16] = csr_diagram_3_3_imag_ff;

assign csr_diagram_3_3_imag_out = csr_diagram_3_3_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_3_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_3_wen) begin
            if (wstrb[2]) begin
                csr_diagram_3_3_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_3_3_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_3_3_imag_ff <= csr_diagram_3_3_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xa4] - diagram_3_4 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_3_4_rdata;

wire csr_diagram_3_4_wen;
assign csr_diagram_3_4_wen = wen && (waddr == 11'ha4);

wire csr_diagram_3_4_ren;
assign csr_diagram_3_4_ren = ren && (raddr == 11'ha4);
reg csr_diagram_3_4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_4_ren_ff <= 1'b0;
    end else begin
        csr_diagram_3_4_ren_ff <= csr_diagram_3_4_ren;
    end
end
//---------------------
// Bit field:
// diagram_3_4[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_4_real_ff;

assign csr_diagram_3_4_rdata[15:0] = csr_diagram_3_4_real_ff;

assign csr_diagram_3_4_real_out = csr_diagram_3_4_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_4_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_4_wen) begin
            if (wstrb[0]) begin
                csr_diagram_3_4_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_3_4_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_3_4_real_ff <= csr_diagram_3_4_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_3_4[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_4_imag_ff;

assign csr_diagram_3_4_rdata[31:16] = csr_diagram_3_4_imag_ff;

assign csr_diagram_3_4_imag_out = csr_diagram_3_4_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_4_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_4_wen) begin
            if (wstrb[2]) begin
                csr_diagram_3_4_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_3_4_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_3_4_imag_ff <= csr_diagram_3_4_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xa8] - diagram_3_5 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_3_5_rdata;

wire csr_diagram_3_5_wen;
assign csr_diagram_3_5_wen = wen && (waddr == 11'ha8);

wire csr_diagram_3_5_ren;
assign csr_diagram_3_5_ren = ren && (raddr == 11'ha8);
reg csr_diagram_3_5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_5_ren_ff <= 1'b0;
    end else begin
        csr_diagram_3_5_ren_ff <= csr_diagram_3_5_ren;
    end
end
//---------------------
// Bit field:
// diagram_3_5[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_5_real_ff;

assign csr_diagram_3_5_rdata[15:0] = csr_diagram_3_5_real_ff;

assign csr_diagram_3_5_real_out = csr_diagram_3_5_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_5_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_5_wen) begin
            if (wstrb[0]) begin
                csr_diagram_3_5_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_3_5_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_3_5_real_ff <= csr_diagram_3_5_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_3_5[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_5_imag_ff;

assign csr_diagram_3_5_rdata[31:16] = csr_diagram_3_5_imag_ff;

assign csr_diagram_3_5_imag_out = csr_diagram_3_5_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_5_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_5_wen) begin
            if (wstrb[2]) begin
                csr_diagram_3_5_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_3_5_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_3_5_imag_ff <= csr_diagram_3_5_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xac] - diagram_3_6 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_3_6_rdata;

wire csr_diagram_3_6_wen;
assign csr_diagram_3_6_wen = wen && (waddr == 11'hac);

wire csr_diagram_3_6_ren;
assign csr_diagram_3_6_ren = ren && (raddr == 11'hac);
reg csr_diagram_3_6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_6_ren_ff <= 1'b0;
    end else begin
        csr_diagram_3_6_ren_ff <= csr_diagram_3_6_ren;
    end
end
//---------------------
// Bit field:
// diagram_3_6[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_6_real_ff;

assign csr_diagram_3_6_rdata[15:0] = csr_diagram_3_6_real_ff;

assign csr_diagram_3_6_real_out = csr_diagram_3_6_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_6_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_6_wen) begin
            if (wstrb[0]) begin
                csr_diagram_3_6_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_3_6_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_3_6_real_ff <= csr_diagram_3_6_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_3_6[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_6_imag_ff;

assign csr_diagram_3_6_rdata[31:16] = csr_diagram_3_6_imag_ff;

assign csr_diagram_3_6_imag_out = csr_diagram_3_6_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_6_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_6_wen) begin
            if (wstrb[2]) begin
                csr_diagram_3_6_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_3_6_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_3_6_imag_ff <= csr_diagram_3_6_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xb0] - diagram_3_7 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_3_7_rdata;

wire csr_diagram_3_7_wen;
assign csr_diagram_3_7_wen = wen && (waddr == 11'hb0);

wire csr_diagram_3_7_ren;
assign csr_diagram_3_7_ren = ren && (raddr == 11'hb0);
reg csr_diagram_3_7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_7_ren_ff <= 1'b0;
    end else begin
        csr_diagram_3_7_ren_ff <= csr_diagram_3_7_ren;
    end
end
//---------------------
// Bit field:
// diagram_3_7[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_7_real_ff;

assign csr_diagram_3_7_rdata[15:0] = csr_diagram_3_7_real_ff;

assign csr_diagram_3_7_real_out = csr_diagram_3_7_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_7_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_7_wen) begin
            if (wstrb[0]) begin
                csr_diagram_3_7_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_3_7_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_3_7_real_ff <= csr_diagram_3_7_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_3_7[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_3_7_imag_ff;

assign csr_diagram_3_7_rdata[31:16] = csr_diagram_3_7_imag_ff;

assign csr_diagram_3_7_imag_out = csr_diagram_3_7_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_3_7_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_3_7_wen) begin
            if (wstrb[2]) begin
                csr_diagram_3_7_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_3_7_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_3_7_imag_ff <= csr_diagram_3_7_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xb4] - diagram_4_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_4_0_rdata;

wire csr_diagram_4_0_wen;
assign csr_diagram_4_0_wen = wen && (waddr == 11'hb4);

wire csr_diagram_4_0_ren;
assign csr_diagram_4_0_ren = ren && (raddr == 11'hb4);
reg csr_diagram_4_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_0_ren_ff <= 1'b0;
    end else begin
        csr_diagram_4_0_ren_ff <= csr_diagram_4_0_ren;
    end
end
//---------------------
// Bit field:
// diagram_4_0[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_0_real_ff;

assign csr_diagram_4_0_rdata[15:0] = csr_diagram_4_0_real_ff;

assign csr_diagram_4_0_real_out = csr_diagram_4_0_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_0_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_0_wen) begin
            if (wstrb[0]) begin
                csr_diagram_4_0_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_4_0_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_4_0_real_ff <= csr_diagram_4_0_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_4_0[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_0_imag_ff;

assign csr_diagram_4_0_rdata[31:16] = csr_diagram_4_0_imag_ff;

assign csr_diagram_4_0_imag_out = csr_diagram_4_0_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_0_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_0_wen) begin
            if (wstrb[2]) begin
                csr_diagram_4_0_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_4_0_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_4_0_imag_ff <= csr_diagram_4_0_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xb8] - diagram_4_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_4_1_rdata;

wire csr_diagram_4_1_wen;
assign csr_diagram_4_1_wen = wen && (waddr == 11'hb8);

wire csr_diagram_4_1_ren;
assign csr_diagram_4_1_ren = ren && (raddr == 11'hb8);
reg csr_diagram_4_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_1_ren_ff <= 1'b0;
    end else begin
        csr_diagram_4_1_ren_ff <= csr_diagram_4_1_ren;
    end
end
//---------------------
// Bit field:
// diagram_4_1[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_1_real_ff;

assign csr_diagram_4_1_rdata[15:0] = csr_diagram_4_1_real_ff;

assign csr_diagram_4_1_real_out = csr_diagram_4_1_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_1_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_1_wen) begin
            if (wstrb[0]) begin
                csr_diagram_4_1_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_4_1_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_4_1_real_ff <= csr_diagram_4_1_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_4_1[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_1_imag_ff;

assign csr_diagram_4_1_rdata[31:16] = csr_diagram_4_1_imag_ff;

assign csr_diagram_4_1_imag_out = csr_diagram_4_1_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_1_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_1_wen) begin
            if (wstrb[2]) begin
                csr_diagram_4_1_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_4_1_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_4_1_imag_ff <= csr_diagram_4_1_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xbc] - diagram_4_2 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_4_2_rdata;

wire csr_diagram_4_2_wen;
assign csr_diagram_4_2_wen = wen && (waddr == 11'hbc);

wire csr_diagram_4_2_ren;
assign csr_diagram_4_2_ren = ren && (raddr == 11'hbc);
reg csr_diagram_4_2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_2_ren_ff <= 1'b0;
    end else begin
        csr_diagram_4_2_ren_ff <= csr_diagram_4_2_ren;
    end
end
//---------------------
// Bit field:
// diagram_4_2[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_2_real_ff;

assign csr_diagram_4_2_rdata[15:0] = csr_diagram_4_2_real_ff;

assign csr_diagram_4_2_real_out = csr_diagram_4_2_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_2_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_2_wen) begin
            if (wstrb[0]) begin
                csr_diagram_4_2_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_4_2_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_4_2_real_ff <= csr_diagram_4_2_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_4_2[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_2_imag_ff;

assign csr_diagram_4_2_rdata[31:16] = csr_diagram_4_2_imag_ff;

assign csr_diagram_4_2_imag_out = csr_diagram_4_2_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_2_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_2_wen) begin
            if (wstrb[2]) begin
                csr_diagram_4_2_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_4_2_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_4_2_imag_ff <= csr_diagram_4_2_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xc0] - diagram_4_3 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_4_3_rdata;

wire csr_diagram_4_3_wen;
assign csr_diagram_4_3_wen = wen && (waddr == 11'hc0);

wire csr_diagram_4_3_ren;
assign csr_diagram_4_3_ren = ren && (raddr == 11'hc0);
reg csr_diagram_4_3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_3_ren_ff <= 1'b0;
    end else begin
        csr_diagram_4_3_ren_ff <= csr_diagram_4_3_ren;
    end
end
//---------------------
// Bit field:
// diagram_4_3[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_3_real_ff;

assign csr_diagram_4_3_rdata[15:0] = csr_diagram_4_3_real_ff;

assign csr_diagram_4_3_real_out = csr_diagram_4_3_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_3_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_3_wen) begin
            if (wstrb[0]) begin
                csr_diagram_4_3_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_4_3_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_4_3_real_ff <= csr_diagram_4_3_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_4_3[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_3_imag_ff;

assign csr_diagram_4_3_rdata[31:16] = csr_diagram_4_3_imag_ff;

assign csr_diagram_4_3_imag_out = csr_diagram_4_3_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_3_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_3_wen) begin
            if (wstrb[2]) begin
                csr_diagram_4_3_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_4_3_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_4_3_imag_ff <= csr_diagram_4_3_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xc4] - diagram_4_4 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_4_4_rdata;

wire csr_diagram_4_4_wen;
assign csr_diagram_4_4_wen = wen && (waddr == 11'hc4);

wire csr_diagram_4_4_ren;
assign csr_diagram_4_4_ren = ren && (raddr == 11'hc4);
reg csr_diagram_4_4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_4_ren_ff <= 1'b0;
    end else begin
        csr_diagram_4_4_ren_ff <= csr_diagram_4_4_ren;
    end
end
//---------------------
// Bit field:
// diagram_4_4[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_4_real_ff;

assign csr_diagram_4_4_rdata[15:0] = csr_diagram_4_4_real_ff;

assign csr_diagram_4_4_real_out = csr_diagram_4_4_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_4_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_4_wen) begin
            if (wstrb[0]) begin
                csr_diagram_4_4_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_4_4_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_4_4_real_ff <= csr_diagram_4_4_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_4_4[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_4_imag_ff;

assign csr_diagram_4_4_rdata[31:16] = csr_diagram_4_4_imag_ff;

assign csr_diagram_4_4_imag_out = csr_diagram_4_4_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_4_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_4_wen) begin
            if (wstrb[2]) begin
                csr_diagram_4_4_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_4_4_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_4_4_imag_ff <= csr_diagram_4_4_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xc8] - diagram_4_5 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_4_5_rdata;

wire csr_diagram_4_5_wen;
assign csr_diagram_4_5_wen = wen && (waddr == 11'hc8);

wire csr_diagram_4_5_ren;
assign csr_diagram_4_5_ren = ren && (raddr == 11'hc8);
reg csr_diagram_4_5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_5_ren_ff <= 1'b0;
    end else begin
        csr_diagram_4_5_ren_ff <= csr_diagram_4_5_ren;
    end
end
//---------------------
// Bit field:
// diagram_4_5[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_5_real_ff;

assign csr_diagram_4_5_rdata[15:0] = csr_diagram_4_5_real_ff;

assign csr_diagram_4_5_real_out = csr_diagram_4_5_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_5_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_5_wen) begin
            if (wstrb[0]) begin
                csr_diagram_4_5_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_4_5_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_4_5_real_ff <= csr_diagram_4_5_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_4_5[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_5_imag_ff;

assign csr_diagram_4_5_rdata[31:16] = csr_diagram_4_5_imag_ff;

assign csr_diagram_4_5_imag_out = csr_diagram_4_5_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_5_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_5_wen) begin
            if (wstrb[2]) begin
                csr_diagram_4_5_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_4_5_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_4_5_imag_ff <= csr_diagram_4_5_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xcc] - diagram_4_6 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_4_6_rdata;

wire csr_diagram_4_6_wen;
assign csr_diagram_4_6_wen = wen && (waddr == 11'hcc);

wire csr_diagram_4_6_ren;
assign csr_diagram_4_6_ren = ren && (raddr == 11'hcc);
reg csr_diagram_4_6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_6_ren_ff <= 1'b0;
    end else begin
        csr_diagram_4_6_ren_ff <= csr_diagram_4_6_ren;
    end
end
//---------------------
// Bit field:
// diagram_4_6[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_6_real_ff;

assign csr_diagram_4_6_rdata[15:0] = csr_diagram_4_6_real_ff;

assign csr_diagram_4_6_real_out = csr_diagram_4_6_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_6_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_6_wen) begin
            if (wstrb[0]) begin
                csr_diagram_4_6_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_4_6_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_4_6_real_ff <= csr_diagram_4_6_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_4_6[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_6_imag_ff;

assign csr_diagram_4_6_rdata[31:16] = csr_diagram_4_6_imag_ff;

assign csr_diagram_4_6_imag_out = csr_diagram_4_6_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_6_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_6_wen) begin
            if (wstrb[2]) begin
                csr_diagram_4_6_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_4_6_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_4_6_imag_ff <= csr_diagram_4_6_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xd0] - diagram_4_7 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_4_7_rdata;

wire csr_diagram_4_7_wen;
assign csr_diagram_4_7_wen = wen && (waddr == 11'hd0);

wire csr_diagram_4_7_ren;
assign csr_diagram_4_7_ren = ren && (raddr == 11'hd0);
reg csr_diagram_4_7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_7_ren_ff <= 1'b0;
    end else begin
        csr_diagram_4_7_ren_ff <= csr_diagram_4_7_ren;
    end
end
//---------------------
// Bit field:
// diagram_4_7[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_7_real_ff;

assign csr_diagram_4_7_rdata[15:0] = csr_diagram_4_7_real_ff;

assign csr_diagram_4_7_real_out = csr_diagram_4_7_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_7_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_7_wen) begin
            if (wstrb[0]) begin
                csr_diagram_4_7_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_4_7_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_4_7_real_ff <= csr_diagram_4_7_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_4_7[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_4_7_imag_ff;

assign csr_diagram_4_7_rdata[31:16] = csr_diagram_4_7_imag_ff;

assign csr_diagram_4_7_imag_out = csr_diagram_4_7_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_4_7_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_4_7_wen) begin
            if (wstrb[2]) begin
                csr_diagram_4_7_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_4_7_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_4_7_imag_ff <= csr_diagram_4_7_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xd4] - diagram_5_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_5_0_rdata;

wire csr_diagram_5_0_wen;
assign csr_diagram_5_0_wen = wen && (waddr == 11'hd4);

wire csr_diagram_5_0_ren;
assign csr_diagram_5_0_ren = ren && (raddr == 11'hd4);
reg csr_diagram_5_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_0_ren_ff <= 1'b0;
    end else begin
        csr_diagram_5_0_ren_ff <= csr_diagram_5_0_ren;
    end
end
//---------------------
// Bit field:
// diagram_5_0[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_0_real_ff;

assign csr_diagram_5_0_rdata[15:0] = csr_diagram_5_0_real_ff;

assign csr_diagram_5_0_real_out = csr_diagram_5_0_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_0_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_0_wen) begin
            if (wstrb[0]) begin
                csr_diagram_5_0_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_5_0_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_5_0_real_ff <= csr_diagram_5_0_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_5_0[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_0_imag_ff;

assign csr_diagram_5_0_rdata[31:16] = csr_diagram_5_0_imag_ff;

assign csr_diagram_5_0_imag_out = csr_diagram_5_0_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_0_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_0_wen) begin
            if (wstrb[2]) begin
                csr_diagram_5_0_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_5_0_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_5_0_imag_ff <= csr_diagram_5_0_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xd8] - diagram_5_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_5_1_rdata;

wire csr_diagram_5_1_wen;
assign csr_diagram_5_1_wen = wen && (waddr == 11'hd8);

wire csr_diagram_5_1_ren;
assign csr_diagram_5_1_ren = ren && (raddr == 11'hd8);
reg csr_diagram_5_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_1_ren_ff <= 1'b0;
    end else begin
        csr_diagram_5_1_ren_ff <= csr_diagram_5_1_ren;
    end
end
//---------------------
// Bit field:
// diagram_5_1[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_1_real_ff;

assign csr_diagram_5_1_rdata[15:0] = csr_diagram_5_1_real_ff;

assign csr_diagram_5_1_real_out = csr_diagram_5_1_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_1_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_1_wen) begin
            if (wstrb[0]) begin
                csr_diagram_5_1_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_5_1_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_5_1_real_ff <= csr_diagram_5_1_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_5_1[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_1_imag_ff;

assign csr_diagram_5_1_rdata[31:16] = csr_diagram_5_1_imag_ff;

assign csr_diagram_5_1_imag_out = csr_diagram_5_1_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_1_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_1_wen) begin
            if (wstrb[2]) begin
                csr_diagram_5_1_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_5_1_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_5_1_imag_ff <= csr_diagram_5_1_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xdc] - diagram_5_2 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_5_2_rdata;

wire csr_diagram_5_2_wen;
assign csr_diagram_5_2_wen = wen && (waddr == 11'hdc);

wire csr_diagram_5_2_ren;
assign csr_diagram_5_2_ren = ren && (raddr == 11'hdc);
reg csr_diagram_5_2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_2_ren_ff <= 1'b0;
    end else begin
        csr_diagram_5_2_ren_ff <= csr_diagram_5_2_ren;
    end
end
//---------------------
// Bit field:
// diagram_5_2[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_2_real_ff;

assign csr_diagram_5_2_rdata[15:0] = csr_diagram_5_2_real_ff;

assign csr_diagram_5_2_real_out = csr_diagram_5_2_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_2_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_2_wen) begin
            if (wstrb[0]) begin
                csr_diagram_5_2_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_5_2_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_5_2_real_ff <= csr_diagram_5_2_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_5_2[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_2_imag_ff;

assign csr_diagram_5_2_rdata[31:16] = csr_diagram_5_2_imag_ff;

assign csr_diagram_5_2_imag_out = csr_diagram_5_2_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_2_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_2_wen) begin
            if (wstrb[2]) begin
                csr_diagram_5_2_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_5_2_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_5_2_imag_ff <= csr_diagram_5_2_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xe0] - diagram_5_3 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_5_3_rdata;

wire csr_diagram_5_3_wen;
assign csr_diagram_5_3_wen = wen && (waddr == 11'he0);

wire csr_diagram_5_3_ren;
assign csr_diagram_5_3_ren = ren && (raddr == 11'he0);
reg csr_diagram_5_3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_3_ren_ff <= 1'b0;
    end else begin
        csr_diagram_5_3_ren_ff <= csr_diagram_5_3_ren;
    end
end
//---------------------
// Bit field:
// diagram_5_3[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_3_real_ff;

assign csr_diagram_5_3_rdata[15:0] = csr_diagram_5_3_real_ff;

assign csr_diagram_5_3_real_out = csr_diagram_5_3_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_3_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_3_wen) begin
            if (wstrb[0]) begin
                csr_diagram_5_3_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_5_3_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_5_3_real_ff <= csr_diagram_5_3_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_5_3[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_3_imag_ff;

assign csr_diagram_5_3_rdata[31:16] = csr_diagram_5_3_imag_ff;

assign csr_diagram_5_3_imag_out = csr_diagram_5_3_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_3_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_3_wen) begin
            if (wstrb[2]) begin
                csr_diagram_5_3_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_5_3_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_5_3_imag_ff <= csr_diagram_5_3_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xe4] - diagram_5_4 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_5_4_rdata;

wire csr_diagram_5_4_wen;
assign csr_diagram_5_4_wen = wen && (waddr == 11'he4);

wire csr_diagram_5_4_ren;
assign csr_diagram_5_4_ren = ren && (raddr == 11'he4);
reg csr_diagram_5_4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_4_ren_ff <= 1'b0;
    end else begin
        csr_diagram_5_4_ren_ff <= csr_diagram_5_4_ren;
    end
end
//---------------------
// Bit field:
// diagram_5_4[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_4_real_ff;

assign csr_diagram_5_4_rdata[15:0] = csr_diagram_5_4_real_ff;

assign csr_diagram_5_4_real_out = csr_diagram_5_4_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_4_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_4_wen) begin
            if (wstrb[0]) begin
                csr_diagram_5_4_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_5_4_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_5_4_real_ff <= csr_diagram_5_4_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_5_4[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_4_imag_ff;

assign csr_diagram_5_4_rdata[31:16] = csr_diagram_5_4_imag_ff;

assign csr_diagram_5_4_imag_out = csr_diagram_5_4_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_4_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_4_wen) begin
            if (wstrb[2]) begin
                csr_diagram_5_4_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_5_4_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_5_4_imag_ff <= csr_diagram_5_4_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xe8] - diagram_5_5 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_5_5_rdata;

wire csr_diagram_5_5_wen;
assign csr_diagram_5_5_wen = wen && (waddr == 11'he8);

wire csr_diagram_5_5_ren;
assign csr_diagram_5_5_ren = ren && (raddr == 11'he8);
reg csr_diagram_5_5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_5_ren_ff <= 1'b0;
    end else begin
        csr_diagram_5_5_ren_ff <= csr_diagram_5_5_ren;
    end
end
//---------------------
// Bit field:
// diagram_5_5[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_5_real_ff;

assign csr_diagram_5_5_rdata[15:0] = csr_diagram_5_5_real_ff;

assign csr_diagram_5_5_real_out = csr_diagram_5_5_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_5_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_5_wen) begin
            if (wstrb[0]) begin
                csr_diagram_5_5_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_5_5_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_5_5_real_ff <= csr_diagram_5_5_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_5_5[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_5_imag_ff;

assign csr_diagram_5_5_rdata[31:16] = csr_diagram_5_5_imag_ff;

assign csr_diagram_5_5_imag_out = csr_diagram_5_5_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_5_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_5_wen) begin
            if (wstrb[2]) begin
                csr_diagram_5_5_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_5_5_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_5_5_imag_ff <= csr_diagram_5_5_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xec] - diagram_5_6 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_5_6_rdata;

wire csr_diagram_5_6_wen;
assign csr_diagram_5_6_wen = wen && (waddr == 11'hec);

wire csr_diagram_5_6_ren;
assign csr_diagram_5_6_ren = ren && (raddr == 11'hec);
reg csr_diagram_5_6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_6_ren_ff <= 1'b0;
    end else begin
        csr_diagram_5_6_ren_ff <= csr_diagram_5_6_ren;
    end
end
//---------------------
// Bit field:
// diagram_5_6[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_6_real_ff;

assign csr_diagram_5_6_rdata[15:0] = csr_diagram_5_6_real_ff;

assign csr_diagram_5_6_real_out = csr_diagram_5_6_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_6_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_6_wen) begin
            if (wstrb[0]) begin
                csr_diagram_5_6_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_5_6_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_5_6_real_ff <= csr_diagram_5_6_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_5_6[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_6_imag_ff;

assign csr_diagram_5_6_rdata[31:16] = csr_diagram_5_6_imag_ff;

assign csr_diagram_5_6_imag_out = csr_diagram_5_6_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_6_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_6_wen) begin
            if (wstrb[2]) begin
                csr_diagram_5_6_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_5_6_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_5_6_imag_ff <= csr_diagram_5_6_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xf0] - diagram_5_7 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_5_7_rdata;

wire csr_diagram_5_7_wen;
assign csr_diagram_5_7_wen = wen && (waddr == 11'hf0);

wire csr_diagram_5_7_ren;
assign csr_diagram_5_7_ren = ren && (raddr == 11'hf0);
reg csr_diagram_5_7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_7_ren_ff <= 1'b0;
    end else begin
        csr_diagram_5_7_ren_ff <= csr_diagram_5_7_ren;
    end
end
//---------------------
// Bit field:
// diagram_5_7[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_7_real_ff;

assign csr_diagram_5_7_rdata[15:0] = csr_diagram_5_7_real_ff;

assign csr_diagram_5_7_real_out = csr_diagram_5_7_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_7_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_7_wen) begin
            if (wstrb[0]) begin
                csr_diagram_5_7_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_5_7_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_5_7_real_ff <= csr_diagram_5_7_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_5_7[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_5_7_imag_ff;

assign csr_diagram_5_7_rdata[31:16] = csr_diagram_5_7_imag_ff;

assign csr_diagram_5_7_imag_out = csr_diagram_5_7_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_5_7_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_5_7_wen) begin
            if (wstrb[2]) begin
                csr_diagram_5_7_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_5_7_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_5_7_imag_ff <= csr_diagram_5_7_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xf4] - diagram_6_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_6_0_rdata;

wire csr_diagram_6_0_wen;
assign csr_diagram_6_0_wen = wen && (waddr == 11'hf4);

wire csr_diagram_6_0_ren;
assign csr_diagram_6_0_ren = ren && (raddr == 11'hf4);
reg csr_diagram_6_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_0_ren_ff <= 1'b0;
    end else begin
        csr_diagram_6_0_ren_ff <= csr_diagram_6_0_ren;
    end
end
//---------------------
// Bit field:
// diagram_6_0[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_0_real_ff;

assign csr_diagram_6_0_rdata[15:0] = csr_diagram_6_0_real_ff;

assign csr_diagram_6_0_real_out = csr_diagram_6_0_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_0_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_0_wen) begin
            if (wstrb[0]) begin
                csr_diagram_6_0_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_6_0_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_6_0_real_ff <= csr_diagram_6_0_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_6_0[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_0_imag_ff;

assign csr_diagram_6_0_rdata[31:16] = csr_diagram_6_0_imag_ff;

assign csr_diagram_6_0_imag_out = csr_diagram_6_0_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_0_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_0_wen) begin
            if (wstrb[2]) begin
                csr_diagram_6_0_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_6_0_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_6_0_imag_ff <= csr_diagram_6_0_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xf8] - diagram_6_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_6_1_rdata;

wire csr_diagram_6_1_wen;
assign csr_diagram_6_1_wen = wen && (waddr == 11'hf8);

wire csr_diagram_6_1_ren;
assign csr_diagram_6_1_ren = ren && (raddr == 11'hf8);
reg csr_diagram_6_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_1_ren_ff <= 1'b0;
    end else begin
        csr_diagram_6_1_ren_ff <= csr_diagram_6_1_ren;
    end
end
//---------------------
// Bit field:
// diagram_6_1[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_1_real_ff;

assign csr_diagram_6_1_rdata[15:0] = csr_diagram_6_1_real_ff;

assign csr_diagram_6_1_real_out = csr_diagram_6_1_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_1_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_1_wen) begin
            if (wstrb[0]) begin
                csr_diagram_6_1_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_6_1_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_6_1_real_ff <= csr_diagram_6_1_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_6_1[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_1_imag_ff;

assign csr_diagram_6_1_rdata[31:16] = csr_diagram_6_1_imag_ff;

assign csr_diagram_6_1_imag_out = csr_diagram_6_1_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_1_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_1_wen) begin
            if (wstrb[2]) begin
                csr_diagram_6_1_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_6_1_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_6_1_imag_ff <= csr_diagram_6_1_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0xfc] - diagram_6_2 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_6_2_rdata;

wire csr_diagram_6_2_wen;
assign csr_diagram_6_2_wen = wen && (waddr == 11'hfc);

wire csr_diagram_6_2_ren;
assign csr_diagram_6_2_ren = ren && (raddr == 11'hfc);
reg csr_diagram_6_2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_2_ren_ff <= 1'b0;
    end else begin
        csr_diagram_6_2_ren_ff <= csr_diagram_6_2_ren;
    end
end
//---------------------
// Bit field:
// diagram_6_2[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_2_real_ff;

assign csr_diagram_6_2_rdata[15:0] = csr_diagram_6_2_real_ff;

assign csr_diagram_6_2_real_out = csr_diagram_6_2_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_2_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_2_wen) begin
            if (wstrb[0]) begin
                csr_diagram_6_2_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_6_2_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_6_2_real_ff <= csr_diagram_6_2_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_6_2[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_2_imag_ff;

assign csr_diagram_6_2_rdata[31:16] = csr_diagram_6_2_imag_ff;

assign csr_diagram_6_2_imag_out = csr_diagram_6_2_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_2_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_2_wen) begin
            if (wstrb[2]) begin
                csr_diagram_6_2_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_6_2_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_6_2_imag_ff <= csr_diagram_6_2_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x100] - diagram_6_3 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_6_3_rdata;

wire csr_diagram_6_3_wen;
assign csr_diagram_6_3_wen = wen && (waddr == 11'h100);

wire csr_diagram_6_3_ren;
assign csr_diagram_6_3_ren = ren && (raddr == 11'h100);
reg csr_diagram_6_3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_3_ren_ff <= 1'b0;
    end else begin
        csr_diagram_6_3_ren_ff <= csr_diagram_6_3_ren;
    end
end
//---------------------
// Bit field:
// diagram_6_3[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_3_real_ff;

assign csr_diagram_6_3_rdata[15:0] = csr_diagram_6_3_real_ff;

assign csr_diagram_6_3_real_out = csr_diagram_6_3_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_3_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_3_wen) begin
            if (wstrb[0]) begin
                csr_diagram_6_3_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_6_3_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_6_3_real_ff <= csr_diagram_6_3_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_6_3[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_3_imag_ff;

assign csr_diagram_6_3_rdata[31:16] = csr_diagram_6_3_imag_ff;

assign csr_diagram_6_3_imag_out = csr_diagram_6_3_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_3_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_3_wen) begin
            if (wstrb[2]) begin
                csr_diagram_6_3_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_6_3_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_6_3_imag_ff <= csr_diagram_6_3_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x104] - diagram_6_4 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_6_4_rdata;

wire csr_diagram_6_4_wen;
assign csr_diagram_6_4_wen = wen && (waddr == 11'h104);

wire csr_diagram_6_4_ren;
assign csr_diagram_6_4_ren = ren && (raddr == 11'h104);
reg csr_diagram_6_4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_4_ren_ff <= 1'b0;
    end else begin
        csr_diagram_6_4_ren_ff <= csr_diagram_6_4_ren;
    end
end
//---------------------
// Bit field:
// diagram_6_4[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_4_real_ff;

assign csr_diagram_6_4_rdata[15:0] = csr_diagram_6_4_real_ff;

assign csr_diagram_6_4_real_out = csr_diagram_6_4_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_4_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_4_wen) begin
            if (wstrb[0]) begin
                csr_diagram_6_4_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_6_4_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_6_4_real_ff <= csr_diagram_6_4_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_6_4[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_4_imag_ff;

assign csr_diagram_6_4_rdata[31:16] = csr_diagram_6_4_imag_ff;

assign csr_diagram_6_4_imag_out = csr_diagram_6_4_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_4_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_4_wen) begin
            if (wstrb[2]) begin
                csr_diagram_6_4_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_6_4_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_6_4_imag_ff <= csr_diagram_6_4_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x108] - diagram_6_5 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_6_5_rdata;

wire csr_diagram_6_5_wen;
assign csr_diagram_6_5_wen = wen && (waddr == 11'h108);

wire csr_diagram_6_5_ren;
assign csr_diagram_6_5_ren = ren && (raddr == 11'h108);
reg csr_diagram_6_5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_5_ren_ff <= 1'b0;
    end else begin
        csr_diagram_6_5_ren_ff <= csr_diagram_6_5_ren;
    end
end
//---------------------
// Bit field:
// diagram_6_5[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_5_real_ff;

assign csr_diagram_6_5_rdata[15:0] = csr_diagram_6_5_real_ff;

assign csr_diagram_6_5_real_out = csr_diagram_6_5_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_5_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_5_wen) begin
            if (wstrb[0]) begin
                csr_diagram_6_5_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_6_5_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_6_5_real_ff <= csr_diagram_6_5_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_6_5[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_5_imag_ff;

assign csr_diagram_6_5_rdata[31:16] = csr_diagram_6_5_imag_ff;

assign csr_diagram_6_5_imag_out = csr_diagram_6_5_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_5_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_5_wen) begin
            if (wstrb[2]) begin
                csr_diagram_6_5_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_6_5_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_6_5_imag_ff <= csr_diagram_6_5_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x10c] - diagram_6_6 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_6_6_rdata;

wire csr_diagram_6_6_wen;
assign csr_diagram_6_6_wen = wen && (waddr == 11'h10c);

wire csr_diagram_6_6_ren;
assign csr_diagram_6_6_ren = ren && (raddr == 11'h10c);
reg csr_diagram_6_6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_6_ren_ff <= 1'b0;
    end else begin
        csr_diagram_6_6_ren_ff <= csr_diagram_6_6_ren;
    end
end
//---------------------
// Bit field:
// diagram_6_6[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_6_real_ff;

assign csr_diagram_6_6_rdata[15:0] = csr_diagram_6_6_real_ff;

assign csr_diagram_6_6_real_out = csr_diagram_6_6_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_6_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_6_wen) begin
            if (wstrb[0]) begin
                csr_diagram_6_6_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_6_6_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_6_6_real_ff <= csr_diagram_6_6_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_6_6[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_6_imag_ff;

assign csr_diagram_6_6_rdata[31:16] = csr_diagram_6_6_imag_ff;

assign csr_diagram_6_6_imag_out = csr_diagram_6_6_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_6_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_6_wen) begin
            if (wstrb[2]) begin
                csr_diagram_6_6_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_6_6_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_6_6_imag_ff <= csr_diagram_6_6_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x110] - diagram_6_7 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_6_7_rdata;

wire csr_diagram_6_7_wen;
assign csr_diagram_6_7_wen = wen && (waddr == 11'h110);

wire csr_diagram_6_7_ren;
assign csr_diagram_6_7_ren = ren && (raddr == 11'h110);
reg csr_diagram_6_7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_7_ren_ff <= 1'b0;
    end else begin
        csr_diagram_6_7_ren_ff <= csr_diagram_6_7_ren;
    end
end
//---------------------
// Bit field:
// diagram_6_7[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_7_real_ff;

assign csr_diagram_6_7_rdata[15:0] = csr_diagram_6_7_real_ff;

assign csr_diagram_6_7_real_out = csr_diagram_6_7_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_7_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_7_wen) begin
            if (wstrb[0]) begin
                csr_diagram_6_7_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_6_7_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_6_7_real_ff <= csr_diagram_6_7_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_6_7[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_6_7_imag_ff;

assign csr_diagram_6_7_rdata[31:16] = csr_diagram_6_7_imag_ff;

assign csr_diagram_6_7_imag_out = csr_diagram_6_7_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_6_7_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_6_7_wen) begin
            if (wstrb[2]) begin
                csr_diagram_6_7_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_6_7_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_6_7_imag_ff <= csr_diagram_6_7_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x114] - diagram_7_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_7_0_rdata;

wire csr_diagram_7_0_wen;
assign csr_diagram_7_0_wen = wen && (waddr == 11'h114);

wire csr_diagram_7_0_ren;
assign csr_diagram_7_0_ren = ren && (raddr == 11'h114);
reg csr_diagram_7_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_0_ren_ff <= 1'b0;
    end else begin
        csr_diagram_7_0_ren_ff <= csr_diagram_7_0_ren;
    end
end
//---------------------
// Bit field:
// diagram_7_0[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_0_real_ff;

assign csr_diagram_7_0_rdata[15:0] = csr_diagram_7_0_real_ff;

assign csr_diagram_7_0_real_out = csr_diagram_7_0_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_0_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_0_wen) begin
            if (wstrb[0]) begin
                csr_diagram_7_0_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_7_0_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_7_0_real_ff <= csr_diagram_7_0_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_7_0[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_0_imag_ff;

assign csr_diagram_7_0_rdata[31:16] = csr_diagram_7_0_imag_ff;

assign csr_diagram_7_0_imag_out = csr_diagram_7_0_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_0_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_0_wen) begin
            if (wstrb[2]) begin
                csr_diagram_7_0_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_7_0_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_7_0_imag_ff <= csr_diagram_7_0_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x118] - diagram_7_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_7_1_rdata;

wire csr_diagram_7_1_wen;
assign csr_diagram_7_1_wen = wen && (waddr == 11'h118);

wire csr_diagram_7_1_ren;
assign csr_diagram_7_1_ren = ren && (raddr == 11'h118);
reg csr_diagram_7_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_1_ren_ff <= 1'b0;
    end else begin
        csr_diagram_7_1_ren_ff <= csr_diagram_7_1_ren;
    end
end
//---------------------
// Bit field:
// diagram_7_1[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_1_real_ff;

assign csr_diagram_7_1_rdata[15:0] = csr_diagram_7_1_real_ff;

assign csr_diagram_7_1_real_out = csr_diagram_7_1_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_1_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_1_wen) begin
            if (wstrb[0]) begin
                csr_diagram_7_1_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_7_1_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_7_1_real_ff <= csr_diagram_7_1_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_7_1[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_1_imag_ff;

assign csr_diagram_7_1_rdata[31:16] = csr_diagram_7_1_imag_ff;

assign csr_diagram_7_1_imag_out = csr_diagram_7_1_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_1_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_1_wen) begin
            if (wstrb[2]) begin
                csr_diagram_7_1_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_7_1_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_7_1_imag_ff <= csr_diagram_7_1_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x11c] - diagram_7_2 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_7_2_rdata;

wire csr_diagram_7_2_wen;
assign csr_diagram_7_2_wen = wen && (waddr == 11'h11c);

wire csr_diagram_7_2_ren;
assign csr_diagram_7_2_ren = ren && (raddr == 11'h11c);
reg csr_diagram_7_2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_2_ren_ff <= 1'b0;
    end else begin
        csr_diagram_7_2_ren_ff <= csr_diagram_7_2_ren;
    end
end
//---------------------
// Bit field:
// diagram_7_2[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_2_real_ff;

assign csr_diagram_7_2_rdata[15:0] = csr_diagram_7_2_real_ff;

assign csr_diagram_7_2_real_out = csr_diagram_7_2_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_2_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_2_wen) begin
            if (wstrb[0]) begin
                csr_diagram_7_2_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_7_2_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_7_2_real_ff <= csr_diagram_7_2_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_7_2[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_2_imag_ff;

assign csr_diagram_7_2_rdata[31:16] = csr_diagram_7_2_imag_ff;

assign csr_diagram_7_2_imag_out = csr_diagram_7_2_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_2_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_2_wen) begin
            if (wstrb[2]) begin
                csr_diagram_7_2_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_7_2_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_7_2_imag_ff <= csr_diagram_7_2_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x120] - diagram_7_3 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_7_3_rdata;

wire csr_diagram_7_3_wen;
assign csr_diagram_7_3_wen = wen && (waddr == 11'h120);

wire csr_diagram_7_3_ren;
assign csr_diagram_7_3_ren = ren && (raddr == 11'h120);
reg csr_diagram_7_3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_3_ren_ff <= 1'b0;
    end else begin
        csr_diagram_7_3_ren_ff <= csr_diagram_7_3_ren;
    end
end
//---------------------
// Bit field:
// diagram_7_3[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_3_real_ff;

assign csr_diagram_7_3_rdata[15:0] = csr_diagram_7_3_real_ff;

assign csr_diagram_7_3_real_out = csr_diagram_7_3_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_3_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_3_wen) begin
            if (wstrb[0]) begin
                csr_diagram_7_3_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_7_3_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_7_3_real_ff <= csr_diagram_7_3_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_7_3[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_3_imag_ff;

assign csr_diagram_7_3_rdata[31:16] = csr_diagram_7_3_imag_ff;

assign csr_diagram_7_3_imag_out = csr_diagram_7_3_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_3_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_3_wen) begin
            if (wstrb[2]) begin
                csr_diagram_7_3_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_7_3_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_7_3_imag_ff <= csr_diagram_7_3_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x124] - diagram_7_4 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_7_4_rdata;

wire csr_diagram_7_4_wen;
assign csr_diagram_7_4_wen = wen && (waddr == 11'h124);

wire csr_diagram_7_4_ren;
assign csr_diagram_7_4_ren = ren && (raddr == 11'h124);
reg csr_diagram_7_4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_4_ren_ff <= 1'b0;
    end else begin
        csr_diagram_7_4_ren_ff <= csr_diagram_7_4_ren;
    end
end
//---------------------
// Bit field:
// diagram_7_4[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_4_real_ff;

assign csr_diagram_7_4_rdata[15:0] = csr_diagram_7_4_real_ff;

assign csr_diagram_7_4_real_out = csr_diagram_7_4_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_4_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_4_wen) begin
            if (wstrb[0]) begin
                csr_diagram_7_4_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_7_4_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_7_4_real_ff <= csr_diagram_7_4_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_7_4[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_4_imag_ff;

assign csr_diagram_7_4_rdata[31:16] = csr_diagram_7_4_imag_ff;

assign csr_diagram_7_4_imag_out = csr_diagram_7_4_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_4_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_4_wen) begin
            if (wstrb[2]) begin
                csr_diagram_7_4_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_7_4_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_7_4_imag_ff <= csr_diagram_7_4_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x128] - diagram_7_5 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_7_5_rdata;

wire csr_diagram_7_5_wen;
assign csr_diagram_7_5_wen = wen && (waddr == 11'h128);

wire csr_diagram_7_5_ren;
assign csr_diagram_7_5_ren = ren && (raddr == 11'h128);
reg csr_diagram_7_5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_5_ren_ff <= 1'b0;
    end else begin
        csr_diagram_7_5_ren_ff <= csr_diagram_7_5_ren;
    end
end
//---------------------
// Bit field:
// diagram_7_5[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_5_real_ff;

assign csr_diagram_7_5_rdata[15:0] = csr_diagram_7_5_real_ff;

assign csr_diagram_7_5_real_out = csr_diagram_7_5_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_5_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_5_wen) begin
            if (wstrb[0]) begin
                csr_diagram_7_5_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_7_5_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_7_5_real_ff <= csr_diagram_7_5_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_7_5[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_5_imag_ff;

assign csr_diagram_7_5_rdata[31:16] = csr_diagram_7_5_imag_ff;

assign csr_diagram_7_5_imag_out = csr_diagram_7_5_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_5_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_5_wen) begin
            if (wstrb[2]) begin
                csr_diagram_7_5_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_7_5_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_7_5_imag_ff <= csr_diagram_7_5_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x12c] - diagram_7_6 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_7_6_rdata;

wire csr_diagram_7_6_wen;
assign csr_diagram_7_6_wen = wen && (waddr == 11'h12c);

wire csr_diagram_7_6_ren;
assign csr_diagram_7_6_ren = ren && (raddr == 11'h12c);
reg csr_diagram_7_6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_6_ren_ff <= 1'b0;
    end else begin
        csr_diagram_7_6_ren_ff <= csr_diagram_7_6_ren;
    end
end
//---------------------
// Bit field:
// diagram_7_6[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_6_real_ff;

assign csr_diagram_7_6_rdata[15:0] = csr_diagram_7_6_real_ff;

assign csr_diagram_7_6_real_out = csr_diagram_7_6_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_6_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_6_wen) begin
            if (wstrb[0]) begin
                csr_diagram_7_6_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_7_6_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_7_6_real_ff <= csr_diagram_7_6_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_7_6[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_6_imag_ff;

assign csr_diagram_7_6_rdata[31:16] = csr_diagram_7_6_imag_ff;

assign csr_diagram_7_6_imag_out = csr_diagram_7_6_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_6_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_6_wen) begin
            if (wstrb[2]) begin
                csr_diagram_7_6_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_7_6_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_7_6_imag_ff <= csr_diagram_7_6_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x130] - diagram_7_7 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_7_7_rdata;

wire csr_diagram_7_7_wen;
assign csr_diagram_7_7_wen = wen && (waddr == 11'h130);

wire csr_diagram_7_7_ren;
assign csr_diagram_7_7_ren = ren && (raddr == 11'h130);
reg csr_diagram_7_7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_7_ren_ff <= 1'b0;
    end else begin
        csr_diagram_7_7_ren_ff <= csr_diagram_7_7_ren;
    end
end
//---------------------
// Bit field:
// diagram_7_7[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_7_real_ff;

assign csr_diagram_7_7_rdata[15:0] = csr_diagram_7_7_real_ff;

assign csr_diagram_7_7_real_out = csr_diagram_7_7_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_7_real_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_7_wen) begin
            if (wstrb[0]) begin
                csr_diagram_7_7_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_7_7_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_diagram_7_7_real_ff <= csr_diagram_7_7_real_ff;
        end
    end
end


//---------------------
// Bit field:
// diagram_7_7[31:16] - imag - Imaginary part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_diagram_7_7_imag_ff;

assign csr_diagram_7_7_rdata[31:16] = csr_diagram_7_7_imag_ff;

assign csr_diagram_7_7_imag_out = csr_diagram_7_7_imag_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_7_7_imag_ff <= 16'h0;
    end else  begin
     if (csr_diagram_7_7_wen) begin
            if (wstrb[2]) begin
                csr_diagram_7_7_imag_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_7_7_imag_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_diagram_7_7_imag_ff <= csr_diagram_7_7_imag_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x134] - motion_selector - 
//------------------------------------------------------------------------------
wire [31:0] csr_motion_selector_rdata;
assign csr_motion_selector_rdata[31:9] = 23'h0;

wire csr_motion_selector_wen;
assign csr_motion_selector_wen = wen && (waddr == 11'h134);

wire csr_motion_selector_ren;
assign csr_motion_selector_ren = ren && (raddr == 11'h134);
reg csr_motion_selector_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_motion_selector_ren_ff <= 1'b0;
    end else begin
        csr_motion_selector_ren_ff <= csr_motion_selector_ren;
    end
end
//---------------------
// Bit field:
// motion_selector[7:0] - filter - Motion selector filter control
// access: rw, hardware: o
//---------------------
reg [7:0] csr_motion_selector_filter_ff;

assign csr_motion_selector_rdata[7:0] = csr_motion_selector_filter_ff;

assign csr_motion_selector_filter_out = csr_motion_selector_filter_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_motion_selector_filter_ff <= 8'h0;
    end else  begin
     if (csr_motion_selector_wen) begin
            if (wstrb[0]) begin
                csr_motion_selector_filter_ff[7:0] <= wdata[7:0];
            end
        end else begin
            csr_motion_selector_filter_ff <= csr_motion_selector_filter_ff;
        end
    end
end


//---------------------
// Bit field:
// motion_selector[8] - onoff - Motion selector on/off
// access: rw, hardware: o
//---------------------
reg  csr_motion_selector_onoff_ff;

assign csr_motion_selector_rdata[8] = csr_motion_selector_onoff_ff;

assign csr_motion_selector_onoff_out = csr_motion_selector_onoff_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_motion_selector_onoff_ff <= 1'b0;
    end else  begin
     if (csr_motion_selector_wen) begin
            if (wstrb[1]) begin
                csr_motion_selector_onoff_ff <= wdata[8];
            end
        end else begin
            csr_motion_selector_onoff_ff <= csr_motion_selector_onoff_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x138] - diagram_angle_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_angle_0_rdata;

wire csr_diagram_angle_0_wen;
assign csr_diagram_angle_0_wen = wen && (waddr == 11'h138);

wire csr_diagram_angle_0_ren;
assign csr_diagram_angle_0_ren = ren && (raddr == 11'h138);
reg csr_diagram_angle_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_0_ren_ff <= 1'b0;
    end else begin
        csr_diagram_angle_0_ren_ff <= csr_diagram_angle_0_ren;
    end
end
//---------------------
// Bit field:
// diagram_angle_0[31:0] - angle - 2**32 = 2 pi
// access: rw, hardware: o
//---------------------
reg [31:0] csr_diagram_angle_0_angle_ff;

assign csr_diagram_angle_0_rdata[31:0] = csr_diagram_angle_0_angle_ff;

assign csr_diagram_angle_0_angle_out = csr_diagram_angle_0_angle_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_0_angle_ff <= 32'h0;
    end else  begin
     if (csr_diagram_angle_0_wen) begin
            if (wstrb[0]) begin
                csr_diagram_angle_0_angle_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_angle_0_angle_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_diagram_angle_0_angle_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_angle_0_angle_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_diagram_angle_0_angle_ff <= csr_diagram_angle_0_angle_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x13c] - diagram_angle_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_angle_1_rdata;

wire csr_diagram_angle_1_wen;
assign csr_diagram_angle_1_wen = wen && (waddr == 11'h13c);

wire csr_diagram_angle_1_ren;
assign csr_diagram_angle_1_ren = ren && (raddr == 11'h13c);
reg csr_diagram_angle_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_1_ren_ff <= 1'b0;
    end else begin
        csr_diagram_angle_1_ren_ff <= csr_diagram_angle_1_ren;
    end
end
//---------------------
// Bit field:
// diagram_angle_1[31:0] - angle - 2**32 = 2 pi
// access: rw, hardware: o
//---------------------
reg [31:0] csr_diagram_angle_1_angle_ff;

assign csr_diagram_angle_1_rdata[31:0] = csr_diagram_angle_1_angle_ff;

assign csr_diagram_angle_1_angle_out = csr_diagram_angle_1_angle_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_1_angle_ff <= 32'h0;
    end else  begin
     if (csr_diagram_angle_1_wen) begin
            if (wstrb[0]) begin
                csr_diagram_angle_1_angle_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_angle_1_angle_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_diagram_angle_1_angle_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_angle_1_angle_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_diagram_angle_1_angle_ff <= csr_diagram_angle_1_angle_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x140] - diagram_angle_2 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_angle_2_rdata;

wire csr_diagram_angle_2_wen;
assign csr_diagram_angle_2_wen = wen && (waddr == 11'h140);

wire csr_diagram_angle_2_ren;
assign csr_diagram_angle_2_ren = ren && (raddr == 11'h140);
reg csr_diagram_angle_2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_2_ren_ff <= 1'b0;
    end else begin
        csr_diagram_angle_2_ren_ff <= csr_diagram_angle_2_ren;
    end
end
//---------------------
// Bit field:
// diagram_angle_2[31:0] - angle - 2**32 = 2 pi
// access: rw, hardware: o
//---------------------
reg [31:0] csr_diagram_angle_2_angle_ff;

assign csr_diagram_angle_2_rdata[31:0] = csr_diagram_angle_2_angle_ff;

assign csr_diagram_angle_2_angle_out = csr_diagram_angle_2_angle_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_2_angle_ff <= 32'h0;
    end else  begin
     if (csr_diagram_angle_2_wen) begin
            if (wstrb[0]) begin
                csr_diagram_angle_2_angle_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_angle_2_angle_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_diagram_angle_2_angle_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_angle_2_angle_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_diagram_angle_2_angle_ff <= csr_diagram_angle_2_angle_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x144] - diagram_angle_3 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_angle_3_rdata;

wire csr_diagram_angle_3_wen;
assign csr_diagram_angle_3_wen = wen && (waddr == 11'h144);

wire csr_diagram_angle_3_ren;
assign csr_diagram_angle_3_ren = ren && (raddr == 11'h144);
reg csr_diagram_angle_3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_3_ren_ff <= 1'b0;
    end else begin
        csr_diagram_angle_3_ren_ff <= csr_diagram_angle_3_ren;
    end
end
//---------------------
// Bit field:
// diagram_angle_3[31:0] - angle - 2**32 = 2 pi
// access: rw, hardware: o
//---------------------
reg [31:0] csr_diagram_angle_3_angle_ff;

assign csr_diagram_angle_3_rdata[31:0] = csr_diagram_angle_3_angle_ff;

assign csr_diagram_angle_3_angle_out = csr_diagram_angle_3_angle_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_3_angle_ff <= 32'h0;
    end else  begin
     if (csr_diagram_angle_3_wen) begin
            if (wstrb[0]) begin
                csr_diagram_angle_3_angle_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_angle_3_angle_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_diagram_angle_3_angle_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_angle_3_angle_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_diagram_angle_3_angle_ff <= csr_diagram_angle_3_angle_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x148] - diagram_angle_4 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_angle_4_rdata;

wire csr_diagram_angle_4_wen;
assign csr_diagram_angle_4_wen = wen && (waddr == 11'h148);

wire csr_diagram_angle_4_ren;
assign csr_diagram_angle_4_ren = ren && (raddr == 11'h148);
reg csr_diagram_angle_4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_4_ren_ff <= 1'b0;
    end else begin
        csr_diagram_angle_4_ren_ff <= csr_diagram_angle_4_ren;
    end
end
//---------------------
// Bit field:
// diagram_angle_4[31:0] - angle - 2**32 = 2 pi
// access: rw, hardware: o
//---------------------
reg [31:0] csr_diagram_angle_4_angle_ff;

assign csr_diagram_angle_4_rdata[31:0] = csr_diagram_angle_4_angle_ff;

assign csr_diagram_angle_4_angle_out = csr_diagram_angle_4_angle_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_4_angle_ff <= 32'h0;
    end else  begin
     if (csr_diagram_angle_4_wen) begin
            if (wstrb[0]) begin
                csr_diagram_angle_4_angle_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_angle_4_angle_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_diagram_angle_4_angle_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_angle_4_angle_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_diagram_angle_4_angle_ff <= csr_diagram_angle_4_angle_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x14c] - diagram_angle_5 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_angle_5_rdata;

wire csr_diagram_angle_5_wen;
assign csr_diagram_angle_5_wen = wen && (waddr == 11'h14c);

wire csr_diagram_angle_5_ren;
assign csr_diagram_angle_5_ren = ren && (raddr == 11'h14c);
reg csr_diagram_angle_5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_5_ren_ff <= 1'b0;
    end else begin
        csr_diagram_angle_5_ren_ff <= csr_diagram_angle_5_ren;
    end
end
//---------------------
// Bit field:
// diagram_angle_5[31:0] - angle - 2**32 = 2 pi
// access: rw, hardware: o
//---------------------
reg [31:0] csr_diagram_angle_5_angle_ff;

assign csr_diagram_angle_5_rdata[31:0] = csr_diagram_angle_5_angle_ff;

assign csr_diagram_angle_5_angle_out = csr_diagram_angle_5_angle_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_5_angle_ff <= 32'h0;
    end else  begin
     if (csr_diagram_angle_5_wen) begin
            if (wstrb[0]) begin
                csr_diagram_angle_5_angle_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_angle_5_angle_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_diagram_angle_5_angle_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_angle_5_angle_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_diagram_angle_5_angle_ff <= csr_diagram_angle_5_angle_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x150] - diagram_angle_6 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_angle_6_rdata;

wire csr_diagram_angle_6_wen;
assign csr_diagram_angle_6_wen = wen && (waddr == 11'h150);

wire csr_diagram_angle_6_ren;
assign csr_diagram_angle_6_ren = ren && (raddr == 11'h150);
reg csr_diagram_angle_6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_6_ren_ff <= 1'b0;
    end else begin
        csr_diagram_angle_6_ren_ff <= csr_diagram_angle_6_ren;
    end
end
//---------------------
// Bit field:
// diagram_angle_6[31:0] - angle - 2**32 = 2 pi
// access: rw, hardware: o
//---------------------
reg [31:0] csr_diagram_angle_6_angle_ff;

assign csr_diagram_angle_6_rdata[31:0] = csr_diagram_angle_6_angle_ff;

assign csr_diagram_angle_6_angle_out = csr_diagram_angle_6_angle_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_6_angle_ff <= 32'h0;
    end else  begin
     if (csr_diagram_angle_6_wen) begin
            if (wstrb[0]) begin
                csr_diagram_angle_6_angle_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_angle_6_angle_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_diagram_angle_6_angle_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_angle_6_angle_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_diagram_angle_6_angle_ff <= csr_diagram_angle_6_angle_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x154] - diagram_angle_7 - 
//------------------------------------------------------------------------------
wire [31:0] csr_diagram_angle_7_rdata;

wire csr_diagram_angle_7_wen;
assign csr_diagram_angle_7_wen = wen && (waddr == 11'h154);

wire csr_diagram_angle_7_ren;
assign csr_diagram_angle_7_ren = ren && (raddr == 11'h154);
reg csr_diagram_angle_7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_7_ren_ff <= 1'b0;
    end else begin
        csr_diagram_angle_7_ren_ff <= csr_diagram_angle_7_ren;
    end
end
//---------------------
// Bit field:
// diagram_angle_7[31:0] - angle - 2**32 = 2 pi
// access: rw, hardware: o
//---------------------
reg [31:0] csr_diagram_angle_7_angle_ff;

assign csr_diagram_angle_7_rdata[31:0] = csr_diagram_angle_7_angle_ff;

assign csr_diagram_angle_7_angle_out = csr_diagram_angle_7_angle_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_diagram_angle_7_angle_ff <= 32'h0;
    end else  begin
     if (csr_diagram_angle_7_wen) begin
            if (wstrb[0]) begin
                csr_diagram_angle_7_angle_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_diagram_angle_7_angle_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_diagram_angle_7_angle_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_diagram_angle_7_angle_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_diagram_angle_7_angle_ff <= csr_diagram_angle_7_angle_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x158] - output_source - 
//------------------------------------------------------------------------------
wire [31:0] csr_output_source_rdata;

wire csr_output_source_wen;
assign csr_output_source_wen = wen && (waddr == 11'h158);

wire csr_output_source_ren;
assign csr_output_source_ren = ren && (raddr == 11'h158);
reg csr_output_source_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_output_source_ren_ff <= 1'b0;
    end else begin
        csr_output_source_ren_ff <= csr_output_source_ren;
    end
end
//---------------------
// Bit field:
// output_source[15:0] - source - Source for output data
// access: rw, hardware: o
//---------------------
reg [15:0] csr_output_source_source_ff;

assign csr_output_source_rdata[15:0] = csr_output_source_source_ff;

assign csr_output_source_source_out = csr_output_source_source_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_output_source_source_ff <= 16'h0;
    end else  begin
     if (csr_output_source_wen) begin
            if (wstrb[0]) begin
                csr_output_source_source_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_output_source_source_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_output_source_source_ff <= csr_output_source_source_ff;
        end
    end
end


//---------------------
// Bit field:
// output_source[31:16] - source_channel - Source channel for output data (if exists)
// access: rw, hardware: o
//---------------------
reg [15:0] csr_output_source_source_channel_ff;

assign csr_output_source_rdata[31:16] = csr_output_source_source_channel_ff;

assign csr_output_source_source_channel_out = csr_output_source_source_channel_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_output_source_source_channel_ff <= 16'h0;
    end else  begin
     if (csr_output_source_wen) begin
            if (wstrb[2]) begin
                csr_output_source_source_channel_ff[7:0] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_output_source_source_channel_ff[15:8] <= wdata[31:24];
            end
        end else begin
            csr_output_source_source_channel_ff <= csr_output_source_source_channel_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x15c] - apu_rank - 
//------------------------------------------------------------------------------
wire [31:0] csr_apu_rank_rdata;
assign csr_apu_rank_rdata[31:16] = 16'h0;

wire csr_apu_rank_wen;
assign csr_apu_rank_wen = wen && (waddr == 11'h15c);

wire csr_apu_rank_ren;
assign csr_apu_rank_ren = ren && (raddr == 11'h15c);
reg csr_apu_rank_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_apu_rank_ren_ff <= 1'b0;
    end else begin
        csr_apu_rank_ren_ff <= csr_apu_rank_ren;
    end
end
//---------------------
// Bit field:
// apu_rank[7:0] - rank - rank for APU
// access: rw, hardware: o
//---------------------
reg [7:0] csr_apu_rank_rank_ff;

assign csr_apu_rank_rdata[7:0] = csr_apu_rank_rank_ff;

assign csr_apu_rank_rank_out = csr_apu_rank_rank_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_apu_rank_rank_ff <= 8'h0;
    end else  begin
     if (csr_apu_rank_wen) begin
            if (wstrb[0]) begin
                csr_apu_rank_rank_ff[7:0] <= wdata[7:0];
            end
        end else begin
            csr_apu_rank_rank_ff <= csr_apu_rank_rank_ff;
        end
    end
end


//---------------------
// Bit field:
// apu_rank[15:8] - window - window length
// access: rw, hardware: o
//---------------------
reg [7:0] csr_apu_rank_window_ff;

assign csr_apu_rank_rdata[15:8] = csr_apu_rank_window_ff;

assign csr_apu_rank_window_out = csr_apu_rank_window_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_apu_rank_window_ff <= 8'h0;
    end else  begin
     if (csr_apu_rank_wen) begin
            if (wstrb[1]) begin
                csr_apu_rank_window_ff[7:0] <= wdata[15:8];
            end
        end else begin
            csr_apu_rank_window_ff <= csr_apu_rank_window_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x160] - detector_level_0 - 
//------------------------------------------------------------------------------
wire [31:0] csr_detector_level_0_rdata;

wire csr_detector_level_0_wen;
assign csr_detector_level_0_wen = wen && (waddr == 11'h160);

wire csr_detector_level_0_ren;
assign csr_detector_level_0_ren = ren && (raddr == 11'h160);
reg csr_detector_level_0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_detector_level_0_ren_ff <= 1'b0;
    end else begin
        csr_detector_level_0_ren_ff <= csr_detector_level_0_ren;
    end
end
//---------------------
// Bit field:
// detector_level_0[31:0] - level - detector comparation level
// access: rw, hardware: o
//---------------------
reg [31:0] csr_detector_level_0_level_ff;

assign csr_detector_level_0_rdata[31:0] = csr_detector_level_0_level_ff;

assign csr_detector_level_0_level_out = csr_detector_level_0_level_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_detector_level_0_level_ff <= 32'h0;
    end else  begin
     if (csr_detector_level_0_wen) begin
            if (wstrb[0]) begin
                csr_detector_level_0_level_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_detector_level_0_level_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_detector_level_0_level_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_detector_level_0_level_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_detector_level_0_level_ff <= csr_detector_level_0_level_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x164] - detector_level_1 - 
//------------------------------------------------------------------------------
wire [31:0] csr_detector_level_1_rdata;

wire csr_detector_level_1_wen;
assign csr_detector_level_1_wen = wen && (waddr == 11'h164);

wire csr_detector_level_1_ren;
assign csr_detector_level_1_ren = ren && (raddr == 11'h164);
reg csr_detector_level_1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_detector_level_1_ren_ff <= 1'b0;
    end else begin
        csr_detector_level_1_ren_ff <= csr_detector_level_1_ren;
    end
end
//---------------------
// Bit field:
// detector_level_1[31:0] - level - detector comparation level
// access: rw, hardware: o
//---------------------
reg [31:0] csr_detector_level_1_level_ff;

assign csr_detector_level_1_rdata[31:0] = csr_detector_level_1_level_ff;

assign csr_detector_level_1_level_out = csr_detector_level_1_level_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_detector_level_1_level_ff <= 32'h0;
    end else  begin
     if (csr_detector_level_1_wen) begin
            if (wstrb[0]) begin
                csr_detector_level_1_level_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_detector_level_1_level_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_detector_level_1_level_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_detector_level_1_level_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_detector_level_1_level_ff <= csr_detector_level_1_level_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x168] - azimuth_angle - 
//------------------------------------------------------------------------------
wire [31:0] csr_azimuth_angle_rdata;

wire csr_azimuth_angle_wen;
assign csr_azimuth_angle_wen = wen && (waddr == 11'h168);

wire csr_azimuth_angle_ren;
assign csr_azimuth_angle_ren = ren && (raddr == 11'h168);
reg csr_azimuth_angle_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_azimuth_angle_ren_ff <= 1'b0;
    end else begin
        csr_azimuth_angle_ren_ff <= csr_azimuth_angle_ren;
    end
end
//---------------------
// Bit field:
// azimuth_angle[31:0] - angle - 2**32 = 2 pi
// access: rw, hardware: o
//---------------------
reg [31:0] csr_azimuth_angle_angle_ff;

assign csr_azimuth_angle_rdata[31:0] = csr_azimuth_angle_angle_ff;

assign csr_azimuth_angle_angle_out = csr_azimuth_angle_angle_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_azimuth_angle_angle_ff <= 32'h0;
    end else  begin
     if (csr_azimuth_angle_wen) begin
            if (wstrb[0]) begin
                csr_azimuth_angle_angle_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_azimuth_angle_angle_ff[15:8] <= wdata[15:8];
            end
            if (wstrb[2]) begin
                csr_azimuth_angle_angle_ff[23:16] <= wdata[23:16];
            end
            if (wstrb[3]) begin
                csr_azimuth_angle_angle_ff[31:24] <= wdata[31:24];
            end
        end else begin
            csr_azimuth_angle_angle_ff <= csr_azimuth_angle_angle_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x16c] - apply - 
//------------------------------------------------------------------------------
wire [31:0] csr_apply_rdata;
assign csr_apply_rdata[31:1] = 31'h0;

wire csr_apply_wen;
assign csr_apply_wen = wen && (waddr == 11'h16c);

wire csr_apply_ren;
assign csr_apply_ren = ren && (raddr == 11'h16c);
reg csr_apply_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_apply_ren_ff <= 1'b0;
    end else begin
        csr_apply_ren_ff <= csr_apply_ren;
    end
end
//---------------------
// Bit field:
// apply[0] - apply - XOR to apply reg changes
// access: rw, hardware: o
//---------------------
reg  csr_apply_apply_ff;

assign csr_apply_rdata[0] = csr_apply_apply_ff;

assign csr_apply_apply_out = csr_apply_apply_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_apply_apply_ff <= 1'b0;
        o_apply <= 0;
    end else  begin
     if (csr_apply_wen) begin
            if (wstrb[0]) begin
                csr_apply_apply_ff <= wdata[0];
                o_apply <= 1;
            end
        end else begin
            o_apply <= 0;
            csr_apply_apply_ff <= csr_apply_apply_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x170] - compensation_reference - 
//------------------------------------------------------------------------------
wire [31:0] csr_compensation_reference_rdata;
assign csr_compensation_reference_rdata[31:16] = 16'h0;

wire csr_compensation_reference_wen;
assign csr_compensation_reference_wen = wen && (waddr == 11'h170);

wire csr_compensation_reference_ren;
assign csr_compensation_reference_ren = ren && (raddr == 11'h170);
reg csr_compensation_reference_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_compensation_reference_ren_ff <= 1'b0;
    end else begin
        csr_compensation_reference_ren_ff <= csr_compensation_reference_ren;
    end
end
//---------------------
// Bit field:
// compensation_reference[15:0] - real - Real part, signed 2s complement, 2**14 = 1.0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_compensation_reference_real_ff;

assign csr_compensation_reference_rdata[15:0] = csr_compensation_reference_real_ff;

assign csr_compensation_reference_real_out = csr_compensation_reference_real_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_compensation_reference_real_ff <= 16'h0;
    end else  begin
     if (csr_compensation_reference_wen) begin
            if (wstrb[0]) begin
                csr_compensation_reference_real_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_compensation_reference_real_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_compensation_reference_real_ff <= csr_compensation_reference_real_ff;
        end
    end
end


//------------------------------------------------------------------------------
// Write ready
//------------------------------------------------------------------------------
assign wready = 1'b1;

//------------------------------------------------------------------------------
// Read address decoder
//------------------------------------------------------------------------------
reg [31:0] rdata_ff;
always @(posedge clk) begin
    if (!rst) begin
        rdata_ff <= 32'h0;
    end else if (ren) begin
        case (raddr)
            11'h0: rdata_ff <= csr_ip_ver_rdata;
            11'h4: rdata_ff <= csr_kill_rdata;
            11'h8: rdata_ff <= csr_test_point_rdata;
            11'hc: rdata_ff <= csr_channel_rdata;
            11'h10: rdata_ff <= csr_compensation_mode_rdata;
            11'h14: rdata_ff <= csr_manual_compensation_0_rdata;
            11'h18: rdata_ff <= csr_manual_compensation_1_rdata;
            11'h1c: rdata_ff <= csr_manual_compensation_2_rdata;
            11'h20: rdata_ff <= csr_manual_compensation_3_rdata;
            11'h24: rdata_ff <= csr_manual_compensation_4_rdata;
            11'h28: rdata_ff <= csr_manual_compensation_5_rdata;
            11'h2c: rdata_ff <= csr_manual_compensation_6_rdata;
            11'h30: rdata_ff <= csr_manual_compensation_7_rdata;
            11'h34: rdata_ff <= csr_diagram_0_0_rdata;
            11'h38: rdata_ff <= csr_diagram_0_1_rdata;
            11'h3c: rdata_ff <= csr_diagram_0_2_rdata;
            11'h40: rdata_ff <= csr_diagram_0_3_rdata;
            11'h44: rdata_ff <= csr_diagram_0_4_rdata;
            11'h48: rdata_ff <= csr_diagram_0_5_rdata;
            11'h4c: rdata_ff <= csr_diagram_0_6_rdata;
            11'h50: rdata_ff <= csr_diagram_0_7_rdata;
            11'h54: rdata_ff <= csr_diagram_1_0_rdata;
            11'h58: rdata_ff <= csr_diagram_1_1_rdata;
            11'h5c: rdata_ff <= csr_diagram_1_2_rdata;
            11'h60: rdata_ff <= csr_diagram_1_3_rdata;
            11'h64: rdata_ff <= csr_diagram_1_4_rdata;
            11'h68: rdata_ff <= csr_diagram_1_5_rdata;
            11'h6c: rdata_ff <= csr_diagram_1_6_rdata;
            11'h70: rdata_ff <= csr_diagram_1_7_rdata;
            11'h74: rdata_ff <= csr_diagram_2_0_rdata;
            11'h78: rdata_ff <= csr_diagram_2_1_rdata;
            11'h7c: rdata_ff <= csr_diagram_2_2_rdata;
            11'h80: rdata_ff <= csr_diagram_2_3_rdata;
            11'h84: rdata_ff <= csr_diagram_2_4_rdata;
            11'h88: rdata_ff <= csr_diagram_2_5_rdata;
            11'h8c: rdata_ff <= csr_diagram_2_6_rdata;
            11'h90: rdata_ff <= csr_diagram_2_7_rdata;
            11'h94: rdata_ff <= csr_diagram_3_0_rdata;
            11'h98: rdata_ff <= csr_diagram_3_1_rdata;
            11'h9c: rdata_ff <= csr_diagram_3_2_rdata;
            11'ha0: rdata_ff <= csr_diagram_3_3_rdata;
            11'ha4: rdata_ff <= csr_diagram_3_4_rdata;
            11'ha8: rdata_ff <= csr_diagram_3_5_rdata;
            11'hac: rdata_ff <= csr_diagram_3_6_rdata;
            11'hb0: rdata_ff <= csr_diagram_3_7_rdata;
            11'hb4: rdata_ff <= csr_diagram_4_0_rdata;
            11'hb8: rdata_ff <= csr_diagram_4_1_rdata;
            11'hbc: rdata_ff <= csr_diagram_4_2_rdata;
            11'hc0: rdata_ff <= csr_diagram_4_3_rdata;
            11'hc4: rdata_ff <= csr_diagram_4_4_rdata;
            11'hc8: rdata_ff <= csr_diagram_4_5_rdata;
            11'hcc: rdata_ff <= csr_diagram_4_6_rdata;
            11'hd0: rdata_ff <= csr_diagram_4_7_rdata;
            11'hd4: rdata_ff <= csr_diagram_5_0_rdata;
            11'hd8: rdata_ff <= csr_diagram_5_1_rdata;
            11'hdc: rdata_ff <= csr_diagram_5_2_rdata;
            11'he0: rdata_ff <= csr_diagram_5_3_rdata;
            11'he4: rdata_ff <= csr_diagram_5_4_rdata;
            11'he8: rdata_ff <= csr_diagram_5_5_rdata;
            11'hec: rdata_ff <= csr_diagram_5_6_rdata;
            11'hf0: rdata_ff <= csr_diagram_5_7_rdata;
            11'hf4: rdata_ff <= csr_diagram_6_0_rdata;
            11'hf8: rdata_ff <= csr_diagram_6_1_rdata;
            11'hfc: rdata_ff <= csr_diagram_6_2_rdata;
            11'h100: rdata_ff <= csr_diagram_6_3_rdata;
            11'h104: rdata_ff <= csr_diagram_6_4_rdata;
            11'h108: rdata_ff <= csr_diagram_6_5_rdata;
            11'h10c: rdata_ff <= csr_diagram_6_6_rdata;
            11'h110: rdata_ff <= csr_diagram_6_7_rdata;
            11'h114: rdata_ff <= csr_diagram_7_0_rdata;
            11'h118: rdata_ff <= csr_diagram_7_1_rdata;
            11'h11c: rdata_ff <= csr_diagram_7_2_rdata;
            11'h120: rdata_ff <= csr_diagram_7_3_rdata;
            11'h124: rdata_ff <= csr_diagram_7_4_rdata;
            11'h128: rdata_ff <= csr_diagram_7_5_rdata;
            11'h12c: rdata_ff <= csr_diagram_7_6_rdata;
            11'h130: rdata_ff <= csr_diagram_7_7_rdata;
            11'h134: rdata_ff <= csr_motion_selector_rdata;
            11'h138: rdata_ff <= csr_diagram_angle_0_rdata;
            11'h13c: rdata_ff <= csr_diagram_angle_1_rdata;
            11'h140: rdata_ff <= csr_diagram_angle_2_rdata;
            11'h144: rdata_ff <= csr_diagram_angle_3_rdata;
            11'h148: rdata_ff <= csr_diagram_angle_4_rdata;
            11'h14c: rdata_ff <= csr_diagram_angle_5_rdata;
            11'h150: rdata_ff <= csr_diagram_angle_6_rdata;
            11'h154: rdata_ff <= csr_diagram_angle_7_rdata;
            11'h158: rdata_ff <= csr_output_source_rdata;
            11'h15c: rdata_ff <= csr_apu_rank_rdata;
            11'h160: rdata_ff <= csr_detector_level_0_rdata;
            11'h164: rdata_ff <= csr_detector_level_1_rdata;
            11'h168: rdata_ff <= csr_azimuth_angle_rdata;
            11'h16c: rdata_ff <= csr_apply_rdata;
            11'h170: rdata_ff <= csr_compensation_reference_rdata;
            default: rdata_ff <= 32'h0;
        endcase
    end else begin
        rdata_ff <= 32'h0;
    end
end
assign rdata = rdata_ff;

//------------------------------------------------------------------------------
// Read data valid
//------------------------------------------------------------------------------
reg rvalid_ff;
always @(posedge clk) begin
    if (!rst) begin
        rvalid_ff <= 1'b0;
    end else if (ren && rvalid) begin
        rvalid_ff <= 1'b0;
    end else if (ren) begin
        rvalid_ff <= 1'b1;
    end
end

assign rvalid = rvalid_ff;

endmodule