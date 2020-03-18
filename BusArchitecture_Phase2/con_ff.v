// con_ff.v

module con_ff  #(parameter BITS = 32)(
    input [BITS-1 : 0] bus,
    input [1 : 0] IR_C2,
    input CON_enable,
    output reg Q
);

    always @ (bus, IR_C2, CON_enable)
	begin
		if(CON_enable == 1) begin
			case(IR_C2)
			2'b00: Q <= (bus == 32'h00000000)? 1 : 0;
			2'b01: Q <= (bus != 32'h00000000)? 1 : 0;
			2'b10: Q <= (bus[31] == 1'b0)? 1 : 0;
			2'b11: Q <= (bus[31] == 1'b1)? 1 : 0;
			default: Q <= 0;
			endcase
		end
		else begin
			Q <= 0;
		end
	end
endmodule