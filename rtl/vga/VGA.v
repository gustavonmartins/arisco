`default_nettype none


module VGA(input clk25175KHz, 
   
    output wire hSync, output wire vSync);

    reg [9:0] hcount;
    reg [18:0] framecount;

    localparam PIXELS_PER_LINE=800;
    localparam LINES_PER_FRAME=525;
    localparam PIXELS_PER_FRAME = LINES_PER_FRAME*PIXELS_PER_LINE;

    //int hcount;
    initial begin
        hcount<=0;
        framecount<=0;
    end

    always @(posedge clk25175KHz) begin
        
                    // Updates counts and only then gets sync. If you check sync before counter, you get wrong results!
                    hcount<=(hcount == PIXELS_PER_LINE-1)? 0 :hcount+1;
                    framecount<=(framecount == PIXELS_PER_FRAME-1)?0:framecount+1;

                    // Selects sync. Do not put this before updating counter!
                   
                
    end
    assign hSync=(hcount > PIXELS_PER_LINE -96)? 0: 1;
    assign vSync=(framecount > PIXELS_PER_FRAME-PIXELS_PER_LINE*2)? 0: 1;
endmodule
