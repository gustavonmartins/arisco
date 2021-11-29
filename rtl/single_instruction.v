`default_nettype none

`include "rtl/memory.v"
`include "rtl/alu.v"
`include "rtl/register_memory.v"

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
    wire [6:0] opcode=instruction[6:0];

    // Most of the instructions:
    wire [4:0] rd,rs1, rs2;
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];

    // ALU -> General
    wire [2:0] alu_opcode;
    wire [31:0]  aluLeftInput,aluRightInput, aluResult;

    ImmediateExtractor immediateExtractor(.instruction (instruction), .result (imm));
    wire [31:0] imm;
    wire [31:0] aluRightSourceImmediate;
    assign aluRightSourceImmediate= imm;
    
    //ALU -> Type I Instructions
    assign aluLeftInput = data_out_b; assign rd_address_b=rs1;
    assign wr_address = rd;

    wire [31:0] upperImmediateSignExtended = {instruction[31:12],12'h 000};
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
			2'd 0 	: internal=aluResult;
			2'd 1 	: internal=upperImmediateSignExtended;
			2'd 2 	: internal=pcNext;
            2'd 3   : internal = mainMemory;
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
    output wire [2:0] aluOperationCode;
    output reg aluRightInputSourceControl;
    output wire [1:0] registerWriteSourceControl;
    wire [6:0] opcode=instruction[6:0];
    wire [2:0] funct3=instruction[14:12];
    reg [2:0] internal;
    
    // Memory control
    output wire mem_write;
    output wire [2:0] mem_write_mode;
    assign mem_write = (opcode === 7'b 0100011)? 1 : 0;
    // Sets write mode to byte, halfword or word
    assign mem_write_mode = funct3;

    // Register control
    assign register_write_enable=(((opcode !== 7'b 0100011))? 1'b 1:1'b 0);
    assign register_write_pattern=((opcode===7'b 0000011)? instruction[14:12] : REGISTER_WRITE_WORD); // Load Byte (LB) decides here

    //Check if not LUI
    //assign registerWriteSourceControl=(opcode !== 7'b 0110111)? 2'b 0 : 2'b 1;
    always @(*) begin 
	    case (opcode)
		    7'b 0110111 	: 	internal = 2'd 1;
		    7'b 1101111 	: 	internal = 2'd 2;
            7'b 0000011     :   internal = 2'd 3;   // Source is main memory
		    default 		: 	internal = 2'd 0;
	    endcase
    end
    assign registerWriteSourceControl=internal;
   

    //ALU Operation Control
    assign aluOperationCode=
        (((opcode===7'b 0110011) & (instruction[31:25]=== 7'b 0100000))? 
        3'b 100:
        (((opcode===7'b 0100011) || (opcode===7'b 0000011))? 3'd 0:funct3)
        );
    
    // ALU source control on right input
    always @(*) begin
        case (opcode)
            7'b 0010011     :   aluRightInputSourceControl  = 1'b 0;    //I-Type. Read from immediate
            7'b 0110011     :   aluRightInputSourceControl  = 1'b 1;    //R-type. Read from register
            default         :   aluRightInputSourceControl  = 1'b 0;
        endcase
    //assign aluRightInputSourceControl =   (opcode === 7'b 0010011)? 1'b 0 : 
    //                ((opcode === 7'b 0110011)? 1'b 1: 32'h 0);

    end

     
endmodule

module ALURightInputSource(sourceSelection,immediateSource, registerSource, resultValue );
    input sourceSelection;
    input [31:0] immediateSource, registerSource;
    output [31:0] resultValue;

    // Selects source to feed ALU right input
    assign resultValue =   (sourceSelection === 1'b 0)? immediateSource : 
                    ((sourceSelection === 1'b 1)? registerSource: 32'h 0);
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
