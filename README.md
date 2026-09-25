# FPGA Learning

这是基于野火征途 Pro（Cyclone IV EP4CE10F17C8N）的 FPGA 学习仓库。

## 从哪里开始

- [课程总览](test/learn_doc/index.html)
- [学习目标](test/learn_doc/MISSION.md)
- [资源清单](test/learn_doc/RESOURCES.md)
- [第 3 课完成记录](test/learn_doc/learning-records/0004-key-filter-complete.md)
- [第 4 课：状态机 FSM](test/learn_doc/lessons/0004-fsm.html)

## 目录

```text
test/
├── case/       每课的 RTL、testbench、Makefile 和 Quartus 工程
└── learn_doc/  课程页面、学习记录和参考卡
```

仿真优先使用命令行和 Makefile。例如第 3 课：

```bash
cd test/case/03-key-filter/sim
make sim
make wave
make clean
```

工具链路径按本机 Quartus II 13.0sp1 / ModelSim-Altera 安装位置配置。开发板引脚和教材资料见 `test/learn_doc/RESOURCES.md`。

## 本地资料

教材 PDF、原理图、硬件手册和官方例程保留在本地资料目录中，没有纳入 Git；它们体积较大或带有发行资料，不适合直接上传到这个学习仓库。课程文档只引用这些资料的本地路径。
