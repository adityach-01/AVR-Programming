; we generate a PWM pulse of 50% duty cycle from PORTB.0 if PORTA.0 is low and at 25% duty cycle if PORTA.0 is high by generating delay from CPU

.INCLUDE "M32DEF.INC"
.EQU input = 0
.EQU output = 0


; stack pointer initialization
ldi r20, high(RAMEND)
out sph, r20
ldi r20, low(RAMEND)
out spl, r20

; setting the ports as output or input
sbi ddrb,output
cbi ddra, input
sbi porta, input
cbi portb, output   ; turn off pulse

check:
    sbic pina, input
    rjmp pulse50
    cbi portb, output    ; low portion of pusle
    rcall delay
    rcall delay
    rcall delay
    sbi portb, output    ; high portion of pulse
    rcall delay
    rjmp check

; for generating the pulse with 50% duty cycle
pulse50:
    sbi portb, output   ; high portion of pulse
    rcall delay
    rcall delay
    cbi portb, output  ; low portion of pulse
    rcall delay
    rcall delay
    rjmp check


; subroutine for generating time delay
delay:
    ldi r16, 200
p1: 
    ldi r17, 200
p2:
    dec r17
    brne p2    ; if r17 is not zero, jumpr to p2
    dec r16
    brne p1    ; if r16 is not zero, jump to p1
    ret


