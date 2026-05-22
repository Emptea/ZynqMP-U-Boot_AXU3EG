`timescale 1 ns / 1 ps

module tb_multiplier_v1_0;

  localparam integer AXI_DATA_WIDTH   = 32;
  localparam integer AXI_ADDR_WIDTH   = 11;
  localparam integer DATA_WIDTH       = 16;
  localparam integer N_DATA_IN_PACK   = 2;
  localparam integer AXIS_TDATA_WIDTH = DATA_WIDTH * N_DATA_IN_PACK;
  localparam integer MULT_WIDTH       = 16;
  localparam integer DSP_DELAY        = 2;

  reg  s00_axi_aclk;
  reg  s00_axi_aresetn;

  reg  [AXI_ADDR_WIDTH-1:0] s00_axi_awaddr;
  reg  [2:0]                s00_axi_awprot;
  reg                       s00_axi_awvalid;
  wire                      s00_axi_awready;

  reg  [AXI_DATA_WIDTH-1:0] s00_axi_wdata;
  reg  [(AXI_DATA_WIDTH/8)-1:0] s00_axi_wstrb;
  reg                       s00_axi_wvalid;
  wire                      s00_axi_wready;

  wire [1:0]                s00_axi_bresp;
  wire                      s00_axi_bvalid;
  reg                       s00_axi_bready;

  reg  [AXI_ADDR_WIDTH-1:0] s00_axi_araddr;
  reg  [2:0]                s00_axi_arprot;
  reg                       s00_axi_arvalid;
  wire                      s00_axi_arready;
  wire [AXI_DATA_WIDTH-1:0] s00_axi_rdata;
  wire [1:0]                s00_axi_rresp;
  wire                      s00_axi_rvalid;
  reg                       s00_axi_rready;

  reg                       aclk;
  reg                       aresetn;

  wire                      m_axis_tvalid;
  wire [AXIS_TDATA_WIDTH-1:0] m_axis_tdata;
  wire                      m_axis_tlast;
  reg                       m_axis_tready;

  wire                      s00_axis_tready;
  reg  [AXIS_TDATA_WIDTH-1:0] s00_axis_tdata;
  reg                       s00_axis_tlast;
  reg                       s00_axis_tvalid;
  
  
  wire                      s01_axis_tready;
  reg  [AXIS_TDATA_WIDTH-1:0] s01_axis_tdata;
  reg                       s01_axis_tlast;
  reg                       s01_axis_tvalid;

  multiplier_v1_0 #(
    .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH),
    .N_DATA_IN_PACK(N_DATA_IN_PACK),
    .AXIS_TDATA_WIDTH(AXIS_TDATA_WIDTH),
    .MULT_WIDTH(MULT_WIDTH),
    .DSP_DELAY(DSP_DELAY)
  ) dut (
    .s00_axi_aclk(s00_axi_aclk),
    .s00_axi_aresetn(s00_axi_aresetn),
    .s00_axi_awaddr(s00_axi_awaddr),
    .s00_axi_awprot(s00_axi_awprot),
    .s00_axi_awvalid(s00_axi_awvalid),
    .s00_axi_awready(s00_axi_awready),
    .s00_axi_wdata(s00_axi_wdata),
    .s00_axi_wstrb(s00_axi_wstrb),
    .s00_axi_wvalid(s00_axi_wvalid),
    .s00_axi_wready(s00_axi_wready),
    .s00_axi_bresp(s00_axi_bresp),
    .s00_axi_bvalid(s00_axi_bvalid),
    .s00_axi_bready(s00_axi_bready),
    .s00_axi_araddr(s00_axi_araddr),
    .s00_axi_arprot(s00_axi_arprot),
    .s00_axi_arvalid(s00_axi_arvalid),
    .s00_axi_arready(s00_axi_arready),
    .s00_axi_rdata(s00_axi_rdata),
    .s00_axi_rresp(s00_axi_rresp),
    .s00_axi_rvalid(s00_axi_rvalid),
    .s00_axi_rready(s00_axi_rready),
    .aclk(aclk),
    .aresetn(aresetn),
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
    .s01_axis_tvalid(s01_axis_tvalid)
  );

  always #5 aclk = ~aclk;
  always #5 s00_axi_aclk = ~s00_axi_aclk;

  task axi_write;
    input [AXI_ADDR_WIDTH-1:0] addr;
    input [AXI_DATA_WIDTH-1:0] data;
    begin
      @(posedge s00_axi_aclk);
      s00_axi_awaddr  <= addr;
      s00_axi_awprot   <= 3'b000;
      s00_axi_awvalid  <= 1'b1;
      s00_axi_wdata    <= data;
      s00_axi_wstrb    <= 4'hF;
      s00_axi_wvalid   <= 1'b1;
      s00_axi_bready   <= 1'b1;

      wait (s00_axi_awready && s00_axi_wready);
      @(posedge s00_axi_aclk);
      s00_axi_awvalid <= 1'b0;
      s00_axi_wvalid  <= 1'b0;

      wait (s00_axi_bvalid);
      @(posedge s00_axi_aclk);
      s00_axi_bready <= 1'b0;
    end
  endtask

  task send_axis_word;
    input [AXIS_TDATA_WIDTH-1:0] data;
    input last;
    begin
      @(posedge aclk);
      s00_axis_tdata  <= data;
      s00_axis_tlast  <= last;
      s00_axis_tvalid <= 1'b1;
      
      s01_axis_tdata  <= data + 1;
      s01_axis_tlast  <= last;
      s01_axis_tvalid <= 1'b1;

//      wait (s00_axis_tready);
//      @(posedge aclk);
//      s00_axis_tvalid <= 1'b0;
//      s00_axis_tlast  <= 1'b0;
//      s00_axis_tdata  <= 0;
    end
  endtask

  initial begin
    aclk = 0;
    s00_axi_aclk = 0;

    aresetn = 0;
    s00_axi_aresetn = 0;

    s00_axi_awaddr = 0;
    s00_axi_awprot = 0;
    s00_axi_awvalid = 0;
    s00_axi_wdata = 0;
    s00_axi_wstrb = 0;
    s00_axi_wvalid = 0;
    s00_axi_bready = 0;
    s00_axi_araddr = 0;
    s00_axi_arprot = 0;
    s00_axi_arvalid = 0;
    s00_axi_rready = 0;

    m_axis_tready = 1;
    s00_axis_tdata = 0;
    s00_axis_tlast = 0;
    s00_axis_tvalid = 0;

    #50;
    aresetn = 1;
    s00_axi_aresetn = 1;

    #20;

    axi_write(11'h10, 32'd3);
    axi_write(11'h14, 32'd2);


    send_axis_word({16'd20, 16'd10}, 1'b0);
    send_axis_word({16'd40, 16'd20}, 1'b0);
    axi_write(11'h0C, 32'd1);
    send_axis_word({16'd4, 16'd3}, 1'b1);

    repeat (DSP_DELAY + 2) @(posedge aclk);

    $display("m_axis_tvalid=%0d tdata=0x%h tlast=%0d", m_axis_tvalid, m_axis_tdata, m_axis_tlast);

    #50;
    $finish;
  end

  always @(posedge aclk) begin
    if (m_axis_tvalid) begin
      $display("%t OUTPUT valid=1 tdata=0x%h tlast=%0d", $time, m_axis_tdata, m_axis_tlast);
    end
  end

endmodule