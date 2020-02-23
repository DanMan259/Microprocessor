// Negate (two's compliment)

module negate #(parameter BITS=32)(
	input [BITS-1:0] in,
	output wire [BITS-1:0] out
);

	wire [BITS-1:0] notResult;
	notBits #(.BITS(BITS)) not_inst(in, notResult);

	carryLookAheadAdder #(.BITS(BITS)) cla_inst(notResult, 1, out);

endmodule
