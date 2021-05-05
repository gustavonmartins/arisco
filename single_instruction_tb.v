`default_nettype none
`include "utilities.v"
module single_instruction_tb ();

reg clk;
reg [31:0] instruction;

single_instruction mut (
    .clk (clk),
    .instruction (instruction)
);

initial
begin
    $dumpfile("single_instruction_out.vcd");
    $dumpvars(0,mut);
    //$monitor("%2t,clk=%b,instruction=%h,x5=%d,wr_address=%d",$time,clk,instruction,mut.reg_mem.memory[5],mut.wr_address);

    //ADDI: Puts 12 on x5
    //imm[11:0] rs1 000 rd 0010011 I addi
    instruction={12'd12, 5'd0, 3'b000, 5'd5, 7'b0010011};
    `assertCaseNotEqual(mut.reg_mem.memory[5], 32'd12,"Register only updates on clock up");
    clk=1;#1;clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.reg_mem.memory[5], 32'd12,"Register 5 should contain 12");

    //ADDI: Puts 20 on x5
    //imm[11:0] rs1 000 rd 0010011 I addi
    instruction={12'd20, 5'd0, 3'b000, 5'd5, 7'b0010011};
    clk=1;#1;clk=0;#1;clk=1;#1;
    `assertCaseEqual(mut.reg_mem.memory[5], 32'd20,"Register 5 should contain 20");

    #1;
    $display("Simulation finished");
    $finish;
end
endmodule