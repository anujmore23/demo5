// Dimension of the square matrix
`define DIM 8
// Total number of elements
`define MAT_SIZE `DIM * `DIM
// Size of each matrix element
`define IN_ELEMT_SIZE 8
// How we reach a 19-bit output
`define OUT_ELEMT_SIZE $clog2((1<<`IN_ELEMT_SIZE)*(1<<`IN_ELEMT_SIZE)*`DIM)
// Number of MACs used in calculation
`define NUM_MACS 1
// Amount of time to write pending MAC outputs at the end of the mat mult
`define WRAP_UP_TIME 0
// Assumes every MAC always has data ready @(posedge clk)
`define STOP_COUNT ((`DIM * `DIM * `DIM) / `NUM_MACS) + `WRAP_UP_TIME
