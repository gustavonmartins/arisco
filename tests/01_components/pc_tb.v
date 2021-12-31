`default_nettype none
`include "rtl/utilities.v"
`include "rtl/ProgramCounter.v"
module program_counter_tb ();

reg sim_clk;
reg [31:0] pc_in;
reg reset;
wire [31:0] pc_out;




ProgramCounter mut (
    .clk (sim_clk),
    .reset (reset),
    .pc_in (pc_in),
    .pc_out (pc_out)
);



initial
begin
    $info("PC unit tests");
    $dumpfile("ProgramCounter.vcd");
    $dumpvars(0,mut);
    //$monitor("%2t,sim_clk=%d,reset=%b,pc_in=%h,pc_out=%h",$time,sim_clk,reset,pc_in,pc_out);

    //Program counter is zero as long as reset is pressed
    reset=0;sim_clk=0;pc_in=32'd4;
    #1;reset=1;#1;
    `assertCaseEqual(pc_out,0,"k Programm counter should be zero while reset is pressed");
    #1;sim_clk=1;#1;sim_clk=0;#1;
    `assertCaseEqual(pc_out,0,"i Program counter should be zero while reset is pressed");
    #1;sim_clk=1;#1;sim_clk=0;#1;

    //Program counter updates on clock down
    #1;reset=0;sim_clk=0;pc_in=32'd4;#1;
    `assertCaseEqual(pc_out,32'd0,"a Program counter should not update ouside clock down");
    #1;sim_clk=1;#1;
    `assertCaseEqual(pc_out,32'd0,"b Program counter should not update ouside clock down");
    #1;sim_clk=0;#1;
    `assertCaseEqual(pc_out,32'd4,"c Program counter should update on clock down");

    #1;
    $display("Simulation finished");
    $finish;
end
endmodule
