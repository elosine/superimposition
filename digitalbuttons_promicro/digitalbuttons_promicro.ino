int numbts = 12;
int bts[] = {2,3,4,5,6,7,8,9,10,16,14,15};
boolean bgates[12];

void setup() {
  Serial.begin(9600);
  for (int i = 0; i < numbts; i++) pinMode(bts[i], INPUT_PULLUP);
  for (int i = 0; i < numbts; i++) bgates[i] = false;
}

void loop() {
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
  delay(5);
}
