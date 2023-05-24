module mac (
	input
		clk, clr,
	input signed [`IN_ELEMT_SIZE-1:0]
		A, B,
	output reg signed [`OUT_ELEMT_SIZE-1:0] 
		Y );
		
	reg signed [`OUT_ELEMT_SIZE-1:0] acc_c;

	always@(*) begin
		acc_c = clr ? A*B : A*B + Y;
	end

	always@(posedge clk)
		Y <= acc_c;

endmodule