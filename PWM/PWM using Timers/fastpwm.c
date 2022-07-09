#include "avr/io.h"
#define duty_cycle 0.25
#define pinout 3

// using the fast PWM mode

int main(){
    ddrb = 1<<pinout;
    ocr0 = (int)(duty_cycle*(float)(256))-1;

    tccr0 = 0b01101001;  // fast PWM, non-inverted, no prescaler

    while(1){
        //other CPU tasks
    }
}