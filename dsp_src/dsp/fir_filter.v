`timescale 1ps/1ps

module FirLayer
  #(
    parameter INPUT_BIT_WIDTH = 16,
    parameter OUTPUT_BIT_WIDTH = 16,
    parameter INPUT_NUMBER = 16
  )
  (
    input [2 * INPUT_BIT_WIDTH * INPUT_NUMBER - 1: 0]i_signal,
    input i_clock,

    output [2 * OUTPUT_BIT_WIDTH * INPUT_NUMBER - 1: 0]o_signal
  );

  wire signed [BIT_WIDTH - 1: 0]input_data[INPUT_NUMBER - 1: 0][1: 0];
  reg signed [BIT_WIDTH: 0]output_data[INPUT_NUMBER - 1: 0][1: 0];

  generate
    genvar i;

    for(i = 0; i < INPUT_NUMBER; i = i + 1)
    begin: gen_assign
      assign input_data[i][0] = i_signal[2 * INPUT_BIT_WIDTH * i +: INPUT_BIT_WIDTH];
      assign input_data[i][1] = i_signal[2 * INPUT_BIT_WIDTH * i + INPUT_BIT_WIDTH +: INPUT_BIT_WIDTH];

      assign o_signal[2 * OUTOUT_BIT_WIDTH * i +: OUTPUT_BIT_WIDTH] = output_data[i][0];
      assign o_signal[2 * OUTOUT_BIT_WIDTH * i + OUTPUT_BIT_WIDTH +: OUTPUT_BIT_WIDTH] = output_data[i][1];
    end

    genvar t;
    for(t = 0; t < INPUT_NUMBER; t = t + 2)
    begin: gen_sum
        if(t + 1 < INPUT_NUMBER)
        begin
          always @(posedge i_clock)
          begin
            output_data[t / 2][0] = input_data[t][0] + input_data[t + 1][0];
            output_data[t / 2][1] = input_data[t][1] + input_data[t + 1][1];
          end
        end
        else
        begin
          always @(posedge i_clock)
          begin
            output_data[t / 2][0] = input_data[t][0];
            output_data[t / 2][1] = input_data[t][1];
          end
        end
    end
  endgenerate
endmodule

module FirFilter
  #(
    parameter FILTER_LENGTH = 35,
    parameter COEF_WIDTH = 8,
    parameter SIGNAL_WIDTH=8,
    parameter COEF_FILE=""
  )
  (
    input [2 * SIGNAL_WIDTH - 1: 0]i_data, 
    input i_clock, 
    output [2 * SIGNAL_WIDTH -1: 0]o_data
  );

  reg [COEF_WIDTH - 1: 0]coefs[FILTER_LENGTH - 1: 0];

  initial
  begin
    $readmemh(COEF_FILE, coefs);
  end

  reg [2 * SIGNAL_WIDTH - 1: 0]delay_line[FILTER_LENGTH - 1: 0];

  integer delay_iter;
  always @(posedge i_clock)
  begin
    delay_line[0] <= i_data;

    for(delay_iter = 1; delay_iter < FILTER_LENGTH; delay_iter = delay_iter + 1)
    begin
      delay_line[delay_iter] <= delay_line[delay_iter - 1];
    end
  end

  localparam MUL_WIDTH = SIGNAL_WIDTH + COEF_WIDTH;

  wire [2 * MUL_WIDTH * FILTER_LENGTH - 1: 0]mul_data;

  generate
    genvar mul_iter;
   
    for(mul_iter = 0; mul_iter < FILTER_LENGTH; mul_iter = mul_iter + 1)
    begin: genmuls
      complex_multiplier
        #(
          .p_value_1_width(SIGNAL_WIDTH),
          .p_value_2_width(COEF_WIDTH),
          .p_pipeline_mult_in(1),
          .p_pipeline_mult_out(1),
          .p_pipeline_add(1),
          .p_reduce_mul_bus("NO")
        )
        (
          .i_value_1_re(delyay_line[mul_iter][0 +: BIT_WIDTH]),
          .i_value_1_im(delay_line[mul_iter][BIT_WIDTH +: BIT_WIDTH]),
      
          .i_value_2_re(coefs[mul_iter][0 +: COEF_WIDTH]),
          .i_value_2_im(coefs[mul_iter][COEF_WIDTH +: COEF_WIDTH]),
          
          .i_reset(i_reset),
          .i_clock_enable(i_clock_enable),
          .i_clock(i_clock),
          
          o_value_re(mul_data[2 * mul_iter * MUL_WIDTH +: MUL_WIDTH]),
          o_value_im(mul_data[2 * mul_iter * MUL_WIDTH + MUL_WIDTH +: MUL_WIDTH])    
        );
      end

      `include "utils.v"

      localparam LAYER_WIDTH_INCREASE = clog2(FILTER_DEPTH);
      localparam LAYER_WIDTH_START = MUL_WIDTH;
      localparam LAYER_WIDTH_END = MUL_WIDTH + LAYER_WIDTH_INCREASE;
      wire [2 * LAYER_WIDTH_END * FILTER_LENGTH - 1: 0]layer_data[FILTER_DEPTH: 0];

      genvar layer_it;
      for(layer_it = 0; layer_it < FILTER_DEPTH; layer_it = layer_it + 1)
      begin: gen_layer
        if(layer_it == 0)
        begin
          genvar layer_filler_it;
          
          for(layer_filler_it = 0; layer_filler_it < FILTER_DEPTH; layer_filler_it = layer_filler_it + 1)
          begin: gen_widen
            wire signed [LAYER_WIDTH_START - 1: 0]in_data_re, in_data_im;
            wire signed [LAYER_WIDTH_END - 1: 0]out_data_re, in_data_im;

            assign in_data_re = muled_data[layer_filler_it * LAYER_WIDTH_START +: LAYER_WIDTH_START];
            assign in_data_im = muled_data[layer_filler_it * LAYER_WIDTH_START + LAYER_WIDTH_START +: LAYER_WIDTH_START];
            assign out_data_re = in_data_re;
            assign out_data_im = in_data_im;
            assign layer_data[layer_filler_it * LAYER_WIDTH_END +: LAYER_WIDTH_END] = out_data_re;
            assign layer_data[layer_filler_it * LAYER_WIDTH_END + LAYER_WIDTH_END +: LAYER_WIDTH_END] = out_data_im;
          end
        end
        else
        begin
           FirLayer
            #(
              .INPUT_BIT_WIDTH(LAYER_WIDTH_START),
              .OUTPUT_BIT_WIDTH(LAYER_WIDTH_END),
              .INPUT_NUMBER(INPUT_NUMBER)
            )
            inst_fir_layer
            (
              .i_signal(layer_data[layer_it - 1]),
              .i_clock(i_clock),
          
              .o_signal(layer_data[layer_it]),
            );
        end
      end
  endgenerate

  wire [SIGNAL_WIDTH - 1: 0]out_re, out_im;
  assign o_signal = {out_im, out_re};
  
  assign out_re = layer_data[FILTER_DEPTH][LAYER_WIDTH_INCREASE + COEF_WIDTH - 1 +: SIGNAL_WIDTH];
  assign out_im = layer_data[FILTER_DEPTH][LAYER_WIDTH_END + LAYER_WIDTH_INCREASE + COEF_WIDTH - 1 +: SIGNAL_WIDTH];
