`default_nettype none

module MaxSelector #(
    parameter DATA_WIDTH = 16,
    parameter CHANNEL_NUMBER = 8,
    parameter COEF_FILE = "",
    parameter DATA_LENGTH = 1024,
    parameter DATA_NUM_WIDTH = 16,
    parameter PIPELINE_MULT_IN = 1,
    parameter PIPELINE_MULT_OUT = 1,
    parameter PIPELINE_ADD = 1
) (
    input wire [2 * DATA_WIDTH * CHANNEL_NUMBER - 1:0] i_data,
    input wire i_data_valid,
    input wire i_data_start,
    input wire i_data_finish,
    input wire [DATA_NUM_WIDTH - 1:0] i_data_num,

    input wire i_reset,
    input wire i_clock,

    output reg [2 * DATA_WIDTH - 1:0] o_max_value,
    output reg o_max_value_valid,
    output reg [DATA_NUM_WIDTH - 1:0] o_max_value_data_num,
    output reg [f_addr_width(DATA_LENGTH) - 1:0] o_max_value_position_num,
    output reg [f_addr_width(CHANNEL_NUMBER) - 1:0] o_max_value_channel_num
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

    localparam LP_CHANNEL_WIDTH = f_addr_width(CHANNEL_NUMBER);
    localparam LP_POSITION_WIDTH = f_addr_width(DATA_LENGTH);
    localparam LP_MAG_WIDTH = 2 * DATA_WIDTH;
    localparam LP_PIPELINE_LATENCY = PIPELINE_MULT_IN + PIPELINE_MULT_OUT + PIPELINE_ADD + 3;

    genvar channel_genvar;

    reg frame_active_in;
    reg [LP_POSITION_WIDTH - 1:0] position_counter_in;

    reg frame_active_out;
    reg [LP_MAG_WIDTH - 1:0] frame_max_metric;
    reg [2 * DATA_WIDTH - 1:0] frame_max_value;
    reg [LP_CHANNEL_WIDTH - 1:0] frame_max_channel_num;
    reg [LP_POSITION_WIDTH - 1:0] frame_max_position_num;

    wire [LP_POSITION_WIDTH - 1:0] position_source;
    wire [2 * DATA_WIDTH - 1:0] channel_value [0:CHANNEL_NUMBER - 1];
    wire signed [DATA_WIDTH - 1:0] channel_re [0:CHANNEL_NUMBER - 1];
    wire signed [DATA_WIDTH - 1:0] channel_im [0:CHANNEL_NUMBER - 1];
    wire signed [DATA_WIDTH - 1:0] channel_im_conj [0:CHANNEL_NUMBER - 1];
    wire signed [LP_MAG_WIDTH - 1:0] channel_metric_re [0:CHANNEL_NUMBER - 1];
    wire signed [LP_MAG_WIDTH - 1:0] channel_metric_im [0:CHANNEL_NUMBER - 1];

    wire [LP_MAG_WIDTH - 1:0] best_metric_chain [0:CHANNEL_NUMBER - 1];
    wire [2 * DATA_WIDTH - 1:0] best_value_chain [0:CHANNEL_NUMBER - 1];
    wire [LP_CHANNEL_WIDTH - 1:0] best_channel_chain [0:CHANNEL_NUMBER - 1];

    wire delayed_valid;
    wire delayed_start;
    wire delayed_finish;
    wire [DATA_NUM_WIDTH - 1:0] delayed_data_num;
    wire [LP_POSITION_WIDTH - 1:0] delayed_position;

    wire [LP_MAG_WIDTH - 1:0] sample_best_metric;
    wire [2 * DATA_WIDTH - 1:0] sample_best_value;
    wire [LP_CHANNEL_WIDTH - 1:0] sample_best_channel_num;
    wire frame_update_needed;

    assign position_source = (i_data_start || !frame_active_in) ? {LP_POSITION_WIDTH{1'b0}} : position_counter_in;

    generate
        for (channel_genvar = 0; channel_genvar < CHANNEL_NUMBER; channel_genvar = channel_genvar + 1) begin : gen_channels
            assign channel_value[channel_genvar] = i_data[(2 * DATA_WIDTH * channel_genvar) +: (2 * DATA_WIDTH)];
            assign channel_re[channel_genvar] = i_data[(2 * DATA_WIDTH * channel_genvar) +: DATA_WIDTH];
            assign channel_im[channel_genvar] = i_data[(2 * DATA_WIDTH * channel_genvar) + DATA_WIDTH +: DATA_WIDTH];
            assign channel_im_conj[channel_genvar] = -channel_im[channel_genvar];

            complex_multiplier #(
                .p_value_1_width(DATA_WIDTH),
                .p_value_2_width(DATA_WIDTH),
                .p_pipeline_mult_in(PIPELINE_MULT_IN),
                .p_pipeline_mult_out(PIPELINE_MULT_OUT),
                .p_pipeline_add(PIPELINE_ADD),
                .p_reduce_mul_bus("NO")
            ) inst_metric (
                .i_value_1_re(channel_re[channel_genvar]),
                .i_value_1_im(channel_im[channel_genvar]),
                .i_value_2_re(channel_re[channel_genvar]),
                .i_value_2_im(channel_im_conj[channel_genvar]),
                .i_reset(i_reset),
                .i_clock_enable(1'b1),
                .i_clock(i_clock),
                .o_value_re(channel_metric_re[channel_genvar]),
                .o_value_im(channel_metric_im[channel_genvar])
            );
        end
    endgenerate

    assign best_metric_chain[0] = channel_metric_re[0];
    assign best_value_chain[0] = channel_value[0];
    assign best_channel_chain[0] = {LP_CHANNEL_WIDTH{1'b0}};

    generate
        for (channel_genvar = 1; channel_genvar < CHANNEL_NUMBER; channel_genvar = channel_genvar + 1) begin : gen_compare
            assign best_metric_chain[channel_genvar] =
                (channel_metric_re[channel_genvar] > best_metric_chain[channel_genvar - 1]) ?
                channel_metric_re[channel_genvar] : best_metric_chain[channel_genvar - 1];

            assign best_value_chain[channel_genvar] =
                (channel_metric_re[channel_genvar] > best_metric_chain[channel_genvar - 1]) ?
                channel_value[channel_genvar] : best_value_chain[channel_genvar - 1];

            assign best_channel_chain[channel_genvar] =
                (channel_metric_re[channel_genvar] > best_metric_chain[channel_genvar - 1]) ?
                channel_genvar[LP_CHANNEL_WIDTH - 1:0] : best_channel_chain[channel_genvar - 1];
        end
    endgenerate

    assign sample_best_metric = best_metric_chain[CHANNEL_NUMBER - 1];
    assign sample_best_value = best_value_chain[CHANNEL_NUMBER - 1];
    assign sample_best_channel_num = best_channel_chain[CHANNEL_NUMBER - 1];

    multiplier_pipeline #(
        .p_bit_width(1),
        .p_pipeline(LP_PIPELINE_LATENCY)
    ) inst_delay_valid (
        .i_data(i_data_valid),
        .i_clock(i_clock),
        .i_clock_enable(1'b1),
        .i_reset(i_reset),
        .o_data(delayed_valid)
    );

    multiplier_pipeline #(
        .p_bit_width(1),
        .p_pipeline(LP_PIPELINE_LATENCY)
    ) inst_delay_start (
        .i_data(i_data_start),
        .i_clock(i_clock),
        .i_clock_enable(1'b1),
        .i_reset(i_reset),
        .o_data(delayed_start)
    );

    multiplier_pipeline #(
        .p_bit_width(1),
        .p_pipeline(LP_PIPELINE_LATENCY)
    ) inst_delay_finish (
        .i_data(i_data_finish),
        .i_clock(i_clock),
        .i_clock_enable(1'b1),
        .i_reset(i_reset),
        .o_data(delayed_finish)
    );

    multiplier_pipeline #(
        .p_bit_width(DATA_NUM_WIDTH),
        .p_pipeline(LP_PIPELINE_LATENCY)
    ) inst_delay_data_num (
        .i_data(i_data_num),
        .i_clock(i_clock),
        .i_clock_enable(1'b1),
        .i_reset(i_reset),
        .o_data(delayed_data_num)
    );

    multiplier_pipeline #(
        .p_bit_width(LP_POSITION_WIDTH),
        .p_pipeline(LP_PIPELINE_LATENCY)
    ) inst_delay_position (
        .i_data(position_source),
        .i_clock(i_clock),
        .i_clock_enable(1'b1),
        .i_reset(i_reset),
        .o_data(delayed_position)
    );

    assign frame_update_needed =
        !frame_active_out || delayed_start || (sample_best_metric > frame_max_metric);

    always @(posedge i_clock) begin
        if (i_reset) begin
            frame_active_in <= 1'b0;
            position_counter_in <= {LP_POSITION_WIDTH{1'b0}};
            frame_active_out <= 1'b0;
            frame_max_metric <= {LP_MAG_WIDTH{1'b0}};
            frame_max_value <= {(2 * DATA_WIDTH){1'b0}};
            frame_max_channel_num <= {LP_CHANNEL_WIDTH{1'b0}};
            frame_max_position_num <= {LP_POSITION_WIDTH{1'b0}};
            o_max_value <= {(2 * DATA_WIDTH){1'b0}};
            o_max_value_valid <= 1'b0;
            o_max_value_data_num <= {DATA_NUM_WIDTH{1'b0}};
            o_max_value_position_num <= {LP_POSITION_WIDTH{1'b0}};
            o_max_value_channel_num <= {LP_CHANNEL_WIDTH{1'b0}};
        end else begin
            o_max_value_valid <= 1'b0;

            if (i_data_start && !i_data_valid) begin
                frame_active_in <= 1'b1;
                position_counter_in <= {LP_POSITION_WIDTH{1'b0}};
            end

            if (i_data_valid) begin
                if (i_data_finish) begin
                    frame_active_in <= 1'b0;
                    position_counter_in <= {LP_POSITION_WIDTH{1'b0}};
                end else begin
                    frame_active_in <= 1'b1;
                    position_counter_in <= position_source + 1'b1;
                end
            end

            if (delayed_valid) begin
                if (frame_update_needed) begin
                    frame_max_metric <= sample_best_metric;
                    frame_max_value <= sample_best_value;
                    frame_max_channel_num <= sample_best_channel_num;
                    frame_max_position_num <= delayed_position;
                end

                if (delayed_finish) begin
                    frame_active_out <= 1'b0;
                    o_max_value_valid <= 1'b1;
                    o_max_value_data_num <= delayed_data_num;

                    if (frame_update_needed) begin
                        o_max_value <= sample_best_value;
                        o_max_value_position_num <= delayed_position;
                        o_max_value_channel_num <= sample_best_channel_num;
                    end else begin
                        o_max_value <= frame_max_value;
                        o_max_value_position_num <= frame_max_position_num;
                        o_max_value_channel_num <= frame_max_channel_num;
                    end
                end else begin
                    frame_active_out <= 1'b1;
                end
            end
        end
    end

endmodule

`default_nettype wire
