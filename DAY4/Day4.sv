//Design and verify a 8-bit ALU which supports the following encoded operations:

//Encoding	Operation	Comment
//3'b000	ADD	-
//3'b001	SUB	-
//3'b010	SLL	Vector a should left shift using bits 2:0 of vector b
//3'b011	LSR	Vector a should right shift using bits 2:0 of vector b
//3'b100	AND	-
//3'b101	OR	-
//3'b110	XOR	-
//3'b111	EQL	Output should be 1 when equal otherwise 0
//Interface Definition
//The module should have the following interface:

//input     logic [7:0]   a_i,  - First 8-bit input vector
//input     logic [7:0]   b_i,  - Second 8-bit input vector
//input     logic [2:0]   op_i, - Encoded operation

//output    logic [7:0]   alu_o - ALU output

// A simple ALU
module day4 (
  input     logic [7:0]   a_i,
  input     logic [7:0]   b_i,
  input     logic [2:0]   op_i,

  output    logic [7:0]   alu_o
);
  
  always @(*)
    begin
      case(op_i)
        3'b000 : alu_o = a_i + b_i;
        3'b001 : alu_o = a_i - b_i;
        3'b010 : alu_o = a_i[7:0] << b_i[2:0];
        3'b011 : alu_o = a_i[7:0] >> b_i[2:0];
        3'b100 : alu_o = a_i & b_i;
        3'b101 : alu_o = a_i | b_i;
        3'b110 : alu_o = a_i ~^ b_i;
        3'b111 : alu_o = (a_i == b_i) ? 1 : 0;
      endcase
    end

endmodule

