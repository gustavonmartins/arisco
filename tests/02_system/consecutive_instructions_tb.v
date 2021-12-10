`default_nettype none
`include "rtl/utilities.v"
`include "rtl/MultipleInstructions.v"

module consecutive_instructions_tb ();

reg clk;
reg reset;

MultipleInstructions mut (
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
    $info("Unit testing consecutive instructions");
    $dumpfile("multiple_instructions_out.vcd");
    $dumpvars(0,mut);
    //$monitor("%2t,reset=%b,clk=%b,pc=%d,current instruction=%h, x5=%d",$time,reset,clk,mut.pc,mut.instruction,mut.single_instr.reg_mem.memory[5]);

    //I-Type instructions
    //$info("Testing I-Type instructions");
    reset=1;#1;
    mut.program_memory[0]={12'd 120, 5'd 0, 3'b 000, 5'd 5, 7'b 0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[1]={12'd 200, 5'd 0, 3'b 000, 5'd 5, 7'b 0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[2]={12'd 2000, 5'd 5, 3'b 000, 5'd 5, 7'b 0010011};//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[3]={12'b 111111111111, 5'd 0, 3'b 111, 5'd5, 7'b 0010011};// imm[11:0] rs1 111 rd 0010011 I andi
    mut.program_memory[4]={12'b 1010,5'd 0,3'b 110,5'd 5,7'b 0010011}; // imm[11:0] rs1 110 rd 0010011 I ori
    @(negedge clk) #1; reset=0;
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd 120,"ADDI: Register 5 should contain 120");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd 200,"ADDI: Register 5 should contain 200");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd 2200,"ADDI: Register 5 should contain 2200");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'b 0,"ANDI: Register 5 should contain all zeroes");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'b 1010,"ORI: Register 5 should end with 1010");

    //R-Type instructions
    //$info("Testing R-Type instructions");
    reset=1;#1;
    mut.program_memory[0]={12'd 2, 5'd 0, 3'b 000, 5'd 29, 7'b 0010011}; //imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[1]={12'd 5, 5'd 0, 3'b 000, 5'd 31, 7'b 0010011}; //imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[2]={7'b 0, 5'd 29, 5'd 31, 3'b 000, 5'd 5, 7'b 0110011}; // 0000000 rs2 rs1 000 rd 0110011 R add
    mut.program_memory[3]={7'b 0100000, 5'd 29, 5'd 31, 3'b 000, 5'd 5, 7'b 0110011};// 0100000 rs2 rs1 000 rd 0110011 R sub
    mut.program_memory[4]={12'd 2047, 5'd 0, 3'b 000, 5'd 10, 7'b 0010011}; //imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[5]={12'd 2047, 5'd 0, 3'b 000, 5'd 11, 7'b 0010011}; //imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[6]={7'b 0100000, 5'd 10, 5'd 11, 3'b 000, 5'd 6, 7'b 0110011};// 0100000 rs2 rs1 000 rd 0110011 R sub
    
    @(negedge clk) #1; reset=0;
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[29], 32'd 2,"ADDI: Register 29 should contain 2");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[31], 32'd 5,"ADDI: Register 31 should contain 5");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd 7,"ADD: Register 5 should contain 7");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd 3,"SUB: Register 5 should contain 3 = 5-2 ($31 - $29)");
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[6], 32'd 0,"SUB: Register 6 should contain 0 = 2047 - 2 ($10 - $11)");

    #20;
    $display("Simulation finished");
    $finish;
end
endmodule
