`default_nettype none
`include "utilities.v"
module branch_instructions_tb ();

reg clk;
reg reset;

multiple_instructions mut (
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
    $info("Testing branch instructios");
    $dumpfile("branch_instructions_out.vcd");
    $dumpvars(0,mut);

    //J-Type instructions
    //Puts a special value on register 5, but only if jump succeeded
    reset=1;#1;
    mut.program_memory[0]={12'd 100, 5'd 0, 3'b 000, 5'd 5, 7'b 0010011}; 	//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[1]={20'd 12, 5'd 1, 7'b 1101111}; 			//imm[20|10:1|11|19:12] rd 1101111 J jal
    mut.program_memory[2]={12'd 200, 5'd 0, 3'b 000, 5'd 5, 7'b 0010011}; 	//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[3]={12'd 201, 5'd 0, 3'b 000, 5'd 5, 7'b 0010011}; 	//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[4]={12'd 203, 5'd 0, 3'b 000, 5'd 5, 7'b 0010011}; 	//imm[11:0] rs1 000 rd 0010011 I addi
    mut.program_memory[5]={20'b 11111111111111110100, 5'd 2, 7'b 1101111}; 	//imm[20|10:1|11|19:12] rd 1101111 J jal
    @(negedge clk) #1; reset=0;
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd 100,"ADDI: Register 5 should contain 100");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[1], 32'd 8, "JAL: Saves current PC+4 on reg 1");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd 203,"JAL: Register 5 should contain 203 after jumping 3 positions (12 bytes)");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[2], 32'd 24, "JAL: Saves current PC+4 on reg 2");
    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[5], 32'd 200,"JAL: Register 5 should contain 200 after jumping back 3 positions (12 bytes)");


    #20;
    $display("Simulation finished");
    $finish;
end
endmodule
