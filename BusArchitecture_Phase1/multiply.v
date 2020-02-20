// Multiply.v

module multiply #(parameter BITS=32)(
	input [BITS-1:0] multiplicand,
	input [BITS-1:0] multiplier,
	output reg [(BITS*2)-1:0] outputMul
);


	wire [BITS-1:0] negMul;
	negate neg_inst(multiplicand, negMul);
	reg [2:0] bitGroupings [(BITS/2)-1:0];	// Array of 3 bit groupings
	reg signed [BITS:0] currentAddition;				// current derived value from bit grouping
	reg signed [(BITS*2)-1:0] shiftedCurrentAddition;
	integer i, j;
	
	always @ (*)
	begin
		outputMul = 0;
		bitGroupings[0] = {multiplier[1], multiplier[0], 1'b0};
	
		for(i = 1;i<(BITS/2);i=i+1) begin
			bitGroupings[i] = {multiplier[(2*i)+1],multiplier[2*i],multiplier[(2*i)-1]};
		end	
	
		for(j=0;j<(BITS/2);j=j+1) begin 
			case(bitGroupings[j])    
				3'b001 , 3'b010 : currentAddition = {multiplicand[BITS-1], multiplicand};
				3'b011 : currentAddition = {multiplicand, 1'b0};
				3'b100 : currentAddition = {negMul, 1'b0};
				3'b101 , 3'b110 : currentAddition = {negMul[BITS-1], negMul};
				default : currentAddition = 0;
			endcase
			shiftedCurrentAddition = currentAddition << (2*j);
			outputMul = (outputMul + shiftedCurrentAddition);
		end
	end
endmodule
