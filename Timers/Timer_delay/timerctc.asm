; programming timer0 to generate a square wave of time period 12.5us at pin 5 of PORTB with clock frequency = 8Mhz using the ctc mode

.INCLUDE "M32DEF.INC"

.EQU delay = 6.25
.EQU clock = 8
.EQU pin = 5

; initialising the CPU stack for CALL instruction
; giving the last location of the RAM in the stack pointer register
ldi r16, high(RAMEND)
out sph, r16            
ldi r16, low(RAMEND)    
out spl, r16 

; setting up pin 5 of PORTB as output
ldi r16, 1<<pin
sbi ddrb, pin        ; setting 5th bit of ddrb register as high
ldi r17, 0
out portb, r17

; wave generator label
wave: 
    rcall delay
    eor r17,r16        ; flipping the 5th bit of r17
    out portb, r17
    rjmp wave

; delay subroutine for generating the delay of 
delay:
    ; lodaing the TCNT0 and TCCR0 registers
    ldi r20,0
    out tcnt0, r20

    ldi r20, delay*clock
    out ocr0, r20

    ldi r20, 0x09
    out tccr0,r20     ; normal mode with no prescaler, CTC mode

again:
    in r20, tifr
    sbrs r20, ocf0   ; skip next instruction if ocf0 flag is set, is set when tcnt0 == ocr0
    rjmp again
    ldi r20, 0x0  
    out tccr0, r20    ; clearing the timer
    ldi r20, (1<<ocf0)  ; clearing the tov0 flag
    out tifr, r20
    ret

