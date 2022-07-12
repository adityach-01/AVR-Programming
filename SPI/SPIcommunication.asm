; data to be outputted and inputted through PORTA.
.INCLUDE "M32DEF.INC"

; setting up the pins at porta for transmission and receiving
.EQU SCLK = 0
.EQU MOSI = 1
.EQU CS = 2
.EQU MISO = 3

; setting up the register names
.EQU spi_send r16
.EQU highb r17
.EQU lowb r18
.EQU counter r20
.EQU temp r19   ; if zero data will be loaded in highb, if 1 data will be loaded in lowb, as the input data is 16 bit data

main:
    ddrb = 0b00000111  ; no/no/no/no/MISO/CS/MOSI/SCLK
    porta = 0xFF       ; setting CS bit to 1
    ldi temp, 1

loop:

    ; generate delay for some time

    ldi, spi_send, $FA    ; address of the register containing the MSB of the temperature
    rjmp spi_transmit     ; transmit data

    rjmp spi_transmit     ; receiving data in high register
    rjmp spi_transmit     ; receiving data in low register

    ;instruction to display contents
    ;<---->
    ;<---->
    ;<---->
    rjmp loop

; transmits the data in r16 register to the peripheral device from MSB to LSB
spi_transmit:
    ldi counter, 8
    cbi porta, CS     ; enable SPI communication

spi_loop:
    rol spi_send  ; move MSB of the output data into the carry flag
    brcs spi_1
    cbi porta, MOSI   ; 0 was the MSB of data
    rjmp spi_2
spi_1:
    sbi porta, MOSI   ; 1 was the MSB of data
spi_2:
    inc porta         ; set clock signal high
    nop               ; wait for input data to arrive
    sbis pina, MISO  ; skip next instruction if input is 1
    rjmp set_carry_0              
    sec               ; carry flag to 1
    rjmp spi_3
set_carry_0:
    clc
spi_3:
    cpi temp,1
    brne send_high   ; jump if Z bit is not zero, that is temp is 0, means we have to send data in high register
    rjmp send_low
send_high:
    rol highb        ; rotate the register with LSB becoming carry flag and carry flag becoming the MSB of the register
    rjmp final
send_low:
    rol lowb
final:
    dec porta       ; setting the clock to zero
    dec counter
    brne spi_loop   ; Continue to send/receive data if the Z flag is not zero
    sbi porta, CS   ; stopping SPI communication
    eor temp, 1     ; flipping bit of temp
    ldi spi_send, 0
    ret
