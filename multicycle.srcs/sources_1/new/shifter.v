`timescale 1ns / 1ps
module shifter(
    rm,
    shamt,
    sh,
    shift
);

input[31:0] rm;
input[4:0] shamt;
input[1:0] sh;
output reg[31:0] shift;

always @(*) begin
    case(sh)
        2'b00: shift = rm << shamt;
        2'b01: shift = rm >> shamt;
        default: shift = 0;
    endcase
end

endmodule