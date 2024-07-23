//Design and verify a module which finds the second bit set from LSB for a N-bit vector.

//Interface Definition

//Output should be produced in a single cycle
//Output must be one-hot or zero
//The module should have the following interface:
//module day21 #(
  //parameter WIDTH = 12
//)(
    //input  wire [WIDTH-1:0] vec_i,
    //output wire [WIDTH-1:0] second_bit_o
//);

// Find second bit set from LSB for a N-bit vector

//`include "Day14.sv"
module day21 #(
  parameter WIDTH = 12
)(
  input       wire [WIDTH-1:0]  vec_i,
  output      wire [WIDTH-1:0]  second_bit_o

);

  // Write your logic here...
  
  logic [WIDTH - 1 : 0] first_bit_mask;
  logic [WIDTH - 1 : 0] masked_vec;
  
  //assign first_bit_mask = vec_i & (vec_i - 1); this logic doesn't work when I change the req from LSB to MSB
  
  assign masked_vec = vec_i & ~first_bit_mask;
  day14 #(.NUM_PORTS(WIDTH)) firstmask (.req_i(vec_i), .gnt_o(first_bit_mask));
  
  
  day14 #(.NUM_PORTS(WIDTH)) secondbitfind (.req_i(masked_vec), .gnt_o(second_bit_o));
  

endmodule

module day14 #(
  parameter NUM_PORTS = 4
)(
    input       wire[NUM_PORTS-1:0] req_i,
    output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
);
  // Port[0] has highest priority
  assign gnt_o[0] = req_i[0];

  genvar i;
  for (i=1; i< NUM_PORTS; i=i+1) begin
    assign gnt_o[i] = req_i[i] & ~(gnt_o[i-1:0] > 0);
  end

endmodule

