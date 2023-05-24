package mm;

	class Transaction;

		parameter IN_ELEM_SIZ = 8;
		parameter OUT_ELEM_SIZE = 19;
		parameter MAT_DIM = 8;

		parameter MAT_SIZE = MAT_DIM * MAT_DIM;

		// Input matrices
		logic signed [IN_ELEM_SIZ-1:0] 
			matrixA [0:MAT_SIZE-1];
		logic signed [IN_ELEM_SIZ-1:0] 
			matrixB [0:MAT_SIZE-1];

		// Output matrix
		logic signed [OUT_ELEM_SIZE-1:0] 
			matrixC [0:MAT_SIZE-1];

		// Golden reference
		logic signed [OUT_ELEM_SIZE-1:0] 
			goldenC [0:MAT_SIZE-1];

	endclass : Transaction

	class Generator;
		
		parameter IN_ELEM_SIZ = 8;
		parameter OUT_ELEM_SIZE = 19;
		parameter MAT_DIM = 8;

		// Pass the paramters to the tr
		Transaction tr;

		function new();
			this.tr = new();
		endfunction

	  	// Lightweight randomization
	  	function void gen_rand_tr();
	  		this.tr = new();
	  		foreach(this.tr.matrixA[i]) begin
			    this.tr.matrixA[i] 
			    	= $urandom();
			    this.tr.matrixB[i]
			    	= $urandom();
		 	end
	  	endfunction

	endclass : Generator

	class Scoreboard;

		parameter IN_ELEM_SIZ = 8;
		parameter OUT_ELEM_SIZE = 19;
		parameter MAT_DIM = 8;

		// Pass the paramters to the tr
		Transaction tr;

		// Populate Golden Ref. Model
	  	function void make_mm_gr();
		  	for(int i=0;i<8;i=i+1) begin
			    for(int j=0;j<8;j=j+1) begin
			      this.tr.goldenC[8*i+j] = 0;
			      for(int k=0;k<8;k=k+1) begin
			        this.tr.goldenC[8*i+j] = 
			        	this.tr.goldenC[8*i+j] 
			          + this.tr.matrixA[j+8*k]
			           *this.tr.matrixB[k+8*i];
			      end
			    end
		  	end
		endfunction : make_mm_gr

	endclass : Scoreboard

	class Checker;

		parameter IN_ELEM_SIZ = 8;
		parameter OUT_ELEM_SIZE = 19;
		parameter MAT_DIM = 8;

		// Pass the paramters to the tr
		Transaction tr;

		bit comparison;

		function void check();
			// Print Input Matrices
			$display("Matrix A");
			for(int i=0;i<8;i=i+1) begin
				$display(	this.tr.matrixA[i+00],this.tr.matrixA[i+08],
							this.tr.matrixA[i+16],this.tr.matrixA[i+24],
							this.tr.matrixA[i+32],this.tr.matrixA[i+40],
							this.tr.matrixA[i+48],this.tr.matrixA[i+56]);
			end
			// Print Input Matrices
			$display("Matrix B");
			for(int i=0;i<8;i=i+1) begin
				$display(	this.tr.matrixB[i+00],this.tr.matrixB[i+08],
							this.tr.matrixB[i+16],this.tr.matrixB[i+24],
							this.tr.matrixB[i+32],this.tr.matrixB[i+40],
							this.tr.matrixB[i+48],this.tr.matrixB[i+56]);
			end
			// Print Input Matrices
			$display("Expected Matrix C");
			for(int i=0;i<8;i=i+1) begin
				$display(	this.tr.goldenC[i+00],this.tr.goldenC[i+08],
							this.tr.goldenC[i+16],this.tr.goldenC[i+24],
							this.tr.goldenC[i+32],this.tr.goldenC[i+40],
							this.tr.goldenC[i+48],this.tr.goldenC[i+56]);
			end
			// Print Input Matrices
			$display("Actual Matrix C");
			for(int i=0;i<8;i=i+1) begin
				$display(	this.tr.matrixC[i+00],this.tr.matrixC[i+08],
							this.tr.matrixC[i+16],this.tr.matrixC[i+24],
							this.tr.matrixC[i+32],this.tr.matrixC[i+40],
							this.tr.matrixC[i+48],this.tr.matrixC[i+56]);
			end
			// Test if the two matrices match
			this.comparison = 1'b0;
			for(int i=0;i<8;i=i+1) begin
				for(int j=0;j<8;j=j+1) begin
					if (this.tr.goldenC[8*i+j] !== this.tr.matrixC[8*i+j]) begin
						$display("Mismatch at (j, i) = (%1d, %1d)",j,i);
						this.comparison = 1'b1;
					end
				end  
			end
			if (this.comparison == 1'b0) begin
				$display("\nsuccess :)");
			end
		endfunction

	endclass : Checker

// Driver, Agent, Monitor and Scrbrd later :)

endpackage : mm