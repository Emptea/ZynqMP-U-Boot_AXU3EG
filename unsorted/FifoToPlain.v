`default_nettype none

module FifoToPlain #(
    parameter START_1 = 0,
    parameter LEN_1 = 1,
    parameter START_2 = 1,
    parameter LEN_2 = 1,
    parameter START_3 = 2,
    parameter LEN_3 = 1,
    parameter TOTAL_LEN = 3,
    parameter INPUT_WIDTH = 8,
    parameter FIFO_COUNTER_WIDTH = 16
) (
    input wire i_clock,
    input wire i_reset,

    input wire [INPUT_WIDTH-1:0] i_data,
    input wire i_data_valid,
    input wire [FIFO_COUNTER_WIDTH-1:0] i_fifo_word_count,
    input wire i_aux_finished,

    output reg [INPUT_WIDTH-1:0] o_main,
    output reg [INPUT_WIDTH-1:0] o_aux,
    output reg o_main_valid_1,
    output reg o_main_valid_2,
    output reg o_aux_valid,
    output reg o_request_data,
    output reg o_aux_data_sent
);

    function integer f_addr_width;
        input integer value;
        integer width;
        begin
            width = 0;
            value = value - 1;
            while (value > 0) begin
                value = value >> 1;
                width = width + 1;
            end

            if (width == 0) begin
                f_addr_width = 1;
            end else begin
                f_addr_width = width;
            end
        end
    endfunction

    localparam [1:0] e_free = 2'd0;
    localparam [1:0] e_receive = 2'd1;
    localparam [1:0] e_wait = 2'd2;
    localparam [1:0] e_send = 2'd3;

    localparam LP_ADDR_WIDTH_1 = f_addr_width(LEN_1);
    localparam LP_ADDR_WIDTH_2 = f_addr_width(LEN_2);

    localparam [FIFO_COUNTER_WIDTH-1:0] LP_START_1 = START_1;
    localparam [FIFO_COUNTER_WIDTH-1:0] LP_LEN_1 = LEN_1;
    localparam [FIFO_COUNTER_WIDTH-1:0] LP_START_2 = START_2;
    localparam [FIFO_COUNTER_WIDTH-1:0] LP_LEN_2 = LEN_2;
    localparam [FIFO_COUNTER_WIDTH-1:0] LP_START_3 = START_3;
    localparam [FIFO_COUNTER_WIDTH-1:0] LP_TOTAL_LEN = TOTAL_LEN;
    localparam [FIFO_COUNTER_WIDTH-1:0] LP_END_1 = START_1 + LEN_1;
    localparam [FIFO_COUNTER_WIDTH-1:0] LP_END_2 = START_2 + LEN_2;
    localparam [FIFO_COUNTER_WIDTH-1:0] LP_END_3 = START_3 + LEN_3;
    localparam [FIFO_COUNTER_WIDTH-1:0] LP_MAIN_SEND_LEN = LEN_1 + LEN_2;

    reg [1:0] state;
    reg [FIFO_COUNTER_WIDTH-1:0] receive_count;
    reg [FIFO_COUNTER_WIDTH-1:0] send_issue_count;
    reg [FIFO_COUNTER_WIDTH-1:0] send_emit_count;
    reg send_data_pending;
    reg send_pending_is_interval_1;

    reg interval_1_write_enable;
    reg interval_2_write_enable;
    reg [LP_ADDR_WIDTH_1-1:0] interval_1_addr;
    reg [LP_ADDR_WIDTH_2-1:0] interval_2_addr;
    reg [INPUT_WIDTH-1:0] interval_1_write_data;
    reg [INPUT_WIDTH-1:0] interval_2_write_data;

    wire [INPUT_WIDTH-1:0] interval_1_read_data;
    wire [INPUT_WIDTH-1:0] interval_2_read_data;

    v_ram #(
        .DATA(INPUT_WIDTH),
        .ADDR(LP_ADDR_WIDTH_1)
    ) inst_interval_1_ram (
        .a_clk(i_clock),
        .a_wr(interval_1_write_enable),
        .a_addr(interval_1_addr),
        .a_din(interval_1_write_data),
        .a_dout(interval_1_read_data)
    );

    v_ram #(
        .DATA(INPUT_WIDTH),
        .ADDR(LP_ADDR_WIDTH_2)
    ) inst_interval_2_ram (
        .a_clk(i_clock),
        .a_wr(interval_2_write_enable),
        .a_addr(interval_2_addr),
        .a_din(interval_2_write_data),
        .a_dout(interval_2_read_data)
    );

    always @(posedge i_clock) begin
        if (i_reset) begin
            state <= e_free;
            receive_count <= {FIFO_COUNTER_WIDTH{1'b0}};
            send_issue_count <= {FIFO_COUNTER_WIDTH{1'b0}};
            send_emit_count <= {FIFO_COUNTER_WIDTH{1'b0}};
            send_data_pending <= 1'b0;
            send_pending_is_interval_1 <= 1'b0;
            interval_1_write_enable <= 1'b0;
            interval_2_write_enable <= 1'b0;
            interval_1_addr <= {LP_ADDR_WIDTH_1{1'b0}};
            interval_2_addr <= {LP_ADDR_WIDTH_2{1'b0}};
            interval_1_write_data <= {INPUT_WIDTH{1'b0}};
            interval_2_write_data <= {INPUT_WIDTH{1'b0}};
            o_main <= {INPUT_WIDTH{1'b0}};
            o_aux <= {INPUT_WIDTH{1'b0}};
            o_main_valid_1 <= 1'b0;
            o_main_valid_2 <= 1'b0;
            o_aux_valid <= 1'b0;
            o_request_data <= 1'b0;
            o_aux_data_sent <= 1'b0;
        end else begin
            o_main_valid_1 <= 1'b0;
            o_main_valid_2 <= 1'b0;
            o_aux_valid <= 1'b0;
            o_request_data <= 1'b0;
            o_aux_data_sent <= 1'b0;
            interval_1_write_enable <= 1'b0;
            interval_2_write_enable <= 1'b0;

            case (state)
                e_free: begin
                    receive_count <= {FIFO_COUNTER_WIDTH{1'b0}};
                    send_issue_count <= {FIFO_COUNTER_WIDTH{1'b0}};
                    send_emit_count <= {FIFO_COUNTER_WIDTH{1'b0}};
                    send_data_pending <= 1'b0;

                    if (i_fifo_word_count >= LP_TOTAL_LEN) begin
                        o_request_data <= 1'b1;
                        state <= e_receive;
                    end
                end

                e_receive: begin
                    o_request_data <= receive_count < LP_TOTAL_LEN;

                    if (i_data_valid) begin
                        if ((receive_count >= LP_START_1) && (receive_count < LP_END_1)) begin
                            interval_1_write_enable <= 1'b1;
                            interval_1_addr <= receive_count - LP_START_1;
                            interval_1_write_data <= i_data;
                        end

                        if ((receive_count >= LP_START_2) && (receive_count < LP_END_2)) begin
                            interval_2_write_enable <= 1'b1;
                            interval_2_addr <= receive_count - LP_START_2;
                            interval_2_write_data <= i_data;
                        end

                        if ((receive_count >= LP_START_3) && (receive_count < LP_END_3)) begin
                            o_aux <= i_data;
                            o_aux_valid <= 1'b1;
                            o_aux_data_sent <= 1'b1;
                        end

                        if (receive_count == (LP_TOTAL_LEN - 1'b1)) begin
                            receive_count <= {FIFO_COUNTER_WIDTH{1'b0}};
                            state <= e_wait;
                            o_request_data <= 1'b0;
                        end else begin
                            receive_count <= receive_count + 1'b1;
                        end
                    end
                end

                e_wait: begin
                    send_issue_count <= {FIFO_COUNTER_WIDTH{1'b0}};
                    send_emit_count <= {FIFO_COUNTER_WIDTH{1'b0}};
                    send_data_pending <= 1'b0;

                    if (i_aux_finished) begin
                        state <= e_send;
                    end
                end

                e_send: begin
                    if (send_data_pending) begin
                        if (send_pending_is_interval_1) begin
                            o_main <= interval_1_read_data;
                            o_main_valid_1 <= 1'b1;
                        end else begin
                            o_main <= interval_2_read_data;
                            o_main_valid_2 <= 1'b1;
                        end

                        if (send_emit_count == (LP_MAIN_SEND_LEN - 1'b1)) begin
                            send_emit_count <= {FIFO_COUNTER_WIDTH{1'b0}};
                            send_data_pending <= 1'b0;
                            state <= e_free;
                        end else begin
                            send_emit_count <= send_emit_count + 1'b1;
                            send_data_pending <= 1'b0;
                        end
                    end

                    if (send_issue_count < LP_MAIN_SEND_LEN) begin
                        if (send_issue_count < LP_LEN_1) begin
                            interval_1_addr <= send_issue_count[LP_ADDR_WIDTH_1-1:0];
                            send_pending_is_interval_1 <= 1'b1;
                        end else begin
                            interval_2_addr <= send_issue_count - LP_LEN_1;
                            send_pending_is_interval_1 <= 1'b0;
                        end

                        send_issue_count <= send_issue_count + 1'b1;
                        send_data_pending <= 1'b1;
                    end
                end

                default: begin
                    state <= e_free;
                end
            endcase
        end
    end

endmodule

`default_nettype wire
