// Module for single register
module register #(parameter BITS = 32)(
	input clk, input clear, input loadEnable, 
	input [BITS-1:0] inputD, 
	output reg [BITS-1:0] outputQ);

// To check whether clock or clear is selected
wire sen;
assign sen = clk || clear;

// At ever positive edge do this
always @ (posedge sen)
	// If clear else put value
	if (clear == 1)
		outputQ <= {BITS{1'b0}};
	else if (loadEnable == 1)
		outputQ <= inputD;
endmodule
