`default_nettype none
`include "utilities.v"
module register_memory_tb ();

reg sim_clk;
reg [4:0] rd_address_a;
reg [4:0] rd_address_b;
reg wr_enable;
reg [4:0] wr_address;
reg [31:0] wr_data;
wire [31:0] data_out_a;
wire [31:0] data_out_b;




register_memory mut (
    .clk (sim_clk),
    .rd_address_a (rd_address_a),
    .rd_address_b (rd_address_b),
    .wr_enable (wr_enable),
    .wr_address (wr_address),
    .wr_data (wr_data),
    .data_out_a (data_out_a),
    .data_out_b (data_out_b)
);



initial
begin
    $dumpfile("reg_memo_out.vcd");
    $dumpvars(0,mut);
    //$monitor("%2t,sim_clk=%d,wr_enable=%b,wr_address=%h,wr_data=%h,rd_address_a=%h,rd_address_b=%h,data_out_a=%h,data_out_b=%hs",$time,sim_clk,wr_enable,wr_address,wr_data,rd_address_a,rd_address_b,data_out_a,data_out_b);

    //Register 0 contains null
    sim_clk=0;
    #1;rd_address_a=5'd0;rd_address_b=5'd0;#1;
    `assertCaseEqual(data_out_a, 32'h00000000,"Register 0 should contain 0");
    `assertCaseEqual(data_out_b, 32'h00000000,"Register 0 should contain 0");

    //Register 0 is unwritable
    $info("Trying to write on register 0 is futile");
    #1;wr_enable=1;wr_address=5'h0; wr_data=32'hEEEEEEEE;rd_address_a=5'h0;rd_address_b=5'h0; 
    sim_clk=0; #1; sim_clk=1;
    #1;
    `assertCaseEqual(data_out_a,32'h0,"Should not write on reg 0");
    `assertCaseEqual(data_out_b,32'h0,"Should not write on reg 0");

    //Writes data on clock
    $info("Writes data on clock and reads it");
    #1;sim_clk=0;
    wr_enable=1; wr_address=5'hA; wr_data=32'hABCDEFAB; rd_address_a=5'hA;rd_address_b=5'hA;
    #1; sim_clk=1;#1;wr_enable=0;
    `assertCaseEqual(data_out_b,32'hABCDEFAB,"Didnt read memory immediately");
    `assertCaseEqual(data_out_a, 32'hABCDEFAB, "Didnt read memory immediately"); 
    
    
    #1;
    $display("Simulation finished");
    $finish;
end
endmodule