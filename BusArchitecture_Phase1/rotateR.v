// Rotate Right 

module rotateR #(parameter BITS=32)(
	input [BITS-1:0] in,
	input [BITS-1:0] rotateAmount,
	output wire [BITS-1:0] out
);

	assign out = ((in >> (rotateAmount % BITS))|(in << (BITS-(rotateAmount % BITS))));
endmodule

