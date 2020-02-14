// ALU tb

`timescale 1ns/10ps

module alu_tb;

	parameter BITS = 32;
	
	reg [11:0] ctrl_signal;
	reg [BITS-1:0] X, Y;
	
	wire [(BITS*2)-1:0] OpResult;
	
	alu alu_inst(ctrl_signal, X, Y, OpResult);
	
	initial begin
		X <= {32{1'b1}};
		Y <= 0;
		ctrl_signal <= 12'b000100000000; // Logical AND
		#100 ctrl_signal <= 12'b001000000000; // Logical OR
		#100
		X <= 3;
		Y <= 5;
		ctrl_signal <= 12'b000000000001; // add
	end
endmodule
