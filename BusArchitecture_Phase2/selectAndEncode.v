// Select and Encode 

module selectAndEncode #(parameter BITS = 32, REGISTERS = 16, REGISTER_BITS = $clog2(REGISTERS))(
    input [BITS-1:0] IR,
    input Gra, Grb, Grc, Rin, Rout, BAout,
    output [REGISTERS-1:0] reg_in_ctrl, reg_out_ctrl,
    output [BITS-1:0] c_sign_extended
);

    // Generate decoder input and c_sign_extended
	 localparam regA = BITS-5-1;
	 localparam regB = regA-REGISTER_BITS;
	 localparam regC = regB-REGISTER_BITS;
	 localparam Unused = regC-REGISTER_BITS;
	 
	 // Realized the only time this is used is when the instruction is in
	 // I-Format, so we always assume Immediate bits end where regC is suppose
	 // to end. Do not read the sign extended output unless in I Format
    //assign c_sign_extended = {{(BITS-Unused){IR[Unused]}}, IR[Unused:0]};
	 assign c_sign_extended = {{(BITS-1-regC){IR[regC]}}, IR[regC:0]};
	 
    wire [REGISTER_BITS-1:0] decoder_in;
	 assign decoder_in = (IR[regA:regB+1]&{REGISTER_BITS{Gra}}) | (IR[regB:regC+1]&{REGISTER_BITS{Grb}}) | (IR[regC:Unused+1]&{REGISTER_BITS{Grc}});
	 
	 genvar i;
    generate
        for(i = 0; i < REGISTERS; i = i + 1) begin : decode 
				assign reg_in_ctrl[i] = (decoder_in == i) & Rin;
            assign reg_out_ctrl[i] = (decoder_in == i) & (Rout|BAout);
        end
    endgenerate


endmodule
