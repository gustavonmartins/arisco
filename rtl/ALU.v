`default_nettype none
`include "rtl/parameters.vh" 

module ALU(opcode, left, right, result);
    input [2:0] opcode;
    input [31:0] left;
    input [31:0] right;
    output reg [31:0] result;

    always @(opcode, left, right)
    begin
        case (opcode)
            ALU_OP_ADD  : result    = left + right;
            ALU_OP_AND  : result    = left & right;
            ALU_OP_OR   : result    = left | right;
            ALU_OP_SUB  : result    = left - right;
            ALU_OP_XOR  : result    = left ^ right;
            ALU_OP_SLL  : result    = left << right;
	    default: result     = 32'h00000000;
        endcase
    end

endmodule