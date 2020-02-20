// Shift Right 

module shiftR #(parameter BITS=32)(
	input [BITS-1:0] in,
	input [BITS-1:0] shiftAmount,
	output wire [BITS-1:0] out
);
	assign out = (in >> shiftAmount);
endmodule
