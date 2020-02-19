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

	wire signed [(BITS*2) - 1:0] add_result, sub_result;
	wire signed [(BITS*2) - 1:0] mul_result, div_result;
	wire[(BITS*2) - 1:0] shiftR_result, shiftL_result;
	wire[(BITS*2) - 1:0] rotateR_result, rotateL_result;
	wire[(BITS*2) - 1:0] and_result, or_result;
	wire[(BITS*2) - 1:0] negate_result, not_result;
	
	
	assign add_result[(2*BITS)-1:BITS] = {BITS{1'bz}};
	assign sub_result[(2*BITS)-1:BITS] = {BITS{1'bz}};
	assign shiftR_result[(2*BITS)-1:BITS] = {BITS{1'bz}};
	assign shiftL_result[(2*BITS)-1:BITS] = {BITS{1'bz}};
	assign rotateR_result[(2*BITS)-1:BITS] = {BITS{1'bz}};
	assign rotateL_result[(2*BITS)-1:BITS] = {BITS{1'bz}};
	assign and_result[(2*BITS)-1:BITS] = {BITS{1'bz}};
	assign or_result[(2*BITS)-1:BITS] = {BITS{1'bz}};
	assign negate_result[(2*BITS)-1:BITS] = {BITS{1'bz}};
	assign not_result[(2*BITS)-1:BITS] = {BITS{1'bz}};
	
	
	aluResultSelector #(.BITS(BITS), .SIG_COUNT(SIG_COUNT), .OUT_BITS(BITS*2)) alu_out_select(
		{add_result, sub_result, mul_result, div_result, shiftR_result, shiftL_result, rotateR_result, rotateL_result, and_result, or_result, negate_result, not_result},
		ctrl_signal,
		operationResult
	);
	
	carryLookAheadAdder #(.BITS(BITS)) cla_inst(X, Y, add_result[BITS-1:0]);
	subtract #(.BITS(BITS)) sub_inst(X, Y, sub_result[BITS-1:0]);
	multiply #(.BITS(BITS)) mul_inst(X, Y, mul_result);
	division #(.BITS(BITS)) div_inst(X, Y, div_result);
	shiftR #(.BITS(BITS)) shiftR_inst(X, Y, shiftR_result[BITS-1:0]);
	shiftL #(.BITS(BITS)) shiftL_inst(X, Y, shiftL_result[BITS-1:0]);
	rotateR #(.BITS(BITS)) rotateR_inst(X, Y, rotateR_result[BITS-1:0]);
	rotateL #(.BITS(BITS)) rotateL_inst(X, Y, rotateL_result[BITS-1:0]);
	assign and_result[BITS-1:0] =  X && Y;
	assign or_result[BITS-1:0] = X || Y;
	negate #(.BITS(BITS))  negate_inst(X, negate_result[BITS-1:0]);
	notBits #(.BITS(BITS))  notBits_inst(X, not_result[BITS-1:0]);
	
endmodule
		