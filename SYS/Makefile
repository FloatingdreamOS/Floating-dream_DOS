#Floating dream-DOS
#Copyright © 2022 Floatingdream All Rights Reserved.
#floatingdream.vxz.vin
TOOLPATH = E:/TOOLS/
OUTPATH = ../MIS/

NASM	= $(TOOLPATH)nasm.exe
MAKE	= $(TOOLPATH)make.exe -r

default:
	$(MAKE)	DATA.SYS

%.SYS: %.ASM Makefile
	$(NASM) $*.ASM -o $(OUTPATH)$*.SYS
