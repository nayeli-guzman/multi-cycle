module datapath (
  clk,
  reset,
  Adr,
  WriteData,
  ReadData,
  Instr,
  ALUFlags,
  PCWrite,
  RegWrite,
  IRWrite,
  FPUWrite,
  AdrSrc,
  RegSrc,
  ALUSrcA,
  ALUSrcB,
  ResultSrc,
  ImmSrc,
  ALUControl,
  IsMul
);
  input wire clk;
  input wire reset;
  output wire [31:0] Adr;
  output wire [31:0] WriteData;
  input wire [31:0] ReadData;
  output wire [31:0] Instr;
  output wire [3:0] ALUFlags;
  input wire PCWrite;
  input wire RegWrite;
  input wire IRWrite;
  input wire FPUWrite;
  input wire AdrSrc;
  input wire [1:0] RegSrc;
  input wire [1:0] ALUSrcA;
  input wire [1:0] ALUSrcB;
  input wire [1:0] ResultSrc;
  input wire [1:0] ImmSrc;
  input wire [3:0] ALUControl;
  input wire IsMul;
  
  wire [31:0] PCNext;
  wire [31:0] PC;
  wire [31:0] ExtImm;
  wire [31:0] SrcA;
  wire [31:0] SrcB;
  wire [31:0] Result;
  wire [31:0] Data;
  wire [31:0] RD1;
  wire [31:0] RD2;
  wire [31:0] A;
  wire [31:0] ALUResult;
  wire [31:0] ALUMulti;
  
  wire [31:0] ALUOut;
  wire [3:0] RA1;
  wire [3:0] RA2;
  wire [3:0] A3;
  
  // ALTERNATIVOS EN CASO DE MUL
  wire [3:0] RA1_;
  wire [3:0] RA2_;
  
    // se agregaron 3 mux para llamar a los valores correctos en caso se auna multiplicacion Rd, Rn, y Rm 

  flopenr #(32) pcreg(
    .clk(clk),
    .reset(reset),
    .en(PCWrite),
    .d(PCNext),
    .q(PC)
  );

  mux2 #(32) adrmux(
    .d0(PC),
    .d1(PCNext),
    .s(AdrSrc),
    .y(Adr)
  );

  flopenr #(32) instrreg(
    .clk(clk),
    .reset(reset),
    .en(IRWrite),
    .d(ReadData),
    .q(Instr)
  );

  flopr #(32) datareg(
    .clk(clk),
    .reset(reset),
    .d(ReadData),
    .q(Data)
  );
  
  // AQUI

  mux2 #(4) ra1mux(
    .d0(Instr[19:16]),
    .d1(4'd15),
    .s(RegSrc[0]),
    .y(RA1_)
  );
  
  mux2 #(4) ra12mux(
    .d0(RA1_),
    .d1(Instr[3:0]),
    .s(IsMul),
    .y(RA1)
  );

  mux2 #(4) ra2mux(
    .d0(Instr[3:0]),
    .d1(Instr[15:12]),
    .s(RegSrc[1]),
    .y(RA2_)
  );
  
  mux2 #(4) ra22mux(
    .d0(RA2_),
    .d1(Instr[11:8]),
    .s(IsMul),
    .y(RA2)
  );
  
  mux2 #(4) ra3mux(
    .d0(Instr[15:12]),
    .d1(Instr[19:16]),
    .s(IsMul),
    .y(A3)
  );

  extend e(
    .Instr(Instr[23:0]),
    .ImmSrc(ImmSrc),
    .ExtImm(ExtImm)
  );

  regfile rf(
    .clk(clk),
    .we3(RegWrite),
    .ra1(RA1),
    .ra2(RA2),
    .a3(A3),
    .wd3(Result),
    .r15(Result),
    .rd1(RD1),
    .rd2(RD2),
    .a4(Instr[15:12]),
    .wd4(ALUMulti),
    .IsMul(IsMul),
    .Instr(Instr[23:21])
  );

  flopr #(64) rdreg(
    .clk(clk),
    .reset(reset),
    .d({RD1, RD2}),
    .q({A, WriteData})
  );

  mux2 #(32) srcamux(
    .d0(A),
    .d1(PC),
    .s(ALUSrcA[0]),
    .y(SrcA)
  );

  mux3 #(32) srcbmux(
    .d0(WriteData),
    .d1(ExtImm),
    .d2(32'd4),
    .s(ALUSrcB),
    .y(SrcB)
  );

  alu a(
    .a(SrcA),
    .b(SrcB),
    .ALUControl(ALUControl),
    .Result(ALUResult),
    .ALUFlags(ALUFlags),
    .ALUMulti(ALUMulti),
    .IsMul(IsMul)
  );

  flopr #(32) alureg(
    .clk(clk),
    .reset(reset),
    .d(ALUResult),
    .q(ALUOut)
  );

  mux3 #(32) resultmux(
    .d0(ALUOut),
    .d1(Data),
    .d2(ALUResult),
    .s(ResultSrc),
    .y(Result)
  );

  assign PCNext = Result;
endmodule