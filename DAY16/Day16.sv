//Design and verify an APB master interface which generates an APB transfer using a command input: | cmd_i | Comment | |-------|---------| | 2'b00 | No-operation | | 2'b01 | APB Read from address 0xDEAD_CAFE | | 2'b10 | Increment the previously read data and write to 0xDEAD_CAFE | | 2'b11 | Invalid/Not possible |

//Interface Definition

//The cmd_i input remains stable until the APB transfer is complete
//The module should have the following interface:
//module day16 (
  //input       wire        clk,
  //input       wire        reset,

  //input       wire[1:0]   cmd_i,

  //output      wire        psel_o,
  //output      wire        penable_o,
  //output      wire[31:0]  paddr_o,
  //output      wire        pwrite_o,
  //output      wire[31:0]  pwdata_o,
  //input       wire        pready_i,
  //input       wire[31:0]  prdata_i
//);


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
