//Day 1
//Design and verify a 2:1 mux

//Interface Definiton
//The module should have the following interface

//input   wire [7:0]    a_i   - First leg of the mux
//input   wire [7:0]    b_i   - Second leg of the mux
//input   wire          sel_i - Mux select
//output  wire [7:0]    y_o   - Mux output

// A simple mux
module day1 (
  input   wire [7:0]    a_i,
  input   wire [7:0]    b_i,
  input   wire          sel_i,
  output  wire [7:0]    y_o
);
  
  assign y_o = sel_i ? a_i : b_i;

endmodule
