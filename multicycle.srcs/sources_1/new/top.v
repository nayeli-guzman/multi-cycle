`timescale 1ns / 1ps

module top (
  clk,
  reset,
  WriteData,
  Adr,
  MemWrite,
  RegMonitored
);
  input wire clk;
  input wire reset;
  output wire [31:0] WriteData;
  output wire [31:0] Adr;
  output wire MemWrite;
  output wire [31:0] RegMonitored;
  wire [31:0] ReadData;
  
  arm arm(
    .clk(clk),
    .reset(reset),
    .MemWrite(MemWrite),
    .Adr(Adr),
    .WriteData(WriteData),
    .ReadData(ReadData),
    .RegMonitored(RegMonitored)
  );
  
  mem mem(
    .clk(clk),
    .we(MemWrite),
    .a(Adr),
    .wd(WriteData),
    .rd(ReadData)
  );
  
endmodule
