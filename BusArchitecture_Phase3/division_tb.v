// Division tb

`timescale 1ns/10ps

module division_tb;

	parameter BITS = 32;
	
	reg [BITS-1:0] X;
	reg [BITS-1:0] Y;
	wire [(2*BITS)-1:0] outDiv;
	
	division div_inst(X, Y, outDiv);
	
	initial begin
		X <= 40;
		Y <= 10;
	end
	
endmodule