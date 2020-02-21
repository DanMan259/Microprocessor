// ALU tb

`timescale 1ns/10ps

module alu_tb;

	parameter BITS = 32;
	parameter SIG_COUNT = 12;
	
	reg [11:0] ctrl_signal;
	reg signed [BITS-1:0] X, Y;
	integer i;
	
	//wire signed [BITS-1:0] OpResult_HI,OpResult_LO;
	wire signed [(BITS*2)-1:0] OpResult;
	//assign OpResult = {OpResult_HI, OpResult_LO};
	alu alu_inst(ctrl_signal, X, Y, OpResult);
	
	initial begin
		X <= {BITS{1'b0}};
		Y <= {BITS{1'b0}};
		
		for(i = 0; i<4; i=i+1) begin
			#10
			ctrl_signal = {SIG_COUNT{1'b0}};
			ctrl_signal[i] = 1;
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
		
		for(i = 4; i<6; i=i+1) begin
			#10
			ctrl_signal = {SIG_COUNT{1'b0}};
			ctrl_signal[i] = 1;
			X <= 16;
			Y <= 2;
		end
		#10
		ctrl_signal = {SIG_COUNT{1'b0}};
		ctrl_signal[6] = 1;
		X <= 2;
		Y <= 2;
		#10
		ctrl_signal = {SIG_COUNT{1'b0}};
		ctrl_signal[7] = 1;
		X <= 2147483648;
		Y <= 2;
		for(i = 8; i<12; i=i+1) begin
			#10
			ctrl_signal = {SIG_COUNT{1'b0}};
			ctrl_signal[i] = 1;
			X <= 15;
			Y <= {BITS{1'b0}};
		end
	end
endmodule
