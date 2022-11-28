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
    
    ; LAB	: 04
    ; NAME	: ÖMER FARUK
    ; SURNAME	: LALE
    ; NUMBER	: 152120181039
    ; NOTE	: You should watch 0x24 address to see sum value and 
    ;		: address of the array begins from the 0x35.
    ;		: to see the first 5 elements of the array ? 0x35, 0x36, 0x37, 0x38, 0x39

x	    EQU	0x20
y	    EQU	0x21
N	    EQU	0x22
noElements  EQU	0x23
sum	    EQU 0x24

count	    EQU 0x25
_low	    EQU	0x26
_high	    EQU	0x27
z	    EQU 0x28
tempx	    EQU 0x30
tempy	    EQU 0x31
tempxy	    EQU 0x32
Q	    EQU 0x33
A	    EQU 0x35

; BEGINNING OF THE MAIN
    MOVLW   d'7'
    MOVWF   x
    MOVLW   d'11'
    MOVWF   y
    MOVLW   d'23'
    MOVWF   N
    CALL    GenerateNumbers
    MOVWF   noElements
    CALL    AddNumbers
    MOVWF   sum
    CALL    DisplayNumbers
; END OF THE MAIN
  
; BEGINNING OF THE MULTIPLY FUNCTION
Multiply
    MOVF    x, W	; WREG = x
    MOVWF   tempx	; tempx = WREG = x
    MOVF    y, W	; WREG = y
    MOVWF   tempy	; tempy = WREG = y
    
    CLRF    _low	; low = 0
    CLRF    _high	; high = 0
    MOVF    tempy, F	; Y = Y
    BTFSC   STATUS, Z	; Is Y==0?
    RETURN		; Return from the function if Y == 0

    MOVFW   tempx	; WREG = X
Multiply_Loop
    ADDWF   _low, F	; low = low + WREG
    BTFSC   STATUS, C	; Is there a carry from this addition? If there is no carry skip next, otherwise call next.
    INCF    _high, F	; high = high + 1
    DECFSZ  tempy, F	; tempy = tempy - 1 and skip the next instruction if the result is 0.
    GOTO    Multiply_Loop
    
    MOVLW   z		; WREG = &z
    MOVWF   FSR		; FSR = &z 
    
    MOVF    _low, W	; WREG = R_L
    MOVWF   INDF	; INDF = WREG => &z = WREG => &z = low
    
    MOVF    _high, W	; WREG = high
    INCF    FSR, F	; FSR++ => FSR ? z++
    MOVWF   INDF	; INDF = WREG => &z++ = WREG => &z++ = high
    
    MOVF    z, W	; WREG = z
    ADDWF   z, W	; WREG = z + WREG
    ADDWF   z+1, W	; WREG = [z+1] + WREG
    RETURN		; return 2 * p[0] + p[1]
; END OF THE MULTIPLY FUNCTION
    

; BEGINNING OF THE GENERATE NUMBERS FUNCTION
GenerateNumbers
    CLRF    count	; count = 0
START_WHILE
    ; beginning of the first while condition
    MOVF    N, W	; WREG = N
    SUBWF   x, W	; WREG = x - N
    BTFSC   STATUS, C	; if there is no a carry (it means x < N), skip next instruction 
    GOTO    OTHER_CONDITION_OF_WHILE
    
    ; beginning of the if condition
IF_LABEL
    MOVF    x, W	; WREG = x
    ADDWF   y, W	; WREG = y + WREG
    MOVWF   tempxy	; tempxy(=x+y) = WREG
    BTFSS   tempxy, 0	; skip the next instruction if the first bit of the tempxy is clear (it means tempxy is even)
    GOTO    ELSE_LABEL
    ; end of the if condition
    
    ; beginning of the if part
    CALL    Multiply
    MOVWF   tempx	; WREG is the return value from the Multiply Function ? tempx = WREG
    MOVLW   A		; WREG = &A[0] = 0x35
    ADDWF   count, W	; WREG = count + WREG
    MOVWF   FSR		; [FSR] = &A[0+count]
    MOVF    tempx, W	; WREG = tempx
    MOVWF   INDF	; &A[count] = WREG
    INCF    FSR, F	; FSR++
    INCF    count, F	; count++
    INCF    x, F	; x++
    GOTO    START_WHILE
    ; end of the if part
    
    ; beginning of the else part
ELSE_LABEL
    MOVF    x, W	; WREG = x
    ADDWF   y, W	; WREG = y + WREG
    MOVWF   tempxy	; tempxy = WREG
    CLRF    Q		; Q = 0
  
