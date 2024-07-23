//Design and verify a parameterized synchronous fifo. Both the depth and data width should be parameterized

//Interface Definition

//The module should have the following interface:

//module day19 #(
  //parameter DEPTH   = 4,
  //parameter DATA_W  = 1
//)(
  //input         wire              clk,
  //input         wire              reset,

  //input         wire              push_i,
  //input         wire[DATA_W-1:0]  push_data_i,

  //input         wire              pop_i,
  //output        wire[DATA_W-1:0]  pop_data_o,

  //output        wire              full_o,
  //output        wire              empty_o
//);

// Parameterized fifo
module FIFO #(
  parameter DEPTH   = 4,
  parameter DATA_W  = 4
)(
  input         wire              clk,
  input         wire              reset,

  input         wire              push_i,
  input         wire[DATA_W-1:0]  push_data_i,

  input         wire              pop_i,
  output        wire[DATA_W-1:0]  pop_data_o,

  output        wire              full_o,
  output        wire              empty_o
);

  // Write your logic here...
  logic [DATA_W - 1 : 0] mem [DEPTH - 1 : 0]; //Memory 
  logic [$clog2(DEPTH) : 0] wp; //Write pointer
  logic [$clog2(DEPTH) : 0] rp; //Read pointer
  logic [DATA_W - 1 : 0] data_out; //register for data out
  
  //Write pointer logic
  always_ff @(posedge clk or posedge reset)
    begin
      if(reset)
        wp <= 0;
      else if(push_i & ~full_o)
        wp <= wp + 1;
      else
        wp <= wp;
    end
  
  //Read pointer logic
  always_ff @(posedge clk or posedge reset)
    begin
      if(reset)
        rp <= 0;
      else if(pop_i & ~empty_o)
        rp <= rp + 1;
      else
        rp <= rp;
    end
  
  //Full and empty conditions
  assign full_o = (wp[$clog2(DEPTH)] != rp[$clog2(DEPTH)] &
                   wp[$clog2(DEPTH) - 1 : 0] == rp[$clog2(DEPTH) - 1 : 0]);
  assign empty_o = (wp == rp);
  
  //Memory write operation
  always_ff @(posedge clk or posedge reset)
    begin
      if(reset)
        begin
          for(int i =0; i<DEPTH; i++)
            begin
              mem[i] <= 0;
            end
        end
      else if(push_i & ~full_o)
        mem[wp[$clog2(DEPTH) - 1 : 0]] <= push_data_i;
      else
        mem[wp[$clog2(DEPTH) - 1 : 0]] <= mem[wp[$clog2(DEPTH) - 1 : 0]] ;
    end
  
  //Memory Read Operation
  always_ff @(posedge clk or posedge reset)
    begin
      if(reset)
        data_out <= 0;
      else if(pop_i & ~empty_o)
        data_out <= mem[rp[$clog2(DEPTH) - 1 : 0]];
      else
        data_out <= 0;
    end
  
  assign pop_data_o = data_out;
  
endmodule 
