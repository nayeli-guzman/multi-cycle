`timescale 1ns / 1ps

module arm (
  clk,
  reset,
  MemWrite,
  Adr,
  WriteData,
  ReadData
);
  input wire clk;
  input wire reset;
  output wire MemWrite;
  output wire [31:0] Adr;
  output wire [31:0] WriteData;
  input wire [31:0] ReadData;
  wire [31:0] Instr;
  wire [3:0] ALUFlags;
  wire PCWrite;
  wire RegWrite;
  wire IRWrite;
  wire FPUWrite;
  wire AdrSrc;
  wire [1:0] RegSrc;
  wire [1:0] ALUSrcA;
  wire [1:0] ALUSrcB;
  wire [1:0] ImmSrc;
  wire [3:0] ALUControl;
  wire [1:0] ResultSrc;
  wire IsMul;
  wire isFP;
  
  controller c(
    .clk(clk),
    .reset(reset),
    .Instr(Instr[31:4]),
    .ALUFlags(ALUFlags),
    .PCWrite(PCWrite),
    .MemWrite(MemWrite),
    .RegWrite(RegWrite),
    .IRWrite(IRWrite),
    .FPUWrite(FPUWrite),
    .AdrSrc(AdrSrc),
    .RegSrc(RegSrc),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ResultSrc(ResultSrc),
    .ImmSrc(ImmSrc),
    .ALUControl(ALUControl),
    .IsMul(IsMul),
    .isFP(isFP)
  );
  datapath dp(
    .clk(clk),
    .reset(reset),
    .Adr(Adr),
    .WriteData(WriteData),
    .ReadData(ReadData),
    .Instr(Instr),
    .ALUFlags(ALUFlags),
    .PCWrite(PCWrite),
    .RegWrite(RegWrite),
    .IRWrite(IRWrite),
    .FPUWrite(FPUWrite),
    .AdrSrc(AdrSrc),
    .RegSrc(RegSrc),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ResultSrc(ResultSrc),
    .ImmSrc(ImmSrc),
    .ALUControl(ALUControl),
    .IsMul(IsMul),
    .isFP(isFP)
  );
endmodule