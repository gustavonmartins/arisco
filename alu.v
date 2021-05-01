`default_nettype none

module alu(opcode, left, right, result);
    input [2:0] opcode;
    input [31:0] left;
    input [31:0] right;
    output reg [31:0] result;

    parameter ADD = 3'd0;
    parameter AND = 3'b111;

    always @(opcode, left, right)
    begin
        case (opcode)
            ADD : result <= left+right;
            AND:result <=left&right;
            default: result <= 32'h00000000;
        endcase
    end

endmodule