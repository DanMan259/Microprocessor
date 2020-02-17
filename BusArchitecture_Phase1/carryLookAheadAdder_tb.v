// Carry Lookahead tb

`timescale 1ns/10ps

module carryLookAheadAdder_tb;
	
	parameter BITS = 32;
	
	reg [BITS-1:0] summand1 = 0;
	reg [BITS-1:0] summand2 = 0;
	wire [BITS-1:0] sum;
	
	carryLookAheadAdder #(.BITS(BITS)) cla_inst(
		.summand1_32_bits(summand1),
		.summand2_32_bits(summand2),
		.outputSum(sum)
	);
	
	initial begin
		#10
		summand1 = 4;
		summand2 = 3;
		#10
		summand1 = 10;
		summand2 = 11;
		#10
		summand1 = 3;
		summand2 = 5;
		#10
		summand1 = 7;
		summand2 = 7;
	end
	
endmodule
