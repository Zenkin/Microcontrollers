org 0
jmp init
org 30h

init:
	MOV TMOD, #11h  ; TMOD 0001 0001 16-bit timer set
	MOV TH0, #0FFh  ; ������ ������� ��� �������
	MOV TL0, #0F0h  ; ������ ������� ��� �������
	SETB TR0        ; ��������� ������
	continue:
	JNB TF0, wait
	; ��������
	CLR TR0         ; ��������� ������
	CLR TF0         ; �������� overflow ���
	ljmp init       ; ����������� ������������
	
wait:
	jmp continue
