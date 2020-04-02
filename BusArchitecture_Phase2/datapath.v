// Datapath
																																																																		
module datapath #(parameter BITS=32, REGISTERS=16, RAMSIZE=512, TOT_REGISTERS=REGISTERS+7, SIG_COUNT=13)(
	input reset, clk, rClk,
	input CONin, PCin, IRin, RYin, RZin, MARin, HILOin, OUTPUTin, INTERin, MDRin, Read, Write, INPUTout, MDRout, HILOout, RZout, PCout, Cout, INTERout,
	input BAout, Gra, Grb, Grc, Rout, Rin,
	input ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, IncPC,
	input [BITS-1:0] INPUTUnit,
	output wire [(BITS*TOT_REGISTERS)-1:0] regSelectStreamLO, regSelectStreamHI,
	output wire [BITS-1:0] busLO, busHI,
	output wire [BITS-1:0] MARVal,
	output wire [(BITS*2)-1:0] RZVal,
	output wire [BITS-1:0] IRVal,
	output wire [BITS-1:0] LOVal, HIVal,
	output wire [BITS-1:0] OUTPUTUnit,
	output wire [BITS-1:0] c_sign_extended,
	output wire [BITS-1:0] MDRVal,
	output wire [BITS-1:0] INTERHIVal, INTERLOVal,
	output wire CON
);
	localparam ADDR = $clog2(RAMSIZE);

	wire [(BITS*REGISTERS)-1:0] genRegisterStream;
	wire [BITS-1:0] PCVal;
	wire [BITS-1:0] RYVal;
	wire [(BITS*2)-1:0] operationResult;
	wire [SIG_COUNT-1:0] alu_ctrl_signal;
	wire [BITS-1:0] INVal;
	wire [REGISTERS-1:0] GPRin, GPRout;
	wire [BITS-1:0] MDataIn;
	 
	register #(.BITS(BITS)) PC(clk, reset, PCin, busLO, PCVal);
	register #(.BITS(BITS)) IR(clk, reset, IRin, busLO, IRVal);
	register #(.BITS(BITS)) RY(clk, reset, RYin, busLO, RYVal);
	register #(.BITS(BITS*2)) RZ(clk, reset, RZin, operationResult, RZVal);
	register #(.BITS(BITS)) MAR(clk, reset, MARin, busLO, MARVal);
	register #(.BITS(BITS)) HI(clk, reset, HILOin, busHI, HIVal);
	register #(.BITS(BITS)) LO(clk, reset, HILOin, busLO, LOVal);
	register #(.BITS(BITS)) OUTPUT(clk, reset, OUTPUTin, busLO, OUTPUTUnit);
	register #(.BITS(BITS)) INPUT(clk, reset, 1'b1, INPUTUnit, INVal);
	register #(.BITS(BITS)) INTERHI(clk, reset, INTERin, busLO, INTERHIVal);
	register #(.BITS(BITS)) INTERLO(clk, reset, INTERin, busHI, INTERLOVal);
	mdr #(.BITS(BITS)) MDR(busLO, MDataIn, Read, clk, reset, MDRin, MDRVal);
	
	ram #(.BITS(BITS), .RAMSIZE(RAMSIZE), .ADDR(ADDR))RAM(MDRVal, Read, Write, MARVal[ADDR-1:0], rClk, MDataIn); // Maybe a fan out warning but should be fine //Not sure if this works
	
	//assign regSelectStream = {INVal, MDRVal, LOVal, HIVal, RZVal[(BITS*2)-1:BITS], RZVal[BITS-1:0], PCVal, genRegisterStream};
	assign regSelectStreamLO = {INTERLOVal, c_sign_extended, INVal, MDRVal, LOVal, RZVal[BITS-1:0], PCVal, genRegisterStream};
	assign regSelectStreamHI = {INTERHIVal, {BITS{1'bz}}, {BITS{1'bz}}, {BITS{1'bz}}, HIVal, RZVal[(2*BITS)-1:BITS], {BITS{1'bz}}, {(BITS*REGISTERS){1'bz}}};
	assign alu_ctrl_signal = {IncPC, NOT, NEGATE, OR, AND, ROL, ROR, SHL, SHR, DIV, MUL, SUB, ADD};
	
	selectAndEncode #(.BITS(BITS), .REGISTERS(REGISTERS)) selectAndEncode_inst(IRVal, Gra, Grb, Grc, Rin, Rout, BAout, GPRin, GPRout, c_sign_extended);
	registerFile #(.BITS(BITS), .REGISTERS(REGISTERS)) genPurposeRegs(busLO, clk, {REGISTERS{reset}}, GPRin, genRegisterStream);
	registerSelect #(.BITS(BITS), .REGISTERS(TOT_REGISTERS)) regSelectLO(regSelectStreamLO, {INTERout, Cout, INPUTout, MDRout, HILOout, RZout, PCout, GPRout}, BAout, busLO);
	registerSelect #(.BITS(BITS), .REGISTERS(TOT_REGISTERS)) regSelectHI(regSelectStreamHI, {INTERout, Cout, INPUTout, MDRout, HILOout, RZout, PCout, GPRout}, BAout, busHI);
	alu #(.BITS(BITS), .SIG_COUNT(SIG_COUNT)) alu_inst(alu_ctrl_signal, RYVal, busLO, operationResult);
	con_ff #(.BITS(BITS)) con_ff_inst(busLO, IRVal[20:19], CONin, CON);
	
endmodule
