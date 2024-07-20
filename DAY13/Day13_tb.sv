module day13_tb ();
  logic [3:0] a_i;
  logic [3:0] sel_i;
  logic y_ter_o;
  logic y_case_o;
  logic y_ifelse_o;
  logic y_loop_o;
  logic y_aor_o;
  
  day13 DAY13(.*);
  
  task testcase1;
    for (int i=0; i<32; i++) 
      begin
        a_i   = $urandom_range(0, 4'hF);
        sel_i = 1'b1 << $urandom_range(0, 2'h3); // one-hot
        #5;
      end
  endtask
  
  initial
    begin
      testcase1;
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day13_tb.DAY13);
    end
  

endmodule
