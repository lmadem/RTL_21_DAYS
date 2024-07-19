module day2_tb();
  logic clk;
  logic reset;
  logic areset;
  logic d_i;
  logic q_norst_o;
  logic q_syncrst_o;
  logic q_asyncrst_o;
  
  day2 DAY2(.*);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial
    begin
      reset = 1'b1;
      d_i = 1'b1;
      repeat(2) @(posedge clk);
      reset = 1'b0;
      d_i = 1'b0;
      @(posedge clk);
      d_i = 1'b1;
      repeat(5) @(posedge clk);
      @(negedge clk);
      reset = 1'b1;
      repeat(5) @(posedge clk);
      reset = 1'b0;
      repeat(5) @(posedge clk);
      #2 areset = 1'b1;
      #20 areset = 1'b0;
      repeat(5) @(posedge clk);
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day2_tb.DAY2);
    end
  
endmodule
