#!/bin/sh
# 控制台模式仿真（ModelSim GUI 在本机 Debian 13 上有兼容性问题，见 learning-records/0003）
# 用法: ./run_sim.sh        （可加参数 <testbench模块名>，默认 top）
# 产物: sp1_prj/simulation/modelsim/led_blink.vcd （用 gtkwave 打开看波形）
set -e
MSBIN=/tool/altera/13.0sp1/modelsim_ase/bin
TB=${1:-top}
ROOT=$(cd "$(dirname "$0")/.." && pwd)          # 02-led-blink/
OUT=$ROOT/sp1_prj/simulation/modelsim
mkdir -p "$OUT" && cd "$OUT"

"$MSBIN/vlib" work >/dev/null
"$MSBIN/vlog" -quiet ../../../src/led_blink.v ../../../sim/tb_led_blink.sv
"$MSBIN/vsim" -c "$TB" -do "vcd file led_blink.vcd; vcd add -r sim:/$TB/*; run -all; quit -f"

echo ""
echo "== 波形已生成: $OUT/led_blink.vcd"
echo "== 查看: gtkwave $OUT/led_blink.vcd"
