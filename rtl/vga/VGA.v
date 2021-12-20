`default_nettype none


module VGA(input clk25175KHz, input reset, 
    output [9:0] x, output [8:0] y,
    input redIn, input greenIn, input blueIn, 
    output redOut,output greenOut, output blueOut,
    output reg hSync, output reg vSync, output reg [9:0] hcount,  output reg [9:0] vcount);

    //int hcount;
    initial begin
        hcount<=0;
        vcount<=0;
    end

    always @(posedge clk25175KHz) begin
        casez (reset)
            1'b 1 : begin 
                    hSync<=0; hcount<=0;
                    vSync<=0; vcount<=0; 
                end
            1'b 0 : begin 
                    // Updates counts and only then gets sync. If you check sync before counter, you get wrong results!
                    hcount=(hcount == 799)? 0 :hcount+1;
                    vcount=(hcount == 0)? ((vcount === 524)? 0 :vcount+1) : vcount;

                    // Selects sync. Do not put this before updating counter!
                    hSync<=(hcount < 96)? 0: 1;
                    vSync<=(vcount < 2)? 0: 1;
                end
        endcase
    end
endmodule
