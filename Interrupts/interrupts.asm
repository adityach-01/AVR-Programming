; programming timer0 to generate a square wave of time period 12.5us at pin 5 of PORTB with clock frequency = 8Mhz, but now using interrupts
; meanwhile the microcontroller will send data from portc to portd

.INCLUDE "M32DEF.INC"
.EQU delay = 6.25
.EQU clock = 8
.EQU pin = 5

.ORG 0x0
    jmp main
.ORG 0x16     ; ROM location for timer0 overflow
    jmp timer_interrupt   ; ISR for timer0


main:
; CPU stack initialisation
    ldi r20, high(RAMEND)
    out sph, r20
    ldi r20, low(RAMEND)
    out spl, r20

    sbi ddrb, pin
    
    ; setting the global interrupt enable
    sei 
    ; enabling the timer0 overflow interrupt
    ldi r20, 1<<toie0
    out timsk, r20

    ; setting the timer configuration
    ldi r20, (256 - (delay*clock))
    out tcnt0, r20
    ldi r20, 0x01     
    out tccr0, r20    ; normal mode and no prescaler

    ; setting up portc and portd
    ldi r20, 0
    out ddrc, r20
    ldi r20, 0xFF
    out ddrd, r20

    ; infinite loop for carrying out the non interrupt task
here:
; can have any task here
    in r20, pinc
    out portd, r20
    jmp here

;--- interrupt service routine for timer0 overflow
timer_interrupt:
    in r17, portb
    ldi r16, (1<<pin)
    eor r17,r16     ; toogling the bits of r17
    out portb, r17

    ldi r20, (256 - (delay*clock))  ; reloading the tcnt0 register 
    out tcnt0, r20
    reti   ; return and set global interrupt enable

