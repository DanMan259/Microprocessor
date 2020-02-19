// Multiplication tb

`timescale 1ns/10ps

module multiply_tb;

	parameter BITS = 32;
	
	reg [BITS-1:0] X;
	reg [BITS-1:0] Y;
	wire [(2*BITS)-1:0] outMul;
	wire [BITS-1:0] lower;
	wire [BITS-1:0] upper;
	assign upper = outMul[(BITS*2)-1:BITS];
	assign lower = outMul[BITS-1:0];
	multiply mul_inst(X, Y, outMul);
	
	
	initial begin
		X <= 33;
		Y <= 3;
	end
	
endmodule