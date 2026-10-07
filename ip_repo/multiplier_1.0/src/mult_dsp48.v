`timescale 1ns / 1ps
module mult_dsp48
    #(
         parameter integer A_WIDTH	 = 16,
         parameter integer B_WIDTH	 = 16,
         parameter integer LATENCY = 3
     )
     (
         input aclk,
         input aresetn,

         input wire [A_WIDTH - 1 : 0] a,
         input wire [B_WIDTH - 1 : 0] b,
         output wire [A_WIDTH + B_WIDTH - 1 : 0] p

     );
    reg [A_WIDTH -1 : 0] a_reg;
    reg [B_WIDTH -1 : 0] b_reg;
    localparam integer P_WIDTH = A_WIDTH + B_WIDTH;
    reg [P_WIDTH - 1 : 0] p_regs [0 : LATENCY - 2];
    integer i;

    always @(posedge aclk or negedge aresetn)
    begin : data_i_reg
        if (!aresetn) begin
            a_reg <= {A_WIDTH{1'b0}};
            b_reg <= {B_WIDTH{1'b0}};
            for (i = 0; i < LATENCY - 1; i = i + 1)
                p_regs[i] <= {P_WIDTH{1'b0}};
            end
        else begin
            a_reg <= a;
            b_reg <= b;
            p_regs[0] <= a_reg * b_reg;
            for (i = 1; i < LATENCY - 1; i = i + 1)
                p_regs[i] <= p_regs[i-1];
        end
    end
    assign p = p_regs[LATENCY - 2][P_WIDTH - 1 : 0];

endmodule
