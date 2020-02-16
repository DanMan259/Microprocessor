// Not (one's compliment)

module notBits #(parameter BITS=32)(
	input [BITS-1:0] in,
	output wire [BITS-1:0] out
);

	assign out = (in ^ {BITS{1'b1}});

endmodule
