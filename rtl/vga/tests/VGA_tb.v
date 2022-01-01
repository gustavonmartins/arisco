`default_nettype none

module VGA_tb ();

    VGA mut(.clk25175KHz(clk));

    reg clk;

    reg [31:0] i;
    reg [9:0] test_hcount;
    reg [18:0] test_framecount;

    always begin
        #5;clk=~clk;
    end

    always @(posedge clk) begin

        //Updates counters
        //always@(posedge clk) hcount <= (reset==1 || hcount!=799) ? 0 : hcount+1; //This would be better than on initial
        if (test_hcount == 800-1)
            test_hcount<=0;
        if (test_hcount < 800-1)
            test_hcount<=test_hcount+1;

        if (test_framecount == 800*525-1)
            test_framecount<=0;
        if (test_framecount < 800*525-1) 
            test_framecount <= test_framecount+1;
        else begin
            test_framecount <=0;
            test_hcount <= 0;
        end
        i<=i+1;

        if (i>800*525*2) begin 
            $display("Simulation finished");
            $finish;
        end
    end

    always @(posedge clk) begin
         // Specifies how signals should be
        if (test_hcount > 800-96 &&  mut.hSync !== 0 ) begin
            $display("%c[1;31m",27);
            $display("Hsync should be low for 96 lines");
            $display("%c[0m",27);
            $fatal();
        end

        if (test_framecount > 800*525-800*2 &&  mut.vSync !== 0 ) begin
                $display("%c[1;31m",27);
                $display("Vsync should be low for 2 lines ");
                $display("%c[0m",27);
                $fatal();
        end 
    end

    

    initial begin
        $dumpfile(`VCDFILEPATH);
        $dumpvars(0,clk,mut,test_hcount,test_framecount);

        clk=0;

        i<=0;
        test_hcount<=0;test_framecount<=0;
    end

endmodule
