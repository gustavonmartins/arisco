`ifndef _parameters_h
    `define _parameters_h

    // Restrict legal words to desired Verilog version
    `ifdef _iverilog_
        `begin_keywords "1800-2005" 
    `endif

    // Program memory's control parameter
    localparam PROGRAM_MEMORY_SIZE_WORDS = 1000;

    // Registers' control parameters
    localparam REGISTER_WRITE_ENABLE_ON=    1'b 1;
    localparam REGISTER_WRITE_ENABLE_OFF=   1'b 0;

    localparam REGISTER_WRITE_BYTE_UNSIGNED =   3'b 100;
    localparam REGISTER_WRITE_BYTE_SIGNED =     3'b 101;
    localparam REGISTER_WRITE_WORD =            3'b 010;
    localparam REGISTER_WRITE_NA =              3'b 011;

    // ALU's control parameters
    localparam ALU_SOURCE_IMMEDIATE=1'b 0;
    localparam ALU_SOURCE_REGISTER= 1'b 1;

    // Used in Single Instructions' circuit only
    localparam REGISTER_SOURCE_ALU_RESULT=                      2'd 0;
    localparam REGISTER_SOURCE_PC_NEXT=                         2'd 2;
    localparam REGISTER_SOURCE_MAIN_MEMORY=                     2'd 3 ;
    localparam REGISTER_SOURCE_UPPER_IMMEDIATED_SIGN_EXTENDED=  2'd 1;

    // ALU operation codes
    localparam ALU_OP_LENGTH    = 4;
    localparam ALU_OP_ADD       = 4'd 0000;
    localparam ALU_OP_SUB       = 4'b 1000;
    localparam ALU_OP_SLL       = 4'b 0001;
    localparam ALU_OP_SLT       = 4'b 0010;
    localparam ALU_OP_SLTU      = 4'b 0011;
    localparam ALU_OP_XOR       = 4'b 0100;
    localparam ALU_OP_SRL       = 4'b 0101;
    localparam ALU_OP_SRA       = 4'b 1101;
    localparam ALU_OP_OR        = 4'b 0110;
    localparam ALU_OP_AND       = 4'b 0111;
    localparam ALU_OP_EQ        = 4'b 1001;

    //PC controls
    localparam PC_SOURCE_LENGHT =       2;
    localparam PC_SOURCE_PC_PLUS_FOUR = 2'd 0;
    localparam PC_SOURCE_JAL =          2'd 1;
    localparam PC_SOURCE_B_OFFSET =     2'd 2;

    // RAM control
    localparam RAM_WORD = 3'b 010;
    localparam RAM_HALFWORD = 3'b 001;
    localparam RAM_BYTE = 3'b 000;
`endif
