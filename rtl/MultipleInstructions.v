`default_nettype none

`include "rtl/SingleInstruction.v"
`include "rtl/ProgramCounter.v"
`include "rtl/parameters.vh"

module MultipleInstructions (
    clk, reset
);

    //localparam PROGRAM_MEMORY_SIZE=64;

    input clk, reset;
    reg [31:0] program_memory[PROGRAM_MEMORY_SIZE_WORDS-1:0];
    
    ProgramCounter programCounter(.clk (clk), .pc_in (pc_in), .pc_out (pc), .reset (reset));
    
    SingleInstruction single_instr (.clk (clk), .instruction (instruction), .pcNext (pc_next), .aluResult(aluResult));

    PCNext pcNext(.in (pc),.instruction(instruction),.aluRes(aluResult), .pc_next (pc_next),.pcPlusJal(pcPlusJal),.pcPlusBOffset(pcPlusBOffset));

    PCSource pcSource(.pcPlusFour (pc_next), .pcPlusJal (pcPlusJal),.pcPlusBOffset(pcPlusBOffset),  .pcSourceControl (pcSourceControl), .pcResult (pc_in));

    PCControl pcControl(.opcode (opcode), .instruction(instruction),.aluResult(aluResult), .pcSourceControl (pcSourceControl));

    wire [31:0] instruction;
    wire [31:0] pc, pc_in;
    wire [31:0] pc_next;
    wire [31:0] pcPlusJal;
    wire [31:0] pcPlusBOffset;
    wire [31:0] aluResult;

    assign instruction=program_memory[(pc>>2)];
    
    wire [6:0] opcode = instruction[6:0];

    wire [PC_SOURCE_LENGHT-1:0] pcSourceControl;

endmodule

module PCControl(opcode, instruction, aluResult,pcSourceControl);
	input wire [6:0] opcode;
    input wire [31:0] instruction;
    input wire [31:0] aluResult;
	output reg [PC_SOURCE_LENGHT-1:0] pcSourceControl;

    wire [2:0] funct3=instruction[14:12];
	//assign pcSourceControl=(opcode === 7'b 1101111)? PC_SOURCE_JAL: PC_SOURCE_PC_PLUS_FOUR;
    always @(*) begin
        casez ({opcode,funct3,aluResult[0]})
            11'b 1101111_???_?           :   pcSourceControl = PC_SOURCE_JAL;
            11'b 1100011_000_1      :   pcSourceControl    =   PC_SOURCE_B_OFFSET; //BEQ
            11'b 1100011_001_0      :   pcSourceControl    =   PC_SOURCE_B_OFFSET; //BNE
            11'b 1100011_100_1      :   pcSourceControl    =   PC_SOURCE_B_OFFSET; //BLT
            11'b 1100011_101_0      :   pcSourceControl    =   PC_SOURCE_B_OFFSET; //BGE
            default  :   pcSourceControl=PC_SOURCE_PC_PLUS_FOUR;

        endcase
    end
endmodule

module PCNext(in,instruction,aluRes, pc_next, pcPlusJal, pcPlusBOffset, debugB);
	input [31:0] in;
    input [31:0] instruction;
    input [31:0] aluRes;
	output [31:0] pc_next;
    output [31:0] pcPlusJal;
    output [31:0] pcPlusBOffset;
    output  [31:0] debugB;

	assign pc_next=in+4;
    assign pcPlusJal =      {{12{instruction[31]}},instruction[31:12]}+in;
    assign debugB={{20{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8],1'b 0}; // Mistakes here dont always break tests. Be careful!
    assign pcPlusBOffset=   debugB+pc_next;
    
endmodule

module PCSource (pcPlusFour, pcPlusJal,pcPlusBOffset, pcSourceControl, pcResult);
	input [31:0] pcPlusFour, pcPlusJal;
	input [PC_SOURCE_LENGHT-1:0] pcSourceControl;
    input [31:0] pcPlusBOffset;
	output reg [31:0] pcResult;
	
	//assign pcResult=(pcSourceControl === PC_SOURCE_PC_PLUS_FOUR)? pcPlusFour : (pcSourceControl === PC_SOURCE_JAL? pcPlusJal : pcPlusBOffset);
    always @(*) begin
        casez (pcSourceControl)
            PC_SOURCE_PC_PLUS_FOUR  :   pcResult=pcPlusFour;
            PC_SOURCE_JAL           :   pcResult = pcPlusJal;
            PC_SOURCE_B_OFFSET      :   pcResult    =   pcPlusBOffset;

        endcase
    end

endmodule

