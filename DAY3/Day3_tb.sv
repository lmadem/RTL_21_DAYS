module day3_tb();
  logic clk;
  logic reset;
  logic a_i;
  logic rising_edge_o;
  logic falling_edge_o;
  
  day3 DAY3(.clk(clk),
            .reset(reset),
            .a_i(a_i),
            .rising_edge_o(rising_edge_o),
            .falling_edge_o(falling_edge_o)
           );
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial 
    begin
      reset <= 1'b1;
      a_i <= 1'b1;
      @(posedge clk);
      reset <= 1'b0;
      @(posedge clk);
      for (int i=0; i<32; i++) 
        begin
          a_i <= $random%2;
          @(posedge clk);
        end
    $finish();
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day3_tb.DAY3);
    end
  
endmodule
