`default_nettype none
`include "utilities.v"
module assembly_instructions_tb ();

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
    $dumpfile("assembly_instructions.vcd");
    $dumpvars(0,mut);
    //$monitor("%2t,reset=%b,clk=%b,pc=%d,current instruction=%h, x31=%d",$time,reset,clk,mut.pc,mut.instruction,mut.single_instr.reg_mem.memory[31]);

    $info("Testing from assembly file. x31 is probed for pass, must always be zero!!!s");
    $readmemh("arquivo.mem", mut.program_memory,0,31);

    reset=1;#20;

    @(negedge clk) #1; reset=0;
    
    for (i=0; i < 32;i=i+1) begin
	    $display("PC is ", mut.pc);
	    @(posedge clk) #1; `assertCaseEqual(mut.single_instr.reg_mem.memory[31],32'd 0, "x31 register has to be zero");
    end
    #1;
    $display("Simulation finished");
    $finish;
end
endmodule