Division_Loop
    MOVLW   d'3'	    ; WREG = 3
    SUBWF   tempxy, W	    ; WREG = tempxy - WREG
    ; lets say tempxy = 7 and then ? 7 / 3 ? 7-3 = 4 ? Q=1 ? 4-3 = 1 ? Q=2 ? 1-3 ? end division loop
    BTFSS   STATUS, C	    ; if tempxy >= WREG then skip next instruction
    GOTO    Division_End    
    
    INCF    Q, F	    ; Q++
    MOVWF   tempxy	    ; tempxy = WREG
    GOTO    Division_Loop
    
Division_End  
    MOVLW   A		    ; WREG = A[0]
    ADDWF   count, W	    ; WREG = count + WREG
    MOVWF   FSR		    ; FSR = A[count]
    MOVF    Q, W	    ; WREG = Q
    
    MOVWF   INDF	    ; A[count] = WREG = Q
    INCF    FSR, F	    ; FSR++
    INCF    count, F	    ; count++	
    MOVLW   d'3'	    ; WREG = 3
    ADDWF   y, F	    ; y = y + WREG
    GOTO    START_WHILE	
    ; end of the else part
    
    ; beginning of the second while condition
OTHER_CONDITION_OF_WHILE
    MOVF    N, W	; WREG = N
    SUBWF   y, W	; WREG = tempy - N
    BTFSC   STATUS, C	; if there is no a carry (it means y < N), skip next instruction 
    GOTO    END_LOOP
    ; end of the second while condition
    GOTO IF_LABEL
; end of while
END_LOOP
    MOVF    count, W	; return count;
    RETURN
; END OF THE GENERATE NUMBERS FUNCTION
    
; BEGINNING OF THE ADD NUMBERS FUNCTION
AddNumbers
i   EQU	0x34		; counter variable to for-loop
    CLRF    sum		; sum = 0
    CLRF    i		; i = 0
    MOVLW   A		; WREG = A[0]
    MOVWF   FSR		; FSR = &A[0]
Loop_Begin
    MOVF    count, W	; WREG = count
    SUBWF   i, W	; WREG = i - count
    BTFSC   STATUS, C	; if there is no overflow, then skip the next instruction
    GOTO    Loop_End	
    MOVF    INDF, W	; WREG = INDF
    ADDWF   sum, F	; WREG = sum + WREG
    INCF    FSR, F	; FSR++
    INCF    i, F	; i++
    GOTO    Loop_Begin
Loop_End
    MOVF    sum, W	; WREG = sum
    RETURN		; return sum;
; END OF THE ADD NUMBERS FUNCTION
    
    
; BEGINNING OF THE DISPLAY NUMBERS FUNCTION
DisplayNumbers
    BSF	    STATUS, RP0	; Select Bank 1
    CLRF    TRISD	; All pins of PORTD are output
    BSF	    TRISB, 3
    BCF	    STATUS, RP0	; Select Bank 0
    CLRF    PORTD	; All LEDs off
    
    MOVF    sum, W	; PORTD = sum
    MOVWF   PORTD	
    
BUSY_LOOP_BEGIN
    BTFSC   PORTB, 3
    GOTO    BUSY_LOOP_BEGIN
	
    CLRF    i		; i = 0
    MOVLW   A		; WREG = A[0]
    MOVWF   FSR		; FSR = &A[0]
Loop_Begin2
    MOVLW   d'5'	; iteration value of the for-loop
    SUBWF   i, W	; WREG = i - count
    BTFSC   STATUS, C	; if there is no overflow, then skip the next instruction
    GOTO    Loop_End2
    
    CALL    Delay250ms
    MOVF    INDF, W	; WREG = INDF
    MOVWF   PORTD
    
   
    INCF    FSR, F	; FSR++
    INCF    i, F	; i++
    
BUSY_LOOP_BEGIN2
    BTFSC   PORTB, 3
    GOTO    BUSY_LOOP_BEGIN2
    
    GOTO    Loop_Begin2
    
Loop_End2  

Delay250ms
k   EQU	0x70
j   EQU	0x71
	MOVLW	d'250'
	MOVWF	k
Delay250ms_OuterLoop
	MOVLW	d'250'
	MOVWF	j
Delay250ms_InnerLoop	
	NOP
	DECFSZ	j, F
	GOTO	Delay250ms_InnerLoop

	DECFSZ	k, F
	GOTO	Delay250ms_OuterLoop    
	RETURN	
; END OF THE DISPLAY NUMBERS FUNCTION
	    
   GOTO $
   END