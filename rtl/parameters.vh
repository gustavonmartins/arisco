`ifndef _parameters_h
    `define _parameters_h
    localparam PROGRAM_MEMORY_SIZE_WORDS = 100;

    localparam REGISTER_WRITE_BYTE_UNSIGNED = 3'b 100;
    localparam REGISTER_WRITE_BYTE_SIGNED = 3'b 101;
    localparam REGISTER_WRITE_WORD = 3'b 010;

    localparam REGISTER_SOURCE_ALU_RESULT=2'd 0;
    localparam REGISTER_SOURCE_PC_NEXT=2'd 2;
    localparam REGISTER_SOURCE_MAIN_MEMORY=2'd 3 ;
    localparam REGISTER_SOURCE_UPPER_IMMEDIATED_SIGN_EXTENDED=2'd 1;

    localparam ALU_SOURCE_IMMEDIATE=1'b 0;
    localparam ALU_SOURCE_REGISTER=1'b 1;
`endif
