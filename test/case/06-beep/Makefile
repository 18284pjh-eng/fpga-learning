MSBIN := /tool/altera/13.0sp1/modelsim_ase/bin
QBIN  := /tool/altera/13.0sp1/quartus/bin
ROOT  := $(CURDIR)
PRJ   := $(ROOT)/sp1_prj
PROJECT := $(PRJ)/beep
REV   := beep
TOP   := tb_beep
SOF   := $(PRJ)/beep.sof
Q64   := --64bit
QP    := --parallel=8

.PHONY: syntax syntax-rtl syntax-tb elab sim wave map fit asm sof timing quartus program clean distclean

# Compile only.  vlog reports syntax and compile-time errors without running time.
syntax:
	cd sim && $(MSBIN)/vlib work
	cd sim && $(MSBIN)/vlog -quiet ../src/beep.v tb_beep.sv

syntax-rtl:
	cd sim && $(MSBIN)/vlib work
	cd sim && $(MSBIN)/vlog -quiet ../src/beep.v

syntax-tb:
	cd sim && $(MSBIN)/vlib work
	cd sim && $(MSBIN)/vlog -quiet tb_beep.sv

# Elaborate the testbench only.  This catches unresolved modules and bad
# parameter/port overrides, but does not advance simulation time.
elab: syntax
	cd sim && $(MSBIN)/vsim -c $(TOP) -do "quit -f"

sim:
	$(MAKE) syntax
	cd sim && $(MSBIN)/vsim -c $(TOP) -do \
		"vcd file beep.vcd; vcd add -r sim:/$(TOP)/* sim:/$(TOP)/dut/*; run -all; quit -f"

wave: sim
	gtkwave sim/beep.vcd &

map:
	$(QBIN)/quartus_map $(Q64) $(QP) $(PROJECT) -c $(REV)

fit: map
	$(QBIN)/quartus_fit $(Q64) $(QP) $(PROJECT) -c $(REV)

asm: fit
	$(QBIN)/quartus_asm $(Q64) $(PROJECT) -c $(REV)

# Generate a programmable SOF without running TimeQuest.
sof: asm
	@test -s $(SOF)

timing: fit
	$(QBIN)/quartus_sta $(Q64) $(QP) $(PROJECT) -c $(REV)

# Full Quartus flow: map, fit, assembler, and timing analysis.
quartus:
	$(QBIN)/quartus_sh $(Q64) --flow compile $(PROJECT)

program:
	@test -s $(SOF) || { echo "SOF not found; run 'make sof' first"; exit 1; }
	$(QBIN)/quartus_pgm -c USB-Blaster -m JTAG -o "p;$(SOF)"

clean:
	rm -rf sim/work sim/beep.vcd sim/transcript \
		$(PRJ)/db $(PRJ)/incremental_db $(PRJ)/output_files

distclean: clean
	rm -f $(SOF) $(PRJ)/*.rpt $(PRJ)/*.summary $(PRJ)/*.sof
