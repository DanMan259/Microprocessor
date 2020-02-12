// Carry Lookahead tb

`timescale 1ns/10ps

module carryLookAheadAdder_tb;
	
	parameter BITS = 32;
	
	reg [BITS-1:0] summand1 = 0;
	reg [BITS-1:0] summand2 = 0;
	wire [BITS:0] sum;
	
	carryLookAheadAdder #(.BITS(BITS)) cla_inst(
		.summand1_32_bits(summand1),
		.summand2_32_bits(summand2),
		.outputSum(sum)
	);
	
	initial begin
		#10
		summand1 = 3'b000;
		summand2 = 3'b001;
		#10
		summand1 = 3'b010;
		summand2 = 3'b010;
		#10
		summand1 = 3'b101;
		summand2 = 3'b110;
		#10
		summand1 = 3'b111;
		summand2 = 3'b111;
	end
	
endmodule
