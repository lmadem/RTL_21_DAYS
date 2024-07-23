// Code your testbench here
// or browse Examples
module APBMaster_tb;
  logic clk;
  logic reset;
  logic [1:0] cmd_i, cmd_iNBA = 0;
  logic pready_i, pready_iNBA = 0;
  logic [31:0] prdata_i, prdata_iNBA = 0;
  logic psel_o;
  logic penable_o;
  logic [31:0] paddr_o;
  logic pwrite_o;
  logic [31:0] pwdata_o;

  
  APBMaster DUT(.clk(clk), .reset(reset), .cmd_i(cmd_iNBA), .pready_i(pready_iNBA), .prdata_i(prdata_iNBA), .psel_o(psel_o), .penable_o(penable_o), .paddr_o(paddr_o), .pwrite_o(pwrite_o), .pwdata_o(pwdata_o));
  
  
  always @* cmd_iNBA <= cmd_i;
  always @* pready_iNBA <= pready_i;
  always @* prdata_iNBA <= prdata_i;
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  task preset;
    pready_i = 0;
    prdata_i = 32'h0;
    cmd_i = 2'b00;
  endtask
  
  task rst;
    reset = 1;
    @(posedge clk);
    reset = 0;
  endtask
  
  task gen_pready;
    repeat(2) @(posedge clk);
    pready_i = 1;
  endtask

  task gen_stimulus;
    repeat(10)
      begin
        for(int i = 0; i<3; i++)
          begin
            cmd_i = i;
            prdata_i = $urandom_range(0,4'hF);
            @(posedge clk);
          end
      end
  endtask
 
  initial
    begin
      preset;
      rst;
      gen_pready;
      gen_stimulus;
      repeat(5) @(posedge clk);
      $finish;
    end
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars(1); 
      $dumpvars(0,APBMaster_tb.DUT); 
    end
endmodule
  
