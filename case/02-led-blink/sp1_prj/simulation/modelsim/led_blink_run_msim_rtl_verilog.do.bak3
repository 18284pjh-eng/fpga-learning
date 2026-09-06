transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/pjh/project/fpga_learning/test/case/02-led-blink/src {/home/pjh/project/fpga_learning/test/case/02-led-blink/src/led_blink.v}

vlog -sv -work work +incdir+/home/pjh/project/fpga_learning/test/case/02-led-blink/sp1_prj/../sim {/home/pjh/project/fpga_learning/test/case/02-led-blink/sp1_prj/../sim/tb_led_blink.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  top

add wave *
view structure
view signals
run -all
