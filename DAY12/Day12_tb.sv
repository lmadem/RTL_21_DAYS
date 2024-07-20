module day12_tb ();
  logic clk;
  logic reset;
  logic x_i;
  logic det_o;
  
  logic [11:0] seq = 12'b1110_1101_1011;
  
  day12 DAY12(clk,reset,x_i,det_o);
  
  always #5 clk = ~clk;
  
  initial clk = 0;
  
  task rst;
    reset <= 1'b1;
    repeat(3) @(posedge clk);
    reset <= 1'b0;
  endtask
  
  task in_gen;
    repeat(16)
      begin
        x_i = $urandom;
        @(posedge clk);
      end
  endtask

  task testcase1;
    rst;
    in_gen;
    repeat(3) @(posedge clk);
  endtask
  
  task testcase2;
    for(int i = 11; i >= 0; i--)
      begin
        x_i <= seq[i];
        @(posedge clk);
      end
    x_i <= 0;
    //repeat(3) @(posedge clk);
  endtask
  
  
  initial
    begin
      testcase1;
      repeat(2)
        begin
          testcase2;
        end
      repeat(3) @(posedge clk);
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day12_tb.DAY12);
    end
endmodule

