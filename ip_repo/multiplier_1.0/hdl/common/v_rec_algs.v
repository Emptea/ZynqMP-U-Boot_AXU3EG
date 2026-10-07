module vRecDiv
  (
    iNum, 
    iDeNom, 
    iStart, 
    C, 
    oDiv, 
    oRem, 
    oRdy
  );
  
	parameter n=42;
	parameter m=32;
	
	input signed [n-1:0]iNum;
	input signed [m-1:0]iDeNom;
	input iStart;
	input C;
	
	reg NomSign, DeNomSign;
	
	output reg signed [n-1:0]oDiv;
	output reg [m-1:0]oRem;
	output reg oRdy;
	
	reg Init;
	reg signed [n-1:0]Div;
	reg signed [n+m-1:0]Nom;
	reg signed [m-1:0]DeNom;
	
	wire [m-1:0]NomNil=0;
	
	reg [m-1:0]Cnt;
	
	wire Carry;
	wire [m:0]Sub;
	assign {Carry, Sub}={1'b0, Nom[n+m-1:n-1]}-{2'b0, DeNom};
	
	always @(posedge C)
	begin
		// Start
		if(iStart) Init<=1;
		else if (Init & Cnt==n) Init<=0;
		
		if(iStart) 
		begin
			if(iNum < 0) 
			begin
				Nom<={NomNil, -iNum};
				NomSign <= 1;
			end
			else
			begin
				Nom<={NomNil, iNum};
				NomSign <= 0;
			end
		end
		else if(~Carry)
		begin
			Nom[n:0]<={Nom[n-2:0], 1'b0};
			Nom[n+m-1:n]<=Sub;
		end
		else Nom[n+m-1:0]<={Nom[n+m-2:0], 1'b0};
		
		if(iStart) 
		begin
			if(iDeNom < 0)
			begin
				DeNom[m-1:0]<=-iDeNom;
				DeNomSign <= 1;
			end
			else
			begin
				DeNom[m-1:0]<=iDeNom;
				DeNomSign <= 0;
			end
		end

		if(iStart) Cnt<=0;
		else Cnt<=Cnt+1;
		
		// Finish
		if(Init & Cnt==n) oRdy<=1;
		else oRdy<=0;
		
		if(Init & Cnt==n) 
		begin
			if(NomSign ^ DeNomSign) oDiv<=-Div;
			else                    oDiv<=Div;
		end
		if(Init & Cnt==n) oRem<=Nom[n+m-1:n];
		
		// Work	
		if(iStart) Div<=0;
		else
		begin
			Div[n-1:1]<=Div[n-2:0];
			Div[0]<=~Carry;
		end
	end
endmodule

module vRecShift
  #(
    parameter n=8,
    parameter m=8,
    parameter pDirection="right"
  )
  (
    input [n-1:0]iD, 
    input [m-1:0]iShift, 
    input iStart, 
    input C, 
    output reg [n-1:0]oD, 
    output reg oDR
  );
	
	wire [0:0]ErrDetect;
	assign ErrDetect[-1 + ((pDirection=="right" | pDirection == "left")?1:0)]=1'b0;
	
	reg [n-1:0]Data;
	reg [m-1:0]MaxShiftCnt;
	reg [m-1:0]ShiftCnt;
	
	reg Init;
	
	reg En;
	//wire En=&(~ShiftCnt);
	always @(posedge C)
	begin
		En<=(ShiftCnt==1);
		
		if(iStart) Data<=iD;
		else Data<=(pDirection=="right")?Data>>1:Data<<1;
		
		if(iStart) ShiftCnt<=iShift;
		else ShiftCnt<=ShiftCnt-1;
		
		if(iStart) Init<=1;
		else if(En) Init<=0;
		
		if(En & Init) oD<=Data;
		if(En & Init) oDR<=1;
		else oDR<=0;
		
	end
endmodule