// Register File
module registerFile #(parameter BITS = 32, REGISTERS = 24)(
			output reg [BITS * REGISTERS - 1 : 0] registerStream
);
	always @* begin
		registerStream <= {BITS*REGISTERS{1'b0}};
	end
endmodule