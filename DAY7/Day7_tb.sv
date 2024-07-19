module day7_tb();
  logic clk;
  logic reset;
  logic [3:0] lfsr_o;
  
  day7 DAY7(.*);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial 
    begin
      reset <= 1'b1;
      repeat(2) @(posedge clk);
      reset <= 1'b0;
      repeat(25)
        begin
          @(posedge clk);
        end
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day7_tb.DAY7);
    end
  
endmodule
