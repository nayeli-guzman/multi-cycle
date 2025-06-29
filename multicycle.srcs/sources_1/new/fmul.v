`timescale 1ns / 1ps
module fmul (A, B, result);
    input [15:0] A;
    input [15:0] B;
    output reg [15:0] result;
    reg[21:0] temp_mantisa;

    reg[4:0] E;
    reg[10:0] m1,m2;
    reg[9:0] mantisa;

    parameter ONE = 15'h3C00;
    parameter MAX_ITERATIONS = 22;
    integer i;

    always @(*) begin
        
        if(A[14:10] == 0 || B[14:10] == 0)
            result = 16'd0;
        else if(A[14:0] == ONE) begin
            result = B;
            result[15] = A[15] ^ B[15]; //  Set sign
        end
        else if(B[14:0] == ONE) begin
            result = A;
            result[15] = A[15] ^ B[15]; //  Set sign
        end
        else  begin
            E = A[14:10] + B[14:10] - 5'b01111; //Calculate exponent
            m1 = {1'b1, A[9:0]};
            m2 = {1'b1, B[9:0]};
            temp_mantisa = (m1 * m2);

            //$display("E = %b, tempmantisa = %b", E,temp_mantisa);
            //continue until the first 1 is found

            if(temp_mantisa[21] == 0) begin
                // Bucle para normalizar la mantisa
                for (i = 0; i < MAX_ITERATIONS; i = i + 1) begin
                    if (temp_mantisa[21] == 0) begin
                        temp_mantisa = temp_mantisa << 1;
                    end 
                end
                mantisa = temp_mantisa[20:11];
            end
            else begin 
                mantisa = temp_mantisa[20:11];
                if(temp_mantisa[10] == 1) begin
                    mantisa = mantisa + 1;
                end
                E = E + 1;
            end


           //$display("mantisa = %b", mantisa);

            result[15] = A[15] ^ B[15]; //  Set sign
            result[14:10] = E;
            result[9:0] = mantisa;
        end
   end    
endmodule
