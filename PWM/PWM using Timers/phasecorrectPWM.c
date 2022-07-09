#include "avr/io.h"
#define duty_cycle 0.25
#define pinout 3

// using the phase correct PWM and non-inverted mode

int main(){
    ddrb = 1<<pinout;
    ocr0 = (int)(duty_cycle*(float)(255));

    tccr0 = 0b01100001;  // phase correct PWM, non-inverted, no prescaler

    while(1){
        //other CPU tasks
    }
}