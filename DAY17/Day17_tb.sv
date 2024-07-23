module ValidReadyMem_tb;
  logic clk;
  logic rst;
  logic req_i, req_iNBA = 0;
  logic req_rnw_i, req_rnw_iNBA = 0;
  logic [3:0] req_addr_i, req_addr_iNBA = 0;
  logic [31:0] req_wdata_i, req_wdata_iNBA = 0;
  logic req_ready_o;
  logic [31:0] req_rdata_o;

  // Instatiate the RTL
  ValidReadyMem DUT(clk,rst, req_iNBA, req_rnw_iNBA, req_addr_iNBA, req_wdata_iNBA, req_ready_o, req_rdata_o);
  
  
  always @* req_iNBA <= req_i;
  always @* req_rnw_iNBA <= req_rnw_i;
  always @* req_addr_iNBA <= req_addr_i;
  always @* req_wdata_iNBA <= req_wdata_i;
  
  always #5 clk = ~clk;
  
  task preset;
    begin
      clk = 0;
      req_i = 0;
      req_rnw_i = 0;
      req_addr_i = 0;
      req_wdata_i = 0;
    end
  endtask
  
  task reset;
    begin
      rst = 1;
      @(posedge clk);
      rst = 0;
    end
  endtask
  
  task gen_stimulus;
    logic [9:0] [9:0] addr_list;
    begin
      @(posedge clk);
      for(int txn = 0; txn<10; txn++)
        begin
          //write 10 transactions
          req_i = 1;
          req_rnw_i = 0;
          req_addr_i = $urandom_range(0, 4'hF);
          $display("Write Address :%d", req_addr_i);
          addr_list[txn] = req_addr_i;
          req_wdata_i = $urandom_range(0, 8'hFF);
          //wait for ready signal
          wait(req_ready_o == 1);
          req_i = 0;
          @(posedge clk);
        end
      for(int txn = 0; txn<10; txn++)
        begin
          //Read 10 transactions
          req_i = 1;
          req_rnw_i = 1;
          req_addr_i = addr_list[txn];
          $display("Read Address: %d", req_addr_i);
          //req_wdata_i = $urandom_range(0, 8'hFF);
          wait(req_ready_o == 1);
          req_i = 0;
          @(posedge clk);
 
        end
      
    end
    
  endtask
  
  initial
    begin
      preset;
      reset;
      gen_stimulus;
      repeat(15) @(posedge clk);
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd"); 
      $dumpvars(0);
      $dumpvars(1,ValidReadyMem_tb.DUT);
    end

endmodule
