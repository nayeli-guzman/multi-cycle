module fadd_16 (
  input  [15:0] A,
  input  [15:0] B,
  output wire [15:0] result
);
  wire signA = A[15], signB = B[15];
  wire [4:0] expA = A[14:10], expB = B[14:10];
  wire [10:0] manA = (expA != 0) ? {1'b1, A[9:0]} : {1'b0, A[9:0]};
  wire [10:0] manB = (expB != 0) ? {1'b1, B[9:0]} : {1'b0, B[9:0]};

  wire [4:0] expDiff = (expA > expB) ? (expA - expB) : (expB - expA);
  wire [10:0] manA_shifted = (expA > expB) ? manA : (manA >> expDiff);
  wire [10:0] manB_shifted = (expB > expA) ? manB : (manB >> expDiff);
  wire [4:0] expAligned = (expA > expB) ? expA : expB;

  reg [11:0] mantissaSum;
  reg resultSign;

  always @(*) begin
    if (signA == signB) begin
      mantissaSum = manA_shifted + manB_shifted;
      resultSign = signA;
    end else begin
      if (manA_shifted > manB_shifted) begin
        mantissaSum = manA_shifted - manB_shifted;
        resultSign = signA;
      end else begin
        mantissaSum = manB_shifted - manA_shifted;
        resultSign = signB;
      end
    end
  end

  reg [4:0] finalExp;
  reg [10:0] finalMan;

  always @(*) begin
    finalExp = expAligned;
    if (mantissaSum[11]) begin
      finalMan = mantissaSum[11:1];  // Shift right (overflow)
      finalExp = finalExp + 1;
    end else begin
      finalMan = mantissaSum[10:0];
      while (finalMan[10] == 0 && finalExp > 1) begin
        finalMan = finalMan << 1;
        finalExp = finalExp - 1;
      end
    end
  end

  wire [9:0] finalFrac = finalMan[9:0];  // discard implicit bit
  assign result = (mantissaSum == 0) ? 16'b0 :
                  {resultSign, finalExp, finalFrac};

endmodule
