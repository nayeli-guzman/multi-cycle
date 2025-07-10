`timescale 1ns / 1ps

module alu (
  input [31:0] a, b,
  input [2:0] ALUControl,
  output reg [31:0] Result,
  output wire [3:0] ALUFlags,
  output reg [31:0] ALUMulti,
  input wire IsMul
);

wire neg, zero, carry, overflow;
wire [31:0] condinvb;
wire [32:0] sum; 

assign condinvb = ALUControl[0] ? ~b : b; 
assign sum = a + condinvb + ALUControl[0];
reg[63:0] multiplication;
reg carr;

always @(*) begin
  casex (ALUControl)
    3'b00?: Result = sum;
    3'b010: Result = a & b;
    3'b011: Result = a | b;
    3'b100: Result = a << b;
    3'b101: Result = a * b;
    3'b110: begin  // UMUL
        multiplication = $unsigned(a) * $unsigned(b);
        ALUMulti = multiplication[31:0];
        Result = multiplication[63:32];
        carr = |Result;
      end
      3'b111: begin  // SMUL
        multiplication = $signed(a) * $signed(b);
        ALUMulti = multiplication[31:0];
        Result = multiplication[63:32];
        carr = (multiplication[63:32] != {32{multiplication[31]}}); 
      end

     
  endcase
end

assign neg = Result[31];
assign zero = IsMul? (Result==32'b0 && ALUMulti==32'b0) : (Result == 32'b0);
assign carry = IsMul? (carr): ((ALUControl[1] == 1'b0) & sum[32]);
assign overflow = IsMul ? ((a[31] == b[31]) && (Result[31] != a[31]))
                :
                (ALUControl[1] == 1'b0) & ~(a[31] ^ b[31] ^ ALUControl[0]) & (a[31] ^ sum[31]);
assign ALUFlags = {neg, zero, carry, overflow};

endmodule