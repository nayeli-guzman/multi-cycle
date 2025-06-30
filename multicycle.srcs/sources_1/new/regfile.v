module regfile (
  clk,
  we3,
  ra1,
  ra2,
  a3,
  wd3,
  r15,
  rd1,
  rd2,
  a4,
  wd4,
  IsMul,
  Instr
);
  input wire clk;
  input wire we3;
  input wire [3:0] ra1;
  input wire [3:0] ra2;
  input wire [3:0] a3;
  input wire [3:0] a4;
  
  input wire [31:0] wd3;
  input wire [31:0] wd4;
  
  input wire [31:0] r15; // PC+8
  output reg [31:0] rd1;
  output reg [31:0] rd2;
  
  input wire IsMul;
  input wire [23:21] Instr;
  
  reg [31:0] rf [14:0]; 
  
  always @(posedge clk) begin
    if (we3) begin
      rf[a3] <= wd3;
      if(IsMul && (Instr[23:21]==3'b100 || Instr[23:21]==3'b110)) begin
          rf[a4] <= wd4;
       end
    end
      
    assign rd1 = (ra1 == 4'b1111 ? r15 : rf[ra1]);
    assign rd2 = (ra2 == 4'b1111 ? r15 : rf[ra2]);
  end
endmodule