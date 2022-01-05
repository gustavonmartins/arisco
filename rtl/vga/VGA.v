`default_nettype none


module VGA
    #(parameter PIXELS_PER_LINE=800, parameter LINES_PER_FRAME=525)
    //762 gives the best error with 24Mhz clock 
    
    (input clk_25125KHz,output wire hSync, output wire vSync,
        output wire [$clog2(PIXELS_PER_LINE)-1:0] o_HPos,output wire [$clog2(LINES_PER_FRAME)-1:0] o_VPos,

        input wire [3:0] i_Red, input wire [3:0] i_Green, input wire [3:0] i_Blue,
        output wire [3:0] o_Red, output wire [3:0] o_Green, output wire [3:0] o_Blue
    );

    localparam PIXELS_PER_FRAME = LINES_PER_FRAME*PIXELS_PER_LINE;

    reg [$clog2(PIXELS_PER_LINE)-1:0] hcount;
    reg [$clog2(PIXELS_PER_FRAME)-1:0] framecount;

    //int hcount;
    initial begin
        hcount<=0;
        framecount<=0;
    end

    always @(posedge clk_25125KHz) begin
        
                    // Updates counts and only then gets sync. If you check sync before counter, you get wrong results!
                    hcount<=(hcount == PIXELS_PER_LINE-1)? 0 :hcount+1;
                    framecount<=(framecount == PIXELS_PER_FRAME-1)?0:framecount+1;

                    // Selects sync. Do not put this before updating counter!

                
    end
    assign hSync=(hcount > PIXELS_PER_LINE -96)? 0: 1;
    assign vSync=(framecount > PIXELS_PER_FRAME-PIXELS_PER_LINE*2)? 0: 1;

    assign {o_Red,o_Green,o_Blue}={i_Red,i_Green,i_Blue};

    assign o_HPos=hcount;
    assign o_VPos=framecount%LINES_PER_FRAME;
endmodule
