module mat_ram_1prt_19b (
	input
		clk,
		wen,
	input [$clog2(`MAT_SIZE)-1:0] 
		addr,
	input signed [`OUT_ELEMT_SIZE-1:0]
		wd,
	output reg signed [`OUT_ELEMT_SIZE-1:0]
		rd);
	
	reg signed [`OUT_ELEMT_SIZE-1:0] mem [0:`MAT_SIZE-1];

	always@(posedge clk) begin
		if(wen) begin
			mem[addr] <= wd;
		end else
			rd <= mem[addr];
	end
	
endmodule