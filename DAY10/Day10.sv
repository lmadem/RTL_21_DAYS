//Design and verify a counter which supports loading a value

//Interface Definition
//Counter should reset to 0
//The module should have the following interface:
//input     wire          clk,
//input     wire          reset,
//input     wire          load_i,     -> Load value is valid this cycle
//input     wire[3:0]     load_val_i, -> 4-bit load value

//output    wire[3:0]     count_o     -> Counter output

// Counter with a load
module day10 (
  input     wire          clk,
  input     wire          reset,
  input     wire          load_i,
  input     wire[3:0]     load_val_i,

  output    wire[3:0]     count_o
);

  // Write your logic here...
  
  logic [3:0] cnt;
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        cnt <= 4'd0;
      else if(cnt == 15)
        cnt <= load_val_i;
      else if(load_i)
        cnt <= load_val_i;
      else
        cnt <= cnt + 1;
    end

  assign count_o = cnt;
endmodule

