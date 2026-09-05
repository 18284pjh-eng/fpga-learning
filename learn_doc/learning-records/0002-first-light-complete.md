# LR-0002: 第 1 课完成 + JTAG 排障记录（2026-09-05）

## 已完成

- 第 1 课「点亮 LED」通关：用户独立写完 `case/01-led/src/led.v`（初稿有 3 处标点语法错误，
  经讲解后自行修正），加文件进工程、编译成功（仅用 1/10,320 LE）、Programmer 下载、上板现象正常。
- 用户掌握了 Quartus 13.0.1 的工程界面：Project Navigator 五个标签、Tasks 编译流水线。

## 关键排障记录（wisdom，值得复习）

- **故障**：Programmer 点 Start 直接 Failed，报 `Error (211512): Can't access JTAG chain`，
  Hardware 一栏显示 "No Hardware"。
- **环境事实**：Quartus 13.0sp1 是 **Linux 原生版**（`/tool/altera/13.0sp1/quartus/linux64/`），非 Wine；
  `jtagd` 已随 Quartus 启动。
- **根因**：USB-Blaster（`09fb:6001`）被内核识别，但 `/dev/bus/usb/*` 节点属 root:root，
  普通用户无写权限 → `jtagconfig` 报 `Unable to lock chain (Insufficient port permissions)`。
- **修复**：加 udev 规则 `51-usb-blaster.rules`（MODE="0666"）→ `udevadm control --reload-rules` +
  `trigger` → 重插 → `jtagconfig` 输出 `020F10DD EP3C(10|5)/EP4CE(10|6)` → Programmer 里选 USB-Blaster。
- **教学价值**：这是用户的第一个"工具链环境"类故障，排障路径
  （Messages 报错 → lsusb → jtagconfig → 权限）已在第 2 课复习题中复用。

## 代码习惯观察

- 用户第一稿把端口列表的大括号/分号用法带偏（C 风格残留），语法层面需要继续纠偏。
- 端口命名与模块同名（led 模块 + led 端口），已建议改为 led_out 与官方规范一致。
- 用户自建了 `src/` 目录而非官方的 `rtl/`——尊重其偏好，不做强制，仅保持一致性提醒。

## 下一课

- 第 2 课已发布：`lessons/0002-blink-and-simulate.html`（时钟/计数器/时序逻辑 + ModelSim 仿真，
  对应书第 15/17 章，官方例程 08_counter）。
- 待用户回报现象后记入 LR-0003。第 3 课预设：按键消抖（书按键消抖章节，官方 10_key_filter）。
