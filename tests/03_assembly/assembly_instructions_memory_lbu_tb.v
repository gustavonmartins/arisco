`default_nettype none
`include "rtl/utilities.v"
`include "rtl/parameters.vh"

module assembly_instructions_memory_lbu_tb ();
//Tests memory behaviour. Is separated from rest because on the future 
//it might spend more than one cycle to coplete each instruction

//localparam PROGRAM_MEMORY_SIZE=100;
//
//x31 register: Checks if expected and as-is inputs are equal by checking if
//their difference is 0, via reg x31
//x1 register: The number of the current test in file (helpful for debugging)

reg clk;
reg reset;

SoC 
#(.SOC_MEMFILEPATH(`MEMFILEPATH))
mut (
    .clk (clk), .reset (reset)
);
initial begin
    clk=0;
end
always begin
    #5;clk=~clk;
end

integer i;
integer current_test=-1;
integer last_test=-1;

initial
begin
    $info("Testing memory behaviour from assembly file. x31 is probed for pass, must always be zero!!!");
    $dumpfile(`VCDFILEPATH);
    $dumpvars(0,mut);
    $monitor("test #%d, inst=%h, rom add=%d",mut.cpu.single_instr.reg_mem.memory[1],mut.cpu.instruction,mut.rom_address);


    reset=1;#20;

    @(negedge clk) #1; reset=0;
    i=0;
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    while (i < PROGRAM_MEMORY_SIZE_WORDS-1 && mut.rom.program_memory[i] != 32'h 00000013) begin // Stops on invalid instruction or end of memory
        //$display("State is %d, i is %d", mut.cpu.single_instr.controlUnit.state, i);
        #1; `assertCaseEqual(mut.cpu.instruction, mut.rom.program_memory[i], {"Instruction read doesnt match memory. Possible cause is control unit missing treating an instruction in its state or comb.logic from state"});
        
        @(negedge clk); // just read rom
        //$display("PC is %d, instruction: %h, state: %d", mut.cpu.pc, mut.cpu.instruction, mut.cpu.single_instr.controlUnit.state);
        @(negedge clk); // just read mem/reg
        @(negedge clk); // just wrote mem/reg and 
        /*
        current_test=mut.cpu.single_instr.reg_mem.memory[1];
        if(current_test!==last_test) begin
            last_test=current_test;
        $display("Running sub-test number: %d",current_test);
        end
        */
	    #1; `assertCaseEqual(mut.cpu.single_instr.reg_mem.memory[31],32'd 0, {"x31 register has to be zero"});

        i+=1;
    end
    #1;
    $display("Simulation finished");
    $finish;
end
endmodule
