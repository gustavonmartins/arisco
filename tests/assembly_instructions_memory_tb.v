`default_nettype none
`include "rtl/utilities.v"
`include "rtl/multiple_instructions.v"

module assembly_instructions_memory_tb ();
//Tests memory behaviour. Is separated from rest because on the future 
//it might spend more than one cycle to coplete each instruction

localparam PROGRAM_MEMORY_SIZE=64;

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
    $dumpfile("assembly_instructions_memory.vcd");
    $dumpvars(0,mut);
    //$monitor("%2t,reset=%b,clk=%b,pc=%d,current instruction=%h, x31=%d",$time,reset,clk,mut.pc,mut.instruction,mut.single_instr.reg_mem.memory[31]);

    $info("Testing memory behaviour from assembly file. x31 is probed for pass, must always be zero!!!");
    $readmemh("arquivo_memory.mem", mut.program_memory,0,PROGRAM_MEMORY_SIZE-1);

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
