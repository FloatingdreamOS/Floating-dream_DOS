;Floating dream-DOS
;Copyright © 2022 Floatingdream All Rights Reserved.
;Floppy Disk Drive
;引导程序\2022.10.31
NUMSECTOR   EQU     18      ;设置读取到的软盘最大扇区编号
NUMHEADER   EQU     1       ;设置读取到的软盘最大磁头编号
NUMCYLIND   EQU     10      ;设置读取到的软盘柱面编号
BOOTSEG     EQU     7c0h    ;定义了一个常量
DATASEG     EQU     800h    ;DATASEG数据段; 
BOOTINFOSEG EQU     7e0h    ;启动数据

JMP SHORT   START
;软盘
    DB  0x90
    DB  "DREAMDOS"  ; 启动区的名称是任意的字符串，八个字节
    DW  512         ; 每个扇区的大小（必须为512），占用2个字节
    DB  1           ; 簇的大小（必须为一个扇区）
    DW  1           ; FAT的起始位置
    DB  2           ; FAT的个数
    DW  224         ; 根目录的大小
    DW  2880        ; 该磁盘的大小
    DB  0xf0        ; 该磁盘的种类
    DW  9           ; FAT的长度
    DW  18          ; 磁道1有几个扇区
    DW  2           ; 磁头数
    DD  0           ; 不使用分区，必须为0
    DD  2880        ; 重写磁盘大小
    DB  0,0,0x29    ; 固定内容
    DD  0xffffffff  ; 卷帙号码
    DB  "FLOATINGDREAMDOS"  
    DB  "FAT32   "  ;FAT32：文件系统类型
START:
;寄存器：
;AX--accumulator,累加寄存器----------|________
;CX--counter, 计数寄存器-------------|________\_____通用寄存器
;DX--data,数据寄存器-----------------|____/
;BX--base, 基址寄存器----------------|___/
;SP--stack pointer,栈指针寄存器
;BP--base pointer, 基址指针寄存器
;SI--source index, 源变址寄存器
;DI--destination index，目的变址寄存器
;八个八位寄存器：
;AL--累加寄存器低位( accumulator low)
;CL--计数寄存器低位( counter low )
;DL--数据寄存器低位( data low )
;BL--基址寄存器低位( base low)
;AH--累加寄存器高位( accumulator high )
;CH--计数寄存器高位( counter high)
;DH--数据寄存器高位( data high)
;BH--基址寄存器高位( base high)
;段寄存器:
;ES--附加段寄存器( extra segment)
;CS--代码段寄存器( code segment )
;SS--栈段寄存器( stack segment )
;DS--数据段寄存器( data segment)
;FS--没有名称( segment part2)
;GS--没有名称( segment part3 )
    MOV AX,BOOTSEG  ;将 BOOTSEG的值赋到AX，相当于AX=BOOTSEG
    MOV DS,AX       ;AX寄存器的值赋到DS数据段寄存器
    MOV AX,DATASEG  ;DATASEG赋值到AX寄存器
    MOV ES,AX       ;AX寄存器的值赋到ES寄存器

    MOV SI,STARTPUT ;STARTPUT->SI
    CALL    PUTSTR  

    CALL    FLOPPYLOAD  ;调用软盘
    CALL    FINDLOADER  

    MOV     AX,BOOTINFOSEG  ;BOOTINFOSEG->AX
    MOV     ES,AX           ;AX->ES
    MOV     BYTE[ES:0],'[' 
    MOV     BYTE[ES:1],0x00

    CALL    NEWLINE
    CALL    NEWLINE

    JMP FAR [LOADERSEG]

