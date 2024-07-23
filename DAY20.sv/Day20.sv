/*
Design and verify a read/write system described below:

Writes should have higher priority than reads
Sytem should be able to buffer 16 read or write requests to avoid any loss
System must use APB master/slave protocol to communicate to memory interface

                                   rd_valid_o
                                       ^
                                       |
|-----|    |------|    |------|     |------|
| ARB | -> | FIFO | -> | APBM | <-> | APBS | => rd_data_o
|-----|    |------|    |------|     |------|


The idea behind this problem is to exercise how a complex system can be created by connecting various small blocks together

Interface Definition

The module should have the following interface:
module day20 (
  input       wire        clk,
  input       wire        reset,

  input       wire        read_i,       - Sends a read request when asserted
  input       wire        write_i,      - Sends a write request when asserted

  output      wire        rd_valid_o,   - Should be asserted whenever read data is valid
  output      wire[31:0]  rd_data_o     - Read data
);
*/

//`include "Day16.sv"
//`include "Day18.sv"
//`include "Day19.sv"

module day20(
  input       wire        clk,
  input       wire        reset,

  input       wire        read_i, //Sends a read request when asserted
  input       wire        write_i, //Sends a write request when asserted

  output      wire        rd_valid_o, //Should be asserted whenever read data is valid
  output      wire[31:0]  rd_data_o //Read data
);
  
  logic wr_gnt; //write grant
  logic rd_gnt; //read grant
  
  //Priority logic - Write and Read Request
  
  always_comb
    begin
      {wr_gnt, rd_gnt} = 2'b00;
      case({read_i,write_i})
        2'b00 : {wr_gnt,rd_gnt} = 2'b00;
        2'b01 : {wr_gnt,rd_gnt} = 2'b10;
        2'b10 : {wr_gnt,rd_gnt} = 2'b01;
        2'b11 : {wr_gnt,rd_gnt} = 2'b10;
        default : {wr_gnt,rd_gnt} = 2'b00;
      endcase
    end
  
  //FIFO Internal Signals
  logic push;
  logic pop;
  logic [1:0] push_data;
  logic [1:0] pop_data;
  logic full;
  logic empty;
  
    
  //APB Master & Slave Internal Signals
  logic          psel;
  logic          penable;
  logic          pwrite;
  logic [31:0]   paddr;
  logic [31:0]   pwdata;
  logic          pready;
  logic [31:0]   prdata;
  
  //FIFO Logic
  assign push = {wr_gnt,rd_gnt} > 0;
  assign push_data = {wr_gnt,rd_gnt};
  assign pop = ~empty & ~(psel & penable);
  
  //FIFO Module Instantiation
  FIFO #(.DEPTH(16), .DATA_W(2)) FIFO_DUT (.clk(clk),
                                           .reset(reset), 
                                           .push_i(push),
                                           .push_data_i(push_data),
                                           .pop_i(pop),
                                           .pop_data_o(pop_data),
                                           .full_o(full),
                                           .empty_o(empty)
                                          );
  
  //Instantiate the APB Master
  
  APBMaster APBMaster_DUT(.clk(clk),
                          .reset(reset),
                          .cmd_i(pop_data),
                          .pready_i(pready),
                          .prdata_i(prdata),
                          .psel_o(psel),
                          .penable_o(penable),
                          .paddr_o(paddr),
                          .pwrite_o(pwrite),
                          .pwdata_o(pwdata)
                         );
  
  //Instantiate the APB Slave
  
  APBSlave APBSlave_DUT(.clk(clk),
                        .reset(reset),
                        .psel_i(psel),
                        .penable_i(penable),
                        .paddr_i(paddr[3:0]),
                        .pwrite_i(pwrite),
                        .pwdata_i(pwdata),
                        .prdata_o(prdata),
                        .pready_o(pready)
                        );
  
  assign rd_valid_o = pready & ~pwrite;
  assign rd_data_o = {32{rd_valid_o}} & prdata;

endmodule


// Code your design here
module APBMaster(input clk, //Clock
                 input reset, //Reset
                 input [1:0] cmd_i, //Command to operate APB Master 
                 input pready_i, //Indicates the completion of APB Transfer
                 input [31:0] prdata_i, // Input data
                 output psel_o, // Signal to indicate the APB IDLE & SETUP Phases
                 output penable_o, //Signal to indicate the APB SETUP phase
                 output [31:0] paddr_o, //Address, this design is tied to the address : 31'hDEAD_CAFE
                 output pwrite_o, // Signal to indicate the APB Access phase
                 output reg [31:0] pwdata_o // Output data
                );
  //APB operates in three phases: IDLE, SETUP, and ACCESS
  
  parameter IDLE = 2'b00;
  parameter SETUP = 2'b01;
  parameter ACCESS = 2'b10;
  
  logic [1:0] state; // Register to control state machine logic
  logic [31:0] rdata_q; //Internal register for input data
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        state <= IDLE;
      else
        begin
          case(state)
            
            IDLE : begin
              if(cmd_i == 1)
                state <= SETUP;
              else
                state <= IDLE;
              end
            
            SETUP : begin
              if(cmd_i == 2)
                state <= ACCESS;
              else
                state <= SETUP;
            end
            
            ACCESS : begin
              if(pready_i)
                state <= IDLE;
              else
                state <= ACCESS;
            end
            
            default : state <= IDLE;
            
          endcase
        end
    end
  
  assign psel_o = (state == IDLE | state == SETUP);
  assign penable_o = (state == SETUP);
  assign paddr_o = 32'hDEAD_CAFE;
  assign pwrite_o = (state == ACCESS);
  assign pwdata_o = rdata_q + 1;
  
  
  always @(posedge clk or posedge reset)
    begin
      if(reset)
        rdata_q <= 0;
      else if(penable_o && pready_i)
        rdata_q <= prdata_i;
      else
        rdata_q <= rdata_q;
    end

endmodule


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
