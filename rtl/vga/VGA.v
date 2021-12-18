`default_nettype none


module VGA(input clk25175KHz, input reset, 
    output [9:0] x, output [8:0] y,
    input redIn, input greenIn, input blueIn, 
    output redOut,output greenOut, output blueOut,
    output reg hSync, output vSync, output reg [9:0] hcount);

    //int hcount;
    initial begin
        hcount=0;
    end

    always @(posedge clk25175KHz) begin
        casez (reset)
            1'b 1 : begin hSync=0; hcount=0; end
            1'b 0 : begin hSync= (hcount < 96)? 0: 1;hcount=(hcount == 799)? 0 :hcount+1;end
        endcase
    end
endmodule