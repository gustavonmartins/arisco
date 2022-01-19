`default_nettype none
`include "rtl/utilities.v"


module single_instruction_tb ();

reg clk;
reg [31:0] instruction;

SingleInstruction mut (
    .clk (clk),
    .instruction (instruction)
);

initial begin
  clk=0;
end

always begin 
  #5;clk=~clk;
end

initial
begin
    $dumpfile("single_instruction_out.vcd");
    $dumpvars(0,mut);
    //$monitor("%2t,clk=%b,instruction=%h,x5=%d,wr_address=%d",$time,clk,instruction,mut.reg_mem.memory[5],mut.wr_address);

    //ADDI: Puts 12 on x5
    //imm[11:0] rs1 000 rd 0010011 I addi
    @(posedge clk) #1;
    instruction={12'd 12, 5'd 0, 3'b 000, 5'd 5, 7'b 0010011};
    @(negedge clk) #1;
    `assertCaseNotEqual(mut.reg_mem.memory[5], 32'd 12,"Register only updates on clock up");
    @(posedge clk) #1;
    `assertCaseEqual(mut.reg_mem.memory[5], 32'd 12,"Register 5 should contain 12");

    //ADDI: Puts 20 on x5
    //imm[11:0] rs1 000 rd 0010011 I addi
    instruction={12'd 20, 5'd 0, 3'b 000, 5'd 5, 7'b 0010011};
    @(posedge clk) #1;
    `assertCaseEqual(mut.reg_mem.memory[5], 32'd 20,"Register 5 should contain 20");

    #1;
    $display("Simulation finished");
    $finish;
end
endmodule
