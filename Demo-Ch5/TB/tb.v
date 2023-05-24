module tb_mm(mm_ifc.tb ifc);
  import mm::*;

  // Output matrix to capture stimulus
  logic signed [18:0] 
    matrixC [0:63];

  // Drive a reset to the mm module
  task drive_reset();
    @(ifc.cb);
    ifc.cb.reset <= 1;
    ifc.cb.start <= 0;
    ifc.cb.wenA  <= 0;
    ifc.cb.wenB  <= 0;
    ifc.cb.wenC  <= 0;
    ifc.cb.load_mem <= 0;
    @(ifc.cb);
  endtask

  // Drive a Matrix A and B to the mm module RAMs
  task drv_mm_mem_ld(
    Transaction tr);
    @(ifc.cb);
    ifc.cb.reset <= 0;
    ifc.cb.load_mem <= 1;
    ifc.cb.start <= 0;
    ifc.cb.wenA <= 1;
    ifc.cb.wenB <= 1;
    foreach(tr.matrixA[i]) begin
      ifc.cb.wdA <= tr.matrixA[i];
      ifc.cb.wdB <= tr.matrixB[i];
      ifc.cb.addrA <= i;
      ifc.cb.addrB <= i;
      @(ifc.cb);
    end
    ifc.cb.load_mem <= 0;
    ifc.cb.wenA <= 0;
    ifc.cb.wenB <= 0;
  endtask

  // Drive a start pulse to the mm module
  task drv_mm_wkld();
    @(ifc.cb);
    ifc.cb.reset <= 0;
    ifc.cb.start <= 1;
    ifc.cb.wenA  <= 0;
    ifc.cb.wenB  <= 0;
    ifc.cb.wenC  <= 0;
    ifc.cb.load_mem <= 0;
    @(ifc.cb);
    ifc.cb.start <= 0;
  endtask

  // Drive the C RAM of the MM module to capture response
  task drv_mm_c_capt();
    @(ifc.cb);
    ifc.cb.reset <= 0;
    ifc.cb.load_mem <= 1;
    ifc.cb.wenA <= 0;
    ifc.cb.wenB <= 0;
    ifc.cb.wenC <= 0;
    ifc.cb.addrC <= 0;
    for(int i = 0; i<64; i++) begin
      ifc.cb.addrC <= i;
      @(ifc.cb);
    end
    @(ifc.cb);
  endtask

  // Monitor for completion of the mm
  task mon_mm_done();
    while(!ifc.cb.done)
      @(ifc.cb);
  endtask

  // Capture all of the output data from the RAM
  task mon_mm_c_capt();
    // offset from drv_mm_capt 2 clocks
    @(ifc.cb); // comment this to see faulty tb
    @(ifc.cb);
    @(ifc.cb);
    for(int i = 0; i<64; i++) begin
      matrixC[i] <= ifc.cb.rdC;
      @(ifc.cb);
    end
    @(ifc.cb);
  endtask

  task run_full_test(
    Transaction tr);
    drive_reset();
    drv_mm_mem_ld(tr);
    drv_mm_wkld();
    mon_mm_done();
    fork
      drv_mm_c_capt();
      mon_mm_c_capt();
    join 
  endtask : run_full_test

  // Instantiate generator object
  Generator gen;

  // Instantiate checker object
  Checker chk;

  // Instantiate a scoreboard object
  Scoreboard scrbrd;

  initial begin
    // Construct generator
    gen = new();
    scrbrd = new();
    chk = new();
    repeat(100) begin
      // Generate 2 random 2-d Matrices (A, B)
      //  Starting point for all transactions
      gen.gen_rand_tr();

      // The following statements can run in parallel
      fork
        begin
          // Construct the golden reference for checker
          scrbrd.tr = gen.tr;
          scrbrd.make_mm_gr();
        end
        // Run driver task - note we aren't ready to
        //  use objects and interfaces yet so a task is fine
        run_full_test(gen.tr);
      join
      // Construct a golden reference model
      chk.tr = scrbrd.tr;
      chk.tr.matrixC = matrixC;
      chk.check();
    end
    $finish; // End Simulation
  end

endmodule
