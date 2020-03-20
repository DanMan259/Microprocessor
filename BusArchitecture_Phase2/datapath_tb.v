// Datapath tb

// and datapath_tb.v file: <This is the filename>

// This file does AND R5, R2, R4
`timescale 1ns/10ps
module datapath_tb;

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
	 
	 
	 wire [BITS-1:0] R2Val, R4Val, R5Val, LOVal, HIVal;
	 
	 assign R2Val = regSelectStreamLO[(3*BITS)-1:BITS*2];
	 assign R4Val = regSelectStreamLO[(5*BITS)-1:BITS*4];
	 assign R5Val = regSelectStreamLO[(6*BITS)-1:BITS*5];
	 
	 parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011, 
	           Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
	           T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
    
	 reg [3:0] Present_state = Default;
								 
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
			OUTPUTUnit);
	

    initial
    begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    always @(posedge clk) // finite state machine; if clock rising-edge
    begin
        case (Present_state)
            Default : Present_state = Reg_load1a;
            Reg_load1a : Present_state = Reg_load1b;
            Reg_load1b : Present_state = Reg_load2a;
            Reg_load2a : Present_state = Reg_load2b;
            Reg_load2b : Present_state = Reg_load3a;
            Reg_load3a : Present_state = Reg_load3b;
            Reg_load3b : Present_state = T0;
            T0 : Present_state = T1;
            T1 : Present_state = T2;
            T2 : Present_state = T3;
            T3 : Present_state = T4;
            T4 : Present_state = T5;
        endcase
    end
	 
    always @(Present_state) // do the required job in each state
    begin
        case (Present_state) // assert the required signals in each clock cycle
            Default: begin
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
            Reg_load1a: begin
                //MDataIn <= 'h22;
					 MDataIn <= 'b1000000000000001100000000000000;
                Read = 1; MDRin = 1;
            end
            Reg_load1b: begin
					 MDRout <= 1; GPRin[2] <= 1;
                #5 MDRin <= 0;
            end
            Reg_load2a: begin
                MDataIn <= 'h24;
                #5 MDRout <= 0; GPRin[2] <= 0; MDRin <= 1;
            end
            Reg_load2b: begin
					 GPRin[4] <= 1; MDRout <= 1;
                #5 MDRin <= 0;
            end
            Reg_load3a: begin
                MDataIn <= 'h26;
                #5 MDRin <= 1; MDRout <= 0; GPRin[4] <= 0;
            end
            Reg_load3b: begin
					 GPRin[5] <= 1; MDRout <= 1;
                #5 MDRin <= 0;
            end
            T0: begin 
                MARin <= 1; IncPC <= 1; RZin <= 1;
					 #5 GPRin[5] <= 0; MDRout <= 0; PCout <= 1;
            end
            T1: begin
					Read <= 1; MDataIn <= 'h4A920000; // OP code for AND R5, R2, R4
					PCin <= 1; MDRin <= 1;
					#5 RZout <= 1; PCout <= 0; MARin <= 0; IncPC <= 0; RZin <= 0;
            end
            T2: begin
					IRin <= 1;
					#5 PCin <= 0; RZout <= 0; MDRout <= 1; MDRin <= 0;
            end
            T3: begin
					 RYin <= 1;
					 #5 IRin <= 0; MDRout <= 0; GPRout[2] <= 1;
            end
            T4: begin
					 //AND <= 1; RZin <= 1;
					 //#5 RYin <= 0; GPRout[2] <= 0; GPRout[4] <= 1;
					 DIV <= 1; RZin <= 1;
					 #5 RYin <= 0; GPRout[2] <= 0; GPRout[4] <= 1;
            end
            T5: begin
					 //GPRin[5] <= 1;
					 //#5 AND <= 0; RZin <= 0; GPRout[4] <= 0; RZout <= 1;
					 HILOin <= 1;
					 #5 DIV <= 0; RZin <= 0; GPRout[4] <= 0; RZout <= 1;
            end
        endcase
    end
endmodule
