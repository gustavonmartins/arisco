`default_nettype none
module tb_alu ();

reg [2:0] opcode;
reg [31:0] left;
reg [31:0] right;
wire [31:0] result;

task enforce_result;
    input [2:0] opcode_;
    input [31:0] left_, right_, result_should;
     
    begin
      // demonstrates driving external Global Reg
      #1;
      left=left_;
      right=right_;
      opcode=opcode_;

      #1;
      if (result != result_should) $error("For opcode %d, expected result to be %d but got %d.", opcode,result_should,result);
    end
  endtask


alu mut (
    .opcode (opcode),
    .left (left),
    .right (right),
    .result (result)
);

initial
begin
    $dumpfile("alu_out.vcd");
    $dumpvars(0,mut);
    $monitor("%2t,opcode=%d,left=%d,right=%d,result=%d",$time,opcode,left,right,result);

    enforce_result(3'd0,32'h4,32'h3,32'h7);//ADD
    enforce_result(3'd1,32'h2,32'h1,32'h1);//SUB
    enforce_result(3'd2,32'hA,32'hA,32'hA);//AND
    enforce_result(3'd3,32'hB,32'h0,32'hB);//OR
    enforce_result(3'd4,32'b0011,32'b0101,32'b0110);//XOR
    #1;
    $display("Simulation finished");
    $finish;
end
endmodule