`timescale 1ns / 1ps
    
module fmul_32 (
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] result
);
    reg[47:0] manT;
    reg[23:0] manR;
    reg[7:0] expR;
    
    wire signA = A[31], signB = B[31];
    wire [7:0] expA = A[30:23], expB = B[30:23];
    wire [22:0] fracA = A[22:0], fracB = B[22:0];
    
    wire [23:0] manA = (expA != 0) ? {1'b1, fracA} : {1'b0, fracA};
    wire [23:0] manB = (expB != 0) ? {1'b1, fracB} : {1'b0, fracB};
        
    parameter N = 45;
    integer i;
    
    always @(*) begin
        if (expA == 8'd0 || expB == 8'd0)
            result = 32'd0;
        else  begin
            // 1. Getting new exp
            expR = expA + expB - 127;
            // 2. Multiply mants
            manT = manA * manB;
            
            // 3. Normalize if it's necessary
            if(manT[47] == 0) begin
                for (i = 0; i < N; i = i + 1) begin
                    if (manT[47] == 0) begin
                        manT = manT << 1;
                    end 
                end
                manR = manT[46:24];
            end 
            else begin 
                manR = manT[46:24];
                if(manT[23] == 1) begin
                    manR = manR + 1;
                end
                expR = expR + 1;
            end
    
        result = {A[31] ^ B[31], expR, manR[22:0]};

        end
    end    
endmodule
