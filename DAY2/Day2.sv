//Design and verify various flavours of a D flip-flop

//Interface Definition
//The module should have the following interface:

//input     logic      clk,
//input     logic      reset,

//input     logic      d_i,         -> D input to the flop

//output    logic      q_norst_o,   -> Q output from non-resettable flop
//output    logic      q_syncrst_o, -> Q output from flop using synchronous reset
//output    logic      q_asyncrst_o -> Q output from flop using asynchrnoous reset

// Different DFF
module day2 (
  input     logic      clk,
  input     logic      reset,
  input     logic      areset,

  input     logic      d_i,

  output    logic      q_norst_o,
  output    logic      q_syncrst_o,
  output    logic      q_asyncrst_o
);

  //Without reset
  always_ff @(posedge clk)
    q_norst_o <= d_i;
  
  //with synchronous reset
  always_ff @(posedge clk)
    begin
      if(reset)
        q_syncrst_o <= 1'b0;
      else
        q_syncrst_o <= d_i;
    end
  
  //with synchronous reset
  always_ff @(posedge clk or posedge areset)
    begin
      if(areset)
        q_asyncrst_o <= 1'b0;
      else
        q_asyncrst_o <= d_i;
    end
  
  

endmodule
