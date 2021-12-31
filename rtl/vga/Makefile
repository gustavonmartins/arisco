SHELL = /bin/bash -euo pipefail

VLOG = iverilog -Wall -g2012

CC = clang --target=riscv32 -march=rv32i -Wall

SOURCES := $(shell find . -name '*.v')

VGA.test.o: $(SOURCES)
	$(VLOG) tests/VGA_tb.v -I VGA.v -DVCDFILEPATH=\"VGA.vcd\"	-o VGA.test.o 

%.json: $(SOURCES)
	yosys -p "read_verilog -sv VGA.v ; synth_ice40 -json top.json -top VGA"

%.asc: %.json pins.pcf
	nextpnr-ice40 --up5k --package sg48 --json $*.json --pcf-allow-unconstrained --pcf pins.pcf --asc $*.asc
	icetime -mit $*.asc -d up5k

test: VGA.test.o

	vvp VGA.test.o 

clean:
	rm -rf *.o *.vcd *.asc *.json

lint:
	verilator --lint-only -Wall $(SOURCES)

synth: test
	yosys -p "read_verilog VGA.v ; synth_ice40 -json top.json -top VGA"
