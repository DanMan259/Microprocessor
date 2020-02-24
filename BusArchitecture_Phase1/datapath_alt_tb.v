// Datapath_alt_tb

`timescale 1ns/10ps

module datapath_alt_tb;
	 parameter BITS=32, REGISTERS=16, TOT_REGISTERS=REGISTERS+6;
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
			IRVal);
				
	 
	 initial begin 
		Clock = 0;
		forever #10 Clock = ~Clock;
	end
	
	initial begin
		//Initialize all signals to 0
		 reset <= 1;
		 PCout <= 0; Zlowout <= 0; MDRout <= 0; MARin <= 0; RZin <= 0;
		 PCin <= 0; MDRin <= 0; IRin <= 0; RYin <= 0; HIin <= 0; LOin <= 0; LOout <= 0; HIout <= 0; Zhighout <= 0; Zlowout <= 0;
		 IncPC <= 0; Read <= 0; ADD <= 0; SUB <= 0; MUL <= 0; DIV <= 0; SHR <= 0; SHL <= 0; ROR <= 0; ROL <= 0; AND <= 0; OR <= 0; NEGATE <= 0; NOT <= 0;
		 Mdatain <= {BITS{1'b0}}; GPRin <= {REGISTERS{1'b0}}; GPRout <= {REGISTERS{1'b0}};
		 #5 reset <= 0;
		 Mdatain <= 'h22;
       Read <= 1; MDRin <= 1;
		 MDRout <= 1; GPRin[2] <= 1;
		 #5 MDRin <= 0;
	end
	
endmodule
