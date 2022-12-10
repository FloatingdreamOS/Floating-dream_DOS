#Floating dream-DOS
#Copyright © 2022 Floatingdream All Rights Reserved.
#floatingdream.vxz.vin
#Floating dream_DOS-Makefile

TOOLPATH = E:/TOOLS/
NDCPATH = ./NDC/
OUTPATH = ./MIS/
IMGPATH = ./Build/
SYSPATH = ./SYS/

NASM	= $(TOOLPATH)nasm.exe
MAKE	= $(TOOLPATH)make.exe -r
EDIMG	= $(TOOLPATH)edimg.exe
FATTOOLS = $(TOOLPATH)fat12tools.exe -file $(IMGPATH)Floatingdream_DOS_3_3-LiveCD.img
MKDIR	= mkdir
COPY	= copy

# 默认

default:
	$(MAKE) Floatingdream_DOS_3_3-LiveCD.img

build:
	$(MKDIR) build

#run:
#如果有qemu，那就可以运行此命令
#	qemu-system-x86_64 -fda ./Build/Floatingdream_DOS_3_3-LiveCD.img -m 164

all:
	$(MAKE) -C $(CGHPATH)
	$(MAKE) -C $(SYSPATH)
	$(MAKE) -C $(NDCPATH)

clean:
	$(MAKE) -C $(OUTPATH) clean

Floatingdream_DOS_3_3-LiveCD.img : 
	$(EDIMG) imgin:E:/TOOLS/fdimg0at.tek \
		wbinimg src:$(OUTPATH)BOOT.SYS len:1024 from:0 to:0 \
		copy from:$(OUTPATH)LOADER.SYS to:@: \
		copy from:$(OUTPATH)SYS_DOS.SYS to:@: \
		copy from:$(NDCPATH)AUTOEXEC.BAT to:@: \
		imgout:$(IMGPATH)Floatingdream_DOS_3_3_Beta_2-LiveCD.img