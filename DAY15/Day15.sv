//Design and verify a 4-bit round robin arbiter.

//Interface Definition

//Output should be produced in a single cycle
//Output must be one-hot
//The module should have the following interface:
//module day15 (
  //input     wire        clk,
  //input     wire        reset,

  //input     wire[3:0]   req_i,
  //output    logic[3:0]  gnt_o
//);


//parameterized round-robin arbiter
module RoundRobinArbiter #(
  parameter NumRequests = 8
) (
  input  logic                   clk,
  input  logic                   rstN,
  input  logic [NumRequests-1:0] req,
  output logic [NumRequests-1:0] grant
);

  logic [NumRequests-1:0] mask, maskNext;
  logic [NumRequests-1:0] maskedReq;
  logic [NumRequests-1:0] unmaskedGrant;
  logic [NumRequests-1:0] maskedGrant;

  assign maskedReq = req & mask;
  
  PriorityArbiter #(.NUM_PORTS(NumRequests)) unmaskedArbiter(
    .req_i(req),
    .gnt_o(unmaskedGrant)
  );

  PriorityArbiter #(.NUM_PORTS(NumRequests)) maskedArbiter(
    .req_i(maskedReq),
    .gnt_o(maskedGrant)
  );

  assign grant = (maskedReq == '0) ? unmaskedGrant : maskedGrant;

  always_comb 
    begin
    if(grant == '0) 
      begin
        maskNext = mask;
      end
    else
      begin
        maskNext = '1;
        for(int i = 0; i < NumRequests; i++) 
          begin
            maskNext[i] = 1'b0;
            if(grant[i]) 
              break;
          end
      end
    end

  always_ff @(posedge clk or posedge rstN) 
    begin
      if(rstN) 
        mask <= '1;
      else
        mask <= maskNext;
    end
endmodule


//Priority Arbiter
module PriorityArbiter #(
  parameter NUM_PORTS = 4
)(
    input       wire[NUM_PORTS-1:0] req_i,
    output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
);
  // Port[0] has highest priority
  assign gnt_o[0] = req_i[0];

  genvar i;
  for (i=1; i<NUM_PORTS; i=i+1) 
    begin
      assign gnt_o[i] = req_i[i] & (!gnt_o[i-1:0]);
    end

endmodule



//4-bit round-robin arbiter
module day15(input  logic       clk,
             input  logic       reset,
             input  logic [3:0] req_i,
             output logic [3:0] gnt_o
);

  logic [3:0] mask, maskNext;
  logic [3:0] maskedReq;
  logic [3:0] unmaskedGrant;
  logic [3:0] maskedGrant;

  assign maskedReq = req_i & mask;
  
  PriorityArbiter #(4) unmaskedArbiter(
    .req_i(req_i),
    .gnt_o(unmaskedGrant)
  );

  PriorityArbiter #(4) maskedArbiter(
    .req_i(maskedReq),
    .gnt_o(maskedGrant)
  );

  assign gnt_o = (maskedReq == '0) ? unmaskedGrant : maskedGrant;

  always_comb 
    begin
      maskNext = mask;
      if(gnt_o[0]) maskNext = 4'b1110;
      if(gnt_o[1]) maskNext = 4'b1100;
      if(gnt_o[2]) maskNext = 4'b1000;
      if(gnt_o[3]) maskNext = 4'b0000;
    end

  always_ff @(posedge clk or posedge reset) 
    begin
      if(reset) 
        mask <= 4'hF;
      else
        mask <= maskNext;
    end
endmodule
