// Datapath_alt_tb

/*`timescale 1ns/10ps

module datapath_alt_tb;
	 parameter BITS=32, REGISTERS=16, TOT_REGISTERS=REGISTERS+5;
	 
	 reg INPUTout, MDRout, HILOout, RZout, PCout, BAout; // add any other signals to see in your simulation
	 reg [REGISTERS-1:0] GPRin, GPRout;
	 reg PCin, IRin, RYin, RZin, MARin, HILOin, MDRin, OUTPUTin;
	 reg Read, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, IncPC;
	 reg clk;
	 reg [BITS-1:0] MDataIn, INPUTUnit;
	 reg reset;
	 wire [(BITS*TOT_REGISTERS)-1:0] regSelectStreamLO, regSelectStreamHI;
	 wire [BITS-1:0] busLO, busHI;
	 wire [BITS-1:0] MARVal;
	 wire [(BITS*2)-1:0] RZVal;
	 wire [BITS-1:0] IRVal;
	 wire [BITS-1:0] OUTPUTUnit;
	 wire [BITS-1:0] c_sign_extended;
	 
    datapath #(.BITS(BITS), .REGISTERS(REGISTERS)) DUT(
			reset, clk,
			GPRin, 
			PCin, IRin, RYin, RZin, MARin, HILOin, MDRin, OUTPUTin, Read, INPUTout, MDRout, HILOout, RZout, PCout, 
			BAout,
			GPRout, 
			ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, IncPC,
			MDataIn,
			INPUTUnit,
			regSelectStreamLO, regSelectStreamHI,
			busLO, busHI,
			MARVal,
			RZVal,
			IRVal,
			LOVal, HIVal,
			OUTPUTUnit, c_sign_extended);
	

    initial
    begin
        clk = 0;
        forever #10 clk = ~clk;
    end
	
	initial begin
		//Initialize all signals to 0
		reset <= 1;  
		GPRin <= {REGISTERS{1'b0}};
		PCin <= 0; IRin <= 0; RYin <= 0; RZin <= 0; MARin <= 0; HILOin <= 0; MDRin <= 0; OUTPUTin <= 0;
		Read <= 0;
		INPUTout <= 0; MDRout <= 0; HILOout <= 0; RZout <= 0; PCout <= 0;
		BAout <= 0;
		GPRout <= {REGISTERS{1'b0}};
		ADD <= 0; SUB <= 0; MUL <= 0; DIV <= 0; SHR <= 0; SHL <= 0; ROR <= 0; ROL <= 0; AND <= 0; OR <= 0; NEGATE <= 0; NOT <= 0; IncPC <= 0; 
		MDataIn <= {BITS{1'b0}};
		INPUTUnit <= {BITS{1'b0}};
		#5 reset <= 0;
	end
	
endmodule*/
