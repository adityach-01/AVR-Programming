// programming timer0 to generate a square wave of time period 12.5us at pin 5 of PORTB with clock frequency = 8Mhz, but now using interrupts
// meanwhile the microcontroller will send data from portc to portd

#include "avr/io.h"
#include "avr/interrupt.h"
#define delay 6.25;
#define clock 8;
#define pin  5;

int main(){
    ddrb |= (1<<pin);
    ddrc = 0;
    ddrd = 0xFF;

    // setting the timer requirements
    timsk = (1<<toie0);
    sei()  // global interrupt enable

    tcnt0 = 256-(int)(delay*(float)clock);
    tccr0 = 0x01;  // no prescaler, normal mode

    while(1){
        portd = pinc;
    }
}

ISR(TIMER0_OVF_vect){
    unsigned char c = 1<<pin;
    portb = portb^c;  // flipping the bits
    tcnt0 = 256-(int)(delay*(float)clock);
}