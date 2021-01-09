
;*********************  Definição do processador *****************************

			#include p16F877A.inc 
			__config _HS_OSC & _WDT_OFF & _LVP_OFF & _PWRTE_ON 

;************************** Memória de programa ******************************
 			


			DELAY EQU 0x24
			VEZES EQU 0x25
			loop EQU 0x26
			ORG	0 

RESET 		nop             
 			goto START 

;***************************** Interrupção **********************************
 			ORG 4 

;*************************** Inicio do programa ******************************
START
			bsf STATUS, RP0 ; BANK 1
			movlw b'00000000'
			movwf TRISC
			movlw b'00000000'
			movwf TRISD
			movlw b'00001111' ;1 PARA CONFIGURAÇÃO DO PINO DO PORT COMO ENTRADA, 0 COMO SAIDA
			movwf TRISB
			movlw b'00000000'
			movwf TRISA
			bcf STATUS, RP0 ;VOLTANDO AO BANK 0
			


INICIO
			movlw b'11101111'
			movwf PORTB
			BTFSS PORTB, 0
		GOTO BOTAO_0 ; SERVO MOTOR 0 GRAUS
			BTFSS PORTB, 1
		GOTO BOTAO_1; SERVO MOTOR 90 GRAUS
			BTFSS PORTB, 2
		GOTO BOTAO_2
			BTFSS PORTB, 3
		GOTO BOTAO_3
			movlw b'11011111'
			movwf PORTB
			BTFSS PORTB, 0
		GOTO BOTAO_4
			BTFSS PORTB, 1
		GOTO BOTAO_5
		goto INICIO ;EXECUTA EM LOOP ENQUANTO O USUARIO NAO PRESSIONA NENHUM DOS BOTOES DO TECLADO MATRICIAL (0 - 5)

BOTAO_0
			movlw b'11111111' ;USANDO O CALCULO DE TEMPO COM O SERVO-MOTOR, PARA CONFIGURAR 0 GRAUS.
			movwf PORTC
			CALL PERDE_TEMPO ;4 FUNCOES DE PERDE_TEMPO POIS CADA UMA TEM UMA QUANTIDADE DE TEMPO DIFERENTE EM EXECUÇÃO
			CLRF PORTC
			CALL PERDE_TEMPO_2
			BTFSS PORTB, 1
		GOTO BOTAO_1 ; CASO O USUARIO LOGO EM SEGUIDA PRESSIONE O PROXIMO BOTAO, O CODIGO JA DIRECIONA PARA A FUNCAO DE 90 GRAUS, EVITAR BUGS
			CALL PERDE_TEMPO_MOTOR ; CASO CONTRARIO, ESPERE UM POUCO ANTES DE VOLTAR A CHECAGEM DE BOTOES (EFEITO BOUNCE)
			GOTO INICIO
BOTAO_1
			movlw b'11111111' ;USANDO O CALCULO DE TEMPO COM O SERVO-MOTOR, PARA CONFIGURAR 0 GRAUS.
			movwf PORTC
			CALL PERDE_TEMPO_3
			CLRF PORTC
			CALL PERDE_TEMPO_4
			BTFSS PORTB, 0
		GOTO BOTAO_0 ; CASO O USUARIO LOGO EM SEGUIDA PRESSIONE O BOTAO ANTERIOR, O CODIGO JA DIRECIONA PARA A FUNCAO DE 0 GRAUS, EVITAR BUGS
			CALL PERDE_TEMPO_MOTOR ; CASO CONTRARIO, ESPERE UM POUCO ANTES DE VOLTAR A CHECAGEM DE BOTOES (EFEITO BOUNCE)
			GOTO INICIO
BOTAO_2
			movlw b'00001100' ;MOTOR DE PASSO 1 SENTIDO HORARIO
			movwf PORTD ; 
			call PERDE_TEMPO_MOTOR
			movlw b'00000110'
			movwf PORTD
			call PERDE_TEMPO_MOTOR			
			movlw b'00000011'
			movwf PORTD
			call PERDE_TEMPO_MOTOR
			movlw b'00001001'
			movwf PORTD
			call PERDE_TEMPO_MOTOR
			BTFSS PORTB, 2
		GOTO BOTAO_2 ;AGUARDA USUARIO SOLTAR O BOTAO PARA PARAR DE GIRAR
			CALL PERDE_TEMPO_MOTOR
			GOTO INICIO
BOTAO_3
			movlw b'00001001' ;MOTOR DE PASSO 1 SENTIDO ANTI-HORARIO
			movwf PORTD
			call PERDE_TEMPO_MOTOR
			movlw b'00000011'
			movwf PORTD
			call PERDE_TEMPO_MOTOR
			movlw b'00000110'
			movwf PORTD
			call PERDE_TEMPO_MOTOR		
			movlw b'00001100'
			movwf PORTD
			call PERDE_TEMPO_MOTOR
			BTFSS PORTB, 3
		GOTO BOTAO_3 ;AGUARDA USUARIO SOLTAR O BOTAO PARA PARAR DE GIRAR
			CALL PERDE_TEMPO_MOTOR
			GOTO INICIO
