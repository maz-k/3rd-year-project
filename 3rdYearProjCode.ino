//**************************************
//Title: KANE_Madeleine_3rdYearProjCode
//Author: Madeleine Kane
//Last edited: 02/04/2024
//Code version: 4
//**************************************

#include <Servo.h>
Servo myservo;  // create servo object to control a servo
int upButton = 2;
int downButton = 3;

int speed = 90; // variable to store the servo speed
float est_ang_speed = 60/0.22*(speed-90); // variable to store the speed estimate in degrees per second
int pos_est = 0; // variable to store the estimate of the position

void setup() {
  myservo.attach(9, 1000, 2000); // attaches the servo on pin 9 to the servo object with a 1 to 2 ms pulse range 
  pinMode(upButton, INPUT_PULLUP); //sends a low signal to arduino when button is pressed
  pinMode(downButton, INPUT_PULLUP);
  Serial.begin(9600); //serial for debugging
}

void loop() {
  bool up = digitalRead(upButton);
  bool down = digitalRead(downButton);
  if (down == LOW) {
    //if (pos_est < 180) {
      est_ang_speed = 60/0.22*(speed-90);
      pos_est = est_ang_speed*0.05;
      Serial.print(pos_est);
      Serial.write(" (down)\n");
      speed = 0;
      myservo.write(speed);
    //}
  }
  else if (up == LOW) {
    //if (pos_est >= 0) {
      est_ang_speed = 60/0.22*(speed-90);
      pos_est = est_ang_speed*0.05;
      speed = 180;
      myservo.write(speed);
      Serial.print(pos_est);
      Serial.write(" (up)\n");
    //}
  }
  else {
    if (speed != 90) {
      est_ang_speed = 60/0.22*(speed-90);
      pos_est = est_ang_speed*0.05;
      speed = 90;
      myservo.write(speed);
      Serial.print(pos_est);
      Serial.write(" (stationary)\n");
    }
  }
  delay(50);
}
