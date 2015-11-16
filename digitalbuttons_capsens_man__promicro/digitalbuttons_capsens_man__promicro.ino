#include <CapacitiveSensor.h>

//Buttons
int numbts = 10;
int bts[] = {2, 3, 4, 5, 6, 7, 8, 9, 10, 16};
boolean bgates[10];
//Capacitive Sensors
int numcps = 5;
int sendpin = 21;
CapacitiveSensor cps0 = CapacitiveSensor(21, 14);
CapacitiveSensor cps1 = CapacitiveSensor(21, 15);
CapacitiveSensor cps2 = CapacitiveSensor(21, 18);
CapacitiveSensor cps3 = CapacitiveSensor(21, 19);
CapacitiveSensor cps4 = CapacitiveSensor(21, 20);
boolean cpsg1 = true;
long cpsval[5];

void setup() {
  Serial.begin(9600);
  for (int i = 0; i < numbts; i++) pinMode(bts[i], INPUT_PULLUP);
  for (int i = 0; i < numbts; i++) bgates[i] = false;
  for (int i = 0; i < numcps; i++) cpsgates[i] = true;
}

void loop() {
  //buttons
  for (int i = 0; i < numbts; i++) {
    if (!bgates[i]) {
      if (digitalRead(bts[i]) == LOW) {
        bgates[i] = true;
        Serial.print("bt" + String(i) + ":");
        Serial.println(1, DEC);
      }
    }
    if (bgates[i]) {
      if (digitalRead(bts[i]) == HIGH) {
        bgates[i] = false;
        Serial.print("bt" + String(i) + ":");
        Serial.println(0, DEC);
      }
    }
  }
  //Capacitive Sensors
  //long val = cps[0].capacitiveSensor(30);
  //Serial.println(val);
  for (int i = 0; i < numcps; i++) {
    long val = cps[i].capacitiveSensor(30);
    if (val >= 5000) {
      if (cpsgates[i]) {
        cpsgates[i] = false;
        Serial.print("cps" + String(i) + ":");
        Serial.println(1, DEC);
      }
    }
    else if (val < 1000) {
      if (cpsgates[i]) {
        cpsgates[i] = true;
        Serial.print("cps" + String(i) + ":");
        Serial.println(0, DEC);
      }
    }
  }

  delay(15);
}
