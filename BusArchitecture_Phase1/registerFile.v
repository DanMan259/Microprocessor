// Register File
module registerFile #(parameter BITS = 32, REGISTERS = 16)(
			input [BITS-1:0] busMuxOut,
			input clk,
			input [REGISTERS-1:0] clr, loadEnable,
			output [BITS * REGISTERS - 1 : 0] registerStream
);
	generate
	genvar i;
		for (i = 0; i < REGISTERS; i = i + 1) begin: gen_registers
			register generalRegister(clk, clr[i], loadEnable[i], busMuxOut, registerStream[(i+1) * BITS - 1 : i*BITS]);
		end
	endgenerate	
endmodule
