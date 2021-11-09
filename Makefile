SHELL=/bin/bash -euo pipefail

VLOG=iverilog -Wall -g2012

CC=clang --target=riscv32 -march=rv32i

SOURCES       := $(shell find . -name '*.v' -not -name '*_tb.v')

test: verilog_test assembly_test

verilog_test:
	@echo 	================ VERILOG TESTS ================
	$(VLOG) -o register_memory_out.o                       tests/register_memory_tb.v                  &&    vvp register_memory_out.o
	$(VLOG) -o pc_out.o                                    tests/pc_tb.v                               &&    vvp pc_out.o
	$(VLOG) -o alu_out.o                                   tests/alu_tb.v                              &&    vvp alu_out.o
	$(VLOG) -o mem_out.o                                   tests/memory_tb.v                           &&    vvp mem_out.o
	$(VLOG) -o single_instruction_out.o                    tests/single_instruction_tb.v               &&    vvp single_instruction_out.o
	$(VLOG) -o instructions_i_out.o                        tests/instructions_i_tb.v                   &&    vvp instructions_i_out.o
	$(VLOG) -o consecutive_instructions_out.o              tests/consecutive_instructions_tb.v         &&    vvp consecutive_instructions_out.o
	$(VLOG) -o branch_instructions_out.o                   tests/branch_instructions_tb.v              &&    vvp branch_instructions_out.o

assembly_test:
	@echo 	================ ASSEMBLY TESTS ================
	$(CC) tests/test_instructions.s       -c -o test_instructions.o           && llvm-objcopy -O binary test_instructions.o   --only-section .text\* test_instructions.bin    && hexdump -ve '1/4 "%08x\n"' test_instructions.bin     >   test_instructions.mem
	$(CC) tests/test_memory.s             -c -o test_memory.o                 && llvm-objcopy -O binary test_memory.o         --only-section .text\* test_memory.bin          && hexdump -ve '1/4 "%08x\n"' test_memory.bin           >   test_memory.mem
	$(CC) tests/test_memory_lbu.s         -c -o test_memory_lbu.o             && llvm-objcopy -O binary test_memory_lbu.o     --only-section .text\* test_memory_lbu.bin      && hexdump -ve '1/4 "%08x\n"' test_memory_lbu.bin       >   test_memory_lbu.mem
	
	$(VLOG) -o assembly_instructions_out.o                 tests/assembly_instructions_tb.v -DMEMFILEPATH=\"test_instructions.mem\"     -DVCDFILEPATH=\"test_instructions.vcd\"     && vvp assembly_instructions_out.o
	$(VLOG) -o assembly_instructions_memory_out.o          tests/assembly_instructions_tb.v -DMEMFILEPATH=\"test_memory.mem\"           -DVCDFILEPATH=\"test_memory.vcd\"           && vvp assembly_instructions_memory_out.o
	$(VLOG) -o assembly_instructions_memory_lbu_out.o      tests/assembly_instructions_tb.v -DMEMFILEPATH=\"test_memory_lbu.mem\"       -DVCDFILEPATH=\"test_memory_lbu.vcd\"       && vvp assembly_instructions_memory_lbu_out.o

https://www.sas.upenn.edu/~jesusfv/Chapter_HPC_6_Make.pdf

lint: 
	verilator --lint-only -Wall $(SOURCES)

.PHONY : clean
clean:
	rm -rf *.vcd *.bin *.o *.vvp *.mem build