#include "avr/io.h"
#define pin 5;
#define clock 8;
#define delay 6.25;

// delay is in microsecond and clock is in MHz

int main(){
    ddrb = 1<<pin;
    portb = 0;
    unsigned char c = 1<<pin;

    while(1){
        delay_time(delay);
        portb = portb^c;  // flipping the 5th bit of portb
    }
}

void delay_time(float time){
    tcnt0 = 256 - (int)(time*(float)clock);
    if(tcnt0 < 0) tcnt0 = 0;
    tccr0 = 0x01;   // no prescalar, normal mode

    while((tifr&0x1) == 0);   // wait till the tov0 flag sets up
    tccr0 = 0;   // disabling the timer
    tifr = 0x1;  // clearing the tov0
}
