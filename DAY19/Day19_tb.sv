module FIFO_tb;

  // Write your Testbench here...
  localparam DEPTH = 8;
  localparam DATA_W = 8;
  
  logic clk;
  logic reset;
  logic push_i;
  logic [DATA_W - 1 : 0] push_data_i;
  logic pop_i;
  logic [DATA_W - 1 : 0] pop_data_o;
  logic full_o;
  logic empty_o;
  
  FIFO #(.DEPTH(DEPTH), .DATA_W(DATA_W)) DUT(.*);
  
  task preset;
    clk = 0;
    push_i = 0;
    pop_i = 0;
    push_data_i = 0;
  endtask
  
  always #5 clk = ~clk;
  
  task rst;
    reset <= 1;
    repeat(3) @(posedge clk);
    reset <= 0;
  endtask
  
  task write_operation;
    push_i <= 1;
    repeat(DEPTH) begin
      push_data_i = $urandom;
      @(posedge clk);
    end
    wait(full_o == 1);
    push_i <= 0;
    push_data_i <= 0;
    @(posedge clk);
  endtask
  
  task read_operation;
    pop_i <= 1;
    @(posedge clk);
    wait(empty_o == 1);
    pop_i <= 0;
    repeat(2) @(posedge clk);
  endtask
  
  task write_read_operation;
    push_i      <= 1'b1;
    push_data_i <= $urandom;
    //@(posedge clk);
    push_i      <= 1'b0;
    // Push and pop both
    for (int i=0; i<DEPTH; i++) begin
      push_i      <= 1'b1;
      pop_i       <= 1'b1;
      push_data_i <= $urandom;
      @(posedge clk);
    end
    pop_i <= 1'b0;
    push_i<= 1'b0;
    repeat(2) @(posedge clk);
  endtask
  
  initial
    begin
      preset;
      rst;
      write_operation;
      read_operation;
      write_read_operation;
      write_read_operation;
      repeat(5) @(posedge clk);
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1); 
      $dumpvars(0,FIFO_tb.DUT); 
    end
  

endmodule
