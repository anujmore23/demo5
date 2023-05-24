module matrix_mult(
	input
		clk,
		load_mem,
		start,
		reset,
		wenA,
		wenB,
		wenC,
	input [$clog2(`MAT_SIZE)-1:0]
		addrA,
		addrB,
		addrC,
	input signed [`IN_ELEMT_SIZE - 1:0]
		wdA,
		wdB,
	output
		done,
	output signed [`OUT_ELEMT_SIZE-1:0]
		rdC);
		
	wire mac_clr, C_wen, 
		A_wen_in, B_wen_in, C_wen_in;

	wire [$clog2(`DIM)-1:0] 
		Ai, Aj, Bi, Bj, Ci, Cj;

	wire [$clog2(`MAT_SIZE)-1:0]
		idxA, idxB, idxC, 
		addrA_in, addrB_in, addrC_in;
	
	wire signed [`IN_ELEMT_SIZE-1:0]
		Aij, Bij;
	
	wire signed [`OUT_ELEMT_SIZE-1:0]
		rslt;
	
	// Memory and idx translation
	gen_idx gen_addr_A(
		.i(Ai),
		.j(Aj),
		.idx(idxA));
	
	assign addrA_in = load_mem ? addrA : idxA;
	assign wenA_in = load_mem ? wenA : 1'b0; 
	mat_ram_1prt_8b memA (
		.clk(clk),
		.wen(wenA_in),
		.addr(addrA_in),
		.wd(wdA),
		.rd(Aij));
	
	gen_idx gen_addr_B(
		.i(Bi),
		.j(Bj),
		.idx(idxB));
	
	assign addrB_in = load_mem ? addrB : idxB;
	assign wenB_in = load_mem ? wenB : 1'b0; 
	mat_ram_1prt_8b memB (
		.clk(clk),
		.wen(wenB_in),
		.addr(addrB_in),
		.wd(wdB),
		.rd(Bij));
	
	gen_idx gen_addr_C(
		.i(Ci),
		.j(Cj),
		.idx(idxC));
	
	assign wenC_in = load_mem ? wenC : C_wen;
	assign addrC_in = load_mem ? addrC : idxC;
	
	mat_ram_1prt_19b memC (
		.clk(clk),
		.wen(wenC_in),
		.addr(addrC_in),
		.wd(rslt),
		// Unused
		.rd(rdC));
	
	ctrl_pt1 ctrl_i0(
		.clk(clk),
		.load_mem(load_mem),
		.done(done),
		.start(start),
		.reset(reset),
		.mac_clr(mac_clr),
		.C_wen(C_wen),
		.Ai(Ai),
		.Aj(Aj),
		.Bi(Bi),
		.Bj(Bj),
		.Ci(Ci),
		.Cj(Cj));
	
	mac mac_i0(
		.clk(clk),
		.clr(mac_clr),
		.A(Aij),
		.B(Bij),
		.Y(rslt));
	
	fsm fsm_i(
		.load_mem(load_mem),
		.clk(clk),
		.reset(reset),
		.start(start),
		.done(done),
		.clock_count(clock_count));

endmodule