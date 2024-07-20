//Design and verify a 4-bit parallel to serial converter with valid and empty indications

//Interface Definition

//The module should have the following interface:

//input     wire      clk,
//input     wire      reset,

//output    wire      empty_o,    -> Should be asserted when all of the bits are given out serially
//input     wire[3:0] parallel_i, -> Parallel input vector
  
//output    wire      serial_o,   -> Serial bit output
//output    wire      valid_o     -> Serial bit is valid

// Parallel to serial with valid and empty
module day11 (
  input     wire      clk,
  input     wire      reset,

  output    wire      empty_o,
  input     wire[3:0] parallel_i,
  
  output    reg      serial_o,
  output    wire      valid_o
);

  logic [3:0] cnt;
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        cnt <= 0;
      else if(cnt == 4)
        cnt <= 0;
      else
        cnt <= cnt + 1;
    end
  
  assign empty_o = (cnt == 4) ? 1 : 0;
  
  always @(*)
    begin
      if(reset)
        serial_o = 0;
      else
        begin
          case(cnt)
            0 : serial_o = parallel_i[3];
            1 : serial_o = parallel_i[2];
            2 : serial_o = parallel_i[1];
            3 : serial_o = parallel_i[0];
            4 : serial_o = 0;
          endcase
        end
    end
  
  assign valid_o = (cnt != 4) ? 1 : 0;
  


endmodule

