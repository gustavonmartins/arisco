`default_nettype none
module memory (clk, address, wr_data, read_data, wr_enable, write_mode);
//Writes in memory. Can be byte, word or halfword, depending on mask given
    input wire clk;
    input [31:0] address;
    input [31:0] wr_data;
    input [1:0] write_mode;
    output wire [31:0] read_data;
    input wire wr_enable;

    reg [7:0] internal [2048-1:0];

    always @ (posedge clk) begin
        if (wr_enable===1'b 1) begin
            case (write_mode)
                1'd 0   :   internal[address] <= wr_data[31:24]; //write byte
                2'd 1   :   begin 
                                internal[address] <= wr_data[31:24];
                                internal[address+1] <= wr_data[23:16]; 
                            end //write half word
                2'd 2   :   begin 
                                internal[address] <= wr_data[31:24];
                                internal[address+1] <= wr_data[23:16];
                                internal[address+2] <= wr_data[15:8];
                                internal[address+3] <= wr_data[7:0];
                            end //write word

                default :   internal[address] <= 8'h 00;
            endcase
        end
    end

    assign read_data = {internal[address], internal[address+1], internal[address+2], internal[address+3]};
endmodule
