// Datapath tb

// and datapath_tb.v file: <This is the filename>
`timescale 1ns/10ps
module datapath_tb;

	 parameter BITS=32, REGISTERS=16;
	 reg MDRout, LOout, HIout, Zlowout, Zhighout, PCout, R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out; // add any other signals to see in your simulation
	 reg MARin, RZin, PCin, MDRin, IRin, RYin, HIin, LOin;
	 reg IncPC, Read, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in;
	 reg Clock;
	 reg [31:0] Mdatain;
	 wire [BITS * REGISTERS - 1 : 0] genRegisterStream;
	 wire [BITS-1:0] bus;
	 
	 parameter Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
								 Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
								 T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100;
								 reg [3:0] Present_state = Default;
								 
	datapath DUT(Clock, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, PCin, IRin, RYin, RZin, MARin, HIin, LOin, MDRin, Read, MDRout, LOout, HIout, Zhighout, Zlowout, PCout, R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, AND, OR, NEGATE, NOT, Mdatain, genRegisterStream, bus);
	
	// add test logic here
    initial
    begin
        Clock = 0;
        forever #20 Clock = ~ Clock;
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
                PCout <= 0; Zlowout <= 0; MDRout <= 0; // initialize the signals
                R0out <= 0; R1out <= 0; R2out <= 0; R3out <= 0; R4out <= 0; R5out <= 0; R6out <= 0; R7out <= 0; R8out <= 0; R9out <= 0; R10out <= 0; R11out <= 0; R12out <= 0; R13out <= 0; R14out <= 0; R15out <= 0; MARin <= 0; RZin <= 0;
                PCin <=0; MDRin <= 1; IRin <= 0; RYin <= 0; HIin <= 0; LOin <= 0; LOout <= 0; HIout <= 0; Zhighout <= 0; Zlowout <= 0;
                IncPC <= 0; Read <= 1; ADD <= 0; SUB <= 0; MUL <= 0; DIV <= 0; SHR <= 0; SHL <= 0; ROR <= 0; ROL <= 0; AND <= 0; OR <= 0; NEGATE <= 0; NOT <= 0;
                R0in <= 0; R1in <= 0; R2in <= 0; R3in <= 0; R4in <= 0; R5in <= 0; R6in <= 0; R7in <= 0; R8in <= 0; R9in <= 0; R10in <= 0; R11in <= 0; R12in <= 0; R13in <= 0; R14in <= 0; R15in <= 0; Mdatain <= 32'h00000022;
            end
            Reg_load1a: begin
				$display("Reg_load1a");
                //Mdatain <= 32'h00000022;
                //Read = 0; MDRin = 0;
                //#5 Read <= 1; MDRin <= 1;
                #10 Read <= 0; MDRin <= 0; MDRout <= 1; R2in <= 1;
            end
            Reg_load1b: begin
					$display("Reg_load1b");
                //#5 MDRout <= 1; R2in <= 1;
                #10 MDRout <= 0; R2in <= 0; Mdatain <= 32'h00000024; Read <= 1; MDRin <= 1;
            end
            Reg_load2a: begin
					$display("Reg_load2a");
                //Mdatain <= 32'h00000024;
                //#5 Read <= 1; MDRin <= 1;
                #10 Read <= 0; MDRin <= 0; MDRout <= 1; R4in <= 1;
					 //Read <= 1; MDRin <= 1;
                //Read <= 0; MDRin <= 0;
            end
            Reg_load2b: begin
					$display("Reg_load2b");
                //#5 MDRout <= 1; R4in <= 1;
                #10 MDRout <= 0; R4in <= 0; Mdatain <= 32'h00000026; Read <= 1; MDRin <= 1;
            end
            Reg_load3a: begin
					$display("Reg_load3a");
                //Mdatain <= 32'h00000026;
                //#5 Read <= 1; MDRin <= 1;
                #10 Read <= 0; MDRin <= 0; MDRout <= 1; R5in <= 1;
            end
            Reg_load3b: begin
					$display("Reg_load3b");
                //#5 MDRout <= 1; R5in <= 1;
                #10 MDRout <= 0; R5in <= 0; 
            end
            T0: begin // see if you need to de-assert these signals
					$display("T0");
                PCout <= 1; MARin <= 1; IncPC <= 1; RZin <= 1;
            end
            T1: begin
					$display("T1");
                Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
                Mdatain <= 32'h4A920000; // opcode for “and R5, R2, R4”
            end
            T2: begin
					$display("T2");
                MDRout <= 1; IRin <= 1; 
            end
            T3: begin
					$display("T3");
                R2out <= 1; RYin <= 1;
            end
            T4: begin
					$display("T4");
                R4out <= 1; AND <= 1; RZin <= 1;
            end
            T5: begin
					$display("T5");
                Zlowout <= 1; R5in <= 1;
            end
        endcase
    end
endmodule
