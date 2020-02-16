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
8 - logical and
9 - logical or
10 - negate (two's compliment)
11 - Not (one's compliment)
*/

module alu #(parameter BITS = 32, SIG_COUNT = 12)(
	input [SIG_COUNT-1:0] ctrl_signal,
	input [BITS-1:0] X, Y,
	output [(BITS*2)-1:0] operationResult
);

	wire[BITS - 1:0] add_result, sub_result;
	wire[(BITS*2) - 1:0] mul_result, div_result;
	wire[BITS - 1:0] shiftR_result, shiftL_result;
	wire[BITS - 1:0] rotateR_result, rotateL_result;
	wire[BITS - 1:0] and_result, or_result;
	wire[BITS - 1:0] negate_result, not_result;
	
	aluResultSelector #(.BITS(BITS), .SIG_COUNT(SIG_COUNT), .OUT_BITS(BITS*2)) alu_out_select(
		{add_result, sub_result, mul_result, div_result, shiftR_result, shiftL_result, rotateR_result, rotateL_result, and_result, or_result, negate_result, not_result},
		ctrl_signal,
		operationResult
	);
	
	carryLookAheadAdder cla_inst(X, Y, add_result);
	subtract sub_inst(X, Y, sub_result);
	multiply mul_inst(X, Y, mul_result);
	division div_inst(X, Y, div_result);
	shiftR shiftR_inst(X, Y, shiftR_result);
	shiftL shiftL_inst(X, Y, shiftL_result);
	rotateR rotateR_inst(X, Y, rotateR_result);
	rotateL rotateL_inst(X, Y, rotateL_result);
	assign and_result = X && Y;
	assign or_result = X || Y;
	negate negate_inst(X, Y, negate_result);
	notBits notBits_inst(X, Y, not_result);
	
endmodule
		