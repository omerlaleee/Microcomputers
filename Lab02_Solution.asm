    LIST 	P=16F877A
    INCLUDE	P16F877.INC
    radix	dec
    __CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF & _DEBUG_OFF & _CPD_OFF

    ; Reset vector
    org 0x00
    ; ---------- Initialization ---------------------------------
    BSF     STATUS, RP0			; Select Bank1
    CLRF    TRISB	                ; Set all pins of PORTB as output
    CLRF    TRISD	                ; Set all pins of PORTD as output
    BCF     STATUS, RP0			; Select Bank0    
    CLRF    PORTB	                ; Turn off all LEDs connected to PORTB
    CLRF    PORTD			; Turn off all LEDs connected to PORTD
    
    ; ---------- Your code starts here --------------------------
    
    ; LAB	: 02
    ; NAME	: ÖMER FARUK
    ; SURNAME	: LALE
    ; NUMBER	: 152120181039

x	EQU	0x20
y	EQU	0x21
box	EQU	0x22
	
    MOVLW	d'3'		    ; WREG = 5
    MOVWF	x		    ; x = WREG
    MOVLW	d'1'		    ; WREG = 6
    MOVWF	y		    ; y = WREG
    
    BTFSC   x,	7		    ; if x<0 go to error
    GOTO    errorr
    
    MOVF    x,	W		    ; WREG = x
    SUBLW   d'11'		    ; WREG = x - WREG
    BTFSS   STATUS, C		    ; if x>11 go to error
    GOTO    errorr
    
    BTFSC   y,	7		    ; if y<0 go to error
    GOTO    errorr
    
    MOVF    y,	W		    ; WREG = y
    SUBLW   d'10'		    ; WREG = y - WREG
    BTFSS   STATUS, C		    ; if y>10 go to error
    GOTO    errorr
    
    MOVF    x, W		    ; WREG = x
    SUBLW   d'3'		    ; WREG = 3 - WREG
    BTFSC   STATUS, C		    ; if x>3 skip next instruction
    GOTO    if_x_less_than_and_equal_to_3
    
    MOVF    x,	W		    ; WREG = x
    SUBLW   d'7'		    ; WREG = 7 - WREG
    BTFSC   STATUS, C		    ; if x>7 skip next instruction
    GOTO    if_x_less_than_and_equal_to_7
    
; else
    MOVF    y,	W		    ; WREG = y
    SUBLW   d'2'		    ; WREG = 2 - WREG
    BTFSS   STATUS, C		    ; if y>2 skip next instruction
    GOTO    if_y_greater_than_2
    MOVLW   d'9'		    ; WREG = 9
    MOVWF   box			    ; box = WREG
    GOTO    next_statement
if_y_greater_than_2:
    MOVF    y,	W		    ; WREG = y
    SUBLW   d'6'		    ; WREG = 6 - WREG
    BTFSS   STATUS, C		    ; if y>6 skip next instruction
    GOTO    if_y_greater_than_6
    MOVLW   d'8'		    ; WREG = 8
    MOVWF   box			    ; box = WREG
    GOTO    next_statement
if_y_greater_than_6:
    MOVF    y,	W		    ; WREG = y
    SUBLW   d'8'		    ; WREG = 8 - WREG
    BTFSS   STATUS, C		    ; if y>8 skip next instruction
    GOTO    if_y_greater_than_8
    MOVLW   d'7'		    ; WREG = 7
    MOVWF   box			    ; box = WREG
    GOTO    next_statement
if_y_greater_than_8:
    MOVLW   d'6'		    ; WREG = 6
    MOVWF   box			    ; box = WREG
    GOTO    next_statement
; end of else part
    
; else if (x <= 7)    
if_x_less_than_and_equal_to_7:
    MOVF    y,	W		    ; WREG = y
    SUBLW   d'5'		    ; WREG = 5 - WREG
    BTFSS   STATUS, C		    ; if y>5 skip next instruction
    GOTO    if_y_greater_than_5
    MOVLW   d'5'		    ; WREG = 5
    MOVWF   box			    ; box = WREG
    GOTO    next_statement
if_y_greater_than_5:
    MOVLW   d'4'		    ; WREG = 4
    MOVWF   box			    ; box = WREG
    GOTO    next_statement
; end of else if (x <= 7) part
    
; else if (x <= 3)
if_x_less_than_and_equal_to_3:
    MOVF    y,	W		    ; WREG = y
    SUBLW   d'1'		    ; WREG = 1 - WREG
    BTFSS   STATUS, C		    ; if y>1 skip next instruction
    GOTO    if_y_greater_than_1
    MOVLW   d'3'		    ; WREG = 3
    MOVWF   box			    ; box = WREG
    GOTO    next_statement
if_y_greater_than_1:
    MOVF    y,	W		    ; WREG = y
    SUBLW   d'4'		    ; WREG = 4 - WREG
    BTFSS   STATUS, C		    ; if y>4 skip next instruction
    GOTO    if_y_greater_than_4
    MOVLW   d'2'		    ; WREG = 2
    MOVWF   box			    ; box = WREG
    GOTO    next_statement
if_y_greater_than_4:
    MOVLW   d'1'		    ; WREG = 1
    MOVWF   box			    ; box = WREG
    GOTO    next_statement
; end of else if (x <= 3) part

errorr:
    MOVLW   -d'1'
    MOVWF   box
    GOTO    next_statement
        
next_statement:
    MOVF    box,    W
    
    ; ---------- Your code ends here ----------------------------    
    MOVWF   PORTD    	; Send the result stored in WREG to PORTD to display it on the LEDs
    
LOOP    GOTO    $	; Infinite loop
     END                               ; End of the program
