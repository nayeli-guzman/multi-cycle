`timescale 1ns / 1ps

module fpu (
  input [31:0] a, b,
  input [3:0] ALUControl,
  output reg [31:0] Result
);

wire [31:0] fadd, fmul;

fadd_16 fa (
  .A(a),
  .B(b),
  .result(fadd)
);

fmul_16 fm (
  .A(a),
  .B(b),
  .result(fmul)
);

always @(*) begin
    casez (ALUControl)
        4'b1101: Result = fadd; // fadd
        4'b1100: Result = fmul; // fmull      
    endcase
end



endmodule