`default_nettype none

module single_instruction (
    clk,
    instruction
);
    input clk;
    input wire [31:0] instruction;
    
    wire wr_enable;
    wire [4:0] rd_address_a,rd_address_b,wr_address;
    wire [31:0] wr_data,data_out_a,data_out_b;

    
    assign wr_address=instruction[11:7];
    assign wr_enable=1;
    assign wr_data=instruction[31:20];
    
    
    register_memory reg_mem (
        .clk (clk),
        .rd_address_a (rd_address_a),
        .rd_address_b (rd_address_b),
        .wr_enable (wr_enable),
        .wr_address (wr_address),
        .wr_data (wr_data),
        .data_out_a (data_out_a),
        .data_out_b (data_out_b));


endmodule