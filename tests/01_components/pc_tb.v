`default_nettype none
`include "rtl/utilities.v"
module program_counter_tb ();

reg sim_clk;
reg [31:0] i_pc;
reg i_reset;
wire [31:0] o_pc;




ProgramCounter mut (
    .i_clk (sim_clk),
    .i_reset (i_reset),
    .i_pc (i_pc),
    .o_pc (o_pc)
);



initial
begin
    $info("PC unit tests");
    $dumpfile("ProgramCounter.vcd");
    $dumpvars(0,mut);
    //$monitor("%2t,sim_clk=%d,i_reset=%b,i_pc=%h,o_pc=%h",$time,sim_clk,i_reset,i_pc,o_pc);

    //Program counter is zero as long as i_reset is pressed
    i_reset=0;sim_clk=0;i_pc=32'd4;
    #1;i_reset=1;#1;
    `assertCaseEqual(o_pc,0,"k Programm counter should be zero while i_reset is pressed");
    #1;sim_clk=1;#1;sim_clk=0;#1;
    `assertCaseEqual(o_pc,0,"i Program counter should be zero while i_reset is pressed");
    #1;sim_clk=1;#1;sim_clk=0;#1;

    //Program counter updates on clock down
    #1;i_reset=0;sim_clk=0;i_pc=32'd4;#1;
    `assertCaseEqual(o_pc,32'd0,"a Program counter should not update ouside clock down");
    #1;sim_clk=1;#1;
    `assertCaseEqual(o_pc,32'd0,"b Program counter should not update ouside clock down");
    #1;sim_clk=0;#1;
    `assertCaseEqual(o_pc,32'd4,"c Program counter should update on clock down");

    #1;
    $display("Simulation finished");
    $finish;
end
endmodule
