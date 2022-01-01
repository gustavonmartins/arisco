SHELL = /bin/bash -euo pipefail

VLOG = iverilog -Wall -g2012

CC = clang --target=riscv32 -march=rv32i -Wall

SOURCES 		:= $(shell find . -name '*.v' -not -name '*_tb.v')
TEST_SOURCES 	:= $(shell find . -name '*_tb.v')

VGA.test.o: $(SOURCES)
	$(VLOG)  $(SOURCES) $(TEST_SOURCES) -DVCDFILEPATH=\"VGA.vcd\"	-o VGA.test.o 

%.json: $(SOURCES)
	yosys -p "read_verilog -sv $*.v ; synth_ice40 -json $*.json -top $*"
#	yosys -p "prep -top VGA -flatten; write_json VGA.json" VGA.v    This is for a diagram with netlistsvg
# 	npx netlistsvg VGA.json -o VGA.svg

%.asc: %.json pins.pcf
	nextpnr-ice40 --up5k --package sg48 --json $*.json --pcf pins.pcf --asc $*.asc
	icetime -mit $*.asc -d up5k

test: VGA.test.o

	vvp VGA.test.o 

clean:
	rm -rf *.o *.vcd *.asc *.json

lint:
	verilator --lint-only -Wall $(SOURCES)

synth: test
	yosys -p "read_verilog VGA.v ; synth_ice40 -json top.json -top VGA"
