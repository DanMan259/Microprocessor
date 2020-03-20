`timescale 1ns/10ps

module registerFile_tb;
	parameter BITS = 32;
	parameter REGISTERS = 16;
	
	reg [BITS-1:0] busMuxOut;
	reg clk;
	reg [REGISTERS-1:0] clr, loadEnable;
	wire [(REGISTERS*BITS)-1:0] registerStream;
	
	registerFile regFile(busMuxOut, clk, clr, loadEnable, registerStream);
	
	initial begin
		// Initialize the registers 
		clr <= {REGISTERS{1'B0}};
		loadEnable <= {REGISTERS{1'b1}};
		
		// Generate a clock signal
		clk = 1;
		forever #10 clk = ~clk;
	end
	
	initial begin
		busMuxOut <= {BITS{1'b1}};
		#100 busMuxOut <= 0;
	end
endmodule

		