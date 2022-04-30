`default_nettype none
`include "rtl/parameters.vh" 

module ALU(opcode, left, right, result);
    input [ALU_LENGTH-1:0] opcode;
    input [31:0] left;
    input [31:0] right;
    output reg [31:0] result;

    always @(*)
    begin
        /***
        Warning: The ALU functions are being used by B insutrctions.
        Because R/I instructions has all combinations of edge cases of ALU ops, B instructions has less extreme edge cases.
        In case you take you stop using this ALU for B instructions, more tests are needed on B side, otherwise 
        it might brake silently
        **/
        case (opcode)
            ALU_ADD  : result    = left              +   right;
            ALU_AND  : result    = left              &   right;
            ALU_OR   : result    = left              |   right;
            ALU_SUB  : result    = left              -   right;
            ALU_XOR  : result    = left              ^   right;
            ALU_SLL  : result    = left              <<  right;
            ALU_SLT  : result    = {{31{1'b 0}},$signed(left)     <   $signed(right)}; 
            ALU_SLTU : result    = {{31{1'b 0}},$unsigned(left)   <   $unsigned(right)}; 
            ALU_SRL  : result    = left              >>  right;
            ALU_SRA  : result    = $signed(left)     >>> right;

            //For B instructions
            ALU_EQ   : result    = {{31{1'b 0}},left === right}; //Actually this could be a SUB.

	    default: result     = 32'h00000000;
        endcase
    end

endmodule
