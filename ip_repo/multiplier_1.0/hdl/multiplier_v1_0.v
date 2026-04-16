
`timescale 1 ns / 1 ps

module multiplier_v1_0 #(parameter integer AXI_DATA_WIDTH	 = 32,
                         parameter integer AXI_ADDR_WIDTH	 = 4,
                         parameter integer AXIS_TDATA_WIDTH	 = 128,
                         parameter integer AXIS_START_COUNT	 = 32,
                         parameter integer MULT_WIDTH = 16,
                         parameter integer DSP_DELAY = 4)
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
                         (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF M00_AXIS:S00_AXIS, ASSOCIATED_RESET aresetn" *)
						 input wire aclk,
						 (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 aresetn RST" *)
						 input wire aresetn, 

						 output wire m00_axis_tvalid, 
						 output wire [AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata, 
						 output wire m00_axis_tlast, 
						 input wire m00_axis_tready, 
						 
						 output wire s00_axis_tready, 
						 input wire [AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata, 
						 input wire s00_axis_tlast, 
						 input wire s00_axis_tvalid);
						 
    reg [(AXIS_TDATA_WIDTH / 8) * MULT_WIDTH-1 :0] mult_output [0:7];
    wire [MULT_WIDTH - 1 :0] mult;
    reg [AXIS_TDATA_WIDTH -1 :0] data_in;
        
    localparam EMPTY = 1'b0;
    localparam FULL  = 1'b1;
    reg state;
    
    reg [DSP_DELAY - 1: 0] shift_reg_tvalid;
    reg [DSP_DELAY - 1: 0] shift_reg_tlast;
    // Instantiation of Axi Bus Interface S00_AXI
    multiplier_v1_0_S00_AXI # (
    .C_S_AXI_DATA_WIDTH(AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
    .MULT_WIDTH(MULT_WIDTH)
    ) multiplier_v1_0_S00_AXI_inst (
    .mult(mult),
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
    
    always @(posedge aclk or negedge aresetn) begin : data_i_reg
    if (!aresetn) data_in             <= 0;
    else if (s00_axis_tvalid) data_in <= s00_axis_tdata;
    end
    

    genvar i;
    // multiply each 16-bit by mult value stored in reg
    generate
        for (i = 0; i < 8; i = i + 1) begin: gen_mult
            always @(posedge aclk or negedge aresetn) begin
                if (!aresetn) begin
                    mult_output[i] <= 0;
                end else begin
                    (* use_dsp = "yes" *) mult_output[i] <= data_in[(i+1)*(AXIS_TDATA_WIDTH / 8) - 1 -: (AXIS_TDATA_WIDTH / 8)] * mult;
                end
            end
        end
    endgenerate
    
    assign m00_axis_tdata = {
        mult_output[7][(AXIS_TDATA_WIDTH / 8) -1 -: 16],
        mult_output[6][(AXIS_TDATA_WIDTH / 8) -1 -: 16],
        mult_output[5][(AXIS_TDATA_WIDTH / 8) -1 -: 16],
        mult_output[4][(AXIS_TDATA_WIDTH / 8) -1 -: 16],
        mult_output[3][(AXIS_TDATA_WIDTH / 8) -1 -: 16],
        mult_output[2][(AXIS_TDATA_WIDTH / 8) -1 -: 16],
        mult_output[1][(AXIS_TDATA_WIDTH / 8) -1 -: 16],
        mult_output[0][(AXIS_TDATA_WIDTH / 8) -1 -: 16]
    };
    
    always @(posedge aclk or negedge aresetn) begin : FSM_State_Transition
    if (!aresetn) state <= EMPTY;
    else begin
            case (state)
                EMPTY:
                if (s00_axis_tvalid) state <= FULL;
                FULL:
                if (m00_axis_tready && !s00_axis_tvalid) state <= EMPTY;
                default:
                state <= EMPTY;
            endcase
        end
    end
    
    always @(posedge aclk or negedge aresetn) begin : shift_tvalid
		if (!aresetn) begin
			shift_reg_tvalid <= 0;
			shift_reg_tlast  <= 0;
		end else if (state == FULL) begin
			shift_reg_tvalid <= {shift_reg_tvalid[DSP_DELAY - 2: 0], s00_axis_tvalid};
			shift_reg_tlast  <= {shift_reg_tlast[DSP_DELAY - 2: 0], s00_axis_tlast};
		end
	end
        
	assign m00_axis_tvalid = shift_reg_tvalid[DSP_DELAY - 1];
	assign m00_axis_tlast  = shift_reg_tlast[DSP_DELAY - 1];
	assign s00_axis_tready = (state == EMPTY) || (m00_axis_tready & state == FULL);
	
endmodule
