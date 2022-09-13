`default_nettype none
`include "rtl/parameters.vh"

module ROM 
//#(parameter PROGRAM_MEMORY_SIZE_WORDS = 6)
#(parameter MEMFILEPATH = "")
(input wire clk, 
    input wire [31:0] rom_address,
    input wire chipSelect,
    output reg [31:0] inst_buffer
);
    
    reg [32-1:0] program_memory[PROGRAM_MEMORY_SIZE_WORDS-1:0];

    initial begin
        if (MEMFILEPATH != "")
        $readmemh(MEMFILEPATH, program_memory,0,PROGRAM_MEMORY_SIZE_WORDS-1);
    end

    //reg [32-1:0] inst_buffer;

    always @(posedge clk) begin
        if (chipSelect) begin
            inst_buffer <= program_memory[rom_address>>2];
        end
    end

    //assign read_data=inst_buffer;

endmodule
