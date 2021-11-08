#!/bin/bash
set -euo pipefail
clang --target=riscv32 -march=rv32i tests/test_instructions.s       -c -o arquivo.o             && llvm-objcopy -O binary arquivo.o             --only-section .text\* arquivo.bin              && hexdump -ve '1/4 "%08x\n"' arquivo.bin               >   arquivo.mem
clang --target=riscv32 -march=rv32i tests/test_memory.s             -c -o arquivo_memory.o      && llvm-objcopy -O binary arquivo_memory.o      --only-section .text\* arquivo_memory.bin       && hexdump -ve '1/4 "%08x\n"' arquivo_memory.bin        >   arquivo_memory.mem
clang --target=riscv32 -march=rv32i tests/test_memory_lbu.s         -c -o arquivo_memory_lbu.o  && llvm-objcopy -O binary arquivo_memory_lbu.o  --only-section .text\* arquivo_memory_lbu.bin   && hexdump -ve '1/4 "%08x\n"' arquivo_memory_lbu.bin    >   arquivo_memory_lbu.mem

iverilog -Wall -o register_memory_out                       tests/register_memory_tb.v                  &&  vvp register_memory_out
iverilog -Wall -o pc_out                                    tests/pc_tb.v                               && vvp pc_out
iverilog -Wall -o alu_out                                   tests/alu_tb.v                              && vvp alu_out
iverilog -Wall -o mem_out                                   tests/memory_tb.v                           && vvp mem_out
iverilog -Wall -o single_instruction_out                    tests/single_instruction_tb.v               &&  vvp single_instruction_out
iverilog -Wall -o instructions_i_out                        tests/instructions_i_tb.v                   &&  vvp instructions_i_out
iverilog -Wall -o consecutive_instructions_out              tests/consecutive_instructions_tb.v         &&  vvp consecutive_instructions_out
iverilog -Wall -o assembly_instructions_out                 tests/assembly_instructions_tb.v            &&  vvp assembly_instructions_out
iverilog -Wall -o branch_instructions_out                   tests/branch_instructions_tb.v              &&  vvp branch_instructions_out
iverilog -Wall -o assembly_instructions_memory_out          tests/assembly_instructions_memory_tb.v     && vvp assembly_instructions_memory_out
iverilog -Wall -o assembly_instructions_memory_lbu_out      -DMEMFILEPATH=\"arquivo_memory_lbu.mem\"    -DVCDFILEPATH=\"assembly_instructions_memory_lbu.vcd\"      tests/assembly_instructions_memory_lbu_tb.v && vvp assembly_instructions_memory_lbu_out
