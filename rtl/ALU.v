`default_nettype none
`include "rtl/parameters.vh" 

module ALU(opcode, left, right, result);
    input [ALU_OP_LENGTH-1:0] opcode;
    input [31:0] left;
    input [31:0] right;
    output reg [31:0] result;

    always @(opcode, left, right)
    begin
        /***
        Warning: The ALU functions are being used by B insutrctions.
        Because R/I instructions has all combinations of edge cases of ALU ops, B instructions has less extreme edge cases.
        In case you take you stop using this ALU for B instructions, more tests are needed on B side, otherwise 
        it might brake silently
        **/
        case (opcode)
            ALU_OP_ADD  : result    = left              +   right;
            ALU_OP_AND  : result    = left              &   right;
            ALU_OP_OR   : result    = left              |   right;
            ALU_OP_SUB  : result    = left              -   right;
            ALU_OP_XOR  : result    = left              ^   right;
            ALU_OP_SLL  : result    = left              <<  right;
            ALU_OP_SLT  : result    = $signed(left)     <   $signed(right); 
            ALU_OP_SLTU : result    = $unsigned(left)   <   $unsigned(right); 
            ALU_OP_SRL  : result    = left              >>  right;
            ALU_OP_SRA  : result    = $signed(left)     >>> right;

            //For B instructions
            ALU_OP_EQ   : result    = left === right; //Actually this could be a SUB.

	    default: result     = 32'h00000000;
        endcase
    end

endmodule
