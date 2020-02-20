// Register File

// Register stream ordering
// Indexes for registers shown below
/*
0 - r0
1 - r1
2 - r2
3 - r3
4 - r4
5 - r5
6 - r6
7 - r7
8 - r8
9 - r9
10 - r10
11 - r12
12 - r13
13 - r14
14 - r15
15 - pc
16 - ir
17 - rY
18 - rZ (LOWER)
19 - rZ (UPPER)
20 - mar
21 - HI
22 - LO
23 - MDR
*/

module registerFile #(parameter BITS = 32, REGISTERS = 24)(
			input [BITS-1:0] busMuxOut,
			input clk,
			input [REGISTERS-1:0] clr, loadEnable,
			output [BITS * REGISTERS - 1 : 0] registerStream
);
	generate
	genvar i;
		for (i = 0; i < REGISTERS; i = i + 1) begin: gen_registers
			register #(.BITS(BITS)) generalRegister(clk, clr[i], loadEnable[i], busMuxOut, registerStream[(i+1) * BITS - 1 : i*BITS]);
		end
	endgenerate	
	
	
	
endmodule
