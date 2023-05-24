module tb_top();

bit clk;

// Clock
always #10 clk = ~clk;

mm_ifc ifc(clk);
tb_mm tb(ifc.tb);

matrix_mult DUT
(
    .clk          (ifc.clk),
    .load_mem     (ifc.load_mem),
    .start        (ifc.start),
    .reset        (ifc.reset),
    .wenA         (ifc.wenA),
    .wenB         (ifc.wenB),
    .wenC         (ifc.wenC),
    .wdA          (ifc.wdA),
    .wdB          (ifc.wdB),
    .addrA        (ifc.addrA),
    .addrB        (ifc.addrB),
    .addrC        (ifc.addrC),
    .rdC          (ifc.rdC),
    .done         (ifc.done)
);

endmodule