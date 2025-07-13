`timescale 1ns / 1ps

module floatingmul_16 (
    input [15:0] A,
    input [15:0] B,
    output reg [15:0] result
);

    reg [21:0] manT;
    reg [10:0] manR;
    reg [4:0] expR;

    wire sign = A[15] ^ B[15];
    wire [4:0] expA = A[14:10], expB = B[14:10];
    wire [9:0] fracA = A[9:0], fracB = B[9:0];

    wire [10:0] manA = (expA != 0) ? {1'b1, fracA} : {1'b0, fracA};
    wire [10:0] manB = (expB != 0) ? {1'b1, fracB} : {1'b0, fracB};

    integer lz;

    always @(*) begin
        if (expA == 0 || expB == 0) begin
            result = 16'd0;
        end else begin
            manT = manA * manB;  // 11x11 = 22 bits
            expR = expA + expB - 15;

            if (manT[21]) begin
                manR = manT[20:10];
                if (manT[9]) manR = manR + 1;
                expR = expR + 1;
            end else begin
                lz = 0;
                while (manT[21 - lz] == 0 && lz < 11) lz = lz + 1;
                manT = manT << lz;
                expR = expR - lz;
                manR = manT[20:10];
            end

            if (expR >= 31) begin
                result = {sign, 5'b11111, 10'b0}; // Inf
            end else if (expR <= 0) begin
                result = 16'b0; // Underflow
            end else begin
                result = {sign, expR, manR[9:0]};
            end
        end
    end
endmodule