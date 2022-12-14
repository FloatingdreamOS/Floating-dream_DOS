;FLOATING DREAM-DOS
;COPYRIGHT © 2022 FLOATINGDREAM ALL RIGHTS RESERVED.
;FLOATINGDREAM.VXZ.VIN
;所有命令/指令
%INCLUDE "../SYS/DATA.ASM"
JMP	NEAR	START
SYSTEMADDRESS	EQU		0x35000
BOOTINFOSEGMENT	EQU		7E0H
FILEINFOSEG		DB		0AH,60H
FILETYPESEG		EQU		0BE0H	; 800H+3E0H=BE0H
COPYBUFFERSEG	EQU		5500H
STACKSEG		EQU		0
STACKTOP		EQU		7C00H	; 堆栈范围0x1000 ~ 0x7C00
DATASEG			EQU		800H	; 10个柱面被读入的段地址
DATATOP			EQU		3500H	; 10个柱面数据顶部段地址
REGION			DB		0	; 起初第0区域：0~10柱面
SECTOR			DB		1		
HEADER			DB		0
CYLINE			DB		0
NUMSECTOR		EQU		18
NUMHEADER		EQU		1
NUMCYLINE		EQU		10

OLDCMDLINE		TIMES	128	DB	0
CMDLINE			TIMES	128	DB	0
FINDFILENAME	DB	'           ',0
TIMETEMP		DB	0,0,0
DATETEMP		DB	0,0,0,0
COLORTEMP		DB	0
DRIVETEMP		DW	0
ADDRESSSEGTEMP	DW	0
ADDRESSOFFTEMP	DW	0
REGEDITNUM		DB	0
AUTOEXECBAT		DB	'AUTOEXEC.BAT'
NOTAUTOEXEC		DB	'Welcome to the Floating dream_DOS',0
APPFILEHEAD		DB	'FLOATINGDREAM'
NOTAPPPUT		DB	':( STOP!',0DH,0AH
				DB	':( System is Error!',0DH,0AH
				DB	'A fatal error occurred when a software was started',0DH,0AH
				DB	' ',0DH,0AH
				DB	'Please restart to recover',0DH,0AH
				DB	' ',0DH,0AH
				DB	'TRAP_CAUSE_UNKNOWN',0DH,0AH
				DB	'KMODE_EXCEPTION_NOT_HANDLED',0DH,0AH
				DB  ' ',0DH,0AH
				DB  '*** STOP: 0x00000012',0DH,0AH
				DB	'*** STOP: 0X0000001E',0DH,0AH
				DB  '*** STOP: ?????????!',0DH,0AH
				DB	' ',0DH,0AH
				DB	' ',0DH,0AH
				DB	'                                                                   ',0DH,0AH
				DB	'Terms of settlement: Please restart to recover and Delete the wrong software!',0DH,0AH
				DB	'ERROR!*** ',0DH,0AH
				DB	'******* ',0DH,0AH
				DB	'ERROR!*** ',0DH,0AH
				DB	'ERROR!*** ',0DH,0AH
				DB  '',0DH,0AH
                DB  'BLUE SCREEN VERSION:0.61',0DH,0AH,0
DEBUGMODEPUT	DB	'[root]# ',0
LINEPUT			DB	'[user]$ ',0
BADCOM			DB	'Error instruction: No such order.',0
CLSCOM			DB	'cls'
TIMECOM			DB	'time'
TIMEMSG			DB	'??:??',0DH,0AH,0
DATECOM			DB	''
DATEMSG			DB	'',0DH,0AH,0
SHUTDOWNCOM		DB	'shutdown'
VERCOM			DB	'ver'
VERPUT:
	DB	OS_NAME,OS_VERSION,0DH,0AH
	DB	OS_KERNEL,0DH,0AH
	DB	OS_BUILD,0DH,0AH
	DB	OS_CPOY,0
DIRCOM			DB	'ls'
DIRPUT			DB	'Directory: <ls> ',0
ISDIR			DB	'       [DIR]',0
ISFIL			DB  '      <FILE>',0
ECHOCOM			DB	'echo'
TYPECOM			DB	'cat'
NOTFIND			DB	'File not find.',0
DELCOM			DB	'del'
WRITEERROR		DB	'Write floppy error.',0
READERROR		DB	'Read floppy error.',0
MKFILECOM		DB	'mkfile'
EDITCOM			DB	'edit'
CDCOM			DB	'cd'
CDPUT			DB	'Invalid directory.',0
COLORCOM		DB	'color'
COLORPUT:
	DB	'0 = BLACK     8 = GRAY',0DH,0AH
	DB	'1 = BLUE      9 = LIGHT BLUE',0DH,0AH
	DB	'2 = GREEN     A = LIGHT GREEN',0DH,0AH
	DB	'3 = AQUA      B = LIGHT AQUA',0DH,0AH
	DB	'4 = RED       C = LIGHT RED',0DH,0AH
	DB	'5 = PURPLE    D = LIGHT PURPLE',0DH,0AH
	DB	'6 = YELLOW    E = LIGHT YELLOW',0DH,0AH
	DB	'7 = WHITE     F = LIGHT WHITE',0
MKDIRCOM		DB	'mkdir'
MKDIRWRITE:
	DB	'.          ',10H
	DB	'..         ',10H
RENAMECOM		DB	'rename'
DRIVECOM		DB	'drive'
DRIVENOTREADY	DB	'Drive ? is not ready.',0
NOTTHISDRIVE	DB	'Not this drive.',0
PAUSECOM		DB	'pause'
PAUSEPUT		DB	'Press any key to continue...',0
COPYCOM			DB	'copy'
COPYFILELENGTH	DW	0
PASTECOM		DB	'paste'
CUTCOM			DB	''
ABOUTCOM		DB  'about'
;about
ABOUTPUT:
	DB  '__________________________',0DH,0AH
	DB  'About:',OS_NAME,0DH,0AH
	DB  'System version:',0DH,0AH
	DB	OS_NAME,OS_VERSION,0DH,0AH
	DB  OS_KERNEL,0DH,0AH
	DB  OS_BUILD,0DH,0AH
	DB  '__________________________',0
HELPCOM			DB  'help'
;help
HELPPUT:
	DB  '                          _________________________',0DH,0AH
	DB	'                         |Floating dream_DOS Help: |',	0DH,0AH
	DB  '                         |_________________________|',0DH,0AH
	DB  ' _____________________________________________________________________________',0DH,0AH
	DB  '|	 [ls] Displays a list of files and subdirectories of a directory            |',0DH,0AH
	DB  '|	 [cls] Clear screen                                                         |',0DH,0AH
	DB  '|	 [ver] View version number                                                  |',0DH,0AH
	DB  '|	 [about] About the system                                                   |',0DH,0AH
	DB  '|	 [echo + (character string)] Print String                                   |',0DH,0AH
	DB	'|	 [cat + (file name)] Show file contents                                     |',0DH,0AH
	DB	'|	 [del + (file name)] Delete File                                            |',0DH,0AH
	DB	'|	 [mkfile + (file name)] New file                                            |',0DH,0AH
	DB	'|	 [mkdir + (directory name)] New directory                                   |',0DH,0AH
	DB	'|	 [edit + (file name)] Edit File Content                                     |',0DH,0AH
	DB  '|	 [cd + (directory name)] Navigate to a directory                            |',0DH,0AH
	DB  '|	 [copy + (file name or directory name) copy file or directory               |',0DH,0AH
	DB	'|	 [paste + (file name or directory name)] paste file or directory            |',0DH,0AH
	DB  '|	 [rename + (file name or directory name)] File or directory renaming        |',0DH,0AH
	DB  '|	 [shutdown] Shut down the system                                            |',0DH,0AH
	DB	'|_____________________________________________________________________________|',0
