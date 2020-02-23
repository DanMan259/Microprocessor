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
12 - incPC
*/

module alu #(parameter BITS = 32, SIG_COUNT = 13)(
	input [SIG_COUNT-1:0] ctrl_signal,
	input [BITS-1:0] X, Y,
	//output [BITS-1:0] operationResult_HI,operationResult_LO
	output [(BITS*2)-1:0] operationResult
);

	wire signed [BITS - 1:0] add_result, sub_result;
	wire signed [(BITS*2) - 1:0] mul_result, div_result;
	wire[BITS - 1:0] shiftR_result, shiftL_result;
	wire[BITS - 1:0] rotateR_result, rotateL_result;
	wire[BITS - 1:0] and_result, or_result;
	wire[BITS - 1:0] negate_result, not_result;
	wire [BITS - 1:0] pc_result;
	
	aluResultSelector #(.BITS(BITS), .SIG_COUNT(SIG_COUNT), .OUT_BITS(BITS)) alu_out_select_LO(
		{pc_result, not_result, negate_result, or_result, and_result, rotateL_result, rotateR_result, shiftL_result, shiftR_result, div_result[BITS-1:0], mul_result[BITS-1:0], sub_result, add_result},
		ctrl_signal,
		operationResult[BITS-1:0]
	);
	aluResultSelector #(.BITS(BITS), .SIG_COUNT(SIG_COUNT), .OUT_BITS(BITS)) alu_out_select_HI(
		//{{BITS{1'bz}}, {BITS{1'bz}}, {BITS{1'bz}}, {BITS{1'bz}}, {BITS{1'bz}}, {BITS{1'bz}}, {BITS{1'bz}}, {BITS{1'bz}}, {BITS{1'bz}}, div_result[(2*BITS)-1:BITS], mul_result[(2*BITS)-1:BITS], {BITS{1'bz}}, {BITS{1'bz}}},
		{{BITS{pc_result[BITS-1]}}, {BITS{not_result[BITS-1]}}, {BITS{negate_result[BITS-1]}}, {BITS{or_result[BITS-1]}}, {BITS{and_result[BITS-1]}}, {BITS{rotateL_result[BITS-1]}}, {BITS{rotateR_result[BITS-1]}}, {BITS{shiftL_result[BITS-1]}}, {BITS{shiftR_result[BITS-1]}}, div_result[(2*BITS)-1:BITS], mul_result[(2*BITS)-1:BITS], {BITS{sub_result[BITS-1]}}, {BITS{add_result[BITS-1]}}},
		ctrl_signal,
		operationResult[(BITS*2)-1:BITS]
	);
	
	
	carryLookAheadAdder #(.BITS(BITS)) cla_inst(X, Y, add_result);
	subtract #(.BITS(BITS)) sub_inst(X, Y, sub_result);
	multiply #(.BITS(BITS)) mul_inst(X, Y, mul_result);
	division #(.BITS(BITS)) div_inst(X, Y, div_result);
	shiftR #(.BITS(BITS)) shiftR_inst(X, Y, shiftR_result);
	shiftL #(.BITS(BITS)) shiftL_inst(X, Y, shiftL_result);
	rotateR #(.BITS(BITS)) rotateR_inst(X, Y, rotateR_result);
	rotateL #(.BITS(BITS)) rotateL_inst(X, Y, rotateL_result);
	assign and_result =  X && Y;
	assign or_result = X || Y;
	negate #(.BITS(BITS))  negate_inst(X, negate_result);
	notBits #(.BITS(BITS))  notBits_inst(X, not_result);
	carryLookAheadAdder #(.BITS(BITS)) PC_INC_ADDER (32'b0100, Y, pc_result);
	
endmodule
		