
`timescale 1 ns / 1 ps

module multiplier_v1_0 #(parameter integer AXI_DATA_WIDTH	 = 32,
                         parameter integer AXI_ADDR_WIDTH	 = 4,
                         parameter integer DATA_WIDTH = 16,
                         parameter integer N_DATA_IN_PACK = 2,
                         parameter integer AXIS_TDATA_WIDTH	 = DATA_WIDTH * N_DATA_IN_PACK,
                         parameter integer MULT_WIDTH = 16,
                         parameter integer DSP_DELAY = 3,
                         parameter integer N_MULTS = 2)
                        ((* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn" *)
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
                         (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF M_AXIS:S00_AXIS:S01_AXIS, ASSOCIATED_RESET aresetn" *)
						 input wire aclk,
						 (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
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
						 input wire s01_axis_tvalid);
						 
	localparam integer IP_VER_MSB = 1;
	localparam integer IP_VER_LSB = 0;					 
    wire [MULT_WIDTH - 1 :0] mult[0 : N_MULTS - 1];
    wire [AXI_DATA_WIDTH - 1:0] ip_ver;
    wire kill;
    wire [2:0] test_point;
    wire [2:0] channel;

    assign ip_ver[AXI_DATA_WIDTH - 1 -: AXI_DATA_WIDTH/2] = IP_VER_MSB;
    assign ip_ver[AXI_DATA_WIDTH/2 - 1:0] = IP_VER_LSB;
    
    // Instantiation of Axi Bus Interface S00_AXI
    multiplier_v1_0_S00_AXI # (
    .C_S_AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .MULT_WIDTH(MULT_WIDTH)
    ) regmap (
    .mult0(mult[0]),
    .mult1(mult[1]),
    .ip_ver(ip_ver),
    .kill(kill),
    .test_point(test_point),
    .channel(channel),
    .S_AXI_ACLK(s00_axi_aclk),
    .S_AXI_ARESETN(s00_axi_aresetn),
    .S_AXI_AWADDR(s00_axi_awaddr),
    .S_AXI_AWPROT(s00_axi_awprot),
    .S_AXI_AWVALID(s00_axi_awvalid),
    .S_AXI_AWREADY(s00_axi_awready),
    .S_AXI_WDATA(s00_axi_wdata),
    .S_AXI_WSTRB(s00_axi_wstrb),
    .S_AXI_WVALID(s00_axi_wvalid),
    .S_AXI_WREADY(s00_axi_wready),
    .S_AXI_BRESP(s00_axi_bresp),
    .S_AXI_BVALID(s00_axi_bvalid),
    .S_AXI_BREADY(s00_axi_bready),
    .S_AXI_ARADDR(s00_axi_araddr),
    .S_AXI_ARPROT(s00_axi_arprot),
    .S_AXI_ARVALID(s00_axi_arvalid),
    .S_AXI_ARREADY(s00_axi_arready),
    .S_AXI_RDATA(s00_axi_rdata),
    .S_AXI_RRESP(s00_axi_rresp),
    .S_AXI_RVALID(s00_axi_rvalid),
    .S_AXI_RREADY(s00_axi_rready)
    );
    
    wire [N_MULTS-1:0] mults_output_tvalid;
    wire [N_MULTS-1:0] mults_output_tlast;
    wire [AXIS_TDATA_WIDTH-1:0] mults_output_tdata [0:N_MULTS-1];
    reg mux_tvalid;
    reg mux_tlast;
    reg [AXIS_TDATA_WIDTH-1:0] mux_tdata;
    assign m_axis_tvalid = mux_tvalid;
    assign m_axis_tlast = mux_tlast;
    assign m_axis_tdata = mux_tdata; 
        
    
    axi_multiplier #(
        .DATA_WIDTH(DATA_WIDTH),
        .MULT_WIDTH(MULT_WIDTH),
        .N_DATA_IN_PACK(N_DATA_IN_PACK),
        .AXIS_TDATA_WIDTH(AXIS_TDATA_WIDTH),
        .DSP_DELAY(DSP_DELAY)
    ) axi_multiplier_inst_0 (
        .aclk                (aclk),
        .aresetn             (aresetn),
        .mult                (mult[0]),
        .s00_axis_tdata      (s00_axis_tdata),
        .s00_axis_tvalid     (s00_axis_tvalid),
        .s00_axis_tlast      (s00_axis_tlast),
        .s00_axis_tready     (s00_axis_tready),
        .m00_axis_tready     (m_axis_tready),
        .m00_axis_tdata      (mults_output_tdata[0]),
        .m00_axis_tvalid     (mults_output_tvalid[0]),
        .m00_axis_tlast      (mults_output_tlast[0])
    );
    
    axi_multiplier #(
        .DATA_WIDTH(DATA_WIDTH),
        .MULT_WIDTH(MULT_WIDTH),
        .N_DATA_IN_PACK(N_DATA_IN_PACK),
        .AXIS_TDATA_WIDTH(AXIS_TDATA_WIDTH),
        .DSP_DELAY(DSP_DELAY)
    ) axi_multiplier_inst_1 (
        .aclk                (aclk),
        .aresetn             (aresetn),
        .mult                (mult[1]),
        .s00_axis_tdata      (s01_axis_tdata),
        .s00_axis_tvalid     (s01_axis_tvalid),
        .s00_axis_tlast      (s01_axis_tlast),
        .s00_axis_tready     (s01_axis_tready),
        .m00_axis_tready     (m_axis_tready),
        .m00_axis_tdata      (mults_output_tdata[1]),
        .m00_axis_tvalid     (mults_output_tvalid[1]),
        .m00_axis_tlast      (mults_output_tlast[1])
    );
    
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