; 超级用户命令
; 不常用
DEBUGCOM		DB	'root'
DEBUGFLAGS		DB	0
EXITCOM			DB	'exit'
POKECOM			DB	'poke'
POKEERROR		DB	'Poke usage error.',0
VISITCOM		DB	'visit'
VISITERROR		DB	'Visit usage error.',0
FINDCOM			DB	'find'
FINDERROR		DB	'Find usage error.',0
FINDPUT			DB	'Find data in address:&',0
FINDPAUSEPUT	DB	'press enter to continue or esc to exit...',0
;	MOV AH, 09H			; DRAW WHITE BAR AT TOP
;	MOV BH, 0
;	MOV CX, 80
;	MOV BL, 00110100b
;	MOV AL, ' '
;	INT 10H
START:
	
	MOV	AX,CS
	MOV	DS,AX
	MOV	ES,AX
	
	; 堆栈的初始化
	MOV	AX,STACKSEG
	MOV	SS,AX
	MOV	SP,STACKTOP
	
	CALL	INITSYSCALL		; 初始化系统调用中断

	; 读取BOOT INFO（0x7E00~0x8000）
	MOV	AX,BOOTINFOSEGMENT
	MOV	ES,AX
	MOV	AL,[ES:0]	; 驱动器字符
	MOV	[DRIVETEMP],AL
	MOV	AL,[ES:1]	; 驱动器号
	MOV	[DRIVETEMP+1],AL
	
	CMP	EDX,20201220H
	JE	.NOAUTOEXEC
	CALL	AUTOEXEC	; 加载AUTOEXEC.BAT为开机启动项（MS-DOS 1.x同款）
.NOAUTOEXEC:
	MOV	AL,[DRIVETEMP]
	MOV	[LINEPUT],AL
	MOV	SI,LINEPUT
    
	MOV	AH,01H
	INT	36H
	MOV	SI,0
	JMP	USRINPUT
	
AUTOEXEC:
	SUB	SI,SI
	MOV	CX,12
.LOOP:
	MOV	AL,[AUTOEXECBAT+SI]
	MOV	BYTE[CMDLINE+SI],AL
	INC	SI
	LOOP	.LOOP
	CALL	BATSEARCH	
	MOV	SI,NOTAUTOEXEC
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	INT	36H
	RET
USRINPUT:
; 将键盘输入字符打印出来
; 无寄存器
	CALL	OLDCLEANCOPY
	CALL	CLEANINPUT
.READY:
	MOV	AH,0
	INT	16H
	CMP	SI,128
	JAE	.LONG
	CMP	SI,0
	JNE	.IN
	CMP	AL,08H
	JNE	.IN
	JMP	.READY
.LONG:
; 进入这个分段SI已经超过了128
; 所以分段只提供打印 而不提供记录
	MOV	AH,0EH
	INT	10H
	CMP	AL,0DH
	JE	.ENTER
	CMP	AL,08H
	JE	.BACKSPACE
	JMP	.READY
.IN:
	CMP	AH,48H	; 上键退回上一行
	JE	.OLDCMDPUT
	MOV	AH,0EH
	INT	10H
	; 如果是回车
	CMP	AL,0DH
	JE	.ENTER
	; 如果是退格
	CMP	AL,08H
	JE	.BACKSPACE
	; 保存字符到CMDLINE中
	; （最多32字节）
	MOV	[CMDLINE+SI],AL
	INC	SI
; OS去掉注释符“ ; ”
;	MOV AH, 09H			; DRAW WHITE BAR AT TOP
;	MOV BH, 0
;	MOV CX, 0
;	MOV BL, 1111B
;	MOV AL, ' '
;	INT 10H
	JMP	.READY
.OLDCMDPUT:
	PUSH	DI
	PUSH	SI
	MOV	SI,OLDCMDLINE
	MOV	AH,01H
	INT	36H
	POP	SI
	MOV	DI,0
.CPYLOOP:
	MOV	AL,[OLDCMDLINE+DI]
	CMP	AL,0
	JE	.READY
	MOV	[CMDLINE+SI],AL
	INC	SI
	INC	DI
	JMP	.CPYLOOP
.BACKSPACE:
	; 对退格键的特殊处理
	DEC	SI
	MOV	AH,0EH
	; 空格
	MOV	AL,20H
	INT	10H
	; 退格
	MOV	AL,08H
	INT	10H
	MOV	BYTE[CMDLINE+SI],0
	JMP	.READY
.ENTER:
	; 对回车键的特殊处理
	MOV	AH,02H
	INT	36H
	CMP	BYTE[CMDLINE],0	; 有输入
	JNE	.HAVEINPUT
	MOV	AL,[DRIVETEMP]	; 没输入
	MOV	[LINEPUT],AL
	MOV	SI,LINEPUT
	MOV	AH,01H
	INT	36H
	MOV	SI,0
	JMP	.READY
.HAVEINPUT:
	CALL	APPSEARCH
	CALL	BATSEARCH
	CALL	COMMAND
	MOV	AH,02H
	INT	36H
	CMP	BYTE[DEBUGFLAGS],1
	JE	.DEBUGMODE
	MOV	AL,[DRIVETEMP]
	MOV	[LINEPUT],AL
	MOV	SI,LINEPUT
; OS去掉注释符“ ; ”
;	MOV AH, 09H			; DRAW WHITE BAR AT TOP
;	MOV BH, 0
;	MOV CX, 22
;	MOV BL, 1111B
;	MOV AL, ' '
;	INT 10H
	MOV	AH,01H
	INT	36H
	JMP	.PUTOK
.DEBUGMODE:
	MOV	SI,DEBUGMODEPUT
	MOV	AH,01H
	INT	36H
.PUTOK:
	MOV	SI,0
	JMP USRINPUT

