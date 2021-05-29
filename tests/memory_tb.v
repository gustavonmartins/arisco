`default_nettype none
`include "rtl/utilities.v"

`include "rtl/memory.v"

module memory_tb ();

  reg clk;
  reg [31:0] address, wr_data; 
  wire [31:0] read_data;
  reg wr_enable;
  reg [1:0] write_mode;



memory mut (
  .clk (clk),
  .address (address),
  .wr_data (wr_data),
  .read_data (read_data),
  .wr_enable (wr_enable),
  .write_length (write_mode)
);

initial begin
  clk=0;
end

always begin 
  #5;clk=~clk;
end

initial
begin
    $info("Memory test");
    $dumpfile("memory.vcd");
    $dumpvars(0,mut);
    #1; wr_enable=0; address=32'd 0; wr_data=32'h 89ABCDEF; write_mode=2'd 1;
    @(posedge clk) `assertCaseNotEqual(mut.read_data, 32'h 89ABCDEF, "Memory should not write");
 
    // Test: Write full word at once
    #1; wr_enable=1;address=32'd 5; wr_data=32'h 12345678; write_mode=2'd 2;
    @(negedge clk)
    `assertCaseNotEqual(mut.read_data, 32'h 12345678,"Clock down doesnt write");
    @(posedge clk) #1 `assertCaseEqual(mut.read_data, 32'h 12345678, "Write full word");
    @(posedge clk)
    // END TEST
    
    //Test: Write 4 bytes at once
    @(negedge clk); wr_enable=1;address=32'd 20; wr_data=32'h 12ABCDEF; write_mode=2'd 0; @(posedge clk);
    # 1; wr_enable=1;address=32'd 21; wr_data=32'h 34FBDEAD; write_mode=2'd 0;
    @(posedge clk);
    #1; wr_enable=1;address=32'd 22; wr_data=32'h 56EDFABD; write_mode=2'd 0;
    @(posedge clk);
    #1; wr_enable=1;address=32'd 23; wr_data=32'h 78ADEFAB; write_mode=2'd 0;
    @(posedge clk);
    #1; address=32'd 20;
    #1 `assertCaseEqual(mut.read_data, 32'h 12345678, "Write 4 bytes in a row");
    // END TEST

    //Test: Write 2 halfwords at once:
    @(negedge clk); wr_enable=1;address=32'd 37; wr_data=32'h 1234ABCD; write_mode=2'd 1; @(posedge clk);
    @(negedge clk); wr_enable=1;address=32'd 39; wr_data=32'h 5678EFDA; write_mode=2'd 1; @(posedge clk);
    @(negedge clk); address=32'd 37;
    @(posedge clk); `assertCaseEqual(mut.read_data, 32'h 12345678, "Write 2 halfworlds at once");
    //END TEST
    
    #1;
    $display("Simulation finished");
    $finish;
end
endmodule
