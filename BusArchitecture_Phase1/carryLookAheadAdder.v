// Carry lookahead adder

module carry_look_ahead_adder #(parameter BITS=32)(
	input [BITS-1:0] summand1_32_bits,
	input [BITS-1:0] summand2_32_bits,
	output [BITS:0] outputSum
);

	wire [BITS:0] w_C;
	wire [BITS-1:0] w_G, w_P, w_Sum;

	// Create the full adders
	genvar i;
	generate
		for(i=0; i<BITS; i=i+1) begin
			fulladder_cla full_adder_inst(
				.summand1(summand1_32_bits[i]),
				.summand2(summand2_32_bits[i]),
				.inCarry(w_C[i]),
				.sum(w_Sum[i])
			);
		end
	endgenerate
	

	// Generate the Generate terms and Propagate terms and Carry Terms
	genvar j;
	generate
		for(j=0; j<BITS; j=j+1)
			begin
				// FINISH THIS