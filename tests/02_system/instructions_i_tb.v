`default_nettype none
`include "rtl/utilities.v"

module instructions_i_tb ();


reg clk;
reg reset;

SoC mut (
    .clk (clk), .reset (reset)
);

initial begin
  clk=0;
end

always begin 
  #5;clk=~clk;
end

initial
begin
    $info("I-type instructions unit test");
    $dumpfile("instructions_i_out.vcd");
    $dumpvars(0,mut);
    //$monitor("%2t,reset=%b,clk=%b,pc=%d,current instruction=%h, x5=%d, x9=%d",$time,reset,clk,mut.cpu.pc,mut.cpu.instruction,mut.cpu.single_instr.reg_mem.memory[5],mut.cpu.single_instr.reg_mem.memory[9]);

    //Two ADDI instructions, both to same register
    //$info("ADDI instructions with no overflow");
    reset=1;
    mut.rom.program_memory[0]={12'd3, 5'd0, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    mut.rom.program_memory[1]={12'd4, 5'd5, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    @(negedge clk) #1;reset=0;
    @(posedge clk) #1;
    `assertCaseEqual(mut.cpu.single_instr.reg_mem.memory[5], 32'd 3,"Register 5 should contain 3");
    @(posedge clk)#1;
    `assertCaseEqual(mut.cpu.single_instr.reg_mem.memory[5], 32'd 7,"Register 5 should contain 7");

    //Two ADDI instructions, using different registers
    //$info("ADDI instructions with no overflow, using different registers");
    reset=1;#1;
    mut.rom.program_memory[0]={12'd3, 5'd0, 3'b000, 5'd5, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    mut.rom.program_memory[1]={12'd4, 5'd5, 3'b000, 5'd9, 7'b0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    @(negedge clk) #1;reset=0;
    @(posedge clk) #1;
    `assertCaseEqual(mut.cpu.single_instr.reg_mem.memory[5], 32'd 3,"Register 5 should contain 3");
    @(posedge clk) #1;
    `assertCaseEqual(mut.cpu.single_instr.reg_mem.memory[9], 32'd 7,"Register 5 should contain 7");



    #1;
    $display("Simulation finished");
    $finish;
end
endmodule
