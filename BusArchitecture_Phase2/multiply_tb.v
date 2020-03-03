// Multiplication tb

`timescale 1ns/10ps

module multiply_tb;

	parameter BITS = 32;
	
	reg [BITS-1:0] X;
	reg [BITS-1:0] Y;
	wire [(2*BITS)-1:0] outMul;
	multiply mul_inst(X, Y, outMul);
	
	
	initial begin
		X <= 33;
		Y <= 33;
	end
	
endmodule