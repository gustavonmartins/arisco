`default_nettype none

module alu(opcode, left, right, result);
    input [2:0] opcode;
    input [31:0] left;
    input [31:0] right;
    output reg [31:0] result;

    parameter ADD = 3'd0;
    parameter SUB = 3'd1;
    parameter AND = 3'd2;
    parameter OR = 3'd3;
    parameter XOR = 3'd4;

    always @(opcode, left, right)
    begin
        case (opcode)
            ADD : result <= left+right;
            SUB : result <= left-right;
            AND:result <=left&right;
            OR:result <= left|right;
            XOR:result <= left^right;
            default: result <= 32'h00000000;
        endcase
    end

endmodule