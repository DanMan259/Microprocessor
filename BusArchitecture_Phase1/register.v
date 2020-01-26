module register(clk, clear, loadEnable, inputD, outputQ);

input [31:0] inputD;
input clk, clear, loadEnable;

output reg [31:0] outputQ;

// should we have this?
wire sen;
assign sen = clk || clear;

always @ (posedge sen)
begin
	if (clear == 1)
	begin
		outputQ <= 0;
	end
	else if (loadEnable == 1)
	begin
		outputQ <= inputD;
	end
end
endmodule
