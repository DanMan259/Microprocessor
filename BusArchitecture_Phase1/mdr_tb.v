// MDR tb

`timescale 1ns/10ps

module mdr_tb;

	parameter BITS=32;
	
	reg [BITS-1:0] busMuxOut, MDataIn;
	reg read, clk, clear, enable;
	wire [BITS-1:0] MDRout;
	
	mdr #(.BITS(BITS)) mdr_inst(busMuxOut, MDataIn, read, clk, clear, enable, MDRout);
	
	initial begin
		read <= 1;
		clear <= 0;
		enable <= 1;
		
		clk = 1;
		forever #10 clk = ~clk;
		
	end
	
	initial begin
		busMuxOut <= {BITS{1'b1}};
		MDataIn <= 0;
		#100 read <= 0;
		#100 read <= 1;
	end
endmodule
