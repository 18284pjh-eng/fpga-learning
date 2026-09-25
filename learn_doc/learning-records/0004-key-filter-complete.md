# LR-0004: 第 3 课按键消抖 + Makefile 完成（2026-09-13）

## 已完成

- 第 3 课按键消抖 RTL 完成并完成仿真验证。
- 理解 `key_ff1`、`key_ff2`、`key_prev`、`key_stable` 的同步、消抖和边沿检测职责。
- 完成 `tb_key_filter.sv`，使用 `$urandom_range` 生成按键抖动激励。
- 完成 Makefile 仿真流程：`vlib` 建库、`vlog` 编译、`vsim` 命令行运行、VCD 波形生成，以及 `make wave` / `make clean`。
- 理解 `parameter`、`automatic task`、`.PHONY` 和 ModelSim 中间编译库 `work/` 的作用。

## 第 4 课起点

- 进入状态机 FSM：用状态、转移和计时区分短按与长按。
- 延续命令行优先方式，使用 Makefile 驱动仿真和 Quartus 编译，GUI 只用于必要的核对、波形和下载观察。