BOTAO_4
			movlw b'00001100' ;MOTOR DE PASSO 2 SENTIDO HORARIO
			movwf PORTA
			call PERDE_TEMPO_MOTOR
			movlw b'00000110'
			movwf PORTA
			call PERDE_TEMPO_MOTOR			
			movlw b'00000011'
			movwf PORTA
			call PERDE_TEMPO_MOTOR
			movlw b'00001001'
			movwf PORTA
			call PERDE_TEMPO_MOTOR
			BTFSS PORTB, 0
		GOTO BOTAO_4 ;AGUARDA USUARIO SOLTAR O BOTAO PARA PARAR DE GIRAR
			CALL PERDE_TEMPO_MOTOR
			GOTO INICIO
BOTAO_5
			movlw b'00001001' ;MOTOR DE PASSO 2 SENTIDO ANTI-HORARIO
			movwf PORTA
			call PERDE_TEMPO_MOTOR
			movlw b'00000011'
			movwf PORTA
			call PERDE_TEMPO_MOTOR
			movlw b'00000110'
			movwf PORTA
			call PERDE_TEMPO_MOTOR		
			movlw b'00001100'
			movwf PORTA
			call PERDE_TEMPO_MOTOR
			BTFSS PORTB, 1
		GOTO BOTAO_5 ;AGUARDA USUARIO SOLTAR O BOTAO PARA PARAR DE GIRAR
			CALL PERDE_TEMPO_MOTOR
			GOTO INICIO		

PERDE_TEMPO
 			MOVLW d'6' ;Função que 'perde' tempo, aguardando um intervalo de tempo sem nenhuma instrução (necessário para evitar alguns bugs)
 			MOVWF VEZES
LOOP_VEZES
 			MOVLW d'250'
		 	MOVWF DELAY
 			CALL DELAY_US
 			DECFSZ VEZES,1
 			GOTO LOOP_VEZES
			RETURN
DELAY_US
 			NOP
 			NOP
 			DECFSZ DELAY,1
 			GOTO DELAY_US
 			RETURN



PERDE_TEMPO_2
 			MOVLW d'74' ;Função que 'perde' tempo, aguardando um intervalo de tempo sem nenhuma instrução (necessário para evitar alguns bugs)
 			MOVWF VEZES
LOOP_VEZES_2
 			MOVLW d'250'
		 	MOVWF DELAY
 			CALL DELAY_US_2
 			DECFSZ VEZES,1
 			GOTO LOOP_VEZES_2
			RETURN
DELAY_US_2
 			NOP
 			NOP
 			DECFSZ DELAY,1
 			GOTO DELAY_US_2
 			RETURN




PERDE_TEMPO_3
 			MOVLW d'10' ;Função que 'perde' tempo, aguardando um intervalo de tempo sem nenhuma instrução (necessário para evitar alguns bugs)
 			MOVWF VEZES
LOOP_VEZES_3
 			MOVLW d'250'
		 	MOVWF DELAY
 			CALL DELAY_US_3
 			DECFSZ VEZES,1
 			GOTO LOOP_VEZES_3
			RETURN
DELAY_US_3
 			NOP
 			NOP
 			DECFSZ DELAY,1
 			GOTO DELAY_US_3
 			RETURN



PERDE_TEMPO_4
 			MOVLW d'70' ;Função que 'perde' tempo, aguardando um intervalo de tempo sem nenhuma instrução (necessário para evitar alguns bugs)
 			MOVWF VEZES
LOOP_VEZES_4
 			MOVLW d'250'
		 	MOVWF DELAY
 			CALL DELAY_US_4
 			DECFSZ VEZES,1
 			GOTO LOOP_VEZES_4
			RETURN
DELAY_US_4
 			NOP
 			NOP
 			DECFSZ DELAY,1
 			GOTO DELAY_US_4
 			RETURN

PERDE_TEMPO_MOTOR
 			MOVLW d'30' ;Função que 'perde' tempo, aguardando um intervalo de tempo sem nenhuma instrução (necessário para evitar alguns bugs)
 			MOVWF VEZES
LOOP_VEZES_MOTOR
 			MOVLW d'30'
		 	MOVWF DELAY
 			CALL DELAY_US_MOTOR
 			DECFSZ VEZES,1
 			GOTO LOOP_VEZES_MOTOR
			RETURN
DELAY_US_MOTOR
 			NOP
 			NOP
 			DECFSZ DELAY,1
 			GOTO DELAY_US_MOTOR
 			RETURN								
END
