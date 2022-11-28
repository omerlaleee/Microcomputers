LIST P=16F877A
INCLUDE P16F877.INC
__CONFIG _CP_OFF &_WDT_OFF & _BODEN_ON & _PWRTE_ON & _XT_OSC & _WRT_ENABLE_OFF & _LVP_OFF &_DEBUG_OFF & _CPD_OFF
radix dec
; Reset vector
org 0x00
; ---------- Initialization ---------------------------------
BSF	    STATUS, RP0	; Select Bank 1
CLRF	    TRISD	; All pins of PORTD output
BSF	    TRISB,3
    
BCF	    STATUS, RP0	; Select Bank 0
CLRF	    PORTD	; All LEDs off	
; ---------- Your code starts here --------------------------
    
   ; LAB	: 03
   ; NAME	: ÖMER FARUK
   ; SURNAME	: LALE
   ; NUMBER	: 152120181039
    
   zib0 EQU 0x20
   zib1 EQU 0x21
   zib  EQU 0X22
   i    EQU 0x23
   N    EQU 0x24
   temp EQU 0x25
	
   MOVLW d'13'
   MOVWF N	    ; int N = 13;
   
   MOVLW d'2'
   MOVWF i	    ; uint8_t i = 2;
   
   MOVLW d'1'
   MOVWF zib0	    ; uint8_t zib0 = 1;
   
   MOVLW d'2'
   MOVWF zib1	    ; uint8_t zib1 = 2;
   
loop_begin
	MOVF	i, W		    ; WREG = i
	SUBWF	N, W		    ; WREG = N - i
	BTFSS	STATUS, C	    ; check the i <= N condition of the for-loop
	GOTO	loop_end	    
; BODY OF THE LOOP
	MOVF	zib0, W		    ; WREG = zib0
	IORLW	0x05		    ; WREG = (zib0 | 0x05)
	MOVWF	temp		    ; temp = WREG = (zib0 | 0x05)
	MOVF	zib1, W		    ; WREG = zib1
	ANDLW	0x3f		    ; WREG = (zib1 & 0x3f)
	ADDWF	temp, W		    ; WREG = temp + WREG ==> (zib0 | 0x05) + (zib1 & 0x3f)
	MOVWF	zib		    ; zib = WREG = (zib0 | 0x05) + (zib1 & 0x3f)
	
	MOVF	zib1, W		    ; WREG = zib1
	MOVWF	zib0		    ; zib0 = WREG ==> zib0 = zib1;
	
	MOVF	zib, W		    ; WREG = zib
	MOVWF	zib1		    ; zib1 = WREG ==> zib1 = zib;
	
	INCF	i, F		    ; i++;
	
	CALL	Delay250ms
	
	MOVF	zib, W		    ; WREG = zib
	MOVWF	PORTD
	
BUSY_LOOP_BEGIN
	BTFSC PORTB, 3
	GOTO  BUSY_LOOP_BEGIN
	GOTO  loop_begin
loop_end
; END OF THE LOOP

; DELAY FUNCTION
Delay250ms:
k	EQU	    0x70		    
j	EQU	    0x71		
	MOVLW	    d'250'		
	MOVWF	    k			
Delay250ms_OuterLoop
	MOVLW	    d'250'
	MOVWF	    j			  
Delay250ms_InnerLoop	
	NOP
	DECFSZ	    j, F		
	GOTO	    Delay250ms_InnerLoop

	DECFSZ	    k, F		  
	GOTO	    Delay250ms_OuterLoop    
	RETURN	
; DELAY FUNCTION
	
lOOP GOTO	$	
END