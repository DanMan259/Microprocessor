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
11 - r11
12 - r12
13 - r13
14 - r14
15 - r15
16 - pc
17 - ir
18 - rY
19 - rZ (LOWER)
20 - rZ (UPPER)
21 - mar
22 - HI
23 - LO
24 - MDR
*/

module registerFile #(parameter BITS = 32, REGISTERS = 25)(
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
