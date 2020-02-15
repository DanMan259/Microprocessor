// Negate (two's compliment)

module negate #(parameter BITS=32)(
	input [BITS-1:0] in,
	output wire [BITS:0] out
);

	carryLookAheadAdder cla_inst(in ^ {BITS{1'b1}}, 1, out);

endmodule
