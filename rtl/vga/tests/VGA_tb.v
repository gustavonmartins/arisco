`default_nettype none
`include "VGA.v"
module VGA_tb ();

    VGA mut(.clk25175KHz(clk), .reset(reset));

    reg clk;
    reg reset;

    reg [31:0] i;
    reg [9:0] test_hcount;
    reg [9:0] test_vcount;

    always begin
        #5;clk=~clk;
    end

    always @(posedge clk) begin
        //always@(posedge clk) hcount <= (reset==1 || hcount!=799) ? 0 : hcount+1; //This would be better than on initial
        if (reset===1) begin 
            test_hcount<=0;
            test_vcount<=0;
        end else if (test_hcount == 799 && test_vcount != 524) begin
            test_hcount<=0;
            test_vcount<=test_vcount+1;
        end else if (test_hcount != 799 && test_vcount != 524) begin 
            test_hcount<=test_hcount+1;
        end else if (test_hcount != 799 && test_vcount == 524) begin 
            test_hcount<=test_hcount+1;
        end else if (test_hcount == 799 && test_vcount == 524) begin 
            test_vcount<=0;
            test_hcount<=0;
        end 

        i<=i+1;

        if (i>800*524*2) begin 
            $display("Simulation finished");
            $finish;
        end
    end

    

    initial begin
        $dumpfile(`VCDFILEPATH);
        $dumpvars(0,mut,test_hcount,test_vcount);

        clk=0;

        i=0;
        test_hcount=0;test_vcount=0;

        reset=1;
        @(posedge clk);@(posedge clk);@(posedge clk);@(posedge clk);@(posedge clk);
        #1;
        reset=0;

    end

endmodule