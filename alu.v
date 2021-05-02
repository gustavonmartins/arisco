`default_nettype none

module alu(opcode, left, right, result);
    input [2:0] opcode;
    input [31:0] left;
    input [31:0] right;
    output reg [31:0] result;

    localparam ADD = 3'd000;
    localparam AND = 3'b111;
    localparam OR = 3'b110;
    localparam SUB = 3'b100;

    always @(opcode, left, right)
    begin
        case (opcode)
            ADD : result <= left + right;
            AND : result <=left & right;
            OR  : result <= left | right;
            SUB : result <= left - right;
	    default: result <= 32'h00000000;
        endcase
    end

endmodule
