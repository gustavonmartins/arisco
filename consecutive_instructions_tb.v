`default_nettype none
`include "utilities.v"
module consecutive_instructions_tb ();

reg clk;
reg reset;

multiple_instructions mut (
    .clk (clk), .reset (reset)
);

initial
begin
    $dumpfile("multiple_instructions_out.vcd");
    $dumpvars(0,mut);
    $monitor("%2t,reset=%b,clk=%b,pc=%d,current instruction=%h, x5=%d",$time,reset,clk,mut.pc,mut.instruction,mut.single_instr.reg_mem.memory[5]);

    //One ADDI instruction
    $display("One ADDI instruction");
    reset=1;#1;
    mut.program_memory[0]={12'd12, 5'd0, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    clk=0;#1;reset=0;
    clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd12,"Register 5 should contain 12");

    //Two ADDI instructions
    $display("Two ADDI instructions");
    reset=1;#1;
    mut.program_memory[0]={12'd120, 5'd0, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[1]={12'd200, 5'd0, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    clk=0;#1;reset=0;
    clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd120,"Register 5 should contain 120");
    clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd200,"Register 5 should contain 200");

    //Three ADDI instructions
    $display("Three ADDI instructions");
    reset=1;#1;
    mut.program_memory[0]={12'd120, 5'd0, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[1]={12'd200, 5'd0, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[2]={12'd2000, 5'd0, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    clk=0;#1;reset=0;
    clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd120,"Register 5 should contain 120");
    clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd200,"Register 5 should contain 200");
    clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd2000,"Register 5 should contain 2000");


    #1;
    $display("Simulation finished");
    $finish;
end
endmodule