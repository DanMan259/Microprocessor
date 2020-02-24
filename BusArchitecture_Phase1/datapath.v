// Datapath
																																																																		
module datapath #(parameter BITS=32, REGISTERS=16, TOT_REGISTERS=REGISTERS+6, SIG_COUNT=13)(
	input reset, clk,
	input [REGISTERS-1:0] GPRin, 
	input PCin, IRin, RYin, RZin, MARin, HIin, LOin, MDRin, Read, MDRout, LOout, HIout, RZHIout, RZLOout, PCout, 
	input [REGISTERS-1:0] GPRout, 
	input ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, IncPC,
	input [BITS-1:0] MDataIn,
	output wire [(BITS*TOT_REGISTERS)-1:0] regSelectStream,
	output wire [BITS-1:0] bus,
	output wire [BITS-1:0] MARVal,
	output wire [(BITS*2)-1:0] RZVal,
	output wire [BITS-1:0] IRVal
);


	wire [(BITS*REGISTERS)-1 : 0] genRegisterStream;
	wire [BITS-1:0] PCVal;
	wire [BITS-1:0] RYVal;
	wire [BITS-1:0] HIVal;
	wire [BITS-1:0] LOVal;
	wire [BITS-1:0] MDRVal;
	wire [(BITS*2)-1:0] operationResult;
	wire [SIG_COUNT-1:0] alu_ctrl_signal;
	 
	register #(.BITS(BITS)) PC(clk, reset, PCin, bus, PCVal);
	register #(.BITS(BITS)) IR(clk, reset, IRin, bus, IRVal);
	register #(.BITS(BITS)) RY(clk, reset, RYin, bus, RYVal);
	register #(.BITS(BITS*2)) RZ(clk, reset, RZin, operationResult, RZVal);
	register #(.BITS(BITS)) MAR(clk, reset, MARin, bus, MARVal);
	register #(.BITS(BITS)) HI(clk, reset, HIin, bus, HIVal);
	register #(.BITS(BITS)) LO(clk, reset, LOin, bus, LOVal);
	mdr #(.BITS(BITS)) MDR(bus, MDataIn, Read, clk, reset, MDRin, MDRVal);
	
	assign regSelectStream = {MDRVal, LOVal, HIVal, RZVal[(BITS*2)-1:BITS], RZVal[BITS-1:0], PCVal, genRegisterStream};
	assign alu_ctrl_signal = {IncPC, NOT, NEGATE, OR, AND, ROL, ROR, SHL, SHR, DIV, MUL, SUB, ADD};
	
	registerFile #(.BITS(BITS), .REGISTERS(REGISTERS)) genPurposeRegs(bus, clk, {REGISTERS{reset}}, GPRin, genRegisterStream);
	registerSelect #(.BITS(BITS), .REGISTERS(TOT_REGISTERS)) regSelect(regSelectStream, {MDRout, LOout, HIout, RZHIout, RZLOout, PCout, GPRout}, bus);
	alu #(.BITS(BITS), .SIG_COUNT(SIG_COUNT)) alu_inst(alu_ctrl_signal, RYVal, bus, operationResult);
	
endmodule
