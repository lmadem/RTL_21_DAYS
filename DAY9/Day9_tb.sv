module day9_tb();
  localparam VEC_W = 5;
  
  logic [VEC_W - 1 : 0] bin_i;
  logic [VEC_W - 1 : 0] gray_o;
  
  day9 #(VEC_W) DAY9 (.*);
  
  initial
    begin
      for(int i=0; i<2**VEC_W; i++)
        begin
          bin_i = i;
          #5;
          $display("time = %0t input_bin = %0d output_gray = %0d", $realtime, bin_i, gray_o);
        end
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day9_tb.DAY9);
    end
endmodule
