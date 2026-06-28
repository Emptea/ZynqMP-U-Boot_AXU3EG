`timescale 1ps/1ps

// Fast Fourier transformation layer
// Method: FFT with frequency decimation


module multiplier_pipeline
  #(parameter p_bit_width = 1, parameter p_pipeline = 0)
  (
    input [p_bit_width - 1: 0]i_data,
    input i_clock,
    input i_clock_enable,
    input i_reset,
    output reg [p_bit_width - 1: 0]o_data
  );

  initial
    o_data = 0;

  generate
    if(p_pipeline == 0)
    begin
      always @(i_data)
        o_data = i_data;
    end
    else if(p_pipeline == 1) 
    begin
      always @(posedge i_clock)
      begin
        if(i_reset)
          o_data = 0;
        else
          if(i_clock_enable)
            o_data = i_data;
      end
    end
    else 
    begin
      integer i;
      integer j;
      reg [p_bit_width - 1: 0]delay[p_pipeline - 2: 0];

      initial
        for(j = 0; j < p_pipeline - 1; j = j + 1)
          delay[j] = 0;

      always @(posedge i_clock)
      begin
        if(i_reset)
        begin
          for(i = 0; i < p_pipeline - 1; i = i + 1)
            delay[i] <= 0;
          o_data <= 0;
        end
        else 
          begin
          if(i_clock_enable)
          begin
          
            delay[0] <= i_data;

            for(i = 1; i < p_pipeline - 1; i = i + 1)
              delay[i] <= delay[i - 1];

            o_data <= delay[p_pipeline - 2];
          end
        end
      end
        
    end
    
  endgenerate
  
endmodule

module addsub
  #(
    parameter p_bit_width = 0,
    parameter p_pipeline_add = 0,
    parameter p_op = "add"
  )
  (
    input signed [p_bit_width - 1: 0]i_data_1,
    input signed [p_bit_width - 1: 0]i_data_2,

    input i_reset,
    input i_clock_enable,
    input i_clock,

    output [p_bit_width: 0]o_data
  );

  localparam lp_out_bit_width = p_bit_width + 1;
  localparam lp_count = lp_out_bit_width / p_pipeline_add;
  localparam lp_bit_width = (lp_out_bit_width % lp_count == 0) ? (lp_out_bit_width) : (lp_out_bit_width + lp_count - (lp_out_bit_width % lp_count));

  localparam lp_bus_width = lp_count;

  reg signed [lp_bit_width - 1: 0]data_1;
  reg signed [lp_bit_width - 1: 0]data_2;
  reg signed [lp_bit_width - 1: 0]data;

  initial
  begin
    if(p_op != "add")
      if(p_op != "sub")
        $finish;
  end

  reg [lp_bus_width - 1: 0]bus_data[p_pipeline_add - 1: 0][p_pipeline_add - 1: 0];
  reg                      bus_over[p_pipeline_add - 1: 0][p_pipeline_add - 1: 0];

  integer i, j, k, m;

  initial
  begin
    data = 0;
    data_1 = 0;
    data_2 = 0;

    for(k = 0; k < p_pipeline_add; k = k + 1)
    begin
      for(m = 0; m < p_pipeline_add; m = m + 1)
      begin
        bus_over[k][m] = 1'b0;
        bus_data[k][m] = 0;
      end
    end
  end
  
  always @(posedge i_clock)
  begin
    if(i_reset)
    begin
      data   <= 0;
      data_1 <= 0;
      data_2 <= 0;   
    
      for(i = 0; i < p_pipeline_add; i = i + 1)
      begin
        for(j = 0; j < p_pipeline_add; j = j + 1)
        begin
          bus_over[i][j] <= 0;
          bus_data[i][j] <= 0;
        end
      end
    end
    else 
    begin
      if(i_clock_enable)
      begin
    
        for(i = 0; i < p_pipeline_add; i = i + 1)
        begin
          {bus_over[0][i], bus_data[0][i]} <= {1'b0, data_1[i * lp_bus_width +: lp_bus_width]} + {1'b0, data_2[i * lp_bus_width +: lp_bus_width]};

          for(j = 1; j < p_pipeline_add; j = j + 1)
          begin
            if(i >= j)
              {bus_over[j][i], bus_data[j][i]} <= {1'b0, bus_data[j - 1][i]} + bus_over[j - 1][i - 1];
            else          
              {bus_over[j][i], bus_data[j][i]} <= {1'b0, bus_data[j - 1][i]};
          end

          data[i * lp_bus_width +: lp_bus_width] <= bus_data[p_pipeline_add - 1][i];
        end

      
        data_1 <= i_data_1;
        if(p_op == "add")
          data_2 <= i_data_2;
        else
          data_2 <= -i_data_2;
      end
    end
  end

  assign o_data[p_bit_width: 0] = data[p_bit_width: 0];

endmodule 


module multiplier
  #(
    parameter p_value_1_width = 10,
    parameter p_value_2_width = 10,
    parameter p_pipeline_mult_in = 0,
    parameter p_pipeline_mult_out = 0
  )
  (
    input signed [p_value_1_width - 1: 0]i_value_1,
    input signed [  p_value_2_width - 1: 0]i_value_2,
    
    input i_reset,
    input i_clock_enable,
    input i_clock,
    
    output signed [p_value_1_width + p_value_2_width - 1: 0]o_value
  );

  reg signed [p_value_1_width - 1: 0]signal;
  reg signed [  p_value_2_width - 1: 0]coef;
  reg signed [p_value_1_width + p_value_2_width - 1: 0]result;

  wire signed [p_value_1_width - 1: 0]signal_pipe;
  wire signed [  p_value_2_width - 1: 0]coef_pipe;

 multiplier_pipeline
    #(.p_bit_width(p_value_1_width), .p_pipeline(p_pipeline_mult_in))
    inst_1
    (.i_data(i_value_1), .i_clock(i_clock), .o_data(signal_pipe), .i_clock_enable(i_clock_enable), .i_reset(i_reset));

 multiplier_pipeline
    #(.p_bit_width(p_value_2_width), .p_pipeline(p_pipeline_mult_in))
    inst_2
    (.i_data(i_value_2), .i_clock(i_clock), .o_data(coef_pipe), .i_clock_enable(i_clock_enable), .i_reset(i_reset));

 multiplier_pipeline
    #(.p_bit_width(p_value_1_width + p_value_2_width), .p_pipeline(p_pipeline_mult_out))
    inst_3
    (.i_data(result), .i_clock(i_clock), .o_data(o_value), .i_clock_enable(i_clock_enable), .i_reset(i_reset));

  initial
  begin
    signal = 0;
    coef = 0;
    result = 0;
  end
  always @(posedge i_clock)
  begin
    if(i_reset)
    begin
      signal <= 0;
      coef <= 0;
      result <= 0;
    end
    else 
    begin
      if(i_clock_enable)
      begin      
        signal <= signal_pipe;
        coef   <= coef_pipe;
        result <= signal * coef;  
      end
    end
  end

  //assign o_value = result;
endmodule

module complex_multiplier
  #(
    parameter p_value_1_width = 10,
    parameter p_value_2_width = 10,
    parameter p_pipeline_mult_in = 0,
    parameter p_pipeline_mult_out = 0,
    parameter p_pipeline_add = 0,
    parameter p_reduce_mul_bus = "NO"
  )
  (
    input signed [p_value_1_width - 1: 0]i_value_1_re,
    input signed [p_value_1_width - 1: 0]i_value_1_im,

    input signed [  p_value_2_width - 1: 0]i_value_2_re,
    input signed [  p_value_2_width - 1: 0]i_value_2_im,
    
    input i_reset,
    input i_clock_enable,
    input i_clock,
    
    output signed [p_value_1_width + p_value_2_width - 1: 0]o_value_re,
    output signed [p_value_1_width + p_value_2_width - 1: 0]o_value_im    
  );

  wire signed [p_value_1_width + p_value_2_width - 1: 0]mul_re_re;
  wire signed [p_value_1_width + p_value_2_width - 1: 0]mul_re_im;
  wire signed [p_value_1_width + p_value_2_width - 1: 0]mul_im_re;
  wire signed [p_value_1_width + p_value_2_width - 1: 0]mul_im_im;

  multiplier
    #(
      .p_value_1_width(p_value_1_width),
      .p_value_2_width(p_value_2_width),
      .p_pipeline_mult_in(p_pipeline_mult_in),
      .p_pipeline_mult_out(p_pipeline_mult_out)
    )
    inst_mul_re_re
    (
      .i_value_1(i_value_1_re),
      .i_value_2(i_value_2_re),
    
      .i_reset(i_reset),
      .i_clock_enable(i_clock_enable),
      .i_clock(i_clock),
    
      .o_value(mul_re_re)
    );  

  multiplier
    #(
      .p_value_1_width(p_value_1_width),
      .p_value_2_width(p_value_2_width),
      .p_pipeline_mult_in(p_pipeline_mult_in),
      .p_pipeline_mult_out(p_pipeline_mult_out)
    )
    inst_mul_re_im
    (
      .i_value_1(i_value_1_re),
      .i_value_2(i_value_2_im),
    
      .i_reset(i_reset),
      .i_clock_enable(i_clock_enable),
      .i_clock(i_clock),
    
      .o_value(mul_re_im)
    );  

  multiplier
    #(
      .p_value_1_width(p_value_1_width),
      .p_value_2_width(p_value_2_width),
      .p_pipeline_mult_in(p_pipeline_mult_in),
      .p_pipeline_mult_out(p_pipeline_mult_out)
    )
    inst_mul_im_re
    (
      .i_value_1(i_value_1_im),
      .i_value_2(i_value_2_re),
    
      .i_reset(i_reset),
      .i_clock_enable(i_clock_enable),
      .i_clock(i_clock),
    
      .o_value(mul_im_re)
    );  

  multiplier
    #(
      .p_value_1_width(p_value_1_width),
      .p_value_2_width(p_value_2_width),
      .p_pipeline_mult_in(p_pipeline_mult_in),
      .p_pipeline_mult_out(p_pipeline_mult_out)
    )
    inst_mul_im_im
    (
      .i_value_1(i_value_1_im),
      .i_value_2(i_value_2_im),
    
      .i_reset(i_reset),
      .i_clock_enable(i_clock_enable),
      .i_clock(i_clock),
    
      .o_value(mul_im_im)
    );  


  localparam lp_adders_width = p_value_1_width + p_value_2_width;

  reg signed [lp_adders_width - 1: 0]adders_mul_re_re;
  reg signed [lp_adders_width - 1: 0]adders_mul_re_im;
  reg signed [lp_adders_width - 1: 0]adders_mul_im_re;
  reg signed [lp_adders_width - 1: 0]adders_mul_im_im;

  initial
  begin
    adders_mul_re_re = 0; 
    adders_mul_re_im = 0; 
    adders_mul_im_re = 0; 
    adders_mul_im_im = 0;     
  end

  generate
    if(p_reduce_mul_bus == "YES")
    begin
      always @(mul_re_re) adders_mul_re_re[p_value_2_width - 1 +: p_value_1_width + 1] = mul_re_re[p_value_2_width -1 +: p_value_1_width + 1];
      always @(mul_re_im) adders_mul_re_im[p_value_2_width - 1 +: p_value_1_width + 1] = mul_re_im[p_value_2_width -1 +: p_value_1_width + 1];
      always @(mul_im_re) adders_mul_im_re[p_value_2_width - 1 +: p_value_1_width + 1] = mul_im_re[p_value_2_width -1 +: p_value_1_width + 1];
      always @(mul_im_im) adders_mul_im_im[p_value_2_width - 1 +: p_value_1_width + 1] = mul_im_im[p_value_2_width -1 +: p_value_1_width + 1];
    end   
    else if(p_reduce_mul_bus == "NO")
    begin
      always @(mul_re_re) adders_mul_re_re = mul_re_re;
      always @(mul_re_im) adders_mul_re_im = mul_re_im;
      always @(mul_im_re) adders_mul_im_re = mul_im_re;
      always @(mul_im_im) adders_mul_im_im = mul_im_im;
    end
    else 
    begin
      initial
        $finish;  
    end

  endgenerate

  wire dummy_re;
  wire dummy_im;

  addsub
    #(
      .p_bit_width(lp_adders_width),
      .p_pipeline_add(p_pipeline_add),
      .p_op("sub")
    )
    inst_re
    (
      .i_data_1(adders_mul_re_re),
      .i_data_2(adders_mul_im_im),

      .i_reset(i_reset),
      .i_clock_enable(i_clock_enable),
      .i_clock(i_clock),

      .o_data({dummy_re, o_value_re})
    );

  addsub
    #(
      .p_bit_width(lp_adders_width),
      .p_pipeline_add(p_pipeline_add),
      .p_op("add")
    )
    inst_im
    (
      .i_data_1(adders_mul_im_re),
      .i_data_2(adders_mul_re_im),

      .i_reset(i_reset),
      .i_clock_enable(i_clock_enable),
      .i_clock(i_clock),

      .o_data({dummy_im, o_value_im})
    );

//  always @(posedge i_clock)
//  begin
//    $display("in: %d %d %d %d a: %d %d %d %d o: %d %d", i_value_1_re, i_value_1_im, i_value_2_re, i_value_2_im, 
//      adders_mul_re_re,
//      adders_mul_re_im,
//      adders_mul_im_re,
//      adders_mul_im_im,
//      o_value_re, o_value_im
//    );
//  end
//
endmodule
