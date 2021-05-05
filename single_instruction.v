`default_nettype none

module single_instruction (clk, instruction);
    input clk;
    input wire [31:0] instruction;
    
    // Control Unit
    ControlUnit controlUnit(.instruction(instruction), .register_write_enable(registerWriteEnable), .aluOperationCode(alu_opcode), .aluRightInputSourceControl (aluRightInputSourceControl));

    // Register memory
    wire registerWriteEnable;
    wire [4:0] rd_address_a,rd_address_b,wr_address;
    wire [31:0] wr_data,data_out_a,data_out_b;
    register_memory reg_mem (
        .clk (clk),
        .rd_address_a (rd_address_a), .rd_address_b (rd_address_b),
        .wr_enable (registerWriteEnable), .wr_address (wr_address), .wr_data (wr_data), .data_out_a (data_out_a), .data_out_b (data_out_b));

    //ALU
    alu ALU(.opcode (alu_opcode),.left (aluLeftInput),.right (aluRightInput),.result (aluResult));

    //ALU multiplexer
    ALURightInputSource aluRightInputSource(.sourceSelection(aluRightInputSourceControl), 
    .registerSource(aluRightSourceRegister),
    .immediateSource(aluRightSourceImmediate), 
    .resultValue (aluRightInput));

    // All instructions:
    wire [6:0] opcode=instruction[6:0];

    // Most of the instructions:
    wire [4:0] rd,rs1, rs2;
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];

    // ALU -> General
    wire [2:0] alu_opcode;
    wire [31:0]  aluLeftInput,aluRightInput, aluResult;

    //ALU -> Type I Instructions
    wire [11:0] imm=instruction[31:20];
    wire [31:0] aluRightSourceImmediate;
    assign aluRightSourceImmediate= {20'b0,imm};
    assign aluLeftInput = data_out_b; assign rd_address_b=rs1;
    assign wr_address = rd;
    assign wr_data = aluResult;

    //ALU -> Type R Instructions
    wire [31:0] aluRightSourceRegister;
    assign aluRightSourceRegister=data_out_a; assign rd_address_a=rs2;

    wire aluRightInputSourceControl;

endmodule


module ControlUnit(instruction, register_write_enable, aluOperationCode, aluRightInputSourceControl);
    input [31:0] instruction;
    output wire register_write_enable;
    output wire [2:0] aluOperationCode;
    output wire aluRightInputSourceControl;
    wire [6:0] opcode=instruction[6:0];
    wire [2:0] funct3=instruction[14:12];

    assign register_write_enable=1'b 1;
    
    //ALU Operation Control
    assign aluOperationCode=(((opcode===7'b 0110011) & (instruction[31:25]=== 7'b 0100000))? 3'b 100: funct3);
    
    // ALU source control on right input
    assign aluRightInputSourceControl =   (opcode === 7'b 0010011)? 1'b 0 : 
                    ((opcode === 7'b 0110011)? 1'b 1: 32'h 0);

     
endmodule

module ALURightInputSource(sourceSelection,immediateSource, registerSource, resultValue );
    input sourceSelection;
    input [31:0] immediateSource, registerSource;
    output [31:0] resultValue;

    // Selects source to feed ALU right input
    assign resultValue =   (sourceSelection === 1'b 0)? immediateSource : 
                    ((sourceSelection === 1'b 1)? registerSource: 32'h 0);
endmodule