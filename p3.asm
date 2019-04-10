; 3.1 Escribe un programa que utilice timer0 que incremente la 
; 	 variable CICLO_125us y se incremente cada 125us

LIST p=16f876A
include "p16f876a.inc"

ciclo_125us		EQU 	0x20
	
;n vale 131 hasta que desborda teoricamente, pero como hay ciclos de 
;instrucción por en medio hay que ajustarlo un poquillo, hay que tener
; en cuenta que el primer ciclo será diferente al segundo

				ORG	0
				goto inicio
				
				ORG	4
				goto	ISR
				ORG	5

inicio
;hay que habilitar el GIE de habilitamiento global de interrupción
;está en el banco 0
				BSF	INTCON, GIE
				BSF INTCON, T0IE	;para que desborde

;Tenemos que cambiar al banco 1 donde esta option_reg
				BSF	STATUS,RP0		

;Estando en el banco 1  modificamos el timer0

				BCF		OPTION_REG,T0CS ; modo temporizador (ciclos de instrucción)
				BSF		OPTION_REG,PSA  ; Queremos configurar como WDT (Prescaler 1:1)
				
;hay que volver al banco0
				BCF		STATUS,RP0
;hay que poner el desbordamiento y eso

				MOVLW	   .147 ; .PARA DECIMAL,  para binario b'10000011'
				MOVWF	TMR0
	
main						;bucle principal que no hace nada
			GOTO main

ISR							;rutina de interrupción


				INCF	ciclo_125us,1		;incrementar la variable

				MOVLW	.140
				MOVWF	TMR0

				;el breakpoint tiene que volver cada 125us		
				BCF		INTCON, T0IF		;borrar el flag de desboradamiento del Timer0

	RETFIE	; como el return pero en rutina de interrupción



END
