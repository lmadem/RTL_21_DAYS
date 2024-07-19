module day8_tb();
  localparam BIN_W = 4;
  localparam ONE_HOT_W = 16;
  
  logic [BIN_W - 1 : 0] bin_i;
  logic [ONE_HOT_W - 1 : 0] one_hot_o;
  
  day8 #(BIN_W, ONE_HOT_W) DAY8 (.*);
  
  initial
    begin
      repeat(32)
        begin
          bin_i = $urandom_range(0,15);
          #5;
          $display("time = %0t input_bin = %0d output_one_hot = %0d", $realtime, bin_i, one_hot_o);
        end
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day8_tb.DAY8);
    end
endmodule
