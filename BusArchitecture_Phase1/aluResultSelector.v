// Operation result selector
// aluResultSelector

module aluResultSelector #(parameter BITS=32, SIG_COUNT=13, OUT_BITS=BITS)(
	input [(OUT_BITS*SIG_COUNT)-1:0] resultStream,
	input [SIG_COUNT-1:0] ctrl_signal,
	output [OUT_BITS-1:0] selectedResult
);

	genvar i;
	generate
		for(i = 0; i < SIG_COUNT; i = i + 1)begin : selectResult
			assign selectedResult = ctrl_signal[i] ? resultStream[((i+1)*OUT_BITS)-1:i*OUT_BITS] : {OUT_BITS{1'bz}};
		end
	endgenerate
	
endmodule
