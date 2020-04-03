// RAM tb

`timescale 1ns/10ps

module ram_tb;
	parameter BITS=32, RAMSIZE=512, ADDR=$clog2(RAMSIZE);
	
	
	reg [BITS-1:0] dataIn;
	reg read;
	reg write;
	reg [ADDR-1:0] address;
	reg clk;
	wire [BITS-1:0] dataOut;
	
	ram #(.BITS(BITS), .ADDR(ADDR), .RAMSIZE(RAMSIZE)) ram_inst(dataIn, read, write, address, clk, dataOut);
	
	initial
    begin
        clk = 0;
        forever #10 clk = ~clk;
    end
	 
	 initial begin 
		// Initialize values to default
		dataIn <= 'h0;
		address <= 'h0;
		write <= 0;
		read <= 0;
		#100;
		dataIn <= 'h5;
		address <= 'h3;
		write <= 1;
		read <= 0;
		#20;
		dataIn <= 'h5;
		write <= 0;
		read <= 1;
	 end
	
endmodule
