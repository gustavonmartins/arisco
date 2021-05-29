`default_nettype none

module register_memory (
    clk,
    rd_address_a ,
    rd_address_b,
    wr_enable,
    wr_address,
    wr_data,
    data_out_a,
    data_out_b
);
    input clk;

    input [31:0] wr_data;
    input [4:0] wr_address;
    input wr_enable;
    output wire [31:0] data_out_a;
    output wire [31:0] data_out_b;
    input [4:0] rd_address_a;
    input [4:0] rd_address_b;

    reg [31:0] memory[31:0];

    initial begin
        memory[0]=32'h00000000;
    end

    always @(posedge clk)
    begin
        if (wr_enable & wr_address!=5'd0) begin
            memory[wr_address]<=wr_data;
        end
    end

    assign data_out_a = memory[rd_address_a];
    assign data_out_b = memory[rd_address_b];

endmodule