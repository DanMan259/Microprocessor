// selectAndEncode tb

`timescale 1ns/10ps

module selectAndEncode_tb;

    parameter BITS = 32;

    reg [BITS-1 : 0] IR;
    reg Gra, Grb, Grc, Rin, Rout, BAout;
    wire [(BITS/2)-1 : 0] reg_in_ctrl, reg_out_ctrl;
    wire [BITS-1 : 0] c_sign_extended;
    wire [(BITS/2)-1 : 0] decoder_out;
    wire [(BITS/4)-1 : 0] decoder_in;

    selectAndEncode #(.BITS(BITS)) sAndE_inst(IR, Gra, Grb, Grc, Rin, Rout, BAout, reg_in_ctrl, reg_out_ctrl, c_sign_extended, decoder_out, decoder_in);

    initial begin
      // R format
      IR <= 32'b00011_0110_0000_1101_00001001000010;
      Gra <= 1;
      Grb <= 1;
      Grc <= 1;
      Rin <= 0;
      Rout <= 1;
      BAout <= 1;
    end