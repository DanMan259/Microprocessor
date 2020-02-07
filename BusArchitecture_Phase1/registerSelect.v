// Module for register file

module registerSelect #(parameter BITS = 32, REGISTERS = 16)(
			input [BITS * REGISTERS - 1 : 0] registerStream,
			input [REGISTERS - 1 : 0] registerSelect,
			output reg [BITS - 1 : 0] busMuxOut
);
	generate
	genvar i;
	for (i = 0; i < REGISTERS; i = i + 1) begin : register_selector
		always @* begin
			if (registerSelect[i] == 1)
				busMuxOut <= registerStream[(i+1)*BITS-1: i*BITS];
		end
	end
	endgenerate
endmodule
