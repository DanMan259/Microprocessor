// Fulladders for carry-lookahead adder

module fulladder_cla(
	input summand1,
	input summand2,
	input inCarry,
	output sum
);

	assign sum = ((summand1 ^ summand2) ^ inCarry);
	
endmodule
