`default_nettype none
`include "rtl/utilities.v"


module single_instruction_tb ();

reg clk;
reg [31:0] instruction;
reg reset;
reg [$clog2(6)-1:0] state;

SingleInstruction mut (
    .clk (clk),
    .instruction (instruction),
    .reset (reset),
    .fsm_state(state)
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
    $monitor("%2t,clk=%b,instruction=%h,x5=%d,wr_address=%d,fs_state=%d",$time,clk,instruction,mut.reg_mem.memory[5],mut.wr_address,state);

    //ADDI: Puts 12 on x5
    //imm[11:0] rs1 000 rd 0010011 I addi
    reset=1;
    @(posedge clk) #5;
    instruction={12'd 12, 5'd 0, 3'b 000, 5'd 5, 7'b 0010011};
    
    

    `resetFSMAndReadInstruction; // Resets FSM and reads first instruction2

    `fullFSMInstructionCycle; // Just finished instruction
    `assertCaseEqual(mut.reg_mem.memory[5], 32'd 12,"Register 5 should contain 12");

    //ADDI: Puts 20 on x5
    //imm[11:0] rs1 000 rd 0010011 I addi
    instruction={12'd 20, 5'd 0, 3'b 000, 5'd 5, 7'b 0010011};
    
    `fullFSMInstructionCycle; // Just finished instruction
    `assertCaseEqual(mut.reg_mem.memory[5], 32'd 20,"Register 5 should contain 20");

    #1;
    $display("Simulation finished");
    $finish;
end
endmodule
