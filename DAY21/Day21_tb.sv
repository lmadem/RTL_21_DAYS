// TB
module day21_tb ();

  // Write your Testbench here...
  localparam WIDTH = 8;

  logic [WIDTH-1:0] vec_i;
  logic [WIDTH-1:0] second_bit_o;

  day21 #(WIDTH) DAY21 (.*);

  initial begin
    for (int i=0; i<64; i=i+1) 
      begin
        vec_i = $urandom_range(0, 2**WIDTH-1);
        #5;
        $display("Time = %0t Input vector = %b :: second_bit_output = %d", $realtime, vec_i, second_bit_o);
      end
  end

  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(0,day21_tb.DAY21); 
    end
endmodule

