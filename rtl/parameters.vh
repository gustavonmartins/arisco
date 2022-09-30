`ifndef _parameters_h
    `define _parameters_h

    // Restrict legal words to desired Verilog version
    `ifdef _iverilog_
        `begin_keywords "1800-2005" 
    `endif

    // Program memory's control parameter
    localparam PROGRAM_MEMORY_SIZE_WORDS = 1000;

    // Registers' control parameters
    localparam REG_WRITE_ENABLE_ON=        1'b 1;
    localparam REG_WRITE_ENABLE_OFF=       1'b 0;

    localparam REG_WRITE_BYTE_UNSIGNED =   3'b 100;
    localparam REG_WRITE_BYTE_SIGNED =     3'b 101;
    localparam REG_WRITE_WORD =            3'b 010;
    localparam REG_WRITE_NA =              3'b 011;

    // Used in Single Instructions' circuit only
    localparam REG_SRC_ALU_RESULT=                      2'd 0;
    localparam REG_SRC_PC_NEXT=                         2'd 2;
    localparam REG_SRC_MAIN_MEMORY=                     2'd 3 ;
    localparam REG_SRC_UPPER_IMMEDIATED_SIGN_EXTENDED=  2'd 1;
    localparam REG_SRC_NA=                              2'd 0;

    // ALU's control parameters
    localparam ALU_SRC_IMMEDIATE=1'b 0;
    localparam ALU_SRC_REGISTER= 1'b 1;
    localparam ALU_SRC_NA = 1'b 0;

    // ALU operation codes
    localparam ALU_LENGTH    = 4;
    localparam ALU_ADD       = 4'b 0000;
    localparam ALU_SUB       = 4'b 1000;
    localparam ALU_SLL       = 4'b 0001;
    localparam ALU_SLT       = 4'b 0010;
    localparam ALU_SLTU      = 4'b 0011;
    localparam ALU_XOR       = 4'b 0100;
    localparam ALU_SRL       = 4'b 0101;
    localparam ALU_SRA       = 4'b 1101;
    localparam ALU_OR        = 4'b 0110;
    localparam ALU_AND       = 4'b 0111;
    localparam ALU_EQ        = 4'b 1001;
    localparam ALU_NOOP      = 4'b 1111;

    //PC controls
    localparam PC_SRC_LENGHT =       2;
    localparam PC_SRC_PC_PLUS_FOUR = 2'd 0;
    localparam PC_SRC_JAL =          2'd 1;
    localparam PC_SRC_B_OFFSET =     2'd 2;

    // RAM control
    localparam RAM_WRITE_ON =   1'b 1;
    localparam RAM_WRITE_OFF =  1'b 0;
    
    localparam RAM_WORD =       3'b 010;
    localparam RAM_HALFWORD =   3'b 001;
    localparam RAM_BYTE =       3'b 000;
    localparam RAM_NA =             3'b 111;

    // Control unit
    `define LOOP_INSTRUCTION_CYCLES "@(negedge clk);@(negedge clk);@(negedge clk);"
`endif
