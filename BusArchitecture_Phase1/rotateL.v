// Rotate Left 

module rotateL #(parameter BITS=32)(
	input [BITS-1:0] in,
	input [BITS-1:0] rotateAmount,
	output wire [BITS-1:0] out
);

	assign out = ((in << rotateAmount)|(in >> (BITS-rotateAmount)));
endmodule

