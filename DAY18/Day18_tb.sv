module APBSlave_tb;

  // Write your Testbench here...
  logic        clk;
  logic        reset;

  logic        psel_i;
  logic        penable_i;
  logic[3:0]   paddr_i;
  logic        pwrite_i;
  logic[31:0]  pwdata_i;
  logic[31:0]  prdata_o;
  logic        pready_o;

  logic [9:0] [3:0] rand_addr_list;

  // Instantiate the RTL
  APBSlave DUT  (.clk(clk),
                 .reset(reset),
                 .psel_i(psel_i),
                 .penable_i(penable_i),
                 .paddr_i(paddr_i),
                 .pwrite_i(pwrite_i),
                 .pwdata_i(pwdata_i),
                 .prdata_o(prdata_o),
                 .pready_o(pready_o)
                );

  // Generate the clock
  always begin
    clk = 1'b0;
    #5;
    clk = 1'b1;
    #5;
  end

  // Generate stimulus
  initial begin
    reset     <= 1'b1;
    psel_i    <= 1'b0;
    penable_i <= 1'b0;
    @(posedge clk);
    reset     <= 1'b0;
    @(posedge clk);
    // Send 10 write transactions to random addresses
    for (int i=0; i<10; i++) begin
      psel_i  <= 1'b1;      // ST_SETUP
      @(posedge clk);
      penable_i <= 1'b1;    // ST_ACCESS
      paddr_i   <= i;
      pwrite_i  <= 1'b1;    // Write
      pwdata_i  <= $urandom_range(0, 16'hFFFF);
      // Wait for PREADY
      while (~(psel_i & penable_i & pready_o)) @(posedge clk);
      psel_i    <= 1'b0;
      penable_i <= 1'b0;
      rand_addr_list[i] = paddr_i;
      @(posedge clk);
    end

    // Send 10 read transactions to the write addresses
    for (int i=0; i<10; i++) begin
      psel_i  <= 1'b1;      // ST_SETUP
      @(posedge clk);
      penable_i <= 1'b1;    // ST_ACCESS
      paddr_i   <= rand_addr_list[i];
      pwrite_i  <= 1'b0;    // READ
      //pwdata_i  <= $urandom_range(0, 16'hFFFF);
      // Wait for PREADY
      while (~(psel_i & penable_i & pready_o)) @(posedge clk);
      psel_i    <= 1'b0;
      penable_i <= 1'b0;
      @(posedge clk);
    end
    $finish();
  end
  
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1); 
      $dumpvars(0,APBSlave_tb.DUT); 
    end

endmodule

