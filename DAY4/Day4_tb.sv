module day4_tb();
  logic [7:0] a_i;
  logic [7:0] b_i;
  logic [2:0] op_i;
  logic [7:0] alu_o;
  
  day4 DAY4(.a_i(a_i),
            .b_i(b_i),
            .op_i(op_i),
            .alu_o(alu_o)
           );
  
  initial 
    begin
      for(bit [2:0] i=0; i<3; i++)
        begin
          for(bit [3:0] j=0; j<8; j++)
            begin
              a_i = $urandom_range(0, 255);
              b_i = $urandom_range(0, 255);
              op_i = j;
              #5;
              $display("time = %0t op_code = %d :: a = %d, b = %d :: alu_out = %d", $realtime, op_i, a_i, b_i, alu_o);       
            end
        end
      
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0, day4_tb.DAY4);
    end
  
endmodule
