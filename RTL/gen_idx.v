module gen_idx(
	input [$clog2(`DIM)-1:0] 
		i, j,
	output [$clog2(`MAT_SIZE)-1:0]
		idx);
	
	// Note if DIM is a multiple of 4 this
	//  is very efficient
	assign idx = i*`DIM + j;
	
endmodule
