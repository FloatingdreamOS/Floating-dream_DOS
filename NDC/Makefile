#Floating dream-DOS
#Copyright © 2022 Floatingdream All Rights Reserved.
#floatingdream.vxz.vin
TOOLPATH = E:/TOOLS/
AUTOEXECPATH = ../NDC
OUTPATH = ../MIS/
IMGPATH = ../Build/
SYSPATH = ../SYS/

NASM	= $(TOOLPATH)nasm.exe
MAKE	= $(TOOLPATH)make.exe -r
EDIMG	= $(TOOLPATH)edimg.exe
# 默认

default:
	$(MAKE) BOOT.SYS
	$(MAKE) LOADER.SYS
	$(MAKE) SYS_DOS.SYS
	$(MAKE) SYS_DOS.DRE


#系统可执行程序
#系统内核文件
%.SYS: %.ASM Makefile
	$(NASM) $*.ASM -o $(OUTPATH)$*.SYS
#可执行程序(Beta)
%.DRE: %.ASM Makefile
	$(NASM) $*.ASM -o $(OUTPATH)$*.DRE