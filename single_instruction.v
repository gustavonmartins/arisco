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

    
    
    assign wr_enable=1;
    
    
    register_memory reg_mem (
        .clk (clk),
        .rd_address_a (rd_address_a),
        .rd_address_b (rd_address_b),
        .wr_enable (wr_enable),
        .wr_address (wr_address),
        .wr_data (wr_data),
        .data_out_a (data_out_a),
        .data_out_b (data_out_b));

    //ALU
    alu ALU(.opcode (opcode),.left (left),.right (right),.result (result));

    //ALU -> ADDI
    wire [2:0] opcode;
    wire [31:0] left, right, result;
    wire [4:0] rd,rs1;
    wire [11:0] imm;
    assign opcode=3'd0;
    assign left = {20'b0,imm}; assign imm=instruction[31:20];
    assign right = data_out_b; assign rd_address_b=instruction[19:15];
    assign wr_address = instruction[11:7];
    assign wr_data = result;

    
    //imm[11:0] rs1 000 rd 0010011 I addi


endmodule