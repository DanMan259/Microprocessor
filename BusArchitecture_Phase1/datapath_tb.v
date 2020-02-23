// Datapath tb

// and datapath_tb.v file: <This is the filename>

// This file does AND R5, R2, R4
`timescale 1ns/10ps
module datapath_tb;

	 parameter BITS=32, REGISTERS=16, TOT_REGISTERS=22;
	 reg MDRout, LOout, HIout, Zlowout, Zhighout, PCout, R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out; // add any other signals to see in your simulation
	 reg MARin, RZin, PCin, MDRin, IRin, RYin, HIin, LOin;
	 reg IncPC, Read, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
	 reg Clock;
	 reg [31:0] Mdatain;
	 reg reset;
	 wire [(BITS*TOT_REGISTERS)-1:0] regSelectStream;
	 wire [BITS-1:0] bus;
	 wire [BITS-1:0] MARVal;
	 wire [(BITS*2)-1:0] RZVal;
	 wire [BITS-1:0] IRVal;
	 
	 parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
								 Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
								 T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
								 reg [3:0] Present_state = Default;
								 
	datapath DUT(reset, Clock, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, PCin, IRin, RYin, RZin, MARin, HIin, LOin, MDRin, Read, MDRout, LOout, HIout, Zhighout, Zlowout, PCout, R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, IncPC, Mdatain, regSelectStream, bus, MARVal, RZVal, IRVal);
	
	// add test logic here
    initial
    begin
        Clock = 0;
        forever #10 Clock = ~ Clock;
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
                PCout <= 0; Zlowout <= 0; MDRout <= 0; 
                R0out <= 0; R1out <= 0; R2out <= 0; R3out <= 0; R4out <= 0; R5out <= 0; R6out <= 0; R7out <= 0; R8out <= 0; R9out <= 0; R10out <= 0; R11out <= 0; R12out <= 0; R13out <= 0; R14out <= 0; R15out <= 0; MARin <= 0; RZin <= 0;
                PCin <=0; MDRin <= 0; IRin <= 0; RYin <= 0; HIin <= 0; LOin <= 0; LOout <= 0; HIout <= 0; Zhighout <= 0; Zlowout <= 0;
                IncPC <= 0; Read <= 0; ADD <= 0; SUB <= 0; MUL <= 0; DIV <= 0; SHR <= 0; SHL <= 0; ROR <= 0; ROL <= 0; AND <= 0; OR <= 0; NEGATE <= 0; NOT <= 0;
                R0in <= 0; R1in <= 0; R2in <= 0; R3in <= 0; R4in <= 0; R5in <= 0; R6in <= 0; R7in <= 0; R8in <= 0; R9in <= 0; R10in <= 0; R11in <= 0; R12in <= 0; R13in <= 0; R14in <= 0; R15in <= 0; Mdatain <= 32'h00000000;
					 #5 reset <= 0;
            end
            Reg_load1a: begin
                Mdatain <= 32'h00000022;
                Read = 1; MDRin = 1;
            end
            Reg_load1b: begin
					 MDRout <= 1; R2in <= 1;
                #5 MDRin <= 0;
            end
            Reg_load2a: begin
                Mdatain <= 32'h00000024;
                #5 MDRout <= 0; R2in <= 0; MDRin <= 1;
            end
            Reg_load2b: begin
					 R4in <= 1; MDRout <= 1;
                #5 MDRin <= 0;
            end
            Reg_load3a: begin
                Mdatain <= 32'h00000026;
                #5 MDRin <= 1; MDRout <= 0; R4in <= 0;
            end
            Reg_load3b: begin
					 R5in <= 1; MDRout <= 1;
                #5 MDRin <= 0;
            end
            T0: begin 
					$display("T0");
                MARin <= 1; IncPC <= 1; RZin <= 1;
					 #5 R5in <= 0; MDRout <= 0; PCout <= 1;
            end
            T1: begin
					Read <= 1; Mdatain <= 32'h4A920000; // OP code for AND R5, R2, R4
					PCin <= 1; MDRin <= 1;
					#5 Zlowout <= 1; PCout <= 0; MARin <= 0; IncPC <= 0; RZin <= 0;
            end
            T2: begin
					IRin <= 1;
					#5 PCin <= 0; Zlowout <= 0; MDRout <= 1; MDRin <= 0;
            end
            T3: begin
					 RYin <= 1;
					 #5 IRin <= 0; MDRout <= 0; R2out <= 1;
            end
            T4: begin
					 AND <= 1; RZin <= 1;
					 #5 RYin <= 0; R2out <= 0; R4out <= 1;
            end
            T5: begin
					 R5in <= 1;
					 #5 AND <= 0; RZin <= 0; R4out <= 0; Zlowout <= 1;
            end
        endcase
    end
endmodule
