//Design and verify a rising and falling edge detector

//Interface Definition
//The module should have the following interface:

//input     wire    clk,
//input     wire    reset,

//input     wire    a_i,            -> Serial input to the module

//output    wire    rising_edge_o,  -> Rising edge output
//output    wire    falling_edge_o  -> Falling edge output

// An edge detector
module day3 (
  input     wire    clk,
  input     wire    reset,

  input     wire    a_i,

  output    wire    rising_edge_o,
  output    wire    falling_edge_o
);

  logic a;

  always_ff @(posedge clk or posedge reset)
    begin
      if (reset)
        a <= 1'b0;
      else
        a <= a_i;
    end
  
  // Rising edge when delayed signal is 0 but current is 1
  assign rising_edge_o =  a_i & ~a;

  // Falling edge when delayed signal is 1 but current is 0
  assign falling_edge_o = ~a_i & a;

endmodule

