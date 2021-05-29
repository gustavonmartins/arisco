#!/bin/bash
set -euo pipefail
clang --target=riscv32 -march=rv32i test_instructions.s -c -o arquivo.o && llvm-objcopy -O binary arquivo.o --only-section .text\* arquivo.bin && hexdump -ve '1/4 "%08x\n"' arquivo.bin > arquivo.mem

iverilog -Wall -o register_memory_out tests/register_memory_tb.v register_memory.v &&  vvp register_memory_out
iverilog -Wall -o pc_out tests/pc_tb.v pc.v  &&  vvp pc_out
iverilog -Wall -o alu_out tests/alu_tb.v alu.v  &&  vvp alu_out
iverilog -Wall -o mem_out tests/memory_tb.v && vvp mem_out
iverilog -Wall -o single_instruction_out tests/single_instruction_tb.v  &&  vvp single_instruction_out
iverilog -Wall -o instructions_i_out tests/instructions_i_tb.v multiple_instructions.v   pc.v &&  vvp instructions_i_out
iverilog -Wall -o consecutive_instructions_out tests/consecutive_instructions_tb.v multiple_instructions.v   pc.v  &&  vvp consecutive_instructions_out
iverilog -Wall -o assembly_instructions_out tests/assembly_instructions_tb.v multiple_instructions.v   pc.v  &&  vvp assembly_instructions_out
iverilog -Wall -o branch_instructions_out tests/branch_instructions_tb.v multiple_instructions.v   pc.v  &&  vvp branch_instructions_out
