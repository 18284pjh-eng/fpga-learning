MSBIN := /tool/altera/13.0sp1/modelsim_ase/bin
QBIN  := /tool/altera/13.0sp1/quartus/bin
ROOT  := $(CURDIR)
PRJ   := $(ROOT)/sp1_prj
PROJECT := $(PRJ)/key_fsm
REV   := key_fsm
TOP   := tb_key_fsm
SOF   := $(PRJ)/key_fsm.sof
Q64   := --64bit
QP    := --parallel=8

.PHONY: sim wave map fit asm sof timing quartus program clean distclean

sim:
	cd sim && $(MSBIN)/vlib work
	cd sim && $(MSBIN)/vlog -quiet ../src/key_fsm.v tb_key_fsm.sv
	cd sim && $(MSBIN)/vsim -c $(TOP) -do \
		"vcd file key_fsm.vcd; vcd add -r sim:/$(TOP)/*; run -all; quit -f"

wave: sim
	gtkwave sim/key_fsm.vcd &

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
	rm -rf sim/work sim/key_fsm.vcd sim/transcript \
		$(PRJ)/db $(PRJ)/incremental_db $(PRJ)/output_files

distclean: clean
	rm -f $(SOF) $(PRJ)/*.rpt $(PRJ)/*.summary $(PRJ)/*.sof