endmodule

module FirModule
  #(
    parameter FILTER_LENGTH = 35,
    parameter COEF_WIDTH = 8,
    parameter SIGNAL_WIDTH=8,
    parameter COEF_FILE=""
  )
  (
    input [2 * SIGNAL_WIDTH - 1: 0]i_signal, 
    input i_reset, 
    input i_clock, 
    input i_valid,
    output [2 * SIGNAL_WIDTH - 1: 0]o_signal,
    output o_valid
  );

  FirFilter
    #(
      .FILTER_LENGTH(FILTER_LENGTH),
      .COEF_WIDTH(COEF_WIDTH),
      .SIGNAL_WIDTH(SIGNAL_WIDTH),
      .COEF_FILE(COEF_FILE)
    )
    inst_filter
    (
      .i_data(i_signal),
      .i_clock(i_clock),
      .o_data(o_signal)
    );

  `include "utils.v"

  localparam lp_sum_delay = clog2(FILTER_LENGTH) + FILTER_LENGTH / 2 + 1; // delay line and sum layers
  localparam lp_additional_delays = 4; // muls and conveyor

  v_reg_delay
    #(
      .p_bit_width(1),
      .p_delay_length(lp_sum_delay + lp_additional_delays)
    )    
    delay
    (
      .i_data(i_valid),
      
      .i_data_valid(1'b1),
      
      .i_reset(i_reset),
      .i_clock(i_clock),
      
      .o_data(o_valid)
    );
  
endmodule

module FirBlock
  #(
    parameter CHANNEL_NUMBER = 8,
    parameter FILTER_LENGTH = 35,
    parameter COEF_WIDTH = 8,
    parameter SIGNAL_WIDTH=8,
    parameter COEF_FILE=""
  )
  (
    input [2 * SIGNAL_WIDTH * CHANNEL_NUMBER - 1: 0]i_signal, 
    input i_reset, 
    input i_clock, 
    input i_valid,
    output [2 * SIGNAL_WIDTH * CHANNEL_NUMBER - 1: 0]o_signal,
    output o_valid
  );
  generate
    genvar i;

    for(i = 0; i < CHANNEL_NUMBER; i = i + 1)
    begin: gen_filter
      wire valid;

      FirModule
        #(
          .FILTER_LENGTH(FILTER_LENGTH),
          .COEF_WIDTH(COEF_WIDTH),
          .SIGNAL_WIDTH(SIGNAL_WIDTH),
          .COEF_FILE(COEF_FILE)
        )
        inst_fir_module
        (
          .i_signal(i_signal[2 * SIGNAL_WIDTH * i +: 2 * SIGNAL_WIDTH]), 
          .i_reset(i_reset), 
          .i_clock(i_clock), 
          .i_valid(i_valid),
          .o_signal(o_signal[2 * SIGNAL_WIDTH * i +: 2 * SIGNAL_WIDTH]),
          .o_valid(valid)
        );

      if(i == 0)
      begin
        assign o_valid = valid;
      end
    end
  endgenerate

endmodule