#Floating dream-DOS
#Copyright © 2022 Floatingdream All Rights Reserved.
#floatingdream.vxz.vin
TOOLPATH = E:/TOOLS/
OUTPATH = ../MIS/

NASM	= $(TOOLPATH)nasm.exe
MAKE	= $(TOOLPATH)make.exe -r
EDIMG	= $(TOOLPATH)edimg.exe
COPY	= copy
DEL		= del

# 默认

default:
	$(MAKE)	DATA.SYS

# 生成规则

%.SYS: %.ASM Makefile
	$(NASM) $*.ASM -o $(OUTPATH)$*.SYS
