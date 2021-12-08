SHELL=/bin/bash -euo pipefail

VLOG=iverilog -Wall -g2012

CC=clang --target=riscv32 -march=rv32i

SOURCES       := $(shell find . -name '*.v' -not -name '*_tb.v')

.PHONY: test
test: verilog_component_test verilog_system_test assembly_test

.PHONY: verilog_component_test
verilog_component_test:
	@echo 	================ VERILOG COMPONENT TESTS ================
	$(VLOG) -o register_memory_out.o                       tests/01_components/register_memory_tb.v       	&&    vvp register_memory_out.o
	$(VLOG) -o pc_out.o                                    tests/01_components/pc_tb.v                    	&&    vvp pc_out.o
	$(VLOG) -o alu_out.o                                   tests/01_components/alu_tb.v                   	&&    vvp alu_out.o
	$(VLOG) -o mem_out.o                                   tests/01_components/memory_tb.v                	&&    vvp mem_out.o
	

.PHONY: verilog_system_test
verilog_system_test:
	@echo 	================ VERILOG SYSTEM TESTS ================
	$(VLOG) -o single_instruction_out.o                    tests/02_system/single_instruction_tb.v        	&&    vvp single_instruction_out.o
	$(VLOG) -o instructions_i_out.o                        tests/02_system/instructions_i_tb.v            	&&    vvp instructions_i_out.o
	$(VLOG) -o consecutive_instructions_out.o              tests/02_system/consecutive_instructions_tb.v	&&    vvp consecutive_instructions_out.o
	$(VLOG) -o branch_instructions_out.o                   tests/02_system/branch_instructions_tb.v			&&    vvp branch_instructions_out.o

.PHONY: assembly_test
assembly_test:
	@echo 	================ ASSEMBLY TESTS ================
	$(CC) tests/03_assembly/test_addi.s						-c -o test_addi.o       && llvm-objcopy -O binary test_addi.o	--only-section .text\* test_addi.bin	&& hexdump -ve '1/4 "%08x\n"' test_addi.bin		>   test_addi.mem
	$(CC) tests/03_assembly/test_sw_lw.s					-c -o test_sw_lw.o      && llvm-objcopy -O binary test_sw_lw.o	--only-section .text\* test_sw_lw.bin	&& hexdump -ve '1/4 "%08x\n"' test_sw_lw.bin	>   test_sw_lw.mem
	$(CC) tests/03_assembly/test_lbu.s						-c -o test_lbu.o		&& llvm-objcopy -O binary test_lbu.o	--only-section .text\* test_lbu.bin		&& hexdump -ve '1/4 "%08x\n"' test_lbu.bin		>   test_lbu.mem
	$(CC) tests/03_assembly/test_r_inst.S					-c -o test_r_inst.o		&& llvm-objcopy -O binary test_r_inst.o	--only-section .text\* test_r_inst.bin	&& hexdump -ve '1/4 "%08x\n"' test_r_inst.bin	>   test_r_inst.mem
	
	$(VLOG) -o assembly_instructions_out.o                	tests/03_assembly/assembly_instructions_tb.v -DMEMFILEPATH=\"test_addi.mem\"	-DVCDFILEPATH=\"test_addi.vcd\"		&& vvp assembly_instructions_out.o
	$(VLOG) -o assembly_instructions_memory_out.o         	tests/03_assembly/assembly_instructions_tb.v -DMEMFILEPATH=\"test_sw_lw.mem\"	-DVCDFILEPATH=\"test_sw_lw.vcd\"	&& vvp assembly_instructions_memory_out.o
	$(VLOG) -o assembly_instructions_memory_lbu_out.o     	tests/03_assembly/assembly_instructions_tb.v -DMEMFILEPATH=\"test_lbu.mem\"		-DVCDFILEPATH=\"test_lbu.vcd\"		&& vvp assembly_instructions_memory_lbu_out.o
	$(VLOG) -o assembly_instructions_type_r_out.o      		tests/03_assembly/assembly_instructions_tb.v -DMEMFILEPATH=\"test_r_inst.mem\"	-DVCDFILEPATH=\"test_r_inst.vcd\"	&& vvp assembly_instructions_type_r_out.o

https://www.sas.upenn.edu/~jesusfv/Chapter_HPC_6_Make.pdf

.PHONY: lint
lint:
	verilator --lint-only -Wall $(SOURCES)

.PHONY : clean
clean:
	rm -rf *.vcd *.bin *.o *.vvp *.mem build

#yosys -p "read_verilog -sv *.v ; synth_ecp5 -json top.json -top Toplevel"
