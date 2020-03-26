// RAM

module ram #(parameter BITS=32, RAMSIZE=512, ADDR=$clog2(RAMSIZE))(
	input [BITS-1:0] dataIn,
	input read,
	input write,
	input [ADDR-1:0] address,
	input clk,
	output reg [BITS-1:0] dataOut
);

	reg [BITS-1:0] RAM [0:RAMSIZE-1];
	
	initial begin
		RAM[0] <= 32'b00000_0000_0000_0000000000000000000;
		RAM[4] <= 32'b00000_0001_0000_0000000000001010101;
		
	end

	always @ (posedge clk) begin
		if(write == 1 && read == 0) begin
			RAM[address] = dataIn;
		end
		else if (read == 1 && write == 0) begin 
			dataOut = RAM[address];
		end
	end
	
endmodule
