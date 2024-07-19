//Design and verify a parameterized binary to one-hot converter

//Interface Definition
//The module should have the following interface:

//module day8#(
  //parameter BIN_W       = 4,
  //parameter ONE_HOT_W   = 16
//)(
  //input   wire[BIN_W-1:0]     bin_i,    -> Binary input vector
 // output  wire[ONE_HOT_W-1:0] one_hot_o -> One-hot output
//);

// Binary to one-hot
module day8#(
  parameter BIN_W       = 4,
  parameter ONE_HOT_W   = 16
)(
  input   wire[BIN_W-1:0]     bin_i,
  output  wire[ONE_HOT_W-1:0] one_hot_o
);
  
  assign one_hot_o = 1'b1 << bin_i;
  
endmodule
