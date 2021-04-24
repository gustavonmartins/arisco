`default_nettype none
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
    $monitor("%2t,sim_clk=%d,wr_enable=%b,wr_address=%h,wr_data=%h,rd_address_a=%h,rd_address_b=%h,data_out_a=%h,data_out_b=%hs",$time,sim_clk,wr_enable,wr_address,wr_data,rd_address_a,rd_address_b,data_out_a,data_out_b);

    sim_clk=1;
    
    #1;rd_address_a=5'd0;rd_address_b=5'hA;#1;
    if (data_out_a != 32'h00000000) 
    begin 
        $error("Reading memory, expected result to be %h but got %h.", 32'h00000000,data_out_a); $finish;
    end

    if (data_out_b != 32'h00000000) 
        begin 
            $error("Reading memory, expected result to be %h but got %h.", 32'h00000000,data_out_b); $finish;
        end

    //Writes data on clock down
    $display("Writes data on clock down and reads it");
    #2;
    wr_address=5'hA; wr_enable=1; wr_data=32'hABCDEFAB;
    #1; sim_clk=0;#1;
    wr_enable=0;
    //rd_address_b=5'hA;
    $display("Should read immediately");
    #1;
    if (data_out_b != 32'hABCDEFAB) 
        begin 
            $error("Reading memory, expected result to be %h but got %h.", 32'hABCDEFAB,data_out_b); $finish;
        end
    
    $display("Both reads the same value");
    #1;rd_address_a=5'hA; #1;
    if (data_out_a != 32'hABCDEFAB) 
        begin 
            $error("Reading memory, expected result to be %h but got %h.", 32'hABCDEFAB,data_out_a); $finish;
        end
    
    $display("Trying to write on register 0 is futile");
    wr_address=5'h0; wr_data=32'hEEEEEEEE;  wr_enable=1;
    
    sim_clk=1;
    #1;
    sim_clk=0;
    #1;
    rd_address_a=5'h0;
    rd_address_b=5'h0;
    #1;
    if (data_out_a != 32'h00000000)
    begin 
        $error("Reading memory, expected result to be %h but got %h.", 32'h00000000,data_out_a); $finish;
    end
    if (data_out_b != 32'h00000000)
    begin 
        $error("Reading memory, expected result to be %h but got %h.", 32'h00000000,data_out_b); $finish;
    end

    $display("Simulation finished");
    $finish;
end
endmodule