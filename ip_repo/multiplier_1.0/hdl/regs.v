// Created with Corsair v1.0.4

module regs #(
    parameter ADDR_W = 11,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(
    // System
    input clk,
    input rst,
    // ip_ver.min_ver
    // ip_ver.maj_ver

    // kill.kill
    output  csr_kill_kill_out,

    // test_point.test_point
    output [2:0] csr_test_point_test_point_out,

    // channel.test_point
    output [2:0] csr_channel_test_point_out,

    // mult0.mult0
    output [15:0] csr_mult0_mult0_out,

    // mult1.mult1
    output [15:0] csr_mult1_mult1_out,

    // mult2.mult2
    output [15:0] csr_mult2_mult2_out,

    // mult3.mult3
    output [15:0] csr_mult3_mult3_out,

    // mult4.mult4
    output [15:0] csr_mult4_mult4_out,

    // mult5.mult5
    output [15:0] csr_mult5_mult5_out,

    // mult6.mult6
    output [15:0] csr_mult6_mult6_out,

    // mult7.mult7
    output [15:0] csr_mult7_mult7_out,

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
        csr_ip_ver_min_ver_ff <= 16'h1;
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
        csr_ip_ver_maj_ver_ff <= 16'h1;
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
    end else  begin
     if (csr_kill_wen) begin
            if (wstrb[0]) begin
                csr_kill_kill_ff <= wdata[0];
            end
        end else begin
            csr_kill_kill_ff <= csr_kill_kill_ff;
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
// [0x10] - mult0 - Multiplication value for ch0
//------------------------------------------------------------------------------
wire [31:0] csr_mult0_rdata;
assign csr_mult0_rdata[31:16] = 16'h0;

wire csr_mult0_wen;
assign csr_mult0_wen = wen && (waddr == 11'h10);

wire csr_mult0_ren;
assign csr_mult0_ren = ren && (raddr == 11'h10);
reg csr_mult0_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_mult0_ren_ff <= 1'b0;
    end else begin
        csr_mult0_ren_ff <= csr_mult0_ren;
    end
end
//---------------------
// Bit field:
// mult0[15:0] - mult0 - Multiplication value for ch0
// access: rw, hardware: o
//---------------------
reg [15:0] csr_mult0_mult0_ff;

assign csr_mult0_rdata[15:0] = csr_mult0_mult0_ff;

assign csr_mult0_mult0_out = csr_mult0_mult0_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_mult0_mult0_ff <= 16'h0;
    end else  begin
     if (csr_mult0_wen) begin
            if (wstrb[0]) begin
                csr_mult0_mult0_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_mult0_mult0_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_mult0_mult0_ff <= csr_mult0_mult0_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x14] - mult1 - Multiplication value for ch1
//------------------------------------------------------------------------------
wire [31:0] csr_mult1_rdata;
assign csr_mult1_rdata[31:16] = 16'h0;

wire csr_mult1_wen;
assign csr_mult1_wen = wen && (waddr == 11'h14);

wire csr_mult1_ren;
assign csr_mult1_ren = ren && (raddr == 11'h14);
reg csr_mult1_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_mult1_ren_ff <= 1'b0;
    end else begin
        csr_mult1_ren_ff <= csr_mult1_ren;
    end
end
//---------------------
// Bit field:
// mult1[15:0] - mult1 - Multiplication value for ch1
// access: rw, hardware: o
//---------------------
reg [15:0] csr_mult1_mult1_ff;

assign csr_mult1_rdata[15:0] = csr_mult1_mult1_ff;

assign csr_mult1_mult1_out = csr_mult1_mult1_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_mult1_mult1_ff <= 16'h0;
    end else  begin
     if (csr_mult1_wen) begin
            if (wstrb[0]) begin
                csr_mult1_mult1_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_mult1_mult1_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_mult1_mult1_ff <= csr_mult1_mult1_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x18] - mult2 - Multiplication value for ch2
//------------------------------------------------------------------------------
wire [31:0] csr_mult2_rdata;
assign csr_mult2_rdata[31:16] = 16'h0;

wire csr_mult2_wen;
assign csr_mult2_wen = wen && (waddr == 11'h18);

wire csr_mult2_ren;
assign csr_mult2_ren = ren && (raddr == 11'h18);
reg csr_mult2_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_mult2_ren_ff <= 1'b0;
    end else begin
        csr_mult2_ren_ff <= csr_mult2_ren;
    end
end
//---------------------
// Bit field:
// mult2[15:0] - mult2 - Multiplication value for ch2
// access: rw, hardware: o
//---------------------
reg [15:0] csr_mult2_mult2_ff;

assign csr_mult2_rdata[15:0] = csr_mult2_mult2_ff;

assign csr_mult2_mult2_out = csr_mult2_mult2_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_mult2_mult2_ff <= 16'h0;
    end else  begin
     if (csr_mult2_wen) begin
            if (wstrb[0]) begin
                csr_mult2_mult2_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_mult2_mult2_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_mult2_mult2_ff <= csr_mult2_mult2_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x1c] - mult3 - Multiplication value for ch3
//------------------------------------------------------------------------------
wire [31:0] csr_mult3_rdata;
assign csr_mult3_rdata[31:16] = 16'h0;

wire csr_mult3_wen;
assign csr_mult3_wen = wen && (waddr == 11'h1c);

wire csr_mult3_ren;
assign csr_mult3_ren = ren && (raddr == 11'h1c);
reg csr_mult3_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_mult3_ren_ff <= 1'b0;
    end else begin
        csr_mult3_ren_ff <= csr_mult3_ren;
    end
end
//---------------------
// Bit field:
// mult3[15:0] - mult3 - Multiplication value for ch3
// access: rw, hardware: o
//---------------------
reg [15:0] csr_mult3_mult3_ff;

assign csr_mult3_rdata[15:0] = csr_mult3_mult3_ff;

assign csr_mult3_mult3_out = csr_mult3_mult3_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_mult3_mult3_ff <= 16'h0;
    end else  begin
     if (csr_mult3_wen) begin
            if (wstrb[0]) begin
                csr_mult3_mult3_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_mult3_mult3_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_mult3_mult3_ff <= csr_mult3_mult3_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x20] - mult4 - Multiplication value for ch4
//------------------------------------------------------------------------------
wire [31:0] csr_mult4_rdata;
assign csr_mult4_rdata[31:16] = 16'h0;

wire csr_mult4_wen;
assign csr_mult4_wen = wen && (waddr == 11'h20);

wire csr_mult4_ren;
assign csr_mult4_ren = ren && (raddr == 11'h20);
reg csr_mult4_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_mult4_ren_ff <= 1'b0;
    end else begin
        csr_mult4_ren_ff <= csr_mult4_ren;
    end
end
//---------------------
// Bit field:
// mult4[15:0] - mult4 - Multiplication value for ch4
// access: rw, hardware: o
//---------------------
reg [15:0] csr_mult4_mult4_ff;

assign csr_mult4_rdata[15:0] = csr_mult4_mult4_ff;

assign csr_mult4_mult4_out = csr_mult4_mult4_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_mult4_mult4_ff <= 16'h0;
    end else  begin
     if (csr_mult4_wen) begin
            if (wstrb[0]) begin
                csr_mult4_mult4_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_mult4_mult4_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_mult4_mult4_ff <= csr_mult4_mult4_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x24] - mult5 - Multiplication value for ch5
//------------------------------------------------------------------------------
wire [31:0] csr_mult5_rdata;
assign csr_mult5_rdata[31:16] = 16'h0;

wire csr_mult5_wen;
assign csr_mult5_wen = wen && (waddr == 11'h24);

wire csr_mult5_ren;
assign csr_mult5_ren = ren && (raddr == 11'h24);
reg csr_mult5_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_mult5_ren_ff <= 1'b0;
    end else begin
        csr_mult5_ren_ff <= csr_mult5_ren;
    end
end
//---------------------
// Bit field:
// mult5[15:0] - mult5 - Multiplication value for ch5
// access: rw, hardware: o
//---------------------
reg [15:0] csr_mult5_mult5_ff;

assign csr_mult5_rdata[15:0] = csr_mult5_mult5_ff;

assign csr_mult5_mult5_out = csr_mult5_mult5_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_mult5_mult5_ff <= 16'h0;
    end else  begin
     if (csr_mult5_wen) begin
            if (wstrb[0]) begin
                csr_mult5_mult5_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_mult5_mult5_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_mult5_mult5_ff <= csr_mult5_mult5_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x28] - mult6 - Multiplication value for ch6
//------------------------------------------------------------------------------
wire [31:0] csr_mult6_rdata;
assign csr_mult6_rdata[31:16] = 16'h0;

wire csr_mult6_wen;
assign csr_mult6_wen = wen && (waddr == 11'h28);

wire csr_mult6_ren;
assign csr_mult6_ren = ren && (raddr == 11'h28);
reg csr_mult6_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_mult6_ren_ff <= 1'b0;
    end else begin
        csr_mult6_ren_ff <= csr_mult6_ren;
    end
end
//---------------------
// Bit field:
// mult6[15:0] - mult6 - Multiplication value for ch6
// access: rw, hardware: o
//---------------------
reg [15:0] csr_mult6_mult6_ff;

assign csr_mult6_rdata[15:0] = csr_mult6_mult6_ff;

assign csr_mult6_mult6_out = csr_mult6_mult6_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_mult6_mult6_ff <= 16'h0;
    end else  begin
     if (csr_mult6_wen) begin
            if (wstrb[0]) begin
                csr_mult6_mult6_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_mult6_mult6_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_mult6_mult6_ff <= csr_mult6_mult6_ff;
        end
    end
end


//------------------------------------------------------------------------------
// CSR:
// [0x2c] - mult7 - Multiplication value for ch7
//------------------------------------------------------------------------------
wire [31:0] csr_mult7_rdata;
assign csr_mult7_rdata[31:16] = 16'h0;

wire csr_mult7_wen;
assign csr_mult7_wen = wen && (waddr == 11'h2c);

wire csr_mult7_ren;
assign csr_mult7_ren = ren && (raddr == 11'h2c);
reg csr_mult7_ren_ff;
always @(posedge clk) begin
    if (!rst) begin
        csr_mult7_ren_ff <= 1'b0;
    end else begin
        csr_mult7_ren_ff <= csr_mult7_ren;
    end
end
//---------------------
// Bit field:
// mult7[15:0] - mult7 - Multiplication value for ch7
// access: rw, hardware: o
//---------------------
reg [15:0] csr_mult7_mult7_ff;

assign csr_mult7_rdata[15:0] = csr_mult7_mult7_ff;

assign csr_mult7_mult7_out = csr_mult7_mult7_ff;

always @(posedge clk) begin
    if (!rst) begin
        csr_mult7_mult7_ff <= 16'h0;
    end else  begin
     if (csr_mult7_wen) begin
            if (wstrb[0]) begin
                csr_mult7_mult7_ff[7:0] <= wdata[7:0];
            end
            if (wstrb[1]) begin
                csr_mult7_mult7_ff[15:8] <= wdata[15:8];
            end
        end else begin
            csr_mult7_mult7_ff <= csr_mult7_mult7_ff;
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
            11'h10: rdata_ff <= csr_mult0_rdata;
            11'h14: rdata_ff <= csr_mult1_rdata;
            11'h18: rdata_ff <= csr_mult2_rdata;
            11'h1c: rdata_ff <= csr_mult3_rdata;
            11'h20: rdata_ff <= csr_mult4_rdata;
            11'h24: rdata_ff <= csr_mult5_rdata;
            11'h28: rdata_ff <= csr_mult6_rdata;
            11'h2c: rdata_ff <= csr_mult7_rdata;
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