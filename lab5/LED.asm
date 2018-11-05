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
;      06h = 00000110 (дает цифру 1):
;
;      0 - нету сигнала (не горит), 1 - есть сигнал (горит)
;
;	a = 0           |
;	b = 1           |
;	c = 1           |
;	d = 0   ===>         получаем цифру 1
;	e = 0           |
;	f = 0           |
;	g = 0           |
;	h = 0

; ---- Объявление ----
FIRST_IND EQU 00h   		; первый индикатор
SECOND_IND EQU 01h  		; второй индикатор
THIRD_IND EQU 02h   		; третий индикатор
TEMPA EQU 03h       		; хранит значение А
TOZERO EQU 05h      		; служит для обнуления XXXXXX00
COUNTER EQU 06h     		; счётчик, который хранит суммирование +10
TEN EQU 07h         		; хранит значение 10d

ButtonUpdate EQU P3.1   	; кнопка обновления данных (правая)
ButtonPlusTen EQU P3.0  	; кнопка увеличения на 10 (левая)

ORG 0
jmp init                        ; инициализация
ORG 30h

init:
   	mov DPTR, #Table            ; ссылаемся на таблицу
   	mov P0, #0                  ; выклюачем 1й индикатор
   	mov P1, #0                  ; выклюачем 2й индикатор
   	mov P2, #0                  ; выклюачем 3й индикатор
   	mov FIRST_IND, #00000000    ; обнуляем значения 1го индикатора
   	mov SECOND_IND, #00000000   ; обнуляем значения 2го индикатора
   	mov THIRD_IND, #00000000    ; обнуляем значения 3го индикатора
   	mov COUNTER, #0d            ; обнуляем значение счётчика (+10)
   	mov TEN, #10d               ; присваиваем TEN значение 10
	jmp main                    ; переходим к основному циклу программы

display:                            ; отображение данных на идикаторах
        jb ButtonUpdate, display    ; ждём отжатия кнопки
   	mov P0, FIRST_IND           ; включаем первый индикатор
        mov P1, SECOND_IND          ; включаем второй индикатор
        mov P2, THIRD_IND           ; включаем третий индикатор
        jmp continue3               ; продолжаем цикл main

decode:                         ; разбиваем наше число на 3 индикатора
	mov A, P3 		; Помещаем в А значение потенциометра
        mov TOZERO, #11111100b
 	anl A, TOZERO           ; обнуляем последние два бита
	rr A 			; побитовый сдвиг вправо на 1 бит
	rr A 			; побитовый сдвиг вправо на 1 бит
	add A, COUNTER
	mov B, #10d 		; Помещаем в B 10
	div AB 			; Выделяем Z цифру в XYZ
	mov TEMPA, A 		; Сохраняем A
	mov A, B 		; Помещаем В в А, тк следующая строчка работает
				; 	только с ним
				
	movc A, @A+DPTR		; Ищем в таблице цифра по коду A
				; (для 3 индикатора)
				
	mov THIRD_IND, A 	; Сохраняем значение 3 индикатора
	mov A, TEMPA		; Восстанавливаем А
	mov B, #10d 		; Помещаем в B 10
	div AB 			; Выделяем X и Y цифру в XYZ
	movc A, @A+DPTR		; Ищем в таблице цифра по коду A
				; 	(для 1 индикатора)
				
	mov FIRST_IND, A	; Сохраняем значение 1 индикатора
	mov A, B 		; Помещаем В в А, тк следующая строчка
				; 	работает только с ним
				
	movc A, @A+DPTR		; Ищем в таблице цифра по коду A
				; 	(для 2 индикатора)
				
	MOV SECOND_IND, A	; Сохраняем значение 2 индикатора
	jmp continue1 		; возвращаемся к основному циклу

plusTen:                             ; увеличиваем счетчик на 10
        jb ButtonPlusTen, plusTen    ; ждем отжатия кнопки
        mov A, COUNTER
	add A, TEN
	mov COUNTER, A
        jmp continue2                ; возвращаемся в цикл main

main:
        jmp decode
        continue1:
        jb ButtonPlusTen, plusTen    ; если нажата кнопка -> plusTen
        continue2:
        jb ButtonUpdate, display     ; если нажата кнопка -> display
        continue3:
        ljmp main 		     ; зацикливание (бесконечный цикл)

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
