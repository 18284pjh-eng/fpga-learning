MSBIN := /tool/altera/13.0sp1/modelsim_ase/bin
VLIB := $(MSBIN)/vlib
VLOG := $(MSBIN)/vlog
VSIM := $(MSBIN)/vsim

VCD := key_filter.vcd
TOP := tb_key_filter
RTL := ../src/key_filter.v
TB  := tb_key_filter.sv

.PHONY: sim

sim: $(VCD)
		@echo "simulate done: $(VCD)"

$(VCD): $(RTL) $(TB)
		if [ ! -d work ]; then $(VLIB) work; fi
		$(VLOG) -quiet $(RTL) $(TB)
		$(VSIM) -c $(TOP) -do "vcd file $(VCD); vcd add -r sim:/$(TOP)/*; run -all; quit -f"

wave: sim
		gtkwave $(VCD) &

clean:
		rm -rf work $(VCD) transcript vsim.wlf
