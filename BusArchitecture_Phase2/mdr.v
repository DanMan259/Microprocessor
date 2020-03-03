// MDR (Memory Data Register) with MUX to select between input from the bus or the mem chip

module mdr #(parameter BITS=32)(
	input [BITS-1:0] busMuxOut, MDataIn,
	input read, clk, clear, enable,
	output [BITS-1:0] MDRout
);

	reg [BITS-1:0] muxOut; 
	
	always @ (busMuxOut, MDataIn, read) begin
		if(read == 1)
			muxOut <= MDataIn;
		else
			muxOut <= busMuxOut;
			
	end
	
	register #(.BITS(BITS)) MDR_reg(clk, clear, enable, muxOut, MDRout);
	
endmodule
