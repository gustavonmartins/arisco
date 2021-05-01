`default_nettype none

module single_instruction (clk, instruction);
    input clk;
    input wire [31:0] instruction;
    
    wire wr_enable;
    wire [4:0] rd_address_a,rd_address_b,wr_address;
    wire [31:0] wr_data,data_out_a,data_out_b;

    assign wr_enable=1;
    
    register_memory reg_mem (
        .clk (clk),
        .rd_address_a (rd_address_a), .rd_address_b (rd_address_b),
        .wr_enable (wr_enable), .wr_address (wr_address), .wr_data (wr_data), .data_out_a (data_out_a), .data_out_b (data_out_b));

    //ALU
    alu ALU(.opcode (alu_opcode),.left (left),.right (right),.result (result));

    // All instructions:
    wire [6:0] opcode=instruction[6:0];

    // Most of the instructions:
    wire [4:0] rd,rs1, rs2;
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    wire [2:0] funct3=instruction[14:12];

    // ALU -> General
    wire [2:0] alu_opcode;
    wire [31:0]  left, right, result;

    //ALU -> Type I Instructions
    wire [11:0] imm=instruction[31:20];
    wire [31:0] left_i;
    assign left_i= {20'b0,imm};
    assign right = data_out_b; assign rd_address_b=rs1;
    assign wr_address = rd;
    assign wr_data = result;

    //ALU Control
    assign alu_opcode=funct3;

    //ALU -> Type R Instructions
    wire [31:0] left_r;
    assign left_r=data_out_a; assign rd_address_a=rs2;

    // Register control
    assign left =   (opcode === 7'b 0010011)? left_i : 
                    ((opcode === 7'b 0110011)? left_r: 32'h 0);
  
endmodule