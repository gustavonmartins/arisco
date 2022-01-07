`default_nettype none

`include "rtl/parameters.vh"

module SoC (
    clk, reset
);

    input clk, reset;


   

    CPU cpu(.clk(clk),.i_reset(reset),
        .o_bus_address(bus_address),.o_bus_wr_data(bus_wr_data),.i_bus_read_data(bus_read_data),.o_bus_write_length(bus_write_length),.o_bus_wr_enable(bus_wr_enable),
        .o_bus_rom_pc(rom_address),.i_instruction(instruction));


    wire [31:0] rom_address,rom_read_data;
    
    reg [31:0] program_memory[PROGRAM_MEMORY_SIZE_WORDS-1:0];
    wire [31:0] instruction=program_memory[rom_address>>2];


    // Main memory
    RAM mainMemory (.clk (clk), .address (bus_address), 
        .wr_data (bus_wr_data), .read_data (bus_read_data), 
        .wr_enable (bus_wr_enable), .write_length (bus_write_length));


    wire [31:0] bus_address;
    wire [31:0] bus_wr_data;
    wire [31:0] bus_read_data;
    wire bus_wr_enable;
    wire [2:0] bus_write_length;
    

  

endmodule
