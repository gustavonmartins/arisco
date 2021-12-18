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

    if (test_vcount >= 0 && test_vcount < 2 &&  mut.vSync !== 0 ) begin
            $display("%c[1;31m",27);
            $display("Vsync should be low for 2 cycles after reset is released");
            $display("%c[0m",27);
            $fatal();
    end else if (test_vcount>=2 && mut.vSync !== 1) begin
        $display("%c[1;31m",27);
            $display("Vsync should be high  most of the times");
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
    
    while (i<800*524*2) begin 
        @(posedge clk)
        i+=1;
        if (test_hcount == 799 && test_vcount != 524) begin
            test_hcount=0;
            test_vcount+=1;
        end else if (test_hcount != 799 && test_vcount != 524) begin 
            test_hcount+=1;
        end else if (test_hcount != 799 && test_vcount == 524) begin 
            test_hcount+=1;
        end else if (test_hcount == 799 && test_vcount == 524) begin 
            test_vcount=0;
            test_hcount=0;
        end 
    end

 

    $display("Simulation finished");
    $finish;
end

endmodule