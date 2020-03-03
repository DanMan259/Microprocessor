// Register Testbench
`timescale 1ns/10ps
module register_tb;
	parameter BITS = 32;
	reg [BITS-1:0] input_D;
	reg clk;
	reg clear;
	//reg loadEnable;
	wire loadEnable;
	assign loadEnable = clk;
	wire [BITS-1:0] outputQ;

	register reg_32(clk, clear, loadEnable, input_D, outputQ);



	initial begin
			clk = 0;
			clear = 0;
			input_D = {BITS{1'b0}};
			forever #10 clk = ~clk;
	end


	initial begin
		@ (posedge clk)
			input_D = ~input_D;
		@ (posedge clk)
			input_D = ~input_D;
		@ (posedge clk)
			clear = 1;
			input_D = ~input_D;
		@ (posedge clk)
			input_D = ~input_D;
		@ (posedge clk)
			clear = 0;
			input_D = ~input_D;
		@ (posedge clk)
			input_D = ~input_D;
		@ (posedge clk)
			input_D = ~input_D;
	end
endmodule
	