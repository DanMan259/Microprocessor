// Select and Encode 

module selectAndEncode #(parameter BITS = 32)(
    input [BITS-1 : 0] IR,
    input Gra, Grb, Grc, Rin, Rout, BAout,
    output [(BITS/2)-1 : 0] reg_in_ctrl, reg_out_ctrl,
    output [BITS-1 : 0] c_sign_extended,
    output wire [BITS-1 : 0] decoder_out,
    output wire [(BITS/4)-1 : 0] decoder_in
);

    // Generate decoder input and c_sign_extended
    assign c_sign_extended = {{14{IR[18]}}, IR[17 : 0]};
    assign decoder_in = (IR[26 : 23] & {4{Gra}}) | (IR[22 : 19] & {4{Grb}}) | (IR[18 : 15] & {4{Grc}});
    decoderOneHot #(.OUTPUT_BITS(BITS/2), .INPUT_BITS(BITS/4)) decoder_inst(decoder_in, decoder_out);

    genvar i;
    generate 
        for(i = 0; i < (BITS/2); i = i + 1) begin : encode 
            assign reg_in_ctrl[i] = decoder_out[i] & Rin;
            assign reg_out_ctrl[i] = decoder_out[i] & (Rout | BAout);
        end 
    endgenerate
endmodule
