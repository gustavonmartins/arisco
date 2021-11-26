`default_nettype none

`include "rtl/single_instruction.v"
`include "rtl/pc.v"
`include "rtl/parameters.vh"

module multiple_instructions (
    clk, reset
);

    //localparam PROGRAM_MEMORY_SIZE=64;

    input clk, reset;
    reg [31:0] program_memory[PROGRAM_MEMORY_SIZE-1:0];
    
    program_counter ProgramCounter(.clk (clk), .pc_out (pc), .pc_in (pc_in), .reset (reset));
    
    single_instruction single_instr (.clk (clk), .instruction (instruction), .pcNext (pc_next));

    PCNext pcNext(.in (pc), .out (pc_next));

    PCSource pcSource(.pcPlusFour (pc_next), .pcImmediate (pcImmediate), .pcResult (pc_in), .pcSourceControl (pcSourceControl));

    PCControl pcControl(.opcode (opcode), .pcSourceControl (pcSourceControl));

    wire [31:0] instruction;
    wire [31:0] pc, pc_in;

    assign instruction=program_memory[(pc>>2)];

    wire [31:0] pc_next;
    wire [31:0] pcImmediate = {jal_offset}+pc;
    wire [31:0] jal_offset = {{12{instruction[31]}},instruction[31:12]};

    wire [6:0] opcode = instruction[6:0];

    wire pcSourceControl;

endmodule

module PCControl(opcode, pcSourceControl);
	input wire [6:0] opcode;
	output wire pcSourceControl;
	assign pcSourceControl=(opcode === 7'b 1101111)? 1'b 1: 1'b 0;
endmodule

module PCNext(in, out);
	input [31:0] in;
	output [31:0] out;
	assign out=in+4;
endmodule

module PCSource (pcPlusFour, pcImmediate, pcSourceControl, pcResult);
	input [31:0] pcPlusFour, pcImmediate;
	input pcSourceControl;
	output [31:0] pcResult;
	
	assign pcResult=(pcSourceControl === 1'b 0)? pcPlusFour : pcImmediate;

endmodule
