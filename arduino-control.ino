/*
 * Code to control both a stepper motor and servo on the same board at the same time using IR remote to control actions.
 * 
 */


//#define DECODE_DENON        // Includes Sharp
//#define DECODE_JVC
//#define DECODE_KASEIKYO
//#define DECODE_PANASONIC    // the same as DECODE_KASEIKYO
//#define DECODE_LG
#define DECODE_NEC          // Includes Apple and Onkyo
//#define DECODE_SAMSUNG
//#define DECODE_SONY
//#define DECODE_RC5
//#define DECODE_RC6

//#define DECODE_BOSEWAVE
//#define DECODE_LEGO_PF
//#define DECODE_MAGIQUEST
//#define DECODE_WHYNTER

//#define DECODE_DISTANCE     // universal decoder for pulse width or pulse distance protocols
//#define DECODE_HASH         // special decoder for all protocols

#include <Arduino.h>

/*
 * Define macros for input and output pin etc.
 */
#include <IRremote.h>
#include <Stepper.h>
#include <Servo.h>

int servo_pos = 1;
int servo_increment = 1;
unsigned long servo_prev_millis = 0;
int servo_interval = 10;
bool servo_is_on = false;

unsigned long stepper_prev_millis = 0;
unsigned long pause_millis = 0;
int stepper_direction = 0;
int stepper_steps_left = 0;
int stepper_revolutions = 1;
const int stepsPerRevolution = 2048;
int stepper_interval = 6;
bool is_paused = false;


Servo servo;
Stepper myStepper(stepsPerRevolution, 2, 4, 3, 5);

void setup() {
    // Serial.begin(9600);
    // Just to know which program is running on my Arduino
    myStepper.setSpeed(25);
    servo.attach(9);
    /*
     * Start the receiver, enable feedback LED and take LED feedback pin from the internal boards definition
     */
    IrReceiver.begin(7, false);
}

void loop() {
    // Servo step
    if (servo_is_on == true && millis() - servo_prev_millis >= servo_interval){
        if ((servo_pos > 179) || (servo_pos < 1)) // end of sweep
        {
          // reverse direction
          servo_increment = -servo_increment;
        }
        servo_pos += servo_increment;
        servo.write(servo_pos);
        servo_prev_millis = millis();
    }
    
    // Stepper step
    if (millis() - stepper_prev_millis >= stepper_interval){
      if (is_paused == false && stepper_steps_left > 0){
        myStepper.step(stepper_direction);
        stepper_steps_left -= 1;
      }
      stepper_prev_millis = millis();
    }

    // IR read step
    if (IrReceiver.decode()) {     
        IrReceiver.resume(); // Enable receiving of the next value
        if (IrReceiver.decodedIRData.command == 0x16) {
          if (millis() - pause_millis >= 500){
              servo_is_on = !servo_is_on;
              pause_millis = millis();
            }
        }
        
        if (IrReceiver.decodedIRData.command == 0x44) {
          is_paused = false;
            //Serial.println("Motor up!");
            if (stepper_direction != 1){
              stepper_direction = 1;
              stepper_steps_left = (stepper_revolutions * stepsPerRevolution);
            }
        } 
        else if (IrReceiver.decodedIRData.command == 0x40) {
            //Serial.println("Motor down!");
            is_paused = false;
            if (stepper_direction != -1){
              stepper_direction = -1;
              stepper_steps_left = (stepper_revolutions * stepsPerRevolution);
            }
        }

        else if (IrReceiver.decodedIRData.command == 0x43){
          //Serial.println("Pause!");
          // stepper_direction = 0;
          if (millis() - pause_millis >= 500){
              is_paused = !is_paused;
              pause_millis = millis();
            }
//          if (IrReceiver.decodedIRData.command == 0x43){
//            stepper_direction = go_direction;
//          }
          //stepper_steps_left = stepper_steps_left;
        }
    }
}
