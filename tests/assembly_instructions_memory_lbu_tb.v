`default_nettype none
`include "rtl/utilities.v"
`include "rtl/multiple_instructions.v"

module assembly_instructions_memory_lbu_tb ();
//Tests memory behaviour. Is separated from rest because on the future 
//it might spend more than one cycle to coplete each instruction

localparam PROGRAM_MEMORY_SIZE=10;

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

integer i;

initial
begin
    $info("Testing memory behaviour for LBU from assembly file. x31 is probed for pass, must always be zero!!!");
    $dumpfile("assembly_instructions_memory_lbu.vcd");
    $dumpvars(0,mut);
    //$monitor("%2t,reset=%b,clk=%b,pc=%d,current instruction=%h, x1=%h, x10=%h,x11=%h, x31=%h",$time,reset,clk,mut.pc,mut.instruction,mut.single_instr.reg_mem.memory[1],mut.single_instr.reg_mem.memory[10],mut.single_instr.reg_mem.memory[11],mut.single_instr.reg_mem.memory[31]);

    $readmemh("arquivo_memory_lbu.mem", mut.program_memory,0,PROGRAM_MEMORY_SIZE-1);

    reset=1;#20;

    @(negedge clk) #1; reset=0;
    
    for (i=0; i < PROGRAM_MEMORY_SIZE;i=i+1) begin
	    $display("PC is %d, instruction: %h", mut.pc, mut.instruction);
	    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[31],32'd 0, {"x31 register has to be zero"});
    end
    #1;
    $display("Simulation finished");
    $finish;
end
endmodule
