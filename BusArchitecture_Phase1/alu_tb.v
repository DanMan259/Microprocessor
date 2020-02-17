// ALU tb

`timescale 1ns/10ps

module alu_tb;

	parameter BITS = 32;
	parameter SIG_COUNT = 12;
	
	reg [11:0] ctrl_signal;
	reg signed [BITS-1:0] X, Y;
	integer i;
	
	wire signed [(BITS*2)-1:0] OpResult;
	
	alu alu_inst(ctrl_signal, X, Y, OpResult);
	
	initial begin
		//X <= {BITS{1'b1}};
		//Y <= {BITS{1'b0}};
		X <= 15;
		Y <= 5;
		for(i = 0; i<SIG_COUNT; i=i+1) begin
			ctrl_signal = {SIG_COUNT{1'b0}};
			ctrl_signal[i] = 1;
			#10
			X <= 15;
			Y <= 5;
			#10
			X <= -15;
			Y <= 5;
			#10
			X <= 15;
			Y <= -5;
			#10
			X <= -15;
			Y <= -5;
		end
		/*
		ctrl_signal <= 12'b000100000000; // Logical AND
		#10 ctrl_signal <= 12'b001000000000; // Logical OR
		#10
		X <= 3;
		Y <= 5;
		ctrl_signal <= 12'b000000000001; // add
		#10
		X <= 15;
		Y <= 5;
		ctrl_signal <= 12'b000000000010; // sub
		#10
		X <= 10;
		Y <= 15;
		ctrl_signal <= 12'b000000000010; // sub
		#10
		X <= 10;
		Y <= -10;
		ctrl_signal <= 12'b000000000010; // sub
		#10
		X <= -15;
		Y <= 10;
		ctrl_signal <= 12'b000000000010; // sub
		#10
		X <= -15;
		Y <= -5;
		ctrl_signal <= 12'b000000000010; // sub
		#10
		X <= 15;
		Y <= 5;
		ctrl_signal <= 12'b000000000100; // mul
		#10
		X <= 15;
		Y <= -5;
		ctrl_signal <= 12'b000000000100; // mul
		#10
		X <= -15;
		Y <= 5;
		ctrl_signal <= 12'b000000000100; // mul
		#10
		X <= -15;
		Y <= -5;
		ctrl_signal <= 12'b000000000100; // mul
		#10
		X <= 15;
		Y <= 5;
		ctrl_signal <= 12'b000000001000; // div
		#10
		X <= 15;
		Y <= -5;
		ctrl_signal <= 12'b000000001000; // div
		#10
		X <= -15;
		Y <= 5;
		ctrl_signal <= 12'b000000001000; // div
		#10
		X <= -15;
		Y <= -5;
		ctrl_signal <= 12'b000000001000; // div
		*/
	end
endmodule
