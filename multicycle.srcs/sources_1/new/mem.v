module mem (
  input wire clk,
  input wire we,
  input wire [31:0] a,
  input wire [31:0] wd,
  output wire [31:0] rd
);
  reg [31:0] RAM [0:63];

  // Para simulación:
  // initial $readmemh("inputs.mem", RAM);

  // Para FPGA:
  initial begin
    RAM[0]  = 32'hE3A00080;
    RAM[1]  = 32'hE3A01000;
    RAM[2]  = 32'hE3A02042;
    RAM[3]  = 32'hE3822008;
    RAM[4]  = 32'hE3A0302E;
    RAM[5]  = 32'hE3833008;
    RAM[6]  = 32'hE2833066;
    RAM[7]  = 32'hE3A040B6;
    RAM[8]  = 32'hE3844008;
    RAM[9]  = 32'hE2844066;
    RAM[10] = 32'hE2835000;
    RAM[11] = 32'hE3500000;
    RAM[12] = 32'h0A00000B;
    RAM[13] = 32'hE1A06002;
    RAM[14] = 32'hE1066003;
    RAM[15] = 32'hE1A07001;
    RAM[16] = 32'hE1077004;
    RAM[17] = 32'hE1A08002;
    RAM[18] = 32'hE1088005;
    RAM[19] = 32'hE1E77008;
    RAM[20] = 32'hE1077003;
    RAM[21] = 32'hE1E11006;
    RAM[22] = 32'hE1E22007;
    RAM[23] = 32'hE2400001;
    RAM[24] = 32'hEAFFFFF1;
  end

  assign rd = RAM[a[31:2]];

  /*
  always @(posedge clk) begin
    if (we) begin
      RAM[a[31:2]] <= wd;
    end
  end
  */
endmodule
