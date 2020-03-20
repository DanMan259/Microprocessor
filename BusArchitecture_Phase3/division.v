// division.v 

module division #(parameter BITS=32)(
	input [BITS-1:0] dividend, 
	input [BITS-1:0] divisor,
	output reg [(BITS*2)-1:0] result
);

	reg [BITS:0] a; 
	reg [BITS-1:0] q;
	reg [BITS:0] m;
	reg negate_flag;

	integer i;

	always @ *
	begin
		a = 0; 
		
	  //  Make dividend and divisor are positive
	  if (dividend[BITS - 1] == 1)
			q = -dividend; 
	  else
			q = dividend;
			
	  if (divisor[BITS - 1] == 1)
			m = {1'b0, -divisor};
	  else
			m = {1'b0, divisor};
			
	  // Determine if result needs to be negated
	  if ((dividend[BITS - 1] ^ divisor[BITS - 1]) == 1)
			negate_flag = 1'b1;
	  else
			negate_flag = 1'b0;
		
		for(i = 0; i < BITS; i = i + 1) begin
			a = a << 1;
			a[0] = q[BITS-1];
			q = q << 1;
			if(a[BITS] == 1) 
				a = a + m;
			else 
				a = a - m;
			if(a[BITS] == 1) 
				q[0] = 1'b0;
			else
				q[0] = 1'b1;
		end
		if(a[BITS] == 1) begin 
			a = a + m;
		end
		
		if (negate_flag == 1)
			q = -q;
		
		result[(2*BITS)-1:BITS] = a[BITS - 1: 0]; 	// Quotient
		result[BITS-1:0] = q; 								// Remainder

	end
endmodule
