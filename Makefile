SHELL=/bin/bash -euo pipefail

VLOG=iverilog -Wall -g2012

CC=clang --target=riscv32 -march=rv32i

SOURCES       := $(shell find . -name '*.v' -not -name '*_tb.v')

test: verilog_component_test verilog_system_test assembly_test

verilog_component_test:
	@echo 	================ VERILOG COMPONENT TESTS ================
	$(VLOG) -o register_memory_out.o                       tests/01_components/register_memory_tb.v       	&&    vvp register_memory_out.o
	$(VLOG) -o pc_out.o                                    tests/01_components/pc_tb.v                    	&&    vvp pc_out.o
	$(VLOG) -o alu_out.o                                   tests/01_components/alu_tb.v                   	&&    vvp alu_out.o
	$(VLOG) -o mem_out.o                                   tests/01_components/memory_tb.v                	&&    vvp mem_out.o
	

verilog_system_test:
	@echo 	================ VERILOG SYSTEM TESTS ================
	$(VLOG) -o single_instruction_out.o                    tests/02_system/single_instruction_tb.v        	&&    vvp single_instruction_out.o
	$(VLOG) -o instructions_i_out.o                        tests/02_system/instructions_i_tb.v            	&&    vvp instructions_i_out.o
	$(VLOG) -o consecutive_instructions_out.o              tests/02_system/consecutive_instructions_tb.v	&&    vvp consecutive_instructions_out.o
	$(VLOG) -o branch_instructions_out.o                   tests/02_system/branch_instructions_tb.v			&&    vvp branch_instructions_out.o

assembly_test:
	@echo 	================ ASSEMBLY TESTS ================
	$(CC) tests/03_assembly/test_instructions.s       	-c -o test_instructions.o           && llvm-objcopy -O binary test_instructions.o   --only-section .text\* test_instructions.bin    && hexdump -ve '1/4 "%08x\n"' test_instructions.bin     >   test_instructions.mem
	$(CC) tests/03_assembly/test_memory.s             	-c -o test_memory.o                 && llvm-objcopy -O binary test_memory.o         --only-section .text\* test_memory.bin          && hexdump -ve '1/4 "%08x\n"' test_memory.bin           >   test_memory.mem
	$(CC) tests/03_assembly/test_memory_lbu.s        	-c -o test_memory_lbu.o             && llvm-objcopy -O binary test_memory_lbu.o     --only-section .text\* test_memory_lbu.bin      && hexdump -ve '1/4 "%08x\n"' test_memory_lbu.bin       >   test_memory_lbu.mem
	
	$(VLOG) -o assembly_instructions_out.o                 tests/03_assembly/assembly_instructions_tb.v -DMEMFILEPATH=\"test_instructions.mem\"     -DVCDFILEPATH=\"test_instructions.vcd\"     && vvp assembly_instructions_out.o
	$(VLOG) -o assembly_instructions_memory_out.o          tests/03_assembly/assembly_instructions_tb.v -DMEMFILEPATH=\"test_memory.mem\"           -DVCDFILEPATH=\"test_memory.vcd\"           && vvp assembly_instructions_memory_out.o
	$(VLOG) -o assembly_instructions_memory_lbu_out.o      tests/03_assembly/assembly_instructions_tb.v -DMEMFILEPATH=\"test_memory_lbu.mem\"       -DVCDFILEPATH=\"test_memory_lbu.vcd\"       && vvp assembly_instructions_memory_lbu_out.o

https://www.sas.upenn.edu/~jesusfv/Chapter_HPC_6_Make.pdf

lint: 
	verilator --lint-only -Wall $(SOURCES)

.PHONY : clean
clean:
	rm -rf *.vcd *.bin *.o *.vvp *.mem build