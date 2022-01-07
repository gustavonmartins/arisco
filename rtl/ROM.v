`default_nettype none
`include "rtl/parameters.vh"

module ROM 
#(parameter PROGRAM_MEMORY_SIZE_WORDS = 6)
(input wire clk, 
    input wire [31:0] address,
    output wire [31:0] read_data
);
    
    reg [32-1:0] internal [0:PROGRAM_MEMORY_SIZE_WORDS-1];

    initial begin
        internal[0]<=32'h 00000000;
    end

    reg [32-1:0] outbuffer;

    always @(negedge clk) begin
        outbuffer <= internal[address>>2];
    end

    assign read_data=outbuffer;

endmodule
