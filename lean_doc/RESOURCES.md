# RESOURCES

本地资料（均在 `/home/pjh/project/fpga_learning/` 下）：

## 主教材（Primary Source）

- **《FPGA Verilog 开发实战指南——基于 Altera EP4CE10》**（野火官方，征途 Pro 配套）
  - 上册：`2-野火开源图书合集（源代码以及文档）/征途Pro/征途Pro《FPGA Verilog开发实战指南——基于Altera EP4CE10》2021.7.10（上）.pdf`
  - 下册：同目录（下）.pdf
  - 结构：75 章，硬件说明篇→软件安装篇→基础入门篇→学习强化篇→进阶提高篇。
  - **第 9 章「点亮你的 LED 灯」是第一个完整工程实验**（当前学习位置）。
  - 官方例程代码：`2-野火开源图书合集（源代码以及文档）/征途Pro/01_led/`（rtl/sim/quartus_prj 齐全）。

## 硬件资料

- `1-开发板原理图_封装库_尺寸图_硬件手册/EBF EP4CE10 Pro/征途_PRO_EBF410202v1_SCH_20230915_原理图.pdf` — 原理图（查按键/LED 电路用）
- `1-开发板原理图_封装库_尺寸图_硬件手册/[野火]征途_Pro开发板硬件规格书V1.0.1.pdf` — 硬件规格书
- `1-开发板原理图_封装库_尺寸图_硬件手册/征途引脚绑定映射表.xlsx` — 引脚分配速查
- 板卡要点：EP4CE10F17C8N，50MHz 晶振，16Mbit SPI Flash，256Mbit SDRAM，
  4 个 LED（低电平点亮）、4 个独立按键、1 个有源蜂鸣器、6 位数码管等。

## 参考工具书（`4-推荐参考资料/`）

- 1-数字电路：《数字电子技术基础》（阎石）、《零起步轻松学数字电路》
- 2-Verilog 语法：《Verilog数字系统设计教程》《设计与验证：Verilog HDL》
- 3-FPGA 开发流程：《FPGA设计指南：器件、工具和流程》
- 5-ModelSim 仿真：《ModelSim电子系统分析及仿真》
- 7-IEEE 官方：《IEEE Standard Verilog HDL (1364)》

## 上电测试程序

- `0-征途开发板上电测试程序/征途Pro开发板上电测试.rar` — 验证板卡硬件好坏

## 在线资源 / 社区（Wisdom）

- 野火论坛：https://www.firebbs.cn — 野火官方社区，提问、搜历史帖（首选社区）
- 野火文档中心（FPGA 系列）：https://doc.embedfire.com — 书的在线版，可搜索
- Intel/Altera 官方文档：Cyclone IV Device Handbook（本地 `4-推荐参考资料/6-.../` 已有中文版）

## 环境备注

- 用户工程：`test/01_led/`（自建练习工程，Quartus 13.0.1 32-bit，EP4CE10F17C8）。
- Quartus 13.0.1 为野火教程指定版本（Web Edition 免费，支持 Cyclone IV）。
