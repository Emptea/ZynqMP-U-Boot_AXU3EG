`timescale 1ps/1ps

module v_reg_delay
  #(
    parameter p_delay_length = 2,
    parameter p_bit_width = 8
  )  
  (
    input [p_bit_width - 1: 0]i_data,
    input i_clock,
    input i_data_valid, // not used, compatibility purpose
    input i_reset, // not used, compatibility purpose
    output [p_bit_width - 1: 0]o_data
  );

  generate
    if(p_delay_length == 0)
    begin
      assign o_data = i_data;
    end
    else
    begin
      reg [p_bit_width - 1: 0]data[p_delay_length - 1: 0];

      integer i;

      initial
      begin
        for(i = 0; i < p_delay_length; i = i + 1)
          data[i] = 0;
      end

      always @(posedge i_clock)
      begin
        data[0] <= i_data;
        for(i = 1; i < p_delay_length; i = i + 1)
          data[i] <= data[i - 1];
      end

      assign o_data = data[p_delay_length - 1];
    end
  endgenerate
endmodule

module v_reg_delay_programmed
  #(
    parameter p_max_delay_length = 2,
    parameter p_bit_width = 8
  )  
  (
    input [p_bit_width - 1: 0]i_data,
    input [15: 0]i_delay_length,
    input i_clock,
    input i_data_valid, // not used, compatibility purpose
    input i_reset, // not used, compatibility purpose
    output reg [p_bit_width - 1: 0]o_data
  );

  generate
    if(p_max_delay_length == 0)
    begin
		always @(i_data)
			o_data <= i_data;
    end
    else
    begin
      reg [p_bit_width - 1: 0]data[p_max_delay_length - 1: 0];

      integer i;
      reg [15: 0]delay_length;

      initial
      begin
        for(i = 0; i < p_max_delay_length; i = i + 1)
          data[i] = 0;
        delay_length = 2;
        o_data = 0;
      end

      always @(posedge i_clock)
      begin
        delay_length <= i_delay_length - 2;

        data[0] <= i_data;
        for(i = 1; i < p_max_delay_length; i = i + 1)
          data[i] <= data[i - 1];

        o_data <= data[delay_length];
      end
    end
  endgenerate
endmodule

module v_mem_delay_imit_with_reg
  #(
    parameter p_data_width = 8,
    parameter p_delay_length = 32,
    parameter p_addr_width = 5
  )
  (
    input [p_data_width - 1: 0]i_data, 
    input i_clock, 
    input i_data_valid, // not used, compatibility purpose
    input i_reset, // not used, compatibility purpose
    output [p_data_width - 1: 0]o_data
  );  
  v_reg_delay
    #(
      .p_delay_length(p_delay_length),
      .p_bit_width(p_data_width)
    )  
    inst_delay
    (
      .i_data(i_data),
      .i_clock(i_clock),
      .o_data(o_data)
    );  
endmodule

module v_mem_delay
  #(
    parameter p_data_width = 8,
    parameter p_delay_length = 32,
    parameter p_addr_width = 5
  )
  (
    input [p_data_width - 1: 0]i_data, 
    input i_clock, 
    input i_data_valid, // not used, compatibility purpose
    input i_reset, // not used, compatibility purpose
    output [p_data_width - 1: 0]o_data
  );  
  
  reg [p_addr_width - 1: 0]WrAddr;
  reg [p_addr_width - 1: 0]RdAddr;
  
  wire Enable = 1'b1;

  initial
  begin
    WrAddr = 0;
	 RdAddr = 1;
  end
  
  always @(posedge i_clock)
  begin
    if(i_reset) WrAddr <= 0;
    else WrAddr <= RdAddr; 
    
    if(i_reset) RdAddr <= 1;
    else 
    begin
      if(RdAddr == p_delay_length - 1) RdAddr <= 0;
      else RdAddr <= RdAddr + 1;
    end
  end

  v_ram_2_port
    #(
      .p_data_width(p_data_width),
      .p_word_count(p_delay_length),
      .p_addr_width(p_addr_width)
    )
    inst_ram
    (
      .i_data(i_data),
      .i_data_valid(1'b1),
      .i_read_addr(RdAddr),
      .i_write_addr(WrAddr),
      .i_read_clock(i_clock),
      .i_write_clock(i_clock),
      
      .o_data(o_data)
    );
endmodule