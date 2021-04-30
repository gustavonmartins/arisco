`default_nettype none

module multiple_instructions (
    clk, reset
);
    input clk, reset;
    reg [31:0] program_memory[31:0];
    
    program_counter ProgramCounter(.clk (clk), .pc_out (pc), .pc_in (pc_in), .reset (reset));
    
    single_instruction single_instr (.clk (clk), .instruction (instruction));

    wire [31:0] instruction;
    wire [31:0] pc, pc_in;

    assign pc_in=pc+1;
    assign instruction=program_memory[pc];
    
    


endmodule