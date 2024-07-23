module day15_tb ();
  localparam Requests = 8;
  // Write your Testbench here...
  // TB for round robin
  logic         clk;
  logic         reset;

  logic [Requests-1 : 0]   req_i;
  logic [Requests-1 : 0]   gnt_o;
  
  bit [7:0] cnt1, cnt2, cnt4, cnt8;
  bit [7:0] cnt16;
  bit [7:0] cnt32;
  bit [7:0] cnt64;
  bit [7:0] cnt128;
  bit [7:0] cnt;
  

  // Instatiate the module
  //day15 DAY(.*);
  RoundRobinArbiter #(.NumRequests(Requests)) DAY15 (.clk(clk),
               .rstN(reset),
               .req(req_i),
               .grant(gnt_o)
              );
  

  // Clock
  initial clk = 0;
  always #5 clk = ~clk;
  
  // Stimulus
  initial begin
    reset <= 1'b1;
    req_i <= 4'h0;
    @(posedge clk);
    reset <= 1'b0;
    repeat(2) @(posedge clk);
    for (int i =0; i<2**Requests; i++) begin
      req_i <= i;
      @(posedge clk);
      case(gnt_o)
        1   : cnt1++;
        2   : cnt2++;
        4   : cnt4++;
        8   : cnt8++;
        16  : cnt16++;
        32  : cnt32++;
        64  : cnt64++;
        128 : cnt128++;
        default : cnt++;
      endcase
    end
    $display("The number of grants for req0 are %d", cnt1);
    $display("The number of grants for req1 are %d", cnt2);
    $display("The number of grants for req2 are %d", cnt4);
    $display("The number of grants for req3 are %d", cnt8);
    $display("The number of grants for req4 are %d", cnt16);
    $display("The number of grants for req5 are %d", cnt32);
    $display("The number of grants for req6 are %d", cnt64);
    $display("The number of grants for req7 are %d", cnt128);
    $display("None requests were granted : %d", cnt);
    //calling testcase1
    testcase1();
    $finish();
  end
  
  //testcase1
  task testcase1();
    req_i <= (2 ** Requests) - 1;
    repeat(Requests) 
      begin
        @(posedge clk);
        $display("req_i = %b :: grant = %d", req_i, gnt_o);
      end
  endtask
  
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day15_tb.DAY15);
      //$dumpvars(0, day15_tb.DAY);
    end

endmodule
