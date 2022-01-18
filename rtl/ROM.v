`default_nettype none
`include "rtl/parameters.vh"

module ROM 
//#(parameter PROGRAM_MEMORY_SIZE_WORDS = 6)
(input wire clk, 
    input wire [31:0] rom_address,
    output reg [31:0] inst_buffer
);
    
    reg [32-1:0] program_memory[PROGRAM_MEMORY_SIZE_WORDS-1:0];

    `ifdef SYNTH
        initial begin
            program_memory[0]<=32'h 00000000;
        end
    `endif

    //reg [32-1:0] inst_buffer;

    always @(negedge clk) begin
        inst_buffer <= program_memory[rom_address>>2];
    end

    //assign read_data=inst_buffer;

endmodule