FLOPPYLOAD:
;调用软盘
    CALL    READ1SECTOR
    MOV AX,ES                       ;ES->AX
    ADD AX,20h                      ;20h+AX
    MOV ES,AX                       ;AX->ES
    INC BYTE[SECTOR]
    CMP BYTE[SECTOR],NUMSECTOR+1
    JNE FLOPPYLOAD
    MOV BYTE[SECTOR],1
    INC BYTE[HEADER]
    CMP BYTE[HEADER],NUMHEADER+1
    JNE FLOPPYLOAD
    MOV BYTE[HEADER],0
    INC BYTE[CYLIND]
    CMP BYTE[CYLIND],NUMCYLIND
    JNE FLOPPYLOAD

    RET

READ1SECTOR:
    MOV CH,[CYLIND]
    MOV DH,[HEADER]
    MOV CL,[SECTOR]

    MOV DI,0
.RETRY:
    MOV AH,02h
    MOV AL,1
    MOV BX,0
    MOV DL,00h
    INT 13h
    JNC .READOK
    INC DI
    MOV AH,00h
    MOV DL,00h
    INT 13h
    CMP DI,5
    JNE .RETRY

.READOK:
    RET

FINDLOADER:
    MOV AX,0a60h
    MOV ES,AX
    MOV SI,0
    MOV CX,11
.CMP:
    MOV AL,[ES:SI]
    MOV AH,[LOADERBIN+SI]
    CMP AL,AH
    JNE .NEXTFILE
    INC SI
    LOOP    .CMP
    MOV AX,ES
    ADD AX,1h
    MOV ES,AX
    MOV CX,[ES:10]
    SUB AX,AX
.MUL:
    ADD AX,20h
    LOOP    .MUL
    ADD AX,0be0h
    MOV [LOADERSEG+2],AL
    MOV [LOADERSEG+3],AH
    RET
.NEXTFILE:
    MOV AX,ES
    ADD AX,2h
    MOV ES,AX
    SUB SI,SI
    MOV AL,[ES:SI]
    CMP AL,0
    JE  .END
    MOV CX,11
    JMP .CMP
.END:
    CALL    NEWLINE
    MOV SI,ERRORMSG
    MOV AH, 09H			; DRAW WHITE BAR AT TOP
	MOV BH, 0
	MOV CX, 10000
	MOV BL, 00011111b
	MOV AL, ' '
	INT 10H				;
    CALL    PUTSTR
    JMP $

PUTSTR:
    MOV AL,[SI]
    CMP AL,'$'
    JE .END
    MOV AH,0eh
    INT 10h
    INC SI
    JMP PUTSTR
.END:
    RET

NEWLINE:
    MOV AH,0eh
    MOV AL,0dh
    INT 10h
    MOV AL,0ah
    INT 10h
    RET

;----------------------------------------------------------
;字符串
STARTPUT    DB  'Starting Floating dream_DOS...','$'
LOADERBIN   DB  'LOADER  SYS'
CYLIND      DB  0
HEADER      DB  0
SECTOR      DB  1
ERRORMSG:
;DB  'Boot Error: NO LOADER.BIN IN DRIVE F.','$';0xc0000098
            DB	':( STOP!',0DH,0AH
			DB	':( System is Error!',0DH,0AH
            DB	' ',0DH,0AH
			DB	'***Missing files: LOADER.SYS',0DH,0AH
			DB	' ',0DH,0AH
			DB	'STATUS_IMAGE_CHECKSUM_MISMATCH',0DH,0AH
            DB  'PROCESS1_INITIALIZATION_FAILED',0DH,0AH
			DB	'TRAP_CAUSE_UNKNOWN',0DH,0AH
			DB  ' ',0DH,0AH
			DB  '*** STOP: 0xc0000221',0DH,0AH
            DB  '*** STOP: 0x0000006B',0DH,0AH
			DB	'*** STOP: 0X00000012',0DH,0AH
			DB	'Terms of settlement: Please contact the system publisher for solutions!',0DH,0AH
			DB  '',0DH,0AH
            DB  'BLUE SCREEN VERSION:0.61',0DH,0AH,0
LOADERSEG   DB  0,0,0,0
TIMES   750-($-$$)  DB  0
DB  0x55,0xaa
