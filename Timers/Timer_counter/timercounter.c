#include "avr/io.h"
#define count 100;
#define pin_in 0;
#define pin_out 0;

// delay is in microsecond and clock is in MHz
// programming timer0 as a counter to count the clock signal connected to pin0 of PORTB and ring a buzzer at pin0 of PORTC every 100 counts

int main(){
    ddrb = ~(1<<pin_in);
    ddrc = 1<<pin_out;
    portc = 0;
    unsigned char c = 1<<pin_out;
    tccr0 = 7;    // allowing the external signal to enter the timer0 and increment the tcnt0 register

    while(1){
        if(tcnt0 == count){
            tcnt0 = 0;
            portc = portc^c; // flipping the bits
        }
    }
}

