module day5_tb();
  logic clk;
  logic reset;
  logic [7:0] cnt_o;
  
  day5 DAY5(.*);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial 
    begin
      reset <= 1'b1;
      repeat(2) @(posedge clk);
      reset <= 1'b0;
      repeat(200) @(posedge clk);
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day5_tb.DAY5);
    end
  
endmodule
