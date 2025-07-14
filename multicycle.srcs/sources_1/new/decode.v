module decode (
  clk,
  reset,
  Op,
  Funct,
  Rd,
  FlagW,
  PCS,
  NextPC,
  RegW,
  MemW,
  IRWrite,
  AdrSrc,
  ResultSrc,
  ALUSrcA,
  ALUSrcB,
  ImmSrc,
  RegSrc,
  ALUControl,
  Instr,
  IsMul,
  NoWrite,
  isFP
);
  input wire clk;
  input wire reset;
  input wire [1:0] Op;
  input wire [5:0] Funct;
  input wire [3:0] Rd;
  input wire [31:4] Instr;
  // outputs
  output reg [1:0] FlagW;
  output wire PCS;
  output wire NextPC;
  output wire RegW;
  output wire MemW;
  output wire IRWrite;
  output wire AdrSrc;
  output wire [1:0] ResultSrc;
  output wire [1:0] ALUSrcA;
  output wire [1:0] ALUSrcB;
  output wire [1:0] ImmSrc;
  output wire [1:0] RegSrc;
  output reg [3:0] ALUControl;
  output wire IsMul;
  output reg isFP;
  
  wire Branch;
  wire ALUOp;
  output reg NoWrite;

  mainfsm fsm(
    .clk(clk),
    .reset(reset),
    .Op(Op),
    .Funct(Funct),
    .IRWrite(IRWrite),
    .AdrSrc(AdrSrc),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ResultSrc(ResultSrc),
    .NextPC(NextPC),
    .RegW(RegW),
    .MemW(MemW),
    .Branch(Branch),
    .ALUOp(ALUOp)
  );
  
  assign IsMul = Instr[7:4] == 4'b1001 ? 1:0;

  // op ALU
  always @(*) begin
    if (ALUOp) begin
      if (IsMul)
        case(Instr[23:21])
            3'b000: ALUControl = 4'b0101;
            3'b100: ALUControl = 4'b0110; // umul
            3'b110: ALUControl = 4'b0111; // smul
        endcase
      else
        case (Funct[4:1])
          4'b0100: ALUControl = 4'b0000; // +
          4'b0010: ALUControl = 4'b0001; // -
          4'b0000: ALUControl = 4'b0010; // &
          4'b1100: ALUControl = 4'b0011; // | LSL
          4'b1101: ALUControl = 4'b0100; // mov
          4'b1010: ALUControl = 4'b0001; // CMP
          4'b1111: ALUControl = 4'b1101; // Fadd
          4'b1000: ALUControl = 4'b1100; // Fmull
          4'b0110: ALUControl = 4'b1001; // div
          default: ALUControl = 4'bxxxx;
        endcase
        
      NoWrite = Funct[4:1] == 4'b1010;
      FlagW[1] = Funct[0];
      FlagW[0] = Funct[0] & (ALUControl == 4'b000?);
      isFP = ALUControl[3:2] == 2'b11; // es floating point
    end else begin
      ALUControl = 4'b0000;
      FlagW = 2'b00;
      isFP = 0;
    end
  end

  assign PCS = ((Rd == 4'b1111) & RegW) | Branch;

  assign ImmSrc = Op;
  
  assign RegSrc[1] = Op == 2'b01;
  assign RegSrc[0] = Op == 2'b10;
endmodule