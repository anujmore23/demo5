// Could have easily combined with
//		prelab FSM but kept them separate
module ctrl_pt1(
	input
		clk,
		load_mem,
		reset,
		done,
		start,
	output reg [$clog2(`DIM)-1:0]
		Ai, Aj, Bi, Bj, Ci, Cj,
	output reg
		mac_clr,
		C_wen);
	
	reg mac_clr_c, C_wen_c;
	
	reg [$clog2(`DIM)-1:0]
		Ai_c, Aj_c, Bi_c, Bj_c, Ci_c, Cj_c;
		
	reg state, state_c;
	
	// Accommodate pipelining 
	reg mac_clr_r, C_wen_r0, C_wen_r1;
	reg [$clog2(`DIM)-1:0]
		Ci_r0, Ci_r1, 
		Cj_r0, Cj_r1;

	// Assume that every clock cycle one new address is required
	//		from both input RAMs this logic will need to change with 
	//		MAC/RAM port architectures (See Part 2)
	always@(*) begin
		if(reset == 1'b1) begin
			{Ai_c, Aj_c} = 0;
			{Bi_c, Bj_c} = 0;
			{Ci_c, Cj_c} = 0;
			// Clear MAC if we have reset or are not started
			mac_clr_c = 1'b1;
			// Do not write if we have reset or are not started
			C_wen_c = 1'b0;
			state_c = 1'b0;
		end else if((reset == 1'b0) && (state == 1'b1)) begin
			state_c = ~done;
			// Indexing logic **************************************
			// A advances in the i direction each clock circularly
			Ai_c = Ai == (`DIM - 1) ? 0 : Ai + 1;
			// A only advances in j if B is at the max index
			Aj_c = (Bj == (`DIM - 1)) && (Bi == (`DIM - 1)) ? 
					Aj + 1 : Aj;
			// B advances in i when A is at it's max i	
			Bi_c =  Bj == (`DIM - 1) ?
				// But Bi must also reset circularly
			        Bi == (`DIM - 1) ? 
					0 : Bi + 1 
			       : Bi;
			// Bj advances every clock cycle circularly just like Ai
			Bj_c = Bj == (`DIM - 1) ? 0 : Bj + 1;
			// Output RAM Logic *************************************
			Ci_c = Bi_c;
			Cj_c = Aj_c;
			mac_clr_c = Ai == (`DIM - 1);
			C_wen_c = Ai == (`DIM - 1);
		end else begin
			{Ai_c, Aj_c} = 0;
			{Bi_c, Bj_c} = 0;
			{Ci_c, Cj_c} = 0;
			// Clear MAC if we have reset or are not started
			mac_clr_c = 1'b1;
			// Do not write if we have reset or are not started
			C_wen_c = 1'b0;
			state_c = start;
		end
	end

	// Update present state/outputs
	always@(posedge clk) begin
		{Ai, Aj} <= {Ai_c, Aj_c};
		{Bi, Bj} <= {Bi_c, Bj_c};
		{Ci_r0, Cj_r0} <= {Ci_c, Cj_c};
		{Ci_r1, Cj_r1} <= {Ci_r0, Cj_r0};
		{Ci, Cj} <= {Ci_r1, Cj_r1};		
		mac_clr_r <= mac_clr_c;
		mac_clr <= mac_clr_r;
		C_wen_r0 <= C_wen_c;
		C_wen_r1 <= C_wen_r0;
		C_wen <= C_wen_r0;
		state <= state_c;
	end
endmodule