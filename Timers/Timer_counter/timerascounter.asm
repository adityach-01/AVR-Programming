; programming timer0 as a counter to count the clock signal connected to pin0 of PORTB and ring a buzzer at pin0 of PORTC every 100 counts

.INCLUDE "M32DEF.INC"

.EQU count = 100
.EQU pin_in = 0
.EQU pin_out = 0

; initialising the CPU stack for CALL instruction
; giving the last location of the RAM in the stack pointer register
ldi r16, high(RAMEND)
out sph, r16            
ldi r16, low(RAMEND)    
out spl, r16 

; setting up pin0 of PORTB as input and pin0 of PORTC as output
cbi ddrb, pin_in
sbi ddrc, pin_out

; setting the registers for toggling action
ldi r16, 1<<pin_out
ldi r17, 0x00
ldi r20, 7 | (1<<wgm01)   ; ctc mode
out tccr0, r20  
ldi r20, count
out ocr0, r20

wave:
    in r20,tifr
    sbrs r20,ocf0
    rjmp wave
    ldi r20, 1<<ocf0   ; clearing the ocfo flag
    out tifr, r20

    eor r17,r16
    out portc, r17
    rjmp wave



