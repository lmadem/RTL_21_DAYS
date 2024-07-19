module day1_tb();
  logic [7:0] a_i;
  logic [7:0] b_i;
  logic sel_i;
  logic [7:0] y_o;
  
  day1 DAY1(a_i, b_i, sel_i, y_o);
  
  initial 
    begin
      repeat(10)
        begin
          a_i = $urandom_range(0, 255);
          b_i = $urandom_range(0, 255);
          sel_i = $random%2;
          #5;
          $display("time = %0t sel = %b :: a = %d, b = %d :: y = %d", $realtime, sel_i, a_i, b_i, y_o);         end
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day1_tb.DAY1);
    end
endmodule
