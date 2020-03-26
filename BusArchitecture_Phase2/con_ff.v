// con_ff.v

module con_ff  #(parameter BITS = 32)(
    input [BITS-1:0] bus,
    input [1:0] IR_C2,
    input CON_enable,
    output reg Q
);

	reg con_d;
	
   always @ (bus, IR_C2) begin
		case(IR_C2)
			2'b00: con_d <= (bus == 32'h00000000)? 1'b1 : 1'b0;
			2'b01: con_d <= (bus != 32'h00000000)? 1'b1 : 1'b0;
			2'b10: con_d <= (bus[BITS-1] == 1'b0)? 1'b1 : 1'b0;
			2'b11: con_d <= (bus[BITS-1] == 1'b1)? 1'b1 : 1'b0;
			default: con_d <= 0;
		endcase
	end
	
	always @(posedge CON_enable) begin
		Q <= con_d;
	end
endmodule
