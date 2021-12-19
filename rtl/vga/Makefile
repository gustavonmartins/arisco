SHELL = /bin/bash -euo pipefail

VLOG = iverilog -Wall -g2012

CC = clang --target=riscv32 -march=rv32i -Wall

SOURCES := $(shell find . -name '*.v')

VGA.test.o: $(SOURCES)
	$(VLOG) tests/VGA_tb.v -I VGA.v -DVCDFILEPATH=\"VGA.vcd\"	-o VGA.test.o 

test: VGA.test.o

	vvp VGA.test.o 

clean:
	rm -rf *.o *.vcd

lint:
	verilator --lint-only -Wall $(SOURCES)
