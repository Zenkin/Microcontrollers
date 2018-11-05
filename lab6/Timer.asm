org 0
jmp init
org 30h

init:
	MOV TMOD, #11h  ; TMOD 0001 0001 16-bit timer set
	MOV TH0, #0FFh  ; Задаем старший бит таймера
	MOV TL0, #0F0h  ; Задаем младший бит таймера
	SETB TR0        ; Запускаем таймер
	continue:
	JNB TF0, wait
	; задержка
	CLR TR0         ; Выключаем таймер
	CLR TF0         ; Обнуляем overflow бит
	ljmp init       ; Бесконечное зацикливание
	
wait:
	jmp continue
