; NO.9 ����ʼ����ʱ����Ļ���������һ��ʮλ���ֵĺ���
; �ÿո�ʱֹͣ���õ��ĺ��������˺�

DATA SEGMENT
	SINGLE_NUMBER DB 20 DUP(0),'$'
	MSG DB 'This is a random number generating program.','$'	                                               
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE , DS:DATA

START:
	;���ݶδ���DS��
	MOV AX,DATA
	MOV DS,AX 
	
	LEA DX,MSG
	MOV AH,9H
    INT 21H
	
	
RANDOM:
	MOV CX,10
	LEA SI,SINGLE_NUMBER


;����ϵͳʱ�����������
TIME_RANDOM:
	;��ȡ��ǰʱ�䲢�����
	DB 0FH,31H ;RDTSCָ���ȡʱ���ǩ���������������DX:AX
	OR AL,AH 
	INC AL
	;DEC AH
	XOR AL,11h
	;XOR AH,00
	
	;MOV DL,AH
	MOV AH,0 ;��ȡϵͳʱ�Ӽ�����

	MOV BL,100 ;����Ϊ100������0-99����
	DIV BL
	MOV AL,AH ;������AL����Ϊ�����
	AAM  ;�����Ĵ���AL��ֵ AH=AL/10 , AL=AL%10
	OR AX,3030H ;
	;XCHG AL,AH ;��Ҫ�ɲ�Ҫ
	
	MOV WORD PTR SINGLE_NUMBER[SI],AX
	ADD SI,2

LOOP TIME_RANDOM


;�ƶ����λ��
    MOV BH,0
    MOV DH,2
    MOV dl,1
    MOV AH,2
    INT 10H

LEA DX,SINGLE_NUMBER
MOV AH,9H 
INT 21H


MOV AH,1H ;�ȴ��������벢����
INT 16H 
JZ RANDOM ;


SPACE:
	;�Ӽ��̶���һ���ַ�
	MOV AH,0
	INT 16H
	;����˳�
	CMP AL,'0'
	JZ EXIT
	;���ո�
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
