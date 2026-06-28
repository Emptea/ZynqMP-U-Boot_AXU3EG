function integer get_value_width;
  input integer x;
  integer i;
	 integer result;
   
   begin
	  result = 0;
    for(i = 0; i < 32; i = i + 1)
    begin
      if(x[i]) result = i + 1;
    end

    get_value_width = result;
   end
endfunction


function integer clog2;
  input integer x;
  integer i;
   integer result;
   reg should_compare;
   
   begin
    result = 0;
    should_compare = 1'b1;
    for(i = 1; i < 32; i = i + 1)
    begin
      if((1 << i) >= x && should_compare) 
      begin
        result = i;
        should_compare = 1'b0;
      end
    end

    clog2 = result;
   end
endfunction
