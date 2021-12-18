`default_nettype none
`include "VGA.v"
module VGA_tb ();

VGA mut(.clk25175KHz(clk), .reset(reset));

reg clk;
reg reset;

initial begin
    clk=0;
    
end
always begin
    #5;clk=~clk;
end

always @(posedge clk) begin
     if (test_hcount >= 0 && test_hcount < 96 &&  mut.hSync !== 0 ) begin
            $display("%c[1;31m",27);
            $display("Hsync should be low for 96 cycles after reset is released");
            $display("%c[0m",27);
            $fatal();
    end else if (test_hcount>=96 && mut.hSync !== 1) begin
        $display("%c[1;31m",27);
            $display("Hsync should be high  most of the times");
            $display("%c[0m",27);
            $fatal();
    end
end

integer i;
integer test_hcount, test_vcount;

initial begin
    $dumpfile(`VCDFILEPATH);
    $dumpvars(0,mut,test_hcount,test_vcount);

    reset=1;
    @(posedge clk);@(posedge clk);@(posedge clk);@(posedge clk);@(posedge clk);#1;
    reset=0;

    @(posedge clk);
    i=0;
    test_hcount=0;test_vcount=0;
    
    while (i<2000) begin 
        @(posedge clk)
        i+=1;
        test_hcount=(test_hcount == 799)? 0 : test_hcount+1;
        test_vcount=(test_vcount % 524 === 0)? 0 : test_vcount+1;
    end

 

    $display("Simulation finished");
    $finish;
end

endmodule