LIST P=16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF &_DEBUG_OFF & _CPD_OFF
radix dec
; Reset vector
org 0x00
; ---------- Initialization ---------------------------------
BSF	    STATUS, RP0	
CLRF	    TRISA  
CLRF	    TRISD  

   ; LAB	: LAB 08
   ; NAME	: ÖMER FARUK
   ; SURNAME	: LALE
   ; NUMBER	: 152120181039
    
MOVLW 0xFF
MOVWF TRISB 

BCF	    STATUS, RP0
CLRF	    PORTD	
CLRF	    PORTA

BSF PORTA,5
   
counter EQU 0x20
MOVLW d'0'
MOVWF counter
 
    _WHILE
	Increment_Button
	    BTFSC PORTB, 3
	    GOTO  Decrement_Button

	    MOVLW d'9'
	    SUBWF counter,W
	    BTFSS STATUS,Z
	    GOTO _ELSE

	    CLRF counter
	    GOTO Next_Statement
	    
	    _ELSE
		INCF counter,F

	Decrement_Button
	    BTFSC PORTB, 4
	    GOTO  Reset_Button

	    MOVLW d'0'
	    SUBWF counter,W
	    BTFSS STATUS,Z
	    GOTO _ELSE2
	    
	    MOVLW d'9'
	    MOVWF counter
	    GOTO Next_Statement
	    
	    _ELSE2
		DECF counter,F

	Reset_Button
	    BTFSC PORTB, 5
	    GOTO Next_Statement
	    
	    CLRF counter
	
	Next_Statement
	    MOVF counter,W
	    CALL GetCode
	    MOVWF PORTD

	    CALL Delay_100ms
	    GOTO _WHILE    
    END_WHILE	
	
Delay_100ms
i	EQU	    0x70		   
j	EQU	    0x71		   
	MOVLW	    d'100'		   
	MOVWF	    i			   
Delay100ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    j			   
Delay100ms_InnerLoop	
	NOP
	DECFSZ	    j, F		   
	GOTO	    Delay100ms_InnerLoop

	DECFSZ	    i, F		   
	GOTO	    Delay100ms_OuterLoop    
	RETURN
	
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
	
LOOP GOTO  $
END
    
 
 
