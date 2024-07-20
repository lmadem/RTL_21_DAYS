module day11_tb ();
  logic clk;
  logic reset;
  logic empty_o;
  logic [3:0] parallel_i;
  logic serial_o;
  logic valid_0;
  
  day11 DAY11(clk,reset,empty_o,parallel_i,serial_o,valid_o);
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  task preset;
    parallel_i <= 0;
  endtask
  
  task rst;
    reset <= 1'b1;
    repeat(3) @(posedge clk);
    reset <= 1'b0;
  endtask
  
  task in_gen;
    //@(posedge clk);
    parallel_i <= $urandom_range(1,15);
    repeat(4) @(posedge clk);
    parallel_i <= 0;
    @(posedge clk);
  endtask
  
  initial
    begin
      preset;
      rst;
      repeat(8)
        begin
          in_gen;
        end
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day11_tb.DAY11);
    end
    

  
endmodule

