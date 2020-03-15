// decoderOneHot

module decoderOneHot #(parameter OUTPUT_BITS = 16, INPUT_BITS = 4)(
    input [INPUT_BITS-1 : 0] in_decode,
    output [OUTPUT_BITS-1 : 0] out_decode
);

    // set the bit at position in_decode to 1
    genvar i;
    generate
        for(i = 0; i < OUTPUT_BITS; i = i + 1) begin : decode 
            assign out_decode[i] = (in_decode == i);
        end
    endgenerate
endmodule
