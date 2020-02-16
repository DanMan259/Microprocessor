// Subtract

module subtract #(parameter BITS=32)(
	input [BITS-1:0] X,
	input [BITS-1:0] Y,
	output [BITS-1:0] outputSub
);

	wire [BITS-1:0] negatedY;
	
	negate neg_inst(Y, negatedY);
	
	carryLookAheadAdder cla_inst(X, negatedY, outputSub);
	
endmodule
