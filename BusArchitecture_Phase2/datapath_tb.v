// Datapath tb

// and datapath_tb.v file: <This is the filename>

// This file does AND R5, R2, R4
`timescale 1ns/10ps
module datapath_tb;

	 parameter BITS=32, REGISTERS=16, TOT_REGISTERS=REGISTERS+7;
	 reg MDRout, LOout, HIout, Zlowout, Zhighout, PCout; // add any other signals to see in your simulation
	 reg [REGISTERS-1:0] GPRin, GPRout;
	 reg MARin, RZin, PCin, MDRin, IRin, RYin, HIin, LOin;
	 reg IncPC, Read, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT;
	 reg Clock;
	 reg [BITS-1:0] Mdatain;
	 reg reset;
	 wire [(BITS*TOT_REGISTERS)-1:0] regSelectStream;
	 wire [BITS-1:0] bus;
	 wire [BITS-1:0] MARVal;
	 wire [(BITS*2)-1:0] RZVal;
	 wire [BITS-1:0] IRVal;
	 
	 
	 
	 wire [BITS-1:0] R2Val, R4Val, R5Val, LOVal, HIVal;
	 
	 assign R2Val = regSelectStream[(3*BITS)-1:BITS*2];
	 assign R4Val = regSelectStream[(5*BITS)-1:BITS*4];
	 assign R5Val = regSelectStream[(6*BITS)-1:BITS*5];
	 
	 parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
								 Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
								 T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
								 reg [3:0] Present_state = Default;
								 
	datapath #(.BITS(BITS), .REGISTERS(REGISTERS)) DUT(
			reset, Clock, 
			GPRin, 
			PCin, IRin, RYin, RZin, MARin, HIin, LOin, MDRin, Read, MDRout, LOout, HIout, Zhighout, Zlowout, PCout, 
			GPRout, 
			ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, IncPC, 
			Mdatain, 
			regSelectStream, 
			bus, 
			MARVal, 
			RZVal, 
			IRVal,
			LOVal, HIVal);
	
	// add test logic here
    initial
    begin
        Clock = 0;
        forever #10 Clock = ~Clock;
    end

    always @(posedge Clock) // finite state machine; if clock rising-edge
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
					$display("Default");
					 reset <= 1;
                PCout <= 0; Zlowout <= 0; MDRout <= 0; MARin <= 0; RZin <= 0;
                PCin <= 0; MDRin <= 0; IRin <= 0; RYin <= 0; HIin <= 0; LOin <= 0; LOout <= 0; HIout <= 0; Zhighout <= 0; Zlowout <= 0;
                IncPC <= 0; Read <= 0; ADD <= 0; SUB <= 0; MUL <= 0; DIV <= 0; SHR <= 0; SHL <= 0; ROR <= 0; ROL <= 0; AND <= 0; OR <= 0; NEGATE <= 0; NOT <= 0;
					 Mdatain <= {BITS{1'b0}}; GPRin <= {REGISTERS{1'b0}}; GPRout <= {REGISTERS{1'b0}};
					 #5 reset <= 0;
            end
            Reg_load1a: begin
                Mdatain <= 'h22;
                Read = 1; MDRin = 1;
            end
            Reg_load1b: begin
					 MDRout <= 1; GPRin[2] <= 1;
                #5 MDRin <= 0;
            end
            Reg_load2a: begin
                Mdatain <= 'h24;
                #5 MDRout <= 0; GPRin[2] <= 0; MDRin <= 1;
            end
            Reg_load2b: begin
					 GPRin[4] <= 1; MDRout <= 1;
                #5 MDRin <= 0;
            end
            Reg_load3a: begin
                Mdatain <= 'h26;
                #5 MDRin <= 1; MDRout <= 0; GPRin[4] <= 0;
            end
            Reg_load3b: begin
					 GPRin[5] <= 1; MDRout <= 1;
                #5 MDRin <= 0;
            end
            T0: begin 
					$display("T0");
                MARin <= 1; IncPC <= 1; RZin <= 1;
					 #5 GPRin[5] <= 0; MDRout <= 0; PCout <= 1;
            end
            T1: begin
					Read <= 1; Mdatain <= 'h4A920000; // OP code for AND R5, R2, R4
					PCin <= 1; MDRin <= 1;
					#5 Zlowout <= 1; PCout <= 0; MARin <= 0; IncPC <= 0; RZin <= 0;
            end
            T2: begin
					IRin <= 1;
					#5 PCin <= 0; Zlowout <= 0; MDRout <= 1; MDRin <= 0;
            end
            T3: begin
					 RYin <= 1;
					 #5 IRin <= 0; MDRout <= 0; GPRout[2] <= 1;
            end
            T4: begin
					 AND <= 1; RZin <= 1;
					 #5 RYin <= 0; GPRout[2] <= 0; GPRout[4] <= 1;
            end
            T5: begin
					 GPRin[5] <= 1;
					 #5 AND <= 0; RZin <= 0; GPRout[4] <= 0; Zlowout <= 1;
            end
        endcase
    end
endmodule
