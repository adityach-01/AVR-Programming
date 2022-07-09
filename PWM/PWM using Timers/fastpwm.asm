; code to generate PWM wave using the fast PWM mode
; duty cycle is given by (OCR0+1)/256 in non-inverted mode
; We just need to set up the OCR0 and TCCR0 registers to enable this mode
; Wave will be generated at PORTB.3

.INCLUDE "M32DEF.INC"
.EQU duty_cycle = 0.25
.EQU pinout = 3

; setting up the output pin
sbi ddrb, pinout

; loading the ocr0 register will appropriate value
ldi r20, (duty_cycle*256)-1
out ocr0, r20

; setting up the tccro register
ldi r20, 1<<wgm00 | 1<<wgm01   ; fast PWM moode
or r20, 1<<com01   ; non-inverted mode
or r20, 1<<cs00    ; no prescaler
out tccr0, r20

here:
    ; CPU free to do other tasks
    jmp here