COMMAND:
; 命令识别与执行
; 无寄存器
.LOP1R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,3
.LOP1:
	; CLS命令的判断
	MOV	AH,[CLSCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP2R
	INC	SI
	LOOP	.LOP1
	JMP	CLS
.LOP2R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,4
.LOP2:
	; TIME命令的判断
	MOV	AH,[TIMECOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP3R
	INC	SI
	LOOP	.LOP2
	JMP	TIME
.LOP3R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,4
.LOP3:
	; DATE命令的判断
	MOV	AH,[DATECOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP4R
	INC	SI
	LOOP	.LOP3
	JMP	DATE
.LOP4R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,8
.LOP4:
	; SHUTDOWN命令的判断
	MOV	AH,[SHUTDOWNCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP5R
	INC	SI
	LOOP	.LOP4
	JMP	SHUTDOWN
.LOP5R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,3
.LOP5:
	; VER命令的判断
	MOV	AH,[VERCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP6R
	INC	SI
	LOOP	.LOP5
	JMP	VER
.LOP6R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,2
.LOP6:
	; LS命令的判断
	MOV	AH,[DIRCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP7R
	INC	SI
	LOOP	.LOP6
	JMP	DIR
.LOP7R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,4
.LOP7:
	; ECHO命令的判断
	MOV	AH,[ECHOCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP8R
	INC	SI
	LOOP	.LOP7
	JMP	ECHO
.LOP8R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,3
.LOP8:
	; TYPE命令的判断
	MOV	AH,[TYPECOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP9R
	INC	SI
	LOOP	.LOP8
	JMP	TYPE
.LOP9R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,3
.LOP9:
	; DEL命令的判断
	MOV	AH,[DELCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP10R
	INC	SI
	LOOP	.LOP9
	JMP	DEL
.LOP10R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,6
.LOP10:
	; MKFILE命令的判断
	MOV	AH,[MKFILECOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP11R
	INC	SI
	LOOP	.LOP10
	JMP	MKFILE
.LOP11R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,4
.LOP11:
	; EDIT命令的判断
	MOV	AH,[EDITCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP12R
	INC	SI
	LOOP	.LOP11
	JMP	EDIT
.LOP12R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,2
.LOP12:
	; CD命令的判断
	MOV	AH,[CDCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP13R
	INC	SI
	LOOP	.LOP12
	JMP	CD
.LOP13R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,5
.LOP13:
	; COLOR命令的判断
	MOV	AH,[COLORCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP14R
	INC	SI
	LOOP	.LOP13
	JMP	COLOR
.LOP14R:
	MOV	SI,0
	MOV	CX,5
.LOP14:
	; MKDIR命令的判断
	MOV	AH,[MKDIRCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP15R
	INC	SI
	LOOP	.LOP14
	JMP	MKDIR
.LOP15R:
	MOV	SI,0
	MOV	CX,5
.LOP15:
	; DEBUG命令的判断
	MOV	AH,[DEBUGCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP16R
	INC	SI
	LOOP	.LOP15
	MOV	BYTE[DEBUGFLAGS],1
	RET
.LOP16R:
	MOV	SI,0
	MOV	CX,6
.LOP16:
	; RENAME命令的判断
	MOV	AH,[RENAMECOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP17R
	INC	SI
	LOOP	.LOP16
	JMP	RENAME
.LOP17R:
	MOV	SI,0
	MOV	CX,5
.LOP17:
	; DRIVE命令的判断
	MOV	AH,[DRIVECOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP18R
	INC	SI
	LOOP	.LOP17
	JMP	DRIVE
.LOP18R:
	MOV	SI,0
	MOV	CX,5
.LOP18:
	; PAUSE命令的判断
	MOV	AH,[PAUSECOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP19R
	INC	SI
	LOOP	.LOP18
	JMP	CPAUSE
.LOP19R:
	MOV	SI,0
	MOV	CX,4
.LOP19:
	; COPY命令的判断
	MOV	AH,[COPYCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP20R
	INC	SI
	LOOP	.LOP19
	JMP	COPY
.LOP20R:
	MOV	SI,0
	MOV	CX,5
.LOP20:
	; PASTE命令的判断
	MOV	AH,[PASTECOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP21R
	INC	SI
	LOOP	.LOP20
	JMP	PASTE
.LOP21R:
	; 清空缓冲区
	MOV	SI,0
	MOV	CX,5
.LOP21:
	; ABOUT命令的判断
	MOV	AH,[ABOUTCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.LOP22R
	INC	SI
	LOOP	.LOP21
	JMP	ABOUT
.LOP22R:
	MOV SI,0
	MOV CX,3
.LOP22:
	MOV AH,[HELPCOM+SI]
	MOV AL,[CMDLINE+SI]
	CMP AH,AL
	JNE .END
	INC SI
	LOOP	.LOP22
	JMP HELP
.DE1R:
	MOV	SI,0
	MOV	CX,4
.DE1:
	; EXIT命令的判断
	MOV	AH,[EXITCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.DE2R
	INC	SI
	LOOP	.DE1
	MOV	BYTE[DEBUGFLAGS],0
	RET
.DE2R:
	MOV	SI,0
	MOV	CX,4
.DE2:
	; POKE命令的判断
	MOV	AH,[POKECOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.DE3R
	INC	SI
	LOOP	.DE2
	JMP	POKE
.DE3R:
	MOV	SI,0
	MOV	CX,5
.DE3:
	; VISIT命令的判断
	MOV	AH,[VISITCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.DE4R
	INC	SI
	LOOP	.DE3
	JMP	VISIT
.DE4R:
	MOV	SI,0
	MOV	CX,4
.DE4:
	; FIND命令的判断
	MOV	AH,[FINDCOM+SI]
	MOV	AL,[CMDLINE+SI]
	CMP	AH,AL
	JNE	.NOCOM
	INC	SI
	LOOP	.DE4
	JMP	FIND
.END:
	CMP	BYTE[DEBUGFLAGS],1	; 如果进入了调试模式
	JE	.DE1R
.NOCOM:
	; 无命令执行
	MOV	SI,BADCOM
	MOV AH, 09H			; DRAW WHITE BAR AT TOP
	MOV BH, 0
	MOV CX, 33
	MOV BL, 00001100B
	INT 10H
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

CLS:
	; CLS命令执行
	MOV	AH,00H
	MOV	AL,03H
	INT	10H
	RET

TIME:
	; TIME命令执行
	MOV	SI,TIMETEMP
	MOV	AH,04H
	INT	36H
	MOV	SI,0
	MOV	DI,10
	MOV	CX,3
.LOOP:
	MOV	DH,[TIMETEMP+SI]
	MOV	DL,[TIMETEMP+SI]
	SHR	DH,4
	AND	DL,0FH
	ADD	DH,30H
	ADD	DL,30H
	MOV	[TIMEMSG+DI],DH
	INC	DI
	MOV	[TIMEMSG+DI],DL
	INC	SI
	ADD	DI,2
	LOOP	.LOOP
	
	; 输出结果到屏幕上
	MOV	SI,TIMEMSG
	MOV	AH,01H
	INT	36H
	RET

DATE:
	; DATA命令执行
	MOV	SI,DATETEMP
	MOV	AH,05H
	INT	36H
	MOV	SI,0
	MOV	DI,10
	MOV	CX,4
.LOOP:
	MOV	DH,[DATETEMP+SI]
	MOV	DL,[DATETEMP+SI]
	SHR	DH,4
	AND	DL,0FH
	ADD	DH,30H
	ADD	DL,30H
	MOV	[DATEMSG+DI],DH
	INC	DI
	MOV	[DATEMSG+DI],DL
	INC	SI
	CMP	CX,4
	JE	.INC1
	INC	DI
.INC1:
	INC	DI
	LOOP	.LOOP
	
	; 输出结果到屏幕上
	MOV	SI,DATEMSG
	MOV	AH,01H
	INT	36H
	RET

SHUTDOWN:
	; SHUTDOWN命令执行
	; 利用BIOS中断关机
	MOV	AX,5301H
	XOR	BX,BX
	INT	15H
	MOV	AX,530EH
	MOV	CX,0102H
	INT	15H
	MOV	AX,5307H
	MOV	BL,01H
	MOV	CX,0003H
	INT	15H
	RET

VER:
	; VER命令执行
	MOV	AH,02H
	INT	36H
	MOV	SI,VERPUT
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

DIR:
	; DIR命令执行
	; 规律：每2H循环文件名
	; 文件属性：20H为文件 10H为目录
	; DIR命令执行
	; 规律：每2H循环文件名
	; 文件属性：20H为文件 10H为目录
	MOV	AL,[DRIVETEMP]
	MOV	[DIRPUT+19],AL
	MOV	SI,DIRPUT
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	MOV	AH,[FILEINFOSEG]	; 文件信息段地址
	MOV	AL,[FILEINFOSEG+1]
	MOV	ES,AX
	MOV	SI,0
.TRY:
	MOV	CX,12
	MOV	AH,02H
	INT	36H
.PUT:
	MOV	AL,[ES:SI]
	CMP	AL,10H		; 文件属性是目录
	JE	.DIR
	MOV	AH,0EH
	INT	10H
	INC	SI
	LOOP	.PUT
.LOP:
	MOV	AX,ES
	ADD	AX,2H	; 给ES加上2H
	MOV	ES,AX
	MOV	SI,0
	MOV	AL,[ES:SI]
	CMP	AL,0	; 如果[ES:SI]处为0
	JE	.RET	; 就结束
	CMP	AL,0xE5	; 如果文件被删除（开头为0xE5）
	JE	.LOP	; 判断下一个文件是否存在
	JMP	.TRY
.DIR:
	MOV	SI,ISDIR
	MOV	AH,01H
	INT	36H
	JMP	.LOP
.FIL:
	MOV SI,ISFIL
	MOV AH,01H
	INT 36H
	JMP .LOP
.RET:
	MOV	AH,02H
	INT	36H
	RET

ECHO:
	; ECHO命令的执行 
	MOV	DI,5
.TRY:
	MOV	AL,[CMDLINE+DI]
	CMP	AL,0
	JE	.RET
	MOV	AH,0EH
	INT	10H
	INC	DI
	JMP .TRY
.RET:
	MOV	AH,02H
	INT	36H
	RET

TYPE:
	; TYPE命令的执行
	MOV	SI,4	; 'CAT '占4字节 文件名是从5字节开始的
	MOV	DH,20H
	CALL	FILENAMECPY
	
	MOV	AH,[FILEINFOSEG]
	MOV	AL,[FILEINFOSEG+1]
	MOV	ES,AX
	MOV	SI,FINDFILENAME
	MOV	AH,06H
	INT	36H	; 寻找文件
	
	CMP	BX,0
	JE	.RET
	CMP	DX,0
	JE	.RET
	ADD	BX,1H
	MOV	ES,BX	; 将文件信息段地址赋值给ES
	MOV	CX,[ES:12]
	CMP	CX,0
	JE	.LENGTHZERO
	MOV	ES,DX	; 将文件内容段地址赋值给ES
	MOV	SI,0
.PUT:
	MOV	AL,[ES:SI]
	MOV	AH,0EH
	INT	10H
	INC	SI
	LOOP	.PUT
.LENGTHZERO:
	RET
.RET:
	MOV	SI,NOTFIND
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

DEL:
	; DEL命令执行
	; 利用INT13H读写删除文件
	MOV	SI,4
	MOV	DH,20H
	CALL	FILENAMECPY
	
	MOV	AH,[FILEINFOSEG]
	MOV	AL,[FILEINFOSEG+1]
	MOV	ES,AX
	MOV	SI,FINDFILENAME
	MOV	AH,06H
	INT	36H
	
	CMP	BX,0
	JE	.RET
	MOV	ES,BX
.DELING:
	MOV	BYTE[ES:0],0xE5	; 把文件的第1字节写成0xE5 造成“删除”（内存）
	CALL	DISKREST
	RET
.RET:
	MOV	SI,NOTFIND
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

MKFILE:
	; MKFILE命令执行
	MOV	AH,[FILEINFOSEG]
	MOV	AL,[FILEINFOSEG+1]
	MOV	ES,AX
	MOV	AH,07H
	INT	36H	; 先寻找空位
	MOV	ES,BX
	
	MOV	SI,7
	MOV	DH,20H
	CALL	FILENAMECPY

	MOV	CX,12
	MOV	SI,0
.LOOP:
	MOV	AL,[FINDFILENAME+SI]
	MOV	[ES:SI],AL
	INC	SI
	LOOP	.LOOP
	
	PUSH	ES
	MOV	AX,ES
	SUB	AX,1H
	MOV	ES,AX	; 寻找上个文件的簇和长度
	
	MOV	AX,[ES:12]
	MOV	CX,1
.DIV:
	CMP	AX,200H
	JB	.NEXT
	SUB	AX,200H
	INC	CX
	JMP	.DIV
.NEXT:
	MOV	AX,[ES:10]
	ADD	CX,AX
	POP	ES
	MOV	[ES:0x10+10],CX
	CALL	DISKREST
	RET

EDIT:
	; EDIT命令执行
	MOV	SI,5
	MOV	DH,20H
	CALL	FILENAMECPY
	
	MOV	AH,[FILEINFOSEG]
	MOV	AL,[FILEINFOSEG+1]
	MOV	ES,AX
	MOV	SI,FINDFILENAME
	MOV	AH,06H
	INT	36H
	
	CMP	BX,0
	JE	.RET
	CMP	DX,0
	JE	.RET
	MOV	ES,DX
	PUSH	BX
	MOV	SI,0
.INPUT:
	MOV	AH,0
	INT	16H
	CMP	AL,1BH
	JE	.INPUTEND
	CMP	AL,0DH
	JE	.ENTER	; 如果输入的是换行
	MOV	AH,0EH
	INT	10H
	CMP	AL,08H
	JE	.BACKSPACE
	MOV	BYTE[ES:SI],AL
	INC	SI
	JMP	.INPUT
.ENTER:
	MOV	AH,02H
	INT	36H
	MOV	WORD[ES:SI],0A0DH	; 将0DH,0AH（换行）写入[ES:SI]处
	ADD	SI,2	; 一个WORD占2字节
	JMP	.INPUT
.BACKSPACE:
	DEC	SI
	MOV	AH,0EH
	MOV	AL,20H
	INT	10H
	MOV	AL,08H
	INT	10H
	MOV	BYTE[ES:SI],0
	JMP	.INPUT
.INPUTEND:
	MOV	AH,02H
	INT	36H
	POP	BX
	ADD	BX,1H
	MOV	ES,BX
	MOV	WORD[ES:12],SI	; 将文件长度赋值
	CALL	DISKREST
	RET
.RET:
	MOV	SI,NOTFIND
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

CD:
	; CD命令执行
	MOV	SI,3
	MOV	DH,10H
	CALL	FILENAMECPY
	
	MOV	AH,[FILEINFOSEG]
	MOV	AL,[FILEINFOSEG+1]
	MOV	ES,AX
	MOV	SI,FINDFILENAME
	MOV	AH,06H
	INT	36H
	
	CMP	BX,0
	JE	.RET
	CMP	DX,0
	JE	.RET
	
	ADD	BX,1H
	MOV	ES,BX
	CMP	WORD[ES:10],0
	JE	.FATHER
	
	MOV	[FILEINFOSEG],DH	; 更改文件目录地址
	MOV	[FILEINFOSEG+1],DL
	RET
.FATHER:	; 根目录
	MOV	BYTE[FILEINFOSEG],0AH
	MOV	BYTE[FILEINFOSEG+1],60H
	RET
.RET:
	MOV	SI,CDPUT
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

COLOR:
	; COLOR命令执行
	MOV	AL,[CMDLINE+6]
	CMP	AL,0
	JE	.ERROR
	AND	AL,11011111B
	CMP	AL,'F'
	JG	.ERROR
	CMP	AL,'9'
	JG	.LETTER
	SUB	AL,30H	; 1~9 ASCII码 转化数字
	JMP	.NEXT
.LETTER:
	SUB	AL,37H	; A~F ASCII码 转化数字
.NEXT:
	MOV	CL,4
	SHL	AL,CL
	MOV	[COLORTEMP],AL
	MOV	AL,[CMDLINE+7]
	CMP	AL,0
	JE	.ZERO
	AND	AL,11011111B
	CMP	AL,'F'
	JG	.ERROR
	CMP	AL,'9'
	JG	.LETTER2
	SUB	AL,30H
	JMP	.NEXT2
.LETTER2:
	SUB	AL,37H
.NEXT2:
	MOV	AH,[COLORTEMP]
	ADD	AH,AL
	MOV	[COLORTEMP],AH
	JMP	.PAINTSCREEN
.ZERO:
	MOV	AL,[COLORTEMP]
	MOV	CL,4
	SHR	AL,CL
	MOV	[COLORTEMP],AL
.PAINTSCREEN:
	MOV	AX,0B800H	; 显存地址
	MOV	ES,AX
	MOV	SI,1
	MOV	AH,[COLORTEMP]
	MOV	CX,25*80
.PAINTLOOP:
	MOV	[ES:SI],AH
	ADD	SI,2
	LOOP	.PAINTLOOP
	RET
.ERROR:
	MOV	SI,COLORPUT
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

MKDIR:
	; MKDIR命令执行
	MOV	AH,[FILEINFOSEG]
	MOV	AL,[FILEINFOSEG+1]
	MOV	ES,AX
	MOV	AH,07H
	INT	36H
.FINDEND:
	MOV	SI,6
	MOV	DI,0
	MOV	CX,11
	MOV	ES,BX
.WRITELOOP1:	
	MOV	BYTE[ES:DI],' '	; 先全部填充空格
	INC	DI
	LOOP	.WRITELOOP1
	MOV	DI,0
.WRITELOOP2:
	MOV	AL,[CMDLINE+SI]
	CMP	AL,0
	JE	.WRITEEND
	AND	AL,11011111B
	MOV	[ES:DI],AL
	INC	SI
	INC	DI
	CMP	DI,11
	JE	.WRITEEND
	JMP	.WRITELOOP2
.WRITEEND:
	MOV	BYTE[ES:11],10H	; 属性：文件夹
	MOV	AX,ES
	SUB	AX,1H
	MOV	ES,AX
	MOV	CL,[ES:10]	; 得到上一个文件簇号
	MOV	AL,[ES:12]
	MOV	AH,[ES:13]	; 得到上一个文件长度
.DIV:
	INC	CL
	CMP	AX,200H
	JB	.DIVOK
	SUB	AX,200H
	JMP	.DIV
.DIVOK:
	MOV	AX,ES
	ADD	AX,2H
	MOV	ES,AX
	MOV	[ES:10],CL	; 将簇号写入
	PUSH	CX
	MOV	AX,0
.MUL:
	ADD	AX,20H
	LOOP	.MUL
	ADD	AX,FILETYPESEG
	MOV	ES,AX
	MOV	DI,0
	MOV	SI,0
	MOV	CX,12
.WRITELOOP3:
	MOV	AL,[MKDIRWRITE+SI]
	MOV	[ES:DI],AL
	INC	SI
	INC	DI
	LOOP	.WRITELOOP3
	MOV	AX,ES
	ADD	AX,1H
	MOV	ES,AX
	POP	CX
	MOV	[ES:10],CL
	MOV	AX,ES
	ADD	AX,1H
	MOV	ES,AX
	MOV	DI,0
	MOV	CX,12
.WRITELOOP4:
	MOV	AL,[MKDIRWRITE+SI]
	MOV	[ES:DI],AL
	INC	SI
	INC	DI
	LOOP	.WRITELOOP4
	CALL	DISKREST
	RET

RENAME:
	; RENAME命令执行
	MOV	SI,7	; 第一个文件名 用来查找文件信息地址
	MOV	DH,20H
	CALL	FILENAMECPY

	MOV	AH,[FILEINFOSEG]
	MOV	AL,[FILEINFOSEG+1]
	MOV	ES,AX
	MOV	SI,FINDFILENAME
	MOV	AH,06H
	INT	36H
	
	CMP	BX,0
	JE	.RET
	CMP	DX,0
	JE	.RET
	MOV	ES,BX
	MOV	SI,7
.LENLOOP:	; 这里用来确认第二个文件在CMDLINE中的位置
	CMP	BYTE[CMDLINE+SI],' '
	JE	.OK
	INC	SI
	JMP	.LENLOOP
.OK:
	INC	SI	; 跳过' '
	MOV	DH,20H
	CALL	FILENAMECPY
	
	MOV	SI,0
	MOV	CX,11
.RELOOP:	; 替换文件名
	MOV	AL,[FINDFILENAME+SI]
	MOV	[ES:SI],AL
	INC	SI
	LOOP	.RELOOP
	CALL	DISKREST
	RET
.RET:
	MOV	AH,01H
	MOV	SI,NOTFIND
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

DRIVE:
	; DRIVE命令的执行
	MOV	AL,[CMDLINE+6]
	CMP	AL,'C'
	JAE	.HARD
	CMP	AL,'A'
	JAE	.FLOPPY
	MOV	AH,01H
	MOV	SI,NOTTHISDRIVE
	INT	36H
	MOV	AH,02H
	INT	36H
	RET
.FLOPPY:	; A,B盘 软盘
	PUSH	AX
	SUB	AL,'A'	; 'A'-'A'=0（=驱动A的编码）
	MOV	DL,AL
	MOV	AH,01H
	INT	13H	; 检测磁盘状态
	CMP	AL,0	; 如果不是无错状态（代码=0） 那就是有错
	JNE	.NOTREADY
	POP	AX
	MOV	[DRIVETEMP],AL
	SUB	AL,'A'
	MOV	[DRIVETEMP+1],AL
	MOV	WORD[FILEINFOSEG],0x600A	; 根目录
	CALL	RESTREAD	; 重新读盘
	RET
.HARD:	; C~Z盘 硬盘
	PUSH	AX
	SUB	AL,'C'	; 'C'-'C'+0x80=0x80（=驱动C的编码）
	ADD	AL,80H
	MOV	DL,AL
	MOV	AH,01H
	INT	13H	; 检测磁盘状态
	CMP	AL,0	; 如果不是无错状态（代码=0） 那就是有错
	JNE	.NOTREADY
	POP	AX
	MOV	[DRIVETEMP],AL
	SUB	AL,'C'
	ADD	AL,80H
	MOV	[DRIVETEMP+1],AL
	MOV	WORD[FILEINFOSEG],0x600A	; 根目录
	CALL	RESTREAD	; 重新读盘
	RET
.NOTREADY:	; 磁盘有错或没准备好
	POP	AX
	MOV	[DRIVENOTREADY+6],AL
	MOV	AH,01H
	MOV	SI,DRIVENOTREADY
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

CPAUSE:
	; PAUSE命令的执行
	MOV	SI,PAUSEPUT
	MOV	AH,01H
	INT	36H
.LOOP:
	MOV	AH,0
	INT	16H
	MOV	AH,02H
	INT	36H
	RET

COPY:
	; COPY命令执行
	MOV	SI,5
	MOV	DH,20H
	CALL	FILENAMECPY

	MOV	AH,[FILEINFOSEG]
	MOV	AL,[FILEINFOSEG+1]
	MOV	ES,AX
	MOV	SI,FINDFILENAME
	MOV	AH,06H
	INT	36H
	
	CMP	BX,0
	JE	.NOTFIND
	CMP	DX,0
	JE	.NOTFIND
	; 将文件内容复制到0x55000~0x65000中（COPYBUFFER）
	MOV	ES,BX
	MOV	CX,[ES:28]	; 得到文件长度
	MOV	[COPYFILELENGTH],CX	; 保存到COPYFILELENGTH中
	PUSH	DS
	MOV	DS,DX
	MOV	SI,0
	MOV	AX,COPYBUFFERSEG
	MOV	ES,AX
	MOV	DI,0
	CALL	MEMCPY
	POP	DS
	RET
.NOTFIND:
	MOV	AH,01H
	MOV	SI,NOTFIND
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

PASTE:
	; PASTE命令执行
	; 寻找目录中的空位
	MOV	AH,[FILEINFOSEG]
	MOV	AL,[FILEINFOSEG+1]
	MOV	ES,AX
	MOV	AH,07H
	INT	36H
	MOV	ES,BX

	MOV	SI,6
	MOV	DH,20H
	CALL	FILENAMECPY

	MOV	CX,12
	MOV	SI,0
.LOOP:	; 复制文件名
	MOV	AL,[FINDFILENAME+SI]
	MOV	[ES:SI],AL
	INC	SI
	LOOP	.LOOP
	; 得到上个文件的簇和长度
	PUSH	ES
	MOV	AX,ES
	SUB	AX,1H
	MOV	ES,AX
	MOV	CX,[ES:12]	; 长度
	MOV	AL,[ES:10]	; 簇
	; 计算这个文件的簇
.SUB:
	INC	AL
	CMP	CX,200H
	JB	.OK
	SUB	CX,200H
	JMP	.SUB
.OK:
	; 写入簇
	POP	ES
	MOV	[ES:26],AL
	; 写入长度
	MOV	CX,[COPYFILELENGTH]
	MOV	[ES:28],CX
	; 写入内容
	MOV	DI,0
	MOV	SI,0
	; 计算文件段地址
	MOV	BX,FILETYPESEG
.MUL:
	ADD	BX,20H
	DEC	AL
	CMP	AL,0
	JE	.OK2
	JMP	.MUL
.OK2:
	MOV	ES,BX
	MOV	AX,COPYBUFFERSEG
	PUSH	DS
	MOV	DS,AX
	CALL	MEMCPY
	POP	DS
	
	; 写盘
	CALL	DISKREST
	RET

HELP:
;help命令执行
	MOV	AH,02H
	INT	36H
	MOV BL,04H
	MOV	SI,HELPPUT
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

ABOUT:
	; ABOUT命令执行
	MOV	AH,02H
	INT	36H
	MOV	SI,ABOUTPUT
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

POKE:
	; POKE命令执行
	MOV	AL,[CMDLINE+5]
	CMP	AL,'&'	; 地址符号标识
	JNE	.ERROR
	MOV	SI,6
.LOOP:	; 得到段地址
	MOV	AL,[CMDLINE+SI]	; 每次转化1个数字 直到下1个字符是' '
	CMP	BYTE[CMDLINE+SI+1],' '
	JE	.OK
	CALL	ASCIITONUM
	MOV	BX,[ADDRESSSEGTEMP]
	SHL	BX,4	; 现在=原来*0x10+新添加
	MOV	AH,0
	ADD	BX,AX
	MOV	[ADDRESSSEGTEMP],BX
	INC	SI
	JMP	.LOOP
.OK:	; 得到偏移地址
	CALL	ASCIITONUM
	MOV	AH,0
	MOV	[ADDRESSOFFTEMP],AX
.FINDADDRESS:
	MOV	AX,[ADDRESSSEGTEMP]
	MOV	ES,AX
	MOV	AL,[CMDLINE+SI+2]
	CALL	ASCIITONUM
	MOV	AH,AL
	MOV	AL,[CMDLINE+SI+3]
	CALL	ASCIITONUM
	SHL	AH,4
	ADD	AH,AL
	MOV	SI,[ADDRESSOFFTEMP]
	MOV	[ES:SI],AH	; 写数据
	; 清空ADDRESSOFFTEMP和ADDRESSSEGTEMP
	MOV	WORD[ADDRESSSEGTEMP],0
	MOV	WORD[ADDRESSOFFTEMP],0
	RET
.ERROR:
	MOV	SI,POKEERROR
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

VISIT:
	; VISIT命令执行
	MOV	AL,[CMDLINE+6]
	CMP	AL,'&'	; 地址符号标识
	JNE	.ERROR
	MOV	SI,7
.LOOP:	; 得到段地址
	MOV	AL,[CMDLINE+SI]	; 每次转化1个数字 直到下1个字符是' '或者0
	CMP	BYTE[CMDLINE+SI+1],' '
	JE	.OK
	CMP	BYTE[CMDLINE+SI+1],0
	JE	.OK
	CALL	ASCIITONUM
	MOV	BX,[ADDRESSSEGTEMP]
	SHL	BX,4	; 现在=原来*0x10+新添加
	MOV	AH,0
	ADD	BX,AX
	MOV	[ADDRESSSEGTEMP],BX
	INC	SI
	JMP	.LOOP
.OK:	; 得到偏移地址
	CALL	ASCIITONUM
	MOV	AH,0
	MOV	[ADDRESSOFFTEMP],AX
.FINDADDRESS:
	MOV	AX,[ADDRESSSEGTEMP]
	MOV	ES,AX
	MOV	SI,[ADDRESSOFFTEMP]
	MOV	AL,[ES:SI]	; 读数据
	SHR	AL,4
	CALL	NUMTOASCII
	MOV	AH,0EH
	INT	10H
	MOV	AL,[ES:SI]
	AND	AL,0FH
	CALL	NUMTOASCII
	INT	10H
	; 清空ADDRESSOFFTEMP和ADDRESSSEGTEMP
	MOV	WORD[ADDRESSSEGTEMP],0
	MOV	WORD[ADDRESSOFFTEMP],0
	RET
.ERROR:
	MOV	SI,VISITERROR
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

FIND:
	; FIND命令的执行
	MOV	AL,[CMDLINE+5]
	CMP	AL,'&'	; 地址符号标识
	JNE	.ERROR
	MOV	SI,6
	; 1.起始地址（保存到堆栈
.LOOP:	; 得到段地址
	MOV	AL,[CMDLINE+SI]	; 每次转化1个数字 直到下1个字符是' '
	CMP	BYTE[CMDLINE+SI+1],' '
	JE	.OK
	CALL	ASCIITONUM
	MOV	BX,[ADDRESSSEGTEMP]
	SHL	BX,4	; 现在=原来*0x10+新添加
	MOV	AH,0
	ADD	BX,AX
	MOV	[ADDRESSSEGTEMP],BX
	INC	SI
	JMP	.LOOP
.OK:	; 得到偏移地址
	CALL	ASCIITONUM
	MOV	AH,0
	MOV	[ADDRESSOFFTEMP],AX
	; 保存起始地址到堆栈
	MOV	AX,[ADDRESSSEGTEMP]
	PUSH	AX
	MOV	AX,[ADDRESSOFFTEMP]
	PUSH	AX
	ADD	SI,2	; 跳过' '
	CMP	BYTE[CMDLINE+SI],'&'	; 地址符标识
	JNE	.ERROR
	INC	SI	; 跳过'&'
	; 2.目标地址（保存到TEMP中
.LOOP2:	; 得到段地址
	MOV	AL,[CMDLINE+SI]	; 每次转化1个数字 直到下1个字符是' '
	CMP	BYTE[CMDLINE+SI+1],' '
	JE	.OK2
	CALL	ASCIITONUM
	MOV	BX,[ADDRESSSEGTEMP]
	SHL	BX,4	; 现在=原来*0x10+新添加
	MOV	AH,0
	ADD	BX,AX
	MOV	[ADDRESSSEGTEMP],BX
	INC	SI
	JMP	.LOOP2
.OK2:	; 得到偏移地址
	CALL	ASCIITONUM
	MOV	AH,0
	MOV	[ADDRESSOFFTEMP],AX
	; 3.数据
	MOV	AL,[CMDLINE+SI+2]
	CALL	ASCIITONUM
	MOV	AH,AL
	MOV	AL,[CMDLINE+SI+3]
	CALL	ASCIITONUM
	SHL	AH,4
	ADD	AH,AL
	; 取出起始地址
	POP	SI
	POP	ES
	; 长度=目标地址-起始地址
	MOV	CX,[ADDRESSSEGTEMP]
	SHL	ECX,4	; CX=CX*0x10=CX<<4
	ADD	CX,[ADDRESSOFFTEMP]
	MOV	BX,ES
	SHL	EBX,4	; BX=BX*0x10=BX<<4
	ADD	BX,SI
	SUB	ECX,EBX
.LOOP3:
	CMP	SI,16
	JNE	.NEXT
	MOV	SI,ES
	INC	SI
	MOV	ES,SI
	MOV	SI,0
.NEXT:
	MOV	AL,[ES:SI]
	CMP	AH,AL
	JE	.PC
	INC	SI
	DEC	ECX
	JECXZ	.END
	JMP	.LOOP3
.PUT	DB	0
.PC:
	PUSH	AX
	PUSH	SI
	MOV	AH,01H
	MOV	SI,FINDPUT
	INT	36H
	MOV	DX,ES
	MOV	AL,DH
	SHR	AL,4
	CALL	NUMTOASCII
	MOV	AH,0EH
	INT	10H
	MOV	AL,DH
	AND	AL,0FH
	CALL	NUMTOASCII
	INT	10H
	MOV	AL,DL
	SHR	AL,4
	CALL	NUMTOASCII
	INT	10H
	MOV	AL,DL
	AND	AL,0FH
	CALL	NUMTOASCII
	INT	10H
	POP	SI
	PUSH	SI
	MOV	DX,SI
	MOV	AL,DL
	AND	AL,0FH
	CALL	NUMTOASCII
	INT	10H
	MOV	AH,02H
	INT	36H
	INC	BYTE[.PUT]	; 记数
	CMP	BYTE[.PUT],25
	JNE	.NEXT2
	MOV	AH,01H
	MOV	SI,FINDPAUSEPUT
	INT	36H
.PAUSE:
	MOV	AH,0
	INT	16H
	CMP	AL,0DH
	JE	.NEWLINE
	CMP	AL,1BH
	JE	.POPEND
	JMP	.PAUSE
.NEWLINE:
	MOV	AH,02H
	INT	36H
.NEXT2:
	POP	SI
	POP	AX
	INC	SI
	DEC	ECX
	JECXZ	.END
	JMP	.LOOP3
.POPEND:
	POP	SI
	POP	AX
.END:
	RET
.ERROR:
	MOV	SI,FINDERROR
	MOV	AH,01H
	INT	36H
	MOV	AH,02H
	INT	36H
	RET

FILENAMECPY:
	MOV	DI,0
	MOV	CX,11
.STRCPY:	; 循环一：将FINDFILENAME全部归' '
	MOV	BYTE[FINDFILENAME+DI],' '
	INC	DI
	LOOP	.STRCPY
	MOV	BYTE[FINDFILENAME+11],DH	; 文件属性
	MOV	DI,0
	MOV	CX,8
.STRCPY2:	; 循环二：将文件名复制到FINDFILENAME前8位中
	MOV	AH,[CMDLINE+SI]
	CMP	AH,'.'
	JE	.SPOT
	CMP	AH,0
	JE	.ZERO
	CMP	AH,' '
	JE	.ZERO
	AND	AH,11011111B	; 防止小写错误
	MOV	[FINDFILENAME+DI],AH
	INC	SI
	INC	DI
	LOOP	.STRCPY2
.STRCPY3R:	; 循环三：跳过'.' 将后缀名复制到FINDFILENAME后3位中
	MOV	CX,3
	MOV	DI,8
	INC	SI	; 跳过'.'
.STRCPY3:
	MOV	AH,[CMDLINE+SI]
	CMP	AH,0
	JE	.STRCPYEND
	AND	AH,11011111B
	MOV	[FINDFILENAME+DI],AH
	INC	SI
	INC	DI
	LOOP	.STRCPY3
.STRCPYEND:
	RET
.SPOT:	; 从循环二跳来 如果后缀点
	CMP	DH,10H
	JE	.SPOTA
	JMP	.STRCPY3R
.SPOTA:		; 'CD .?'的情况
	MOV	BYTE[FINDFILENAME+0],'.'
	INC	SI
	CMP	BYTE[CMDLINE+SI],'.'
	JNE	.STRCPYEND	; 'CD .'
	MOV	BYTE[FINDFILENAME+1],'.'	; 'CD ..'
	JMP	.STRCPYEND
.ZERO:	; 从循环二跳来 如果没有后缀点
	MOV	CX,8
	SUB	CX,DI
.ZEROLOOP:
	MOV	BYTE[FINDFILENAME+DI],' '
	INC	DI
	LOOP	.ZEROLOOP
;	JMP	.STRCPY3R
	RET

CLEANINPUT:
; 清空输入（CMDLINE）的内容
; 无寄存器
	PUSH	SI	; SI入堆栈
	MOV	SI,0
.LOOP:
	CMP	SI,128	; [MAX]LEN
	JE	.END
	MOV	BYTE[CMDLINE+SI],0
	INC	SI
	JMP	.LOOP
.END:
	POP	SI	; SI出堆栈
	RET

OLDCLEANCOPY:
; 将上上次输入（OLDCMDLINE）清空 将上一次输入复制到这里
; 无寄存器
	PUSH	SI
.LOOP:
	CMP	SI,128	; [MAX]LEN
	JE	.END
	MOV	BYTE[OLDCMDLINE+SI],0
	INC	SI
	JMP	.LOOP
.END:
	MOV	SI,0
.LOOP2:
	MOV	AL,[CMDLINE+SI]
	CMP	AL,0
	JE	.END2
	MOV	[OLDCMDLINE+SI],AL
	INC	SI
	JMP	.LOOP2
.END2:
	POP	SI
	RET

ASCIITONUM:
; 将ASCII码转化成16进制数
; 寄存器：IN:AL OUT:AL
	CMP	AL,'A'
	JGE	.LETTER
	SUB	AL,30H
	RET
.LETTER:
	SUB	AL,37H
	RET

NUMTOASCII:
; 将16进制数转化成ASCII码
; 寄存器：IN:AL OUT:AL
	CMP	AL,9
	JG	.LETTER
	ADD	AL,30H
	RET
.LETTER:
	ADD	AL,37H
	RET

DISKREST:
; 重新写读盘
; 无寄存器
	MOV	AX,DATASEG	; 启动时读入的数据地址
	MOV	ES,AX
.WRITE:
	MOV	CL,[SECTOR]
	MOV	DH,[HEADER]
	MOV	CH,[CYLINE]
	CALL	WRITE1SECTOR	; 将ES:BX（地址）的内存数据写入软盘
	CALL	READ1SECTOR		; 再读入ES:BX（地址）
	
	MOV	AX,ES
	ADD	AX,20H	; 512B=200H
	MOV	ES,AX	; ES=ES+20H
	; 扇区
	INC	BYTE[SECTOR]
	CMP	BYTE[SECTOR],NUMSECTOR+1
	JNE	.WRITE
	MOV	BYTE[SECTOR],1
	; 磁头
	INC	BYTE[HEADER]
	CMP	BYTE[HEADER],NUMHEADER+1
	JNE	.WRITE
	MOV	BYTE[HEADER],0
	; 柱面
	INC	BYTE[CYLINE]
	CMP	BYTE[CYLINE],NUMCYLINE
	JNE	.WRITE
	
	MOV	BYTE[SECTOR],1	; 写读完后全部还原（必须）
	MOV	BYTE[HEADER],0
	MOV	BYTE[CYLINE],0
	RET

RESTREAD:
; 重新读盘0x
; 无寄存器
	MOV	AX,DATASEG	; 启动时读入的数据地址
	MOV	ES,AX
	MOV	BYTE[SECTOR],1	; 写读完后全部还原（必须）
	MOV	BYTE[HEADER],0
	MOV	BYTE[CYLINE],0
.READ:
	MOV	CL,[SECTOR]
	MOV	DH,[HEADER]
	MOV	CH,[CYLINE]
	CALL	READ1SECTOR		; 读入ES:BX（地址）
	
	MOV	AX,ES
	ADD	AX,20H	; 512B=200H
	MOV	ES,AX	; ES=ES+20H
	; 扇区
	INC	BYTE[SECTOR]
	CMP	BYTE[SECTOR],NUMSECTOR+1
	JNE	.READ
	MOV	BYTE[SECTOR],1
	; 磁头
	INC	BYTE[HEADER]
	CMP	BYTE[HEADER],NUMHEADER+1
	JNE	.READ
	MOV	BYTE[HEADER],0
	; 柱面
	INC	BYTE[CYLINE]
	CMP	BYTE[CYLINE],NUMCYLINE
	JNE	.READ
	
	MOV	BYTE[SECTOR],1	; 写读完后全部还原（必须）
	MOV	BYTE[HEADER],0
	MOV	BYTE[CYLINE],0
	RET

WRITE1SECTOR:
; 写1个扇区的通用程序
; 寄存器：IN:CL/DH/CH/ES
	MOV	DI,0
.RETRY:
	MOV	AH,03H
	MOV	AL,1
	MOV	BX,0	; ES:BX = ????:0
	MOV	DL,[DRIVETEMP+1]
	INT	13H
	JNC	.OK		; 未出错就跳转
	INC	DI
	
	MOV	AH,00H
	MOV	DL,[DRIVETEMP+1]
	INT	13H
	CMP	DI,5	; 写5次依然出错就放弃
	JNE	.RETRY

	MOV	AH,01H
	MOV	SI,WRITEERROR	; 打印错误
	INT	36H
	MOV	AH,02H
	INT	36H
.OK:
	RET

READ1SECTOR:
; 读取1个扇区的通用程序
; 寄存器：IN:CL/DH/CH/ES
	MOV	DI,0
.RETRY:
	MOV	AH,02H
	MOV	AL,1
	MOV	BX,0	; ES:BX = ????:0
	MOV	DL,[DRIVETEMP+1]
	INT	13H
	JNC	.OK		; 未出错就跳转
	INC	DI
	
	MOV	AH,00H
	MOV	DL,[DRIVETEMP+1]
	INT	13H
	CMP	DI,5	; 读5次依然出错就放弃
	JNE	.RETRY

	MOV	AH,01H
	MOV	SI,READERROR	; 打印错误
	INT	36H
	MOV	AH,02H
	INT	36H
.OK:
	RET

%INCLUDE "EXEPRG.ASM"	; 可执行文件 批处理文件
%INCLUDE "SYS.ASM"		; 系统调用