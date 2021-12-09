`default_nettype none

`include "rtl/Memory.v"
`include "rtl/ALU.v"
`include "rtl/RegisterMemory.v"

`include "rtl/parameters.vh"

module SingleInstruction (clk, instruction, pcNext);
    input clk;
    input wire [31:0] instruction, pcNext;

    
    // Control Unit
    ControlUnit controlUnit(.instruction(instruction), 
    .register_write_enable(registerWriteEnable), 
    .aluOperationCode(alu_opcode), 
    .aluRightInputSourceControl (aluRightInputSourceControl), 
    .registerWriteSourceControl(registerWriteSourceControl),
    .mem_write(mem_write_enable),
    .mem_write_mode(mem_write_mode),
    .register_write_pattern(register_write_pattern));

    // Register memory
    wire registerWriteEnable;
    wire [4:0] rd_address_a,rd_address_b,wr_address;
    wire [31:0] wr_data,data_out_a,data_out_b;
    wire [2:0] register_write_pattern;
    RegisterMemory reg_mem (
        .clk (clk),
        .rd_address_a (rd_address_a), .rd_address_b (rd_address_b),
        .wr_enable (registerWriteEnable), .wr_address (wr_address), 
        .wr_data (wr_data), .data_out_a (data_out_a), .data_out_b (data_out_b),
        .write_pattern (register_write_pattern));

    //ALU
    ALU ALU(.opcode (alu_opcode),.left (aluLeftInput),.right (aluRightInput),.result (aluResult));

    //ALU multiplexer
    ALURightInputSource aluRightInputSource(.sourceSelection(aluRightInputSourceControl), 
    .registerSource(aluRightSourceRegister),
    .immediateSource(aluRightSourceImmediate), 
    .resultValue (aluRightInput));

    // Main memory
    Memory mainMemory (.clk (clk), .address (aluResult), 
        .wr_data (data_out_a), .read_data (mem_read_data), 
        .wr_enable (mem_write_enable), .write_length (mem_write_mode));
    wire [31:0] mem_read_data;
    wire mem_write_enable;
    wire [2:0] mem_write_mode;

    // All instructions:
    wire [6:0] opcode;

    // Most of the instructions:
    wire [4:0] rd,rs1, rs2;
    wire [6:0] funct7;
    wire [2:0] funct3;
    assign {funct7,rs2,rs1,funct3,rd,opcode}=instruction;

    // ALU -> General
    wire [ALU_OP_LENGTH-1:0] alu_opcode;
    wire [31:0]  aluLeftInput,aluRightInput, aluResult;

    ImmediateExtractor immediateExtractor(.instruction (instruction), .result (imm));
    wire [31:0] imm;
    wire [31:0] aluRightSourceImmediate;
    assign aluRightSourceImmediate= imm;
    
    //ALU -> Type I Instructions
    assign aluLeftInput = data_out_b; assign rd_address_b=rs1;
    assign wr_address = rd;

    wire [31:0] upperImmediateSignExtended = {instruction[31:12],12'h 000}; //Used only for U instructions
    wire [1:0] registerWriteSourceControl;
    
    MuxRegisterWriteDataSource registerWriteDataSource(.sourceSelection (registerWriteSourceControl),
    .aluResult (aluResult), .upperImmediateSignExtended (upperImmediateSignExtended), .pcNext (pcNext),
    .mainMemory(mem_read_data),
    .resultValue (wr_data));

    //ALU -> Type R Instructions
    wire [31:0] aluRightSourceRegister;
    assign aluRightSourceRegister=data_out_a; 

    // General: Read RS2 register
    assign rd_address_a=rs2;

    wire aluRightInputSourceControl;

endmodule

module MuxRegisterWriteDataSource(sourceSelection, aluResult, upperImmediateSignExtended, pcNext, mainMemory, resultValue);
	input [1:0] sourceSelection;
	input [31:0] aluResult, pcNext;
	input [31:0] upperImmediateSignExtended, mainMemory;
	output [31:0] resultValue;
	reg [31:0] internal;

	always @(*) begin
		case (sourceSelection)
			REGISTER_SOURCE_ALU_RESULT 	: internal=aluResult;
			REGISTER_SOURCE_UPPER_IMMEDIATED_SIGN_EXTENDED	: internal=upperImmediateSignExtended;
			REGISTER_SOURCE_PC_NEXT 	: internal=pcNext;
            REGISTER_SOURCE_MAIN_MEMORY  : internal = mainMemory;
			default : internal = 32'b 0; 
		endcase
	end

	assign resultValue = internal;

endmodule

module ControlUnit(instruction, register_write_enable, aluOperationCode, aluRightInputSourceControl,
    registerWriteSourceControl, 
    mem_write, mem_write_mode,register_write_pattern);
    input [31:0] instruction;
    output wire register_write_enable;
    output wire [2:0] register_write_pattern;
    output wire [ALU_OP_LENGTH-1:0] aluOperationCode;
    output reg aluRightInputSourceControl;
    output wire [1:0] registerWriteSourceControl;
    wire [6:0] opcode=instruction[6:0];
    wire [2:0] funct3=instruction[14:12];
    reg [1:0] internal;
    wire [6:0] funct7;
    assign funct7=instruction[31:25];
    
    // Memory control
    output wire mem_write;
    output wire [2:0] mem_write_mode;

    logic [10+ALU_OP_LENGTH:0] control;
    assign {aluOperationCode, mem_write, mem_write_mode,register_write_pattern,register_write_enable,aluRightInputSourceControl, registerWriteSourceControl} = control;

    always @(*) begin 
	    casez ({funct7,funct3,opcode})
		    17'b ???????_???_0110111 	: 	control = {{1'b 0, funct3}      , 1'b 0, funct3, REGISTER_WRITE_WORD,             REGISTER_WRITE_ENABLE_ON, ALU_SOURCE_IMMEDIATE   , REGISTER_SOURCE_UPPER_IMMEDIATED_SIGN_EXTENDED};
		    17'b ???????_???_1101111 	: 	control = {{1'b 0, funct3}      , 1'b 0, funct3, REGISTER_WRITE_WORD,             REGISTER_WRITE_ENABLE_ON, ALU_SOURCE_IMMEDIATE   , REGISTER_SOURCE_PC_NEXT};
            17'b ???????_100_0000011    :   control = {ALU_OP_ADD           , 1'b 0, funct3, REGISTER_WRITE_BYTE_UNSIGNED,    REGISTER_WRITE_ENABLE_ON, ALU_SOURCE_IMMEDIATE   , REGISTER_SOURCE_MAIN_MEMORY};   // LBU
            17'b ???????_000_0000011    :   control = {ALU_OP_ADD           , 1'b 0, funct3, REGISTER_WRITE_BYTE_SIGNED,      REGISTER_WRITE_ENABLE_ON, ALU_SOURCE_IMMEDIATE   , REGISTER_SOURCE_MAIN_MEMORY};   // LB
            17'b ???????_???_0000011    :   control = {ALU_OP_ADD           , 1'b 0, funct3, REGISTER_WRITE_WORD,             REGISTER_WRITE_ENABLE_ON, ALU_SOURCE_IMMEDIATE   , REGISTER_SOURCE_MAIN_MEMORY};   // 
            17'b ???????_???_0010011    :   control = {{1'b 0, funct3}      , 1'b 0, funct3, REGISTER_WRITE_WORD,             REGISTER_WRITE_ENABLE_ON, ALU_SOURCE_IMMEDIATE   , REGISTER_SOURCE_ALU_RESULT};    //I-Type. Read from immediate
            17'b ???????_???_0110011    :   control = {{funct7[5], funct3}  , 1'b 0, funct3, REGISTER_WRITE_WORD,             REGISTER_WRITE_ENABLE_ON, ALU_SOURCE_REGISTER    , REGISTER_SOURCE_ALU_RESULT};    //R-type. Read from register
		    17'b ???????_???_0100011    :   control = {ALU_OP_ADD           , 1'b 1, funct3, REGISTER_WRITE_WORD,             REGISTER_WRITE_ENABLE_OFF,1'b 0                  , 2'b 0};
            default 		            : 	control = {{1'b 0, funct3}      , 1'b 0, funct3, REGISTER_WRITE_WORD,             REGISTER_WRITE_ENABLE_ON, ALU_SOURCE_IMMEDIATE   , REGISTER_SOURCE_ALU_RESULT};
	    endcase
    end
endmodule

module ALURightInputSource(sourceSelection,immediateSource, registerSource, resultValue );
    input sourceSelection;
    input [31:0] immediateSource, registerSource;
    output [31:0] resultValue;

    // Selects source to feed ALU right input
    assign resultValue =   (sourceSelection === ALU_SOURCE_IMMEDIATE)? immediateSource : 
                    ((sourceSelection === ALU_SOURCE_REGISTER)? registerSource: 32'h 0);
endmodule

module ImmediateExtractor(instruction, result);
    input [31:0] instruction;
    output reg [31:0] result;
    
    always @(*) begin
        case (instruction[6:0])
            7'b 0010011     :   result  =   {{20{instruction[31]}}, instruction[31:20]};
            7'b 0100011     :   result  =   {{20{instruction[31]}}, instruction[31:25],instruction[11:7]};
            7'b 0000011     :   result  =   {{20{instruction[31]}}, instruction[31:20]};
            default         :   result  =   32'b 0;
        endcase
    end
endmodule
