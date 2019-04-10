;Ejercicio 3.2. Escribe un programa usando el Timer0 y su interrupción
;asociada que incrementa la variable CICLO_35ms cada 35ms
; y mira el valor en 8 LEDs connectados al PORTC.

LIST p=16f876A
include "p16f876a.inc"

ciclo_35ms	EQU 	0x20
	
		ORG		0
		goto inicio
				
		ORG		4
		goto	ISR
		ORG		5

inicio
;hay que habilitar el GIE de habilitamiento global de interrupción
;está en el banco 0
		BSF	INTCON, GIE
		BSF	INTCON, T0IE	;para que desborde 3.1 ???

;Tenemos que cambiar al banco 1 donde esta option_reg y trisC para ponerlo como salida
		BSF	STATUS,RP0		
			
;Estando en el banco 1  modificamos el timer0

		CLRF 	TRISC   ; Ponemos el PORTC como salida

		BCF	OPTION_REG,T0CS ; modo temporizador (ciclos de instrucción)

		BCF	OPTION_REG,PSA  ; Queremos configurarlo para el modulo timer0 
	;Configuramos el prescaler 1:256 > bit value 111
		BSF 	OPTION_REG,PS2
		BSF 	OPTION_REG,PS1
		BSF 	OPTION_REG,PS0

;hay que volver al banco0
		BCF	STATUS,RP0

		MOVLW	.119  ; .PARA DECIMAL 
		MOVWF	TMR0
	
main					
;	BTFSS	INTCON,T0IF		;Salta si está a 1
	;> Si la variable ha desbordado, saltamos la vuelta al main
	goto 	main

ISR
		INCF	ciclo_35ms,1	; Incrementamos la variable
	
		MOVLW	.119			;VALOR DE N
		MOVWF 	TMR0
		
		MOVF	ciclo_35ms,0	;Movemos la variable al acumulador
	       
		MOVWF	PORTC			;Movemos el acumulador al PORTC	
				;Movemos el valor del PORTC al Timer0
	
		BCF	INTCON,T0IF		; Ponemos a 0, el flag de desbordamiento del timer0
retfie

END
