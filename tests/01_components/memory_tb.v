`default_nettype none
`include "rtl/utilities.v"

module memory_tb ();

  reg clk;
  reg [31:0] address, wr_data; 
  wire [31:0] read_data;
  reg wr_enable;
  reg [2:0] write_mode;



Memory mut (
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
    $dumpfile("Memory.vcd");
    $dumpvars(0,mut);
    #1; wr_enable=0; address=32'd 0; wr_data=32'h 89ABCDEF; write_mode=3'd 1;
    @(posedge clk) `assertCaseNotEqual(mut.read_data, 32'h 89ABCDEF, "Memory should not write");
 
    // Test: Write full word at once
    #1; wr_enable=1;address=32'd 5; wr_data=32'h 12345678; write_mode=3'd 2;
    @(negedge clk)
    `assertCaseNotEqual(mut.read_data, 32'h 12345678,"Clock down doesnt write");
    @(posedge clk) #1 `assertCaseEqual(mut.read_data, 32'h 12345678, "Write full word");
    @(posedge clk)
    // END TEST
    
    //Test: Write 4 bytes at once. This is to implement SB instruction
    @(negedge clk); wr_enable=1;address=32'd 4; wr_data=32'h 12ABCDEF; write_mode=3'd 0; @(posedge clk); // Least significant byte: 0xEF
    # 1; wr_enable=1;address=32'd 5; wr_data=32'h 34FBDEAD; write_mode=3'd 0; // Least significant byte: 0xAD
    @(posedge clk);
    #1; wr_enable=1;address=32'd 6; wr_data=32'h 56EDFABD; write_mode=3'd 0; // Least significant byte: 0xBD
    @(posedge clk);
    #1; wr_enable=1;address=32'd 7; wr_data=32'h 78ADEFAB; write_mode=3'd 0; // Least significant byte: 0xAB
    @(posedge clk);
    #1; address=32'd 4;
    #1 `assertCaseEqual(mut.read_data, 32'h ABBDADEF, "Write 4 bytes in a row"); // Should be AB|BD|AD|EF, Not 0x12345678 because its NOT BIG ENDIAN. Risc V is little indian
    // END TEST

    //Test: Write 2 halfwords at once:
    @(negedge clk); wr_enable=1;address=32'd 36; wr_data=32'h 1234ABCD; write_mode=3'd 2; @(posedge clk); // Will be partially ovewritten
    @(negedge clk); wr_enable=1;address=32'd 36; wr_data=32'h 5678EFDA; write_mode=3'd 1; @(posedge clk); // Two Least significante byte: 0xEFDA
    @(negedge clk); address=32'd 36;
    @(posedge clk); `assertCaseEqual(mut.read_data, 32'h 1234EFDA, "Write 2 halfworlds at once");
    //END TEST
    
    #1;
    $display("Simulation finished");
    $finish;
end
endmodule
