`ifndef _parameters_h
    `define _parameters_h

    // Program memory's control parameter
    localparam PROGRAM_MEMORY_SIZE_WORDS = 100;

    // Registers' control parameters
    localparam REGISTER_WRITE_ENABLE_ON=1'b 1;
    localparam REGISTER_WRITE_ENABLE_OFF=1'b 0;

    localparam REGISTER_WRITE_BYTE_UNSIGNED = 3'b 100;
    localparam REGISTER_WRITE_BYTE_SIGNED = 3'b 101;
    localparam REGISTER_WRITE_WORD = 3'b 010;

    // ALU's control parameters
    localparam ALU_SOURCE_IMMEDIATE=1'b 0;
    localparam ALU_SOURCE_REGISTER=1'b 1;

    // Used in Single Instructions' circuit only
    localparam REGISTER_SOURCE_ALU_RESULT=2'd 0;
    localparam REGISTER_SOURCE_PC_NEXT=2'd 2;
    localparam REGISTER_SOURCE_MAIN_MEMORY=2'd 3 ;
    localparam REGISTER_SOURCE_UPPER_IMMEDIATED_SIGN_EXTENDED=2'd 1;

    // ALU operation codes
    localparam ALU_OP_ADD = 3'd 000;
    localparam ALU_OP_AND = 3'b 111;
    localparam ALU_OP_OR = 3'b 110;
    localparam ALU_OP_SUB = 3'b 101;
    localparam ALU_OP_XOR = 3'b 100;
    localparam ALU_OP_SLL = 3'b 001;
    localparam ALU_OP_SLT = 3'b 010;

`endif
