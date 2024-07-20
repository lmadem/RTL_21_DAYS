//Design a 2:1 mux using the following language constructs: | Construct | |----------| |Ternary Operator| |Case statement| |If else block| |Combinatorial For loop| |And-or tree|

//Interface Definition

//The module should have the following interface:

//input     wire[3:0] a_i,
//input     wire[3:0] sel_i,

// Output using ternary operator
//output    wire     y_ter_o,
// Output using case
//output    logic     y_case_o,
// Ouput using if-else
//output    logic     y_ifelse_o,
// Output using for loop
//output    logic     y_loop_o,
// Output using and-or tree
//output    logic     y_aor_o

// Various ways to implement a mux
module day13 (
  input     wire[3:0] a_i,
  input     wire[3:0] sel_i,

  // Output using ternary operator
  output    wire     y_ter_o,
  // Output using case
  output    logic     y_case_o,
  // Ouput using if-else
  output    logic     y_ifelse_o,
  // Output using for loop
  output    logic     y_loop_o,
  // Output using and-or tree
  output    logic     y_aor_o
);

  assign y_ter_o = sel_i[0] ? a_i[0] : 
                   sel_i[1] ? a_i[1] : 
                   sel_i[2] ? a_i[2] :
                   a_i[3];
  
  always @(*)
    begin
      case(sel_i)
        4'b0001 : y_case_o = a_i[0];
        4'b0010 : y_case_o = a_i[1];
        4'b0100 : y_case_o = a_i[2];
        4'b1000 : y_case_o = a_i[3];
        default : y_case_o = 1'bx;
      endcase
    end
  
  always @(*)
    begin
      if(sel_i[0])
        y_ifelse_o = sel_i[0];
      else if(sel_i[1])
        y_ifelse_o = sel_i[1];
      else if(sel_i[2])
        y_ifelse_o = sel_i[2];
      else if(sel_i[3])
        y_ifelse_o = sel_i[3];
      else
        y_ifelse_o = 1'bx;
    end
  
  always @(*)
    begin
      y_loop_o = 0;
      for(int i = 0; i<4; i++)
        begin
          y_loop_o = (sel_i[i] & a_i[i]) | y_loop_o;
        end
    end
  
  assign y_aor_o = (sel_i[3] & a_i[3]) |
    (sel_i[2] & a_i[2]) |
    (sel_i[1] & a_i[1]) |
    (sel_i[0] & a_i[0]);
  
endmodule

