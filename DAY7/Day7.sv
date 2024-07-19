//Design and verify a 4-bit linear feedback shift register where the bit0 of the register is driven by the XOR of the LFSR register bit1 and bit3

//Interface Definition
//The module should have the following interface:

//input     wire      clk,
//input     wire      reset,

//output    wire[3:0] lfsr_o

// LFSR
module day7 (
  input     wire      clk,
  input     wire      reset,

  output    wire[3:0] lfsr_o
);

  logic [3:0] ff;
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        ff <= 4'd15;
      else
        ff <= {ff[2:0], ff[3] ^ ff[1]};
    end
  
  assign lfsr_o = ff;
endmodule

