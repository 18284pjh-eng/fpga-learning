# LR-0003: 第 2 课仿真环节 + ModelSim GUI 故障归档（2026-09-06）

## 第 2 课进展

- 用户完成 `case/02-led-blink`：led_blink.v（flag 标志信号写法，独立风格）编译、上板正常。
- 第 1 版 tb 有 `import`/`.name` 简写/`$STOP` 等 Verilog/SV 混用错误，经讲解后自行改为 `tb_led_blink.sv`。
- 用户把 tb 模块命名为 `top`（配合 Quartus NativeLink 设置）。风格偏好：不写 `logic`，保留 reg/wire。
- **仿真最终验证通过**：`led` 翻转间隔精确 5000ns（CNT=249），RTL 功能正确。

## ModelSim GUI 故障（环境问题，已绕过）

- **现象**：Quartus NativeLink 报 "Successfully launched" 但 GUI 永不出现；
  命令行复现 `vsim -gui` → `** Fatal: Read failure in vlm process (0,0)`；`vsim -c` 控制台模式完全正常。
- **已排除**：设备权限（udev 已修）、ASLR（setarch -R 无效）、IPC 限制、license（ASE 免license）、
  沙箱（真机复现）、捆绑 freetype（此版本 Tcl/Tk 静态链接，无 lib/ 目录）。
- **现象细节**：vlm（license/IPC 子进程）从管道读到 EOF → 说明 vsimk 在 GUI 初始化早期静默死亡；
  vsimk 直启时 UI 子进程报 "-i/-gui/-c 冲突"。判定为 2012 年 32 位工具链在 Debian 13 上的深层兼容性问题。
- **绕过方案（已交付）**：`case/02-led-blink/sim/run_sim.sh` —— vlib/vlog/vsim -c 控制台编译运行 + VCD 波形导出，
  波形用 gtkwave 查看（`sudo apt install gtkwave`）。
- **教训**： NativeLink "Successfully launched" 不代表 GUI 真起来了，要看 rpt + rtl_work 是否生成。

## 用户环境事实补充

- Quartus 13.0sp1 + ModelSim ASE 10.1d 均在 `/tool/altera/13.0sp1/`；modelsim_ase 目录存在
  双重嵌套（modelsim_ase/modelsim_ase/），疑似解压错位，但不影响控制台功能。
- i386 multiarch 已启用；VCD 解析注意：led 信号符号 `#` 与 VCD 时间戳前缀冲突，脚本解析需特判。

## 下一步

- 第 2 课通关。第 3 课：按键消抖（官方 10_key_filter）。
- 教学调整：后续课程仿真环节统一用 run_sim.sh 控制台流程，不依赖 NativeLink GUI；
  自检型 testbench（PASS/FAIL 自动判定）提到第 3 课教。
