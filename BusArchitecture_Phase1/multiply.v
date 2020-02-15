// Multiply.v

module multiply #(parameter BITS=32)(
	input [BITS-1:0] multiplicand,
	input [BITS-1:0] multiplier,
	output reg [(BITS*2)-1:0] outputMul
);


	wire [BITS-1:0] negMul;
	negate neg_inst(multiplicand, negMul);
	reg [2:0] bitGroupings [(BITS/2)-1:0];						// Array of 3 bit groupings
	reg signed [BITS-1:0] partialProducts [(BITS/2)-1:0];	// The partial products which are computed based on combinedBits
	integer i, j;
	
	always @ *
	begin
		outputMul = {BITS{2'b0}};
		bitGroupings[0] = {multiplier[1], multiplier[0], 1'b0};
	
		for(i = 1;i<(BITS/2);i=i+1) begin
			bitGroupings[i] = {multiplier[(2*i)+1],multiplier[2*i],multiplier[(2*i)-1]};
		end	
	
		for(j=0;j<(BITS/2);j=j+1) begin 
			case(bitGroupings[j])    
				3'b001 , 3'b010 : partialProducts[j] = multiplicand;
				3'b011 : partialProducts[j] = {multiplicand, 1'b0};
				3'b100 : partialProducts[j] = {negMul, 1'b0};
				3'b101 , 3'b110 : partialProducts[j] = negMul;
				default : partialProducts[j] = {BITS{1'b0}};
			endcase
			outputMul = outputMul + (partialProducts[j] << (2*j));
		end
	end
endmodule
