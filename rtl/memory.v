`default_nettype none
`include "rtl/parameters.vh"

module Memory (clk, address, wr_data, read_data, wr_enable, write_length);
    input wire clk;
    input [31:0] address;
    input [31:0] wr_data;
    input [2:0] write_length; //This follows SB/SW/SH fields 12-14 convention
    output wire [31:0] read_data;
    input wire wr_enable;

    reg [7:0] internal [0:MEMORY_SIZE_BYTES-1];

    always @ (posedge clk) begin
        if (wr_enable===1'b 1) begin
            case (write_length)
                3'd 0   :   internal[address]       <= wr_data[7:0];  //Write byte
                3'd 1   :   begin                                       
                            // Write half word, following the goal of SH instruction (read ISA SPEC!). Little-indian
                                internal[address+1] <= wr_data[15:8]; 
                                internal[address+0] <= wr_data[7:0]; 
                            end
                3'd 2   :   begin                                       
                            // Write word 
                                internal[address+3] <= wr_data[31:24];
                                internal[address+2] <= wr_data[23:16];
                                internal[address+1] <= wr_data[15:8];
                                internal[address+0] <= wr_data[7:0];
                            end

                default :   internal[address]       <= 8'h 00;
            endcase
        end
    end

    assign read_data = {internal[address+3], internal[address+2], internal[address+1], internal[address+0]};
endmodule
