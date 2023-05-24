`define MAT_SIZE 64
`define OUT_ELEMT_SIZE 19
`define IN_ELEMT_SIZE 8

interface mm_ifc(input bit clk);

	// 1-bit signals
	logic 
		wenA, wenB, wenC, done,
		start, reset, load_mem;

	// Address signals
	logic [$clog2(`MAT_SIZE)-1:0]
		addrA, addrB, addrC;

	// Matrix C read data
	logic signed [`OUT_ELEMT_SIZE-1:0]
		rdC;

	// Matrix A/B write data
	logic signed [`IN_ELEMT_SIZE-1:0]
		wdA, wdB;

	clocking cb @(posedge clk);
		input 
			done, rdC;
		output 
			wenA, wenB, wenC, wdA, wdB,
			start, reset, load_mem, addrA,
			addrB, addrC;
	endclocking

	modport tb (clocking cb);

endinterface : mm_ifc