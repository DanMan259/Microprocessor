// Rotate Right 

module rotateR #(parameter BITS=32)(
	input [BITS-1:0] in,
	output wire [BITS-1:0] out
);
	assign out = (in >> 1);
endmodule
