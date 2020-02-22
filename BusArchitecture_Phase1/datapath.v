// Datapath
																																																																		
module datapath #(parameter BITS=32, REGISTERS=16, TOT_REGISTERS=22, SIG_COUNT=12)(
	input clk, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, PCin, IRin, RYin, RZin, MARin, HIin, LOin, MDRin, Read, MDRout, LOout, HIout, RZHIout, RZLOout, PCout, R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT,
	input [BITS-1:0] MDataIn,
	output [BITS * REGISTERS - 1 : 0] genRegisterStream
);

	wire [BITS-1:0] bus;
	//wire [BITS * REGISTERS - 1 : 0] genRegisterStream;
	wire [BITS-1:0] PCVal;
	wire [BITS-1:0] IRVal;
	wire [BITS-1:0] RYVal;
	wire [(BITS*2)-1:0] RZVal;
	wire [BITS-1:0] MARVal;
	wire [BITS-1:0] HIVal;
	wire [BITS-1:0] LOVal;
	wire [BITS-1:0] MDRVal;
	wire [(BITS*2)-1:0] operationResult;
	
	wire [(BITS*TOT_REGISTERS)-1:0] regSelectStream;
	wire [SIG_COUNT-1:0] alu_ctrl_signal;
	 
	register #(.BITS(BITS)) PC(clk, 1'b0, PCin, bus, PCVal);
	register #(.BITS(BITS)) IR(clk, 1'b0, IRin, bus, IRVal);
	register #(.BITS(BITS)) RY(clk, 1'b0, RYin, bus, RYVal);
	register #(.BITS(BITS*2)) RZ(clk, 1'b0, RZin, operationResult, RZVal);
	register #(.BITS(BITS)) MAR(clk, 1'b0, MARin, bus, MARVal);
	register #(.BITS(BITS)) HI(clk, 1'b0, HIin, bus, HIVal);
	register #(.BITS(BITS)) LO(clk, 1'b0, LOin, bus, LOVal);
	mdr #(.BITS(BITS)) MDR(bus, MDataIn, Read, clk, 1'b0, MDRin, MDRVal);
	
	assign regSelectStream = {MDRVal, LOVal, HIVal, RZVal[(BITS*2)-1:BITS], RZVal[BITS-1:0], PCVal, genRegisterStream};
	//assign regSelectStream = {genRegisterStream, PCVal, RZVal[BITS-1:0], RZVal[(BITS*2)-1:BITS], HIVal, LOVal, MDRVal};
	assign alu_ctrl_signal = {NOT, NEGATE, OR, AND, ROL, ROR, SHL, SHR, DIV, MUL, SUB, ADD};
	
	registerFile #(.BITS(BITS), .REGISTERS(REGISTERS)) genPurposeRegs(bus, clk, {16'b0}, {R15in, R14in, R13in, R12in, R11in, R10in, R9in, R8in, R7in, R6in, R5in, R4in, R3in, R2in, R1in, R0in}, genRegisterStream);
	registerSelect #(.BITS(BITS), .REGISTERS(TOT_REGISTERS)) regSelect(regSelectStream, {MDRout, LOout, HIout, RZHIout, RZLOout, PCout, R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out}, bus);
	alu #(.BITS(BITS), .SIG_COUNT(SIG_COUNT)) alu_inst(alu_ctrl_signal, RYVal, bus, operationResult);
	
endmodule

	
	