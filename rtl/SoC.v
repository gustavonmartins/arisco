`default_nettype none

`include "rtl/parameters.vh"
`include "rtl/CPU.v"

module SoC (
    clk, reset
);

    input clk, reset;
   

    CPU cpu(.clk(clk),.reset(reset),.bus_address(bus_address),.bus_wr_data(bus_wr_data),.bus_read_data(bus_read_data),.bus_write_length(bus_write_length),.bus_wr_enable(bus_wr_enable));

    // Main memory
    Memory mainMemory (.clk (clk), .address (bus_address), 
        .wr_data (bus_wr_data), .read_data (bus_read_data), 
        .wr_enable (bus_wr_enable), .write_length (bus_write_length));

    wire [31:0] bus_address;
    wire [31:0] bus_wr_data;
    wire [31:0] bus_read_data;
    wire bus_wr_enable;
    wire [2:0] bus_write_length;
    

  

endmodule
