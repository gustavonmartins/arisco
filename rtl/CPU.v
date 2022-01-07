`default_nettype none

`include "rtl/parameters.vh"

module CPU (
    input wire clk, 
    input wire i_reset,
    input wire [31:0]   i_bus_read_data,
    input wire [31:0]   i_instruction,

    output wire [2:0]   o_bus_write_length,
    output wire         o_bus_wr_enable,
    output wire [31:0]  o_bus_address,
    output wire [31:0]  o_bus_wr_data,
    output wire [31:0]  o_bus_rom_pc

    );

    //localparam PROGRAM_MEMORY_SIZE=64;
    
    ProgramCounter programCounter(.i_clk (clk), .i_pc (pc_in), .o_pc (pc), .i_reset (i_reset));
    
    SingleInstruction single_instr (.clk (clk), .instruction (instruction), .pcNext (pc_next), .aluResult(aluResult),
    .bus_address(o_bus_address),.bus_wr_data(o_bus_wr_data),.bus_read_data(i_bus_read_data),.bus_write_length(o_bus_write_length),.bus_wr_enable(o_bus_wr_enable));

    PCGenerator pcNext(.i_pc (pc),.i_instruction(instruction), .o_pc_next (pc_next), .i_pcSourceControl (pcSourceControl), .o_pcResult (pc_in));

    PCControl pcControl(.instruction(instruction),.aluResult(aluResult), .pcSourceControl (pcSourceControl));

    wire [31:0] instruction;
    wire [31:0] pc, pc_in;
    wire [31:0] pc_next;
    wire [31:0] pcPlusJal;
    wire [31:0] pcPlusBOffset;
    wire [31:0] aluResult;

    assign o_bus_rom_pc = pc;
    assign instruction=i_instruction;
    
    
    wire [6:0] opcode = instruction[6:0];

    wire [PC_SOURCE_LENGHT-1:0] pcSourceControl;

    //CPU cpu(.clk,.bus_address,.bus_wr_data,.bus_read_data,.bus_write_length,.bus_wr_enable);


endmodule

module PCControl(
    input wire [31:0] instruction, 
    input wire [31:0] aluResult,
    output reg [PC_SOURCE_LENGHT-1:0] pcSourceControl);

    wire [2:0] funct3=instruction[14:12];
    wire [6:0] opcode=instruction[6:0];
	//assign pcSourceControl=(opcode === 7'b 1101111)? PC_SOURCE_JAL: PC_SOURCE_PC_PLUS_FOUR;
    always @(*) begin
        casez ({opcode,funct3,aluResult[0]})
            11'b 1101111_???_?           :   pcSourceControl = PC_SOURCE_JAL;
            11'b 1100011_000_1      :   pcSourceControl    =   PC_SOURCE_B_OFFSET; //BEQ
            11'b 1100011_001_0      :   pcSourceControl    =   PC_SOURCE_B_OFFSET; //BNE
            11'b 1100011_100_1      :   pcSourceControl    =   PC_SOURCE_B_OFFSET; //BLT
            11'b 1100011_101_0      :   pcSourceControl    =   PC_SOURCE_B_OFFSET; //BGE
            11'b 1100011_110_1      :   pcSourceControl    =   PC_SOURCE_B_OFFSET; //BLTU
            11'b 1100011_111_0      :   pcSourceControl    =   PC_SOURCE_B_OFFSET; //BGEU
            default  :   pcSourceControl=PC_SOURCE_PC_PLUS_FOUR;

        endcase
    end
endmodule

module PCGenerator(
    input [31:0] i_pc,
    input [31:0] i_instruction, 
    output [31:0] o_pc_next,
    input [PC_SOURCE_LENGHT-1:0] i_pcSourceControl, 
    output reg [31:0] o_pcResult
    );



	assign o_pc_next=i_pc+4;

	
	//assign pcResult=(pcSourceControl === PC_SOURCE_PC_PLUS_FOUR)? pcPlusFour : (pcSourceControl === PC_SOURCE_JAL? pcPlusJal : pcPlusBOffset);
    always @(*) begin
        casez (i_pcSourceControl)
            PC_SOURCE_PC_PLUS_FOUR  :   o_pcResult=     o_pc_next;
            PC_SOURCE_JAL           :   o_pcResult =    {{12{i_instruction[31]}},i_instruction[31:12]}+i_pc;
            PC_SOURCE_B_OFFSET      :   o_pcResult =    i_pc+{{19{i_instruction[31]}},i_instruction[31],i_instruction[7],i_instruction[30:25],i_instruction[11:8],1'b 0}; // Mistakes here dont always break tests. Be careful!
            default                 :   o_pcResult  = 32'd 0;

        endcase
    end

endmodule

module ProgramCounter (
    input i_clk,
    input i_reset,
    input [31:0] i_pc,
    output [31:0] o_pc
);
    reg [31:0] memory;

    always @ (posedge i_clk or posedge i_reset) begin
            if (i_reset)
                memory<=0;
            else 
                memory<=i_pc;
    end

    assign o_pc = memory;

endmodule
