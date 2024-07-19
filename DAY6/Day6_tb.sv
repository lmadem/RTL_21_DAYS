module day6_tb();
  logic clk;
  logic reset;
  logic x_i;
  logic [3:0] sr_o;
  
  day6 DAY6(.*);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial 
    begin
      reset <= 1'b1;
      x_i <= 1'b0;
      repeat(2) @(posedge clk);
      reset <= 1'b0;
      @(posedge clk);
      repeat(16)
        begin
          x_i = $random % 2;
          @(posedge clk);
        end
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day6_tb.DAY6);
    end
  
endmodule
