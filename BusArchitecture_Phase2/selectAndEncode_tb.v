// selectAndEncode tb

`timescale 1ns/10ps

module selectAndEncode_tb;

    parameter BITS = 32;
	 parameter REGISTERS = 16;
	 parameter REGISTER_BITS = $clog2(REGISTERS);
	 localparam immediateValLen = (BITS-5-(REGISTER_BITS*3));
	
    wire [BITS-1:0] IR;
    reg Gra, Grb, Grc, Rin, Rout, BAout;
    wire [REGISTERS-1:0] reg_in_ctrl, reg_out_ctrl;
    wire [BITS-1:0] c_sign_extended;

	 reg [4:0] opCode;	 
	 reg [REGISTER_BITS-1:0] regA, regB, regC;
	 reg [immediateValLen-1:0] immediateVal;
	 assign IR = {opCode, regA, regB, regC, immediateVal};
	 
    selectAndEncode #(.BITS(BITS), .REGISTERS(REGISTERS), .REGISTER_BITS(REGISTER_BITS)) sAndE_inst(IR, Gra, Grb, Grc, Rin, Rout, BAout, reg_in_ctrl, reg_out_ctrl, c_sign_extended);

    initial begin
      // R format
		opCode <= 5'b00011;
		regA <= ({REGISTER_BITS{1'b0}} + 6);
		regB <= ({REGISTER_BITS{1'b0}} + 0);
		regC <= ({REGISTER_BITS{1'b0}} + 13);
		immediateVal <= ({immediateValLen{1'b0}}+4130);
      Gra <= 1;
      Grb <= 0;
      Grc <= 0;
      Rin <= 0;
      Rout <= 1;
      BAout <= 1;
    end

endmodule
