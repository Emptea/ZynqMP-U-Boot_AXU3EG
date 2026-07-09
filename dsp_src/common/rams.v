// A parameterized, inferable, true dual-port, dual-clock block RAM in Verilog.


module v_ram_2_port
	#(
		parameter p_data_width = 8,
		parameter p_word_count = 1024,
		parameter p_addr_width = 10
	)
	(
		input [p_data_width - 1: 0]i_data,
		input i_data_valid,
		input [p_addr_width - 1: 0]i_read_addr,
		input [p_addr_width - 1: 0]i_write_addr,
		input i_read_clock,
		input i_write_clock,
		
		output reg [p_data_width - 1: 0]o_data
	);
 
	reg [p_data_width - 1:0] mem [p_word_count - 1: 0];
	reg [p_addr_width - 1:0] read_addr;
	reg [p_addr_width - 1:0] write_addr;
	reg [p_data_width - 1:0] data;
	reg data_valid;
	
	always @(posedge i_write_clock)
	begin
		data <= i_data;
		data_valid <= i_data_valid;
		write_addr <= i_write_addr;
		
		if(data_valid) mem[write_addr] <= data;
	end
 
	always @(posedge i_read_clock)
	begin
		read_addr <= i_read_addr;
		o_data <= mem[read_addr];
	end
 	
endmodule
 
module v_ram 
	#(
		parameter DATA = 8,
		parameter ADDR = 8
	)
	(
		input   wire    a_clk,
		input   wire    a_wr,
		input   wire    [ADDR-1:0]  a_addr,
		input   wire    [DATA-1:0]  a_din,
		output  reg     [DATA-1:0]  a_dout
     
	);

	// Shared memory
	reg [DATA-1:0] mem [(2**ADDR)-1:0];
	 
	always @(posedge a_clk) 
	begin
		 a_dout <= mem[a_addr];
		 
		 if(a_wr) mem[a_addr] <= a_din;
	end

 
endmodule


//
// Asymmetric port RAM
// Port A is write-only
// Port B is read-only
//
// Download: ftp://ftp.xilinx.com/pub/documentation/misc/xstug_examples.zip
// File: HDL_Coding_Techniques/rams/asymmetric_ram_1a.v
//
module v_2_clk_2_port_ram 
  #(
    parameter WIDTH = 8,
    parameter SIZE = 256,
    parameter ADDRWIDTH = 8
  )
  (
    input clkA,
    input clkB,
    input weA,
    input reB,
    input [ADDRWIDTH - 1: 0]  addrA,
    input [ADDRWIDTH - 1: 0]  addrB,
    input [WIDTH - 1: 0]      diA,
    output reg [WIDTH - 1: 0] doB
  );
  
  
  
  `define max(a,b) {(a) > (b) ? (a) : (b)}
  `define min(a,b) {(a) < (b) ? (a) : (b)}
  
  function integer log2;
  
    input integer value;
    reg [31:0] shifted;
    integer res;
    begin
      if (value < 2)
      log2 = value;
      else
      begin
        shifted = value-1;
        for (res=0; shifted>0; res=res+1)
          shifted = shifted>>1;
        log2 = res;
      end
    end
  endfunction
  
  /*localparam maxSIZE = `max(SIZEA, SIZEB);
  localparam maxWIDTH = `max(WIDTHA, WIDTHB);
  localparam minWIDTH = `min(WIDTHA, WIDTHB);
  localparam RATIO = maxWIDTH / minWIDTH;
  localparam log2RATIO = log2(RATIO);*/
  
  reg [WIDTH-1:0] RAM [0:SIZE-1];
  reg [WIDTH-1:0] readB;
  
  genvar i;
  
  always @(posedge clkA)
  begin
    if (weA)
      RAM[addrA] <= diA;
  end
  
  always @(posedge clkB)
  begin
    if (reB)
      doB <= readB;
  end
  
      
  always @(posedge clkB)
  begin
    readB <= RAM[addrB];
  end

endmodule

module v_2port_mem
  #(
    parameter p_init_file = "",
    parameter p_addr_width = 8,
    parameter p_word_count = 256,
    parameter p_data_width = 8
  )
  (
    // Port A
    input   wire                           i_clock_1,
    input   wire                           i_data_1_wren,
    input   wire    [p_addr_width - 1: 0]  i_data_1_addr,
    input   wire    [p_data_width - 1: 0]  i_data_1,
    output  reg     [p_data_width - 1: 0]  o_data_1,
     
    // Port B
    input   wire                           i_clock_2,
    input   wire                           i_data_2_wren,
    input   wire    [p_addr_width - 1: 0]  i_data_2_addr,
    input   wire    [p_data_width - 1: 0]  i_data_2,
    output  reg     [p_data_width - 1: 0]  o_data_2
  );
  // Shared memory
  reg [p_data_width - 1: 0] mem [p_word_count - 1: 0];
  
  reg [31: 0] i;
  
  initial
  begin
    //if(p_init_file == "")
    //begin
      //for(i = 0; i < p_word_count; i = i + 1)
        //mem[i] = 0;
    //end
    //else
	 if(p_init_file != "")
    begin
      $readmemh(p_init_file, mem);
    end

    //for (i = 0; i < p_word_count; i = i + 1)
      //$display("Address %d, data %x", i, mem[i][p_data_width - 1: 0]);
  end
  
  initial
  begin
      o_data_1 = 0;
      o_data_2 = 0;
  end  
  // Port A
  always @(posedge i_clock_1) 
  begin
    o_data_1      <= mem[i_data_1_addr];
    
    if(i_data_1_wren) 
    begin
      o_data_1           <= i_data_1;
      mem[i_data_1_addr] <= i_data_1;
    end
  end
  
  // Port B
  always @(posedge i_clock_2) 
  begin
    o_data_2      <= mem[i_data_2_addr];
    
    if(i_data_2_wren) 
    begin
      o_data_2           <= i_data_2;
      mem[i_data_2_addr] <= i_data_2;
    end
  end
endmodule