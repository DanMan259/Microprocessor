// Register Testbench
`timescale 1ns/10ps
module register_tb;

reg [31:0] input_D;
reg clk;
reg clear;
reg loadEnable;
wire [31:0] outputQ;

register reg_32(clk, clear, clk, input_D, outputQ);



initial 
	begin
		// Generate clock signal
		clk = 0;
		forever #10 clk = ~clk;
end

initial
	begin
		@ (posedge clk);
			input_D <= 32'b0;
		@ (posedge clk);
			input_D <= {32{1'b1}};
		@ (posedge clk);
			input_D <= 32'b0;
end

endmodule
	