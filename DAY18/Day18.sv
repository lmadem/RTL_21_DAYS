//Design and verify a APB slave interface which utilises the memory interface designed on day17

//Interface Definition

//The module should have the following interface:
//module day18 (
  //input         wire        clk,
  //input         wire        reset,

  //input         wire        psel_i,
  //input         wire        penable_i,
  //input         wire[9:0]   paddr_i,
  //input         wire        pwrite_i,
  //input         wire[31:0]  pwdata_i,
  //output        wire[31:0]  prdata_o,
  //output        wire        pready_o
//);

//APBSlave with memory
//Using ValidReadyMem module
//`include "Day17.sv"
module APBSlave(input clk,
                input reset,
                input psel_i,
                input penable_i,
                input [3:0] paddr_i,
                input pwrite_i,
                input [31:0] pwdata_i,
                output reg [31:0] prdata_o,
                output pready_o);
  
  logic APB_req;
  
  assign APB_req = psel_i & penable_i;
  
  ValidReadyMem MEMDUT(.clk(clk),
                    .rst(reset),
                    .req_i(APB_req),
                    .req_rnw_i(~pwrite_i),
                    .req_addr_i(paddr_i),
                    .req_wdata_i(pwdata_i),
                    .req_ready_o(pready_o),
                    .req_rdata_o(prdata_o)
                   );
endmodule

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
