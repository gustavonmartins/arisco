`default_nettype none

`include "rtl/parameters.vh"

module SingleInstruction (
    input clk, 
    input wire [31:0] instruction, 
    input wire [31:0] pcNext,
    output wire [31:0] aluResult, 
    output wire [31:0]  bus_address,
    output wire [31:0]  bus_wr_data,
    input wire [31:0]   bus_read_data,
    output wire [2:0]   bus_write_length,
    output wire         bus_wr_enable
    );
    
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

    

    assign bus_address =aluResult;
    assign bus_wr_data = data_out_a;
    assign  mem_read_data=bus_read_data;
    assign bus_wr_enable = mem_write_enable;
    assign bus_write_length = mem_write_mode;
    
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
    wire [ALU_LENGTH-1:0] alu_opcode;
    wire [31:0]  aluLeftInput,aluRightInput;

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

module MuxRegisterWriteDataSource(
    input [1:0] sourceSelection, 
    input [31:0] aluResult, 
    input [31:0] upperImmediateSignExtended, 
    input [31:0] pcNext, 
    input [31:0] mainMemory, 
    output [31:0] resultValue
    );

	reg [31:0] internal;

	always @(*) begin
		case (sourceSelection)
			REG_SRC_ALU_RESULT 	: internal=aluResult;
			REG_SRC_UPPER_IMMEDIATED_SIGN_EXTENDED	: internal=upperImmediateSignExtended;
			REG_SRC_PC_NEXT 	: internal=pcNext;
            REG_SRC_MAIN_MEMORY  : internal = mainMemory;
			default : internal = 32'b 0; 
		endcase
	end

	assign resultValue = internal;

endmodule

module ControlUnit(
    input [31:0] instruction,
    output wire register_write_enable, 
    output wire [ALU_LENGTH-1:0] aluOperationCode, 
    output reg aluRightInputSourceControl,
    output wire [1:0] registerWriteSourceControl, 
    output wire mem_write, 
    output wire [2:0] mem_write_mode,
    output wire [2:0] register_write_pattern
    );
    
    wire [6:0] opcode=instruction[6:0];
    wire [2:0] funct3=instruction[14:12];
    wire [6:0] funct7;
    assign funct7=instruction[31:25];
    
    // RAM control
    reg [10+ALU_LENGTH:0] control;
    assign {aluOperationCode, mem_write, mem_write_mode,register_write_pattern,register_write_enable,aluRightInputSourceControl, registerWriteSourceControl} = control;

    always @(*) begin 
	    casez ({funct7,funct3,opcode})
		    17'b ???????_???_0110111 	: 	control = {{1'b 0, funct3}      , 1'b 0, funct3, REG_WRITE_WORD,             REG_WRITE_ENABLE_ON, ALU_SRC_IMMEDIATE   , REG_SRC_UPPER_IMMEDIATED_SIGN_EXTENDED};
		    17'b ???????_???_1101111 	: 	control = {{1'b 0, funct3}      , 1'b 0, funct3, REG_WRITE_WORD,             REG_WRITE_ENABLE_ON, ALU_SRC_IMMEDIATE   , REG_SRC_PC_NEXT};
            17'b ???????_100_0000011    :   control = {ALU_ADD           , 1'b 0, funct3, REG_WRITE_BYTE_UNSIGNED,    REG_WRITE_ENABLE_ON, ALU_SRC_IMMEDIATE   , REG_SRC_MAIN_MEMORY};   // LBU
            17'b ???????_000_0000011    :   control = {ALU_ADD           , 1'b 0, funct3, REG_WRITE_BYTE_SIGNED,      REG_WRITE_ENABLE_ON, ALU_SRC_IMMEDIATE   , REG_SRC_MAIN_MEMORY};   // LB
            17'b ???????_???_0000011    :   control = {ALU_ADD           , 1'b 0, funct3, REG_WRITE_WORD,             REG_WRITE_ENABLE_ON, ALU_SRC_IMMEDIATE   , REG_SRC_MAIN_MEMORY};   // 
            17'b ?1?????_101_0010011    :   control = {{1'b 1, funct3}      , 1'b 0, funct3, REG_WRITE_WORD,             REG_WRITE_ENABLE_ON, ALU_SRC_IMMEDIATE   , REG_SRC_ALU_RESULT};    //I-Type. Read from immediate
            17'b ???????_???_0010011    :   control = {{1'b 0, funct3}      , 1'b 0, funct3, REG_WRITE_WORD,             REG_WRITE_ENABLE_ON, ALU_SRC_IMMEDIATE   , REG_SRC_ALU_RESULT};    //I-Type. Read from immediate
            17'b ???????_???_0110011    :   control = {{funct7[5], funct3}  , 1'b 0, funct3, REG_WRITE_WORD,             REG_WRITE_ENABLE_ON, ALU_SRC_REGISTER    , REG_SRC_ALU_RESULT};    //R-type. Read from register
		    17'b ???????_???_0100011    :   control = {ALU_ADD           , 1'b 1, funct3, REG_WRITE_WORD,             REG_WRITE_ENABLE_OFF,1'b 0                  , 2'b 0}; //SB, SH, SW
            17'b ???????_00?_1100011    :   control = {ALU_EQ            , 1'b 0, funct3, REG_WRITE_NA,               REG_WRITE_ENABLE_OFF,ALU_SRC_REGISTER    , REG_SRC_ALU_RESULT}; // BEQ/BNE
            17'b ???????_10?_1100011    :   control = {ALU_SLT           , 1'b 0, funct3, REG_WRITE_NA,               REG_WRITE_ENABLE_OFF,ALU_SRC_REGISTER    , REG_SRC_ALU_RESULT}; // BLT
            17'b ???????_11?_1100011    :   control = {ALU_SLTU          , 1'b 0, funct3, REG_WRITE_NA,               REG_WRITE_ENABLE_OFF,ALU_SRC_REGISTER    , REG_SRC_ALU_RESULT}; // BLTU
            default 		            : 	control = {{1'b 0, funct3}      , 1'b 0, funct3, REG_WRITE_WORD,             REG_WRITE_ENABLE_ON, ALU_SRC_IMMEDIATE   , REG_SRC_ALU_RESULT};
	    endcase
    end
endmodule

module ALURightInputSource(
    input wire sourceSelection,
    input wire [31:0] immediateSource, 
    input wire [31:0] registerSource, 
    output wire [31:0] resultValue
    );

    reg [31:0] internal_result;

    // Selects source to feed ALU right input
    always @(*) begin
        case (sourceSelection)
            ALU_SRC_IMMEDIATE    : internal_result<=immediateSource;
            ALU_SRC_REGISTER     : internal_result<=registerSource;
        endcase
    end

    assign resultValue = internal_result;
endmodule

module ImmediateExtractor(
    input [31:0] instruction, 
    output wire [31:0] result
    );

    wire[6:0] opcode = instruction[6:0];
    wire[4:0] shamt = instruction[24:20];
    wire[6:0] funct7 = instruction[31:25];

    reg [31:0] result_internal;
    
    always @(*) begin
        casez ({funct7,opcode})
            14'b 0100000_0010011     :   result_internal  <=   {27'b 0,shamt};
            14'b ???????_0010011     :   result_internal  <=   {{20{instruction[31]}}, instruction[31:20]};
            14'b ???????_0100011     :   result_internal  <=   {{20{instruction[31]}}, instruction[31:25],instruction[11:7]};
            14'b ???????_0000011     :   result_internal  <=   {{20{instruction[31]}}, instruction[31:20]};
            default                  :   result_internal  <=   32'b 0;
        endcase
    end

    assign result = result_internal;
endmodule
