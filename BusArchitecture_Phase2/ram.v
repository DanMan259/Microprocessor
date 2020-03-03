// RAM

module ram #(parameter BITS=32, ADDR=9, RAMSIZE=512)(
	input [BITS-1:0] dataIn,
	input read,
	input write,
	input [ADDR-1:0] address,
	input clk,
	output reg [BITS-1:0] dataOut
);

	reg [BITS-1:0] RAM [RAMSIZE-1:0];

	always @ (posedge clk) begin
		if(write == 1 && read == 0) begin
			RAM[address] = dataIn;
		end
		else if (read == 1 && write == 0) begin 
			dataOut = RAM[address];
		end
	end
	
endmodule
