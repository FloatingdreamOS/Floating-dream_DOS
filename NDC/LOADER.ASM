;Floating dream-DOS
;Copyright © 2022 Floatingdream All Rights Reserved.
;floatingdream.vxz.vin
JMP	NEAR	START
SYSTEM8SYS		DB	'SYS_DOS SYS'
ERRORMSG		;程序错误
			DB	':( STOP!',0DH,0AH
			DB	':( System is Error!',0DH,0AH
			DB	' ',0DH,0AH
			DB	'***Missing files: SYS_DOS.SYS',0DH,0AH
			DB	' ',0DH,0AH
			DB	'* STATUS_IMAGE_CHECKSUM_MISMATCH',0DH,0AH
            DB  '* PROCESS1_INITIALIZATION_FAILED',0DH,0AH
			DB	'* TRAP_CAUSE_UNKNOWN',0DH,0AH
			DB  ' ',0DH,0AH
			DB  '*** STOP: 0xc0000221',0DH,0AH
            DB  '*** STOP: 0x0000006B',0DH,0AH
			DB	'*** STOP: 0X00000012',0DH,0AH
			DB  '*** STOP: ?????????!',0DH,0AH
			DB	' ',0DH,0AH
			DB	'Terms of settlement: Please contact the system publisher for solutions!',0DH,0AH
			DB  '',0DH,0AH
			DB	' ',0DH,0AH
			DB	' ',0DH,0AH
			DB	' ',0DH,0AH
            DB  'BLUE SCREEN VERSION:0.61',0DH,0AH,0
COMMANDSEGMENT	EQU	0x3500

START:
	MOV	AX,CS
	MOV	DS,AX
	MOV	ES,AX
	
	MOV	SI,SYSTEM8SYS
	CALL	FINDFILE
	CMP	AH,0	; 返回值=0 没找到文件
	JNE	NEXT
	
	CALL	NEWLINE
	MOV	SI,ERRORMSG
	MOV AH, 09H			; DRAW WHITE BAR AT TOP
	MOV BH, 0
	MOV CX, 10000
	MOV BL, 00011111b
	MOV AL, ' '
	INT 10H				;
	CALL	PUTSTR
	JMP	$
NEXT:
	JMP	JMPFILE

FINDFILE:
; 巡查是否有指定的文件
; 寄存器：IN:SI OUT:ES/AH
; AH=1找到 AH=0未找到
	MOV	AX,0A60H
	MOV	ES,AX
	SUB	DI,DI
	MOV	CX,11
.LOOP:
	MOV	AH,[SI]
	MOV	AL,[ES:DI]
	CMP	AH,AL
	JNE	.NEXT
	INC	SI
	INC	DI
	LOOP	.LOOP
	MOV	AH,1
	RET
.NEXT:
	MOV	AX,ES
	ADD	AX,2H
	MOV	ES,AX
	SUB	DI,DI
	MOV	AL,[ES:DI]
	CMP	AL,0
	JE	.END
	MOV	CX,11
	JMP	.LOOP
.END:
	MOV	AH,0
	RET

JMPFILE:
; 跳转到指定的文件地址
; 寄存器：IN:ES
	MOV	AX,ES
	ADD	AX,1H
	MOV	ES,AX
	MOV	CX,[ES:10]
	MOV	AX,0
.MUL:
	ADD	AX,20H
	LOOP	.MUL
	ADD	AX,0BE0H
	
	MOV	DS,AX
	MOV	SI,0
	MOV	AX,COMMANDSEGMENT
	MOV	ES,AX
	MOV	DI,0
	MOV	CX,0xFFFF
	CALL	MEMCPY
	JMP	DWORD COMMANDSEGMENT:0

PUTSTR:
; 打印字符串=
; 寄存器：IN:SI
	MOV	AL,[SI]
	CMP	AL,0
	JE	.END
	MOV	AH,0EH
	INT	10H
	INC	SI
	JMP	PUTSTR
.END:
	RET

NEWLINE:
; 换行
; 无寄存器
	MOV	AL,0DH
	MOV	AH,0EH
	INT	10H
	MOV	AL,0AH
	INT	10H
	RET

MEMCPY:
; 拷贝内存到某处
; 寄存器：IN:DS:SI/ES:DI/CX
	MOV	AL,[DS:SI]
	MOV	[ES:DI],AL
	INC	SI
	INC	DI
	LOOP	MEMCPY
.CPYEND:
	RET