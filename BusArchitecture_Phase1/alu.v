// ALU

// ctrl_signal is a one-hot encoding
// Indexes for ctrl_signal shown below
/*
0 - add
1 - subtract
2 - multiply
3 - divide
4 - shift right
5 - shift left
6 - rotate right
7 - rotate left
8 - logical add
9 - logical or
10 - negate (two's compliment)
11 - Not (one's compliment)
*/

module alu #(parameter BITS = 32)(
	input [11:0] ctrl_signal,
	input [BITS-1:0] X, Y,
	output [(BITS*2)-1:0] operationResult
);

	wire[BITS:0] add_result;
	wire[BITS-1:0] and_result, or_result;
	
	aluResultSelector #(.SIG_COUNT(3), .OUT_BITS(BITS*2)) alu_out_select(
		{add_result, and_result, or_result},
		{ctrl_signal[0], ctrl_signal[8], ctrl_signal[9]},
		operationResult
	);
	
	carryLookAheadAdder cla_inst(X, Y, add_result);
	assign and_result = X && Y;
	assign or_result = X || Y;
	
endmodule
		