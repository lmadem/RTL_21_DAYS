module day10_tb();
  logic clk;
  logic reset;
  logic load_i;
  logic [3:0] load_val_i;
  logic [3:0] count_o;
  
  day10 DAY10(.*);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  int cycles;
  initial 
    begin
      reset <= 1'b1;
      load_i <= 1'b0;
      load_val_i <= 4'h0;
      repeat(2) @(posedge clk);
      reset <= 1'b0;
      
      for(int i=1; i<7; i++)
        begin
          load_i <= 1'b1;
          load_val_i <= 3*i;
          cycles = 15 - load_val_i;
          @(posedge clk);
          load_i <= 1'b0;
          while(cycles)
            begin
              cycles = cycles - 1;
              @(posedge clk);
            end
        end
      repeat(5) @(posedge clk);
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day10_tb.DAY10);
    end
  
endmodule
