    LIST 	P=16F877
    INCLUDE	P16F877.INC
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF 
    
   ; LAB	: LAB 07
   ; NAME	: ÖMER FARUK
   ; SURNAME	: LALE
   ; NUMBER	: 152120181039
    
    org	0x00	
	GOTO	MAIN
	
    #include <Delay.inc>
    #include <LcdLib.inc>

MAIN:    
    BSF     STATUS, RP0
    MOVLW	0x0
    MOVWF	TRISD
    MOVWF	TRISE
    MOVWF	TRISB
    MOVWF	TRISA
    
    MOVLW	0x03
    MOVWF	ADCON1

    BCF	    STATUS, RP0
    CLRF	PORTD
    CLRF	PORTA
    CLRF	PORTB
    CALL	LCD_Initialize

    number EQU 0x24
    digit0 EQU 0x20
    digit1 EQU 0x21	
    no_iteration EQU 0x22
    i EQU 0x23

    CLRF    i
    CLRF    number

    MOVLW d'90'
    MOVWF no_iteration

    MOVLW d'0'
    MOVWF digit0

    MOVLW d'0'
    MOVWF digit1

    _WHILE
	BCF PORTA,5
	BCF PORTA,4
	CALL DisplayCounter
	_FOR
	    MOVF no_iteration,W
	    SUBWF i,W
	    BTFSC STATUS,C
	    GOTO END_FOR

	    BSF PORTA,5
	    BCF PORTA,4
	    MOVF digit0,W
	    CALL GetCode
	    MOVWF PORTD
	    CALL Delay_5ms

	    BSF PORTA, 4
	    BCF PORTA,5
	    MOVF digit1,W
	    CALL GetCode
	    MOVWF PORTD
	    CALL Delay_5ms
	    INCF i,F
	    GOTO _FOR	
	END_FOR

	CLRF i
	INCF digit0,F

	_IF
	    MOVLW d'10'
	    SUBWF digit0,W
	    BTFSS STATUS,Z
	    GOTO NEXT_IF
	    CLRF digit0
	    INCF digit1,F

	NEXT_IF
	    MOVLW d'2'
	    SUBWF digit1,W
	    BTFSS STATUS,Z
	    GOTO _WHILE

	    MOVLW d'1'
	    SUBWF digit0,W
	    BTFSS STATUS,Z
	    GOTO _WHILE
	    
	    CLRF digit0
	    CLRF digit1
	    BCF PORTA,5
	    BCF PORTA,4
	    CALL NEXT_TEXT
	    GOTO _FOR
	END_IF
    END_WHILE

GetCode
    ADDWF   PCL, F
    RETLW   B'00111111'		; 0
    RETLW   B'00000110'		; 1
    RETLW   B'01011011'		; 2
    RETLW   B'01001111'		; 3
    RETLW   B'01100110'		; 4
    RETLW   B'01101101'		; 5
    RETLW   B'01111101'		; 6
    RETLW   B'00000111'		; 7
    RETLW   B'01111111'		; 8
    RETLW   B'01101111'		; 9    
    RETLW   B'01110111'		; A
    RETLW   B'01111100'		; b    
    RETLW   B'00111001'		; C    
    RETLW   B'01011110'		; d    
    RETLW   B'01111001'		; E    
    RETLW   B'01110001'		; F 

DisplayCounter
    call	LCD_Clear

    movlw	'C'	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	'u'	
    call	LCD_Send_Char
    movlw	'n'	
    call	LCD_Send_Char
    movlw	't'	
    call	LCD_Send_Char
    movlw	'e'	
    call	LCD_Send_Char
    movlw	'r'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	'V'	
    call	LCD_Send_Char
    movlw	'a'	
    call	LCD_Send_Char
    movlw	'l'	
    call	LCD_Send_Char
    movlw	':'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    
    MOVF	digit1, W 
    ADDLW	'0'	  
    CALL	LCD_Send_Char

    
    MOVF	digit0, W 
    ADDLW	'0'	  
    CALL	LCD_Send_Char
    
    CALL	LCD_MoveCursor2SecondLine    
    
    movlw	'C'	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	'u'	
    call	LCD_Send_Char
    movlw	'n'	
    call	LCD_Send_Char
    movlw	't'	
    call	LCD_Send_Char
    movlw	'i'	
    call	LCD_Send_Char
    movlw	'n'	
    call	LCD_Send_Char
    movlw	'g'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	'u'	
    call	LCD_Send_Char
    movlw	'p'	
    call	LCD_Send_Char
    movlw	'.'	
    call	LCD_Send_Char
    movlw	'.'	
    call	LCD_Send_Char
    movlw	'.'	
    call	LCD_Send_Char
    RETURN
NEXT_TEXT	
    call	LCD_Clear
    
    movlw	'C'	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	'u'	
    call	LCD_Send_Char
    movlw	'n'	
    call	LCD_Send_Char
    movlw	't'	
    call	LCD_Send_Char
    movlw	'e'	
    call	LCD_Send_Char
    movlw	'r'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	'V'	
    call	LCD_Send_Char
    movlw	'a'	
    call	LCD_Send_Char
    movlw	'l'	
    call	LCD_Send_Char
    movlw	':'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    
    MOVF	digit1, W
    ADDLW	'0'	 
    CALL	LCD_Send_Char

   
    MOVF	digit0, W
    ADDLW	'0'	 
    CALL	LCD_Send_Char
    
    CALL	LCD_MoveCursor2SecondLine
    movlw	'R'	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	'l'	
    call	LCD_Send_Char
    movlw	'l'	
    call	LCD_Send_Char
    movlw	'e'	
    call	LCD_Send_Char
    movlw	'd'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	'v'	
    call	LCD_Send_Char
    movlw	'e'	
    call	LCD_Send_Char
    movlw	'r'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	't'	
    call	LCD_Send_Char
    movlw	'o'	
    call	LCD_Send_Char
    movlw	' '	
    call	LCD_Send_Char
    movlw	'0'	
    call	LCD_Send_Char
    RETURN
LOOP GOTO  $
END