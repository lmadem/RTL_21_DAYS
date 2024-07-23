//Design and verify a valid/ready based memory interface slave. The interface should be able to generate the ready output after a random delay. Memory should be 16x32 bits wide.

//Interface Definition

//Valid/ready protocol must be honoured
//The module should have the following interface:
//module day17 (
  //input       wire        clk,
  //input       wire        reset,

  //input       wire        req_i,        -> Valid request input remains asserted until ready is seen
  //input       wire        req_rnw_i,    -> Read-not-write (1-read, 0-write)
  //input       wire[3:0]   req_addr_i,   -> 4-bit Memory address
  //input       wire[31:0]  req_wdata_i,  -> 32-bit write data
  //output      wire        req_ready_o,  -> Ready output when request accepted
  //output      wire[31:0]  req_rdata_o   -> Read data from memory
//);

  // Memory array
  //logic [15:0][31:0] mem;

module ValidReadyMem(input clk, //Input clock
                     input rst, // Asyn Reset
                     input req_i, //Input request - Valid Signal
                     input req_rnw_i, // Memory control signal, req_rnw_i = 1 for read and req_rnw_i = 0 for write
                     input [3:0] req_addr_i,//Address
                     input [31:0] req_wdata_i, //Write data
                     output req_ready_o, // Output ready signal
                     output [31:0] req_rdata_o); // Read data
  
  logic [31:0] mem [15:0]; //memory of 16X32 bit wide
  
  //Internal Signals
  reg req_i_q; //Latch for req_i
  wire req_raising_edge; // Signal to capture req_i raising edge
  wire mem_wr; //Control signal for memory write
  wire mem_rd; //control signal for memory read
  logic [3:0] ff; //flop to generate random values
  logic [3:0] count; //Counter to load a random value when req_i is asserted and then increments further
  
  // This block is to capture req raising edge
  always_ff @(posedge clk or posedge rst)
    begin
      if(rst)
        req_i_q <= 0;
      else
        req_i_q <= req_i;
    end
  
  assign req_raising_edge = req_i & ~req_i_q;
  
  //memory read and write operations - Instead of input signal req_i: I have used internal_signal: req_i_q
  assign mem_wr = req_i_q & (req_rnw_i == 0);
  assign mem_rd = req_i_q & (req_rnw_i == 1);
  
  //generating random values 
  
  always_ff @(posedge clk or posedge rst)
    begin
      if(rst)
        ff <= 4'hF;
      else 
        ff <= {ff[2:0], ff[1] ^ ff[3]};
    end
  
  //counter logic
  
  always_ff @(posedge clk or posedge rst)
    begin
      if(rst)
        count <= 0;
      else if(req_raising_edge)
        count <= ff;
      else
        count <= count + 1;
    end
  
  //Memory logic
  
  always_ff @(posedge clk or posedge rst)
    begin
      if(rst)
        begin
          //clearing the memory when rst is asserted
          for(int i = 0; i<16; i++)
            begin
              mem[i] <= 0;
            end
        end
      //write into the memory when count is 0
      else if(mem_wr & count == 0)
        mem[req_addr_i] <= req_wdata_i;
      else
        mem[req_addr_i] <= mem[req_addr_i];
    end
  
  //assert ready when count is 0
  assign req_ready_o = (count == 0);
  //Read from the memory address when mem_rd is high
  assign req_rdata_o = mem[req_addr_i] & {31{mem_rd}};
  
  

  
endmodule
