// mfhi tb

`timescale 1ns/10ps
module mfhi_tb;

	 parameter BITS=32, REGISTERS=16, TOT_REGISTERS=REGISTERS+7, RAMSIZE=512;
	 
	 reg INPUTout, MDRout, HILOout, RZout, PCout, Cout, INTERout, BAout, Gra, Grb, Grc, Rout, Rin; // add any other signals to see in your simulation
	 reg CONin, PCin, IRin, RYin, RZin, MARin, HILOin, OUTPUTin, INTERin, MDRin;
	 reg Read, Write, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, IncPC;
	 reg clk, rClk;
	 reg [BITS-1:0] INPUTUnit;
	 reg reset;
	 wire [(BITS*TOT_REGISTERS)-1:0] regSelectStreamLO, regSelectStreamHI;
	 wire [BITS-1:0] busLO, busHI;
	 wire [BITS-1:0] MARVal;
	 wire [(BITS*2)-1:0] RZVal;
	 wire [BITS-1:0] IRVal;
	 wire [BITS-1:0] OUTPUTUnit;
	 wire [BITS-1:0] c_sign_extended;
	 wire [BITS-1:0] MDRVal;
	 wire [BITS-1:0] INTERHIVal, INTERLOVal;
	 wire CON;
	 
	 
	 wire [BITS-1:0] R0Val, R1Val, R2Val, LOVal, HIVal;
	 
	 assign R0Val = regSelectStreamLO[(1*BITS)-1:BITS*0];
	 assign R1Val = regSelectStreamLO[(2*BITS)-1:BITS*1];
	 assign R2Val = regSelectStreamLO[(3*BITS)-1:BITS*2];
	 
	 /*parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011, 
	           Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
	           T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;*/
				  
	parameter Default = 4'b0000, T0 = 4'b0001, T1 = 4'b0010, T2 = 4'b0011, 
			  T3 = 4'b0100, T4 = 4'b0101, T5 = 4'b0110, T6 = 4'b0111, T7 = 4'b1000, T8 = 4'b1001;
    
	 reg [3:0] Present_state = Default;
	 reg preload_reg = 1'b0;
								 
    datapath #(.BITS(BITS), .REGISTERS(REGISTERS), .RAMSIZE(RAMSIZE)) DUT(
			reset, clk, rClk,
			CONin, PCin, IRin, RYin, RZin, MARin, HILOin, OUTPUTin, INTERin, MDRin, Read, Write, INPUTout, MDRout, HILOout, RZout, PCout, Cout, INTERout, 
			BAout, Gra, Grb, Grc, Rout, Rin,
			ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, IncPC,
			INPUTUnit,
			regSelectStreamLO, regSelectStreamHI,
			busLO, busHI,
			MARVal,
			RZVal,
			IRVal,
			LOVal, HIVal,
			OUTPUTUnit, 
			c_sign_extended, 
			MDRVal,
			INTERHIVal, INTERLOVal,
			CON);
	

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
	 
	 initial begin
			rClk = 1;
			forever #5 rClk = ~rClk;
	 end

    always @(posedge clk) // finite state machine; if clock rising-edge
    begin
        case (Present_state)
            Default : Present_state = T0;
            T0 : Present_state = T1;
            T1 : Present_state = T2;
            T2 : begin
						if(preload_reg == 1)
							Present_state = T7;
						else	
							Present_state = T3;
				end
            T3 : Present_state = T4;
            T4 : Present_state = T5;
				T5 : Present_state = T6;
				T6 : Present_state = T1;
				T7 : Present_state = T8;
        endcase
    end
	 
    always @(Present_state) // do the required job in each state
    begin
        case (Present_state) // assert the required signals in each clock cycle
            Default: begin
					 reset <= 1;  
					 CONin <= 0; PCin <= 0; IRin <= 0; RYin <= 0; RZin <= 0; MARin <= 0; HILOin <= 0; MDRin <= 0; OUTPUTin <= 0; INTERin <= 0;
					 Read <= 0; Write <= 0;
					 INPUTout <= 0; MDRout <= 0; HILOout <= 0; RZout <= 0; PCout <= 0; Cout <= 0; INTERout <= 0;
					 BAout <= 0; Gra <= 0; Grb <= 0; Grc <= 0; Rout <= 0; Rin <= 0; 
                ADD <= 0; SUB <= 0; MUL <= 0; DIV <= 0; SHR <= 0; SHL <= 0; ROR <= 0; ROL <= 0; AND <= 0; OR <= 0; NEGATE <= 0; NOT <= 0; IncPC <= 0; 
					 INPUTUnit <= {BITS{1'b0}};
					 #5 reset <= 0;
            end
            T0: begin 
                MARin <= 1; IncPC <= 1; RZin <= 1; PCout <= 1;
            end
            T1: begin
					Read <= 1; PCin <= 1; MDRin <= 1; 
					#5 RZout <= 1; PCout <= 0; MARin <= 0; IncPC <= 0; RZin <= 0;
            end
            T2: begin
					IRin <= 1;
					#5 PCin <= 0; RZout <= 0; MDRout <= 1; MDRin <= 0; Read <= 0;
            end
				T3: begin
					HILOin <= 1;
					#5 MDRout <= 0; IRin <= 0; Cout <= 1;
				end
				T4: begin 
					INTERin <= 1;
					#5 HILOin <= 0; Cout <= 0; HILOout <= 1;
				end
				T5: begin
					HILOin <= 1;
					#5 INTERin <= 0; INTERout <= 1; HILOout <= 0;
				end
				T6: begin
					MARin <= 1; IncPC <= 1; RZin <= 1;
					#5 HILOin <= 0; PCout <= 1; preload_reg <= 1; INTERout <= 0;
				end
            T7: begin
					INTERin <= 1;
					#5 MDRout <= 0; IRin <= 0; HILOout <= 1;  PCout <= 0; MARin <= 0;
            end			
            T8: begin
					Gra <= 1; Rin <= 1;
					#5 INTERin <= 0; HILOout <= 0; INTERout <= 1;
            end
        endcase
    end
endmodule
