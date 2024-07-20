//Design and verify a sequence detector to detect the following sequence: 1110_1101_1011

//Interface Definition

//Overlapping sequences should be detected
//The module should have the following interface:
//input     wire        clk,
//input     wire        reset,
//input     wire        x_i,    -> Serial input

//output    wire        det_o   -> Output asserted when sequence is detected

// Detecting a big sequence - 1110_1101_1011
module day12 (
  input     wire        clk,
  input     wire        reset,
  input     wire        x_i,

  output    wire        det_o
);

  // Write your logic here...
  logic [11:0] ff;

  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        ff <= 12'd0;
      else
        ff <= {ff[10:0], x_i};
    end
  
  assign det_o = (ff == 12'b1110_1101_1011) ? 1 : 0;

endmodule
