`default_nettype none

module program_counter (
    clk,
    reset,
    pc_in,
    pc_out
);
    input clk;

    input reset;
    input [31:0] pc_in;
    output [31:0] pc_out;

    reg [31:0] memory;

    always @ (negedge clk or posedge reset) begin
            if (reset)
                memory<=0;
            else 
                memory<=pc_in;
    end

    assign pc_out = memory;

endmodule