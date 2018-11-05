; ------- TAB --------
; 	0 = 3F h
; 	1 = 06 h
; 	2 = 5B h
; 	3 = 4F h
; 	4 = 66 h
; 	5 = 6D h
; 	6 = 7D h
; 	7 = 07 h
; 	8 = 7F h
; 	9 = 6F h
; --------------------
;	  a
;	 ---
;      |     |
;    f |     | b
;      |  g  |
;        ---
;      |     |
;    e |     | c
;      |     |
;        ---      .h
;         d
;
;      hgfedcba
;      06h = 00000110 (���� ����� 1):
;
;      0 - ���� ������� (�� �����), 1 - ���� ������ (�����)
;
;	a = 0           |
;	b = 1           |
;	c = 1           |
;	d = 0   ===>         �������� ����� 1
;	e = 0           |
;	f = 0           |
;	g = 0           |
;	h = 0

; ---- ���������� ----
FIRST_IND EQU 00h   		; ������ ���������
SECOND_IND EQU 01h  		; ������ ���������
THIRD_IND EQU 02h   		; ������ ���������
TEMPA EQU 03h       		; ������ �������� �
TOZERO EQU 05h      		; ������ ��� ��������� XXXXXX00
COUNTER EQU 06h     		; �������, ������� ������ ������������ +10
TEN EQU 07h         		; ������ �������� 10d

ButtonUpdate EQU P3.1   	; ������ ���������� ������ (������)
ButtonPlusTen EQU P3.0  	; ������ ���������� �� 10 (�����)

ORG 0
jmp init                        ; �������������
ORG 30h

init:
   	mov DPTR, #Table            ; ��������� �� �������
   	mov P0, #0                  ; ��������� 1� ���������
   	mov P1, #0                  ; ��������� 2� ���������
   	mov P2, #0                  ; ��������� 3� ���������
   	mov FIRST_IND, #00000000    ; �������� �������� 1�� ����������
   	mov SECOND_IND, #00000000   ; �������� �������� 2�� ����������
   	mov THIRD_IND, #00000000    ; �������� �������� 3�� ����������
   	mov COUNTER, #0d            ; �������� �������� �������� (+10)
   	mov TEN, #10d               ; ����������� TEN �������� 10
	jmp main                    ; ��������� � ��������� ����� ���������

display:                            ; ����������� ������ �� ����������
        jb ButtonUpdate, display    ; ��� ������� ������
   	mov P0, FIRST_IND           ; �������� ������ ���������
        mov P1, SECOND_IND          ; �������� ������ ���������
        mov P2, THIRD_IND           ; �������� ������ ���������
        jmp continue3               ; ���������� ���� main

decode:                         ; ��������� ���� ����� �� 3 ����������
	mov A, P3 		; �������� � � �������� �������������
        mov TOZERO, #11111100b
 	anl A, TOZERO           ; �������� ��������� ��� ����
	rr A 			; ��������� ����� ������ �� 1 ���
	rr A 			; ��������� ����� ������ �� 1 ���
	add A, COUNTER
	mov B, #10d 		; �������� � B 10
	div AB 			; �������� Z ����� � XYZ
	mov TEMPA, A 		; ��������� A
	mov A, B 		; �������� � � �, �� ��������� ������� ��������
				; 	������ � ���
				
	movc A, @A+DPTR		; ���� � ������� ����� �� ���� A
				; (��� 3 ����������)
				
	mov THIRD_IND, A 	; ��������� �������� 3 ����������
	mov A, TEMPA		; ��������������� �
	mov B, #10d 		; �������� � B 10
	div AB 			; �������� X � Y ����� � XYZ
	movc A, @A+DPTR		; ���� � ������� ����� �� ���� A
				; 	(��� 1 ����������)
				
	mov FIRST_IND, A	; ��������� �������� 1 ����������
	mov A, B 		; �������� � � �, �� ��������� �������
				; 	�������� ������ � ���
				
	movc A, @A+DPTR		; ���� � ������� ����� �� ���� A
				; 	(��� 2 ����������)
				
	MOV SECOND_IND, A	; ��������� �������� 2 ����������
	jmp continue1 		; ������������ � ��������� �����

plusTen:                             ; ����������� ������� �� 10
        jb ButtonPlusTen, plusTen    ; ���� ������� ������
        mov A, COUNTER
	add A, TEN
	mov COUNTER, A
        jmp continue2                ; ������������ � ���� main

main:
        jmp decode
        continue1:
        jb ButtonPlusTen, plusTen    ; ���� ������ ������ -> plusTen
        continue2:
        jb ButtonUpdate, display     ; ���� ������ ������ -> display
        continue3:
        ljmp main 		     ; ������������ (����������� ����)

Table:
	DB 3Fh
	DB 06h
	DB 5Bh
	DB 4Fh
	DB 66h
	DB 6Dh
	DB 7Dh
	DB 07h
	DB 7Fh
	DB 6Fh
	
END
