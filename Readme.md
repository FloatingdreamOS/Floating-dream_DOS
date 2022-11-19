Floating dream_NDC是一个由汇编语言编写的16位实模式内核，可以
在此基础上构建操作系统。

目录结构：
MIS-------构建后文件生成目录（*.SYS/*.COM）
NDC-------内核目录
SYS-------系统调用目录
Build-----镜像生成目录（构建成功后）

构建内核：
1.准备构建环境：make、nasm、edimg、fat12tools等；
2.构建：在根目录打开终端，输入“make build”以创建文件夹；
3.编译：输入“make all”编译所有文件，然后“make”制作磁盘映像；
4.清理环境：“make clean”。

2022.11.13

版权：CopyriSght (C) 2022 Floatingdream All Rights Reserved.
2422586862@qq.com(Floating dream)

floatingdream-d@outlook.com

floatingdream520@qq.com
