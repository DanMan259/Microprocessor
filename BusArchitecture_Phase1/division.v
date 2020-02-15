// division.v 

module division #(parameter BITS=32)(
	input [BITS-1:0] divisor, 
	input [BITS-1:0] dividend,
	output reg [BITS-1:0] quotient, 
	output reg [BITS-1:0] remainder
);

	reg [BITS-1:0] a;
	reg [BITS-1:0] q;
	reg [BITS-1:0] temp_q;
	reg [BITS-1:0] m;

	integer i;

	always @*
	begin
		a = 32'b0;
		q = divisor;
		m = dividend;
		for(i = 0; i < BITS; i = i + 1) begin
			a = a << 1;
			a[0] = q[BITS-1];
			q = q << 1;
			if(a[BITS-1] == 1)
				a = a + m;
			else 
				a = a - m;
			if(a[BITS-1] == 1)
				q[0] = 1'b0;
			else
				q[0] = 1'b1;
		end
		if(a[31] == 1) begin
			a = a + m;
		end
		
		quotient = q;
		remainder = a;
	end
endmodule
