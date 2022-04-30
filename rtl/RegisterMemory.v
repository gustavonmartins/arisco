`default_nettype none
`include "rtl/parameters.vh"

module RegisterMemory (
    clk,
    rd_address_a ,
    rd_address_b,
    wr_enable,
    wr_address,
    wr_data,
    data_out_a,
    data_out_b,
    write_pattern
);
    input clk;

    input [31:0] wr_data;
    input [4:0] wr_address;
    input wr_enable;
    output wire [31:0] data_out_a;
    output wire [31:0] data_out_b;
    input [4:0] rd_address_a;
    input [4:0] rd_address_b;
    input [2:0] write_pattern; // Used for LB/LBU instructions

    reg [31:0] memory[31:0];

    initial begin
        memory[0]<=32'h00000000;
    end

    always @(posedge clk) begin
        casez ({wr_enable,wr_address,write_pattern})
            {1'b 0, 5'd ?, 3'b ?}                           : memory[0]<=32'h00000000;
            {1'b ?, 5'd 0, 3'b ?}                           : memory[0]<=32'h00000000;
            {1'b 1, 5'd ?, REG_WRITE_BYTE_UNSIGNED}    : memory[wr_address]<={24'h 000000,wr_data[7:0]};
            {1'b 1, 5'd ?, REG_WRITE_BYTE_SIGNED}      : memory[wr_address]<={{24{wr_data[7]}},wr_data[7:0]};
            {1'b 1, 5'd ?, REG_WRITE_WORD}             : memory[wr_address]<=wr_data[31:0];
        endcase
        
    end

    assign data_out_a = memory[rd_address_a];
    assign data_out_b = memory[rd_address_b];

endmodule
