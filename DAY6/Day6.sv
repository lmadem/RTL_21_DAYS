//Design and verify a simple shift register

//Interface Definition
//The module should have the following interface:

//input     wire        clk,
//input     wire        reset,
//input     wire        x_i,  -> Serial input

//output    wire[3:0]   sr_o  -> Shift register output

// Simple shift register
module day6(
  input     wire        clk,
  input     wire        reset,
  input     wire        x_i,      // Serial input

  output    wire[3:0]   sr_o
);

  // Write your logic here...
  
  logic [3:0] ff;
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        ff <= 0;
      else
        ff <= {sr_o[2:0], x_i};
    end

  assign sr_o = ff;
endmodule

