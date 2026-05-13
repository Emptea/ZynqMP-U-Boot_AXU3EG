`timescale 1ns / 1ps

module axi_multiplier #(
    parameter DATA_WIDTH    = 16,
    parameter MULT_WIDTH    = 16,
    parameter N_DATA_IN_PACK = 2,
    parameter integer AXIS_TDATA_WIDTH	 = DATA_WIDTH * N_DATA_IN_PACK,
    parameter DSP_DELAY     = 4
)(
    input wire [MULT_WIDTH - 1: 0] mult,
    input  wire                        aclk,
    input  wire                        aresetn,
    input  wire [N_DATA_IN_PACK*DATA_WIDTH-1:0] s00_axis_tdata,
    input  wire                        s00_axis_tvalid,
    input  wire                        s00_axis_tlast,
    output wire                        s00_axis_tready,
    input  wire                        m00_axis_tready,
    output wire [N_DATA_IN_PACK*DATA_WIDTH-1:0] m00_axis_tdata,
    output wire                        m00_axis_tvalid,
    output wire                        m00_axis_tlast
);
    reg [AXIS_TDATA_WIDTH -1 :0] data_in;
    wire [DATA_WIDTH + MULT_WIDTH-1 :0] mult_output [0:N_DATA_IN_PACK - 1]; 
      
    localparam EMPTY = 1'b0;
    localparam FULL  = 1'b1;
    reg state;
    
    reg [DSP_DELAY : 0] shift_reg_tvalid; // DSP_DELAY + 1 regs
    reg [DSP_DELAY : 0] shift_reg_tlast;
    
    always @(posedge aclk or negedge aresetn) begin : data_i_reg
    if (!aresetn) data_in             <= 0;
    else if (s00_axis_tvalid) data_in <= s00_axis_tdata;
    end
    

    genvar i;
    // multiply each 16-bit by mult value stored in reg
    generate
        for (i = 0; i < N_DATA_IN_PACK; i = i + 1) begin: gen_mult
            mult_dsp48 #(
                .A_WIDTH(DATA_WIDTH),
                .B_WIDTH(MULT_WIDTH),
                .LATENCY(DSP_DELAY)
            ) u_mult_dsp48 (
                .aclk    (aclk),
                .aresetn (aresetn),
                .a       (data_in[(i+1)*DATA_WIDTH -1 -: DATA_WIDTH]),
                .b       (mult),
                .p       (mult_output[i])
            );
        end
    endgenerate
    
    assign m00_axis_tdata = {
        mult_output[1][DATA_WIDTH - 1 -: DATA_WIDTH],
        mult_output[0][DATA_WIDTH - 1 -: DATA_WIDTH]
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
		end else begin
			shift_reg_tvalid <= {shift_reg_tvalid[DSP_DELAY - 1: 0], s00_axis_tvalid};
			shift_reg_tlast  <= {shift_reg_tlast[DSP_DELAY - 1: 0], s00_axis_tlast};
		end
	end
        
	assign m00_axis_tvalid = shift_reg_tvalid[DSP_DELAY];
	assign m00_axis_tlast  = shift_reg_tlast[DSP_DELAY];
	assign s00_axis_tready = (state == EMPTY) || (m00_axis_tready & state == FULL);

endmodule