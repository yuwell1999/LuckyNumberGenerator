; NO.9 程序开始运行时在屏幕上随机跳动一组十位数字的号码
; 敲空格时停止，得到的号码是幸运号

DATA SEGMENT
	SINGLE_NUMBER DB 20 DUP(0),'$'
	MSG DB 'This is a random number generating program.','$'	                                               
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE , DS:DATA

START:
	;数据段存入DS中
	MOV AX,DATA
	MOV DS,AX 
	
	LEA DX,MSG
	MOV AH,9H
    INT 21H
	
	
RANDOM:
	MOV CX,10
	LEA SI,SINGLE_NUMBER


;利用系统时钟生成随机数
TIME_RANDOM:
	;读取当前时间并随机化
	DB 0FH,31H ;RDTSC指令，读取时间标签计数器，将其读入DX:AX
	OR AL,AH 
	INC AL
	;DEC AH
	XOR AL,11h
	;XOR AH,00
	
	;MOV DL,AH
	MOV AH,0 ;读取系统时钟计数器

	MOV BL,100 ;除数为100，产生0-99余数
	DIV BL
	MOV AL,AH ;余数存AL，作为随机数
	AAM  ;调整寄存器AL的值 AH=AL/10 , AL=AL%10
	OR AX,3030H ;
	;XCHG AL,AH ;可要可不要
	
	MOV WORD PTR SINGLE_NUMBER[SI],AX
	ADD SI,2

LOOP TIME_RANDOM


;移动光标位置
    MOV BH,0
    MOV DH,2
    MOV dl,1
    MOV AH,2
    INT 10H

LEA DX,SINGLE_NUMBER
MOV AH,9H 
INT 21H


MOV AH,1H ;等待键盘输入并回显
INT 16H 
JZ RANDOM ;


SPACE:
	;从键盘读入一个字符
	MOV AH,0
	INT 16H
	;检测退出
	CMP AL,'0'
	JZ EXIT
	;检测空格
	CMP AL,' ' 
	JNZ RANDOM


REPEAT_SPACE:
	MOV AH,0 
	INT 16H
	CMP AL,'0'
	JZ EXIT
	CMP Al,' '
	JNZ TIME_RANDOM
	JMP RANDOM


EXIT:
	MOV AX,4C00H
	INT 21H

    CODE ENDS
END START
