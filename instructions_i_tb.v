`default_nettype none
`include "utilities.v"
module instructions_i ();

reg clk;
reg reset;

multiple_instructions mut (
    .clk (clk), .reset (reset)
);

initial
begin
    $dumpfile("instructions_i_out.vcd");
    $dumpvars(0,mut);
    $monitor("%2t,reset=%b,clk=%b,pc=%d,current instruction=%h, x5=%d, x9=%d",$time,reset,clk,mut.pc,mut.instruction,mut.single_instr.reg_mem.memory[5],mut.single_instr.reg_mem.memory[9]);

    //Two ADDI instructions, both to same register
    $display("ADDI instructions with no overflow");
    reset=1;#1;
    mut.program_memory[0]={12'd3, 5'd0, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[1]={12'd4, 5'd5, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    clk=0;#1;reset=0;
    clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd3,"Register 5 should contain 3");
    clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd7,"Register 5 should contain 7");

    //Two ADDI instructions, using different registers
    $display("ADDI instructions with no overflow, using different registers");
    reset=1;#1;
    mut.program_memory[0]={12'd3, 5'd0, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[1]={12'd4, 5'd5, 3'b000, 5'd9, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    clk=0;#1;reset=0;
    clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd3,"Register 5 should contain 3");
    clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.single_instr.reg_mem.memory[9], 32'd7,"Register 5 should contain 7");



    #1;
    $display("Simulation finished");
    $finish;
end
endmodule