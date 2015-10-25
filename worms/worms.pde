//POSSIBLY CAPTURE AS IMAGE IN A BUFFER
//Freehand draw a bunch of these
//capture in buffer and save as image file?

String[] xs;
String[] ys;

int[]xa = new int[0];
int[]ya = new int[0];


float s1 = 5;
float s2 = 5;
int p = 0;
Dibujo ConPlumon;
void setup() {
  size(900, 400);
  smooth();  

  ConPlumon = new Dibujo();
}
void draw() {
}
void keyPressed() {

  if (key == 'b' || key == 'B') {
    ConPlumon.switchState(1);
  }
  if (key == 'a' || key == 'A') {
    ConPlumon.switchState(0);
  }
  if (key == 'c' || key == 'C') {
    ConPlumon.switchState(2);
  }
  if (key == '1') {
    xs = str(xa);
    ys = str(ya);
    saveStrings("xs.txt", xs);
    saveStrings("ys.txt", ys);
    
  }
  if (key == '2') {
    String[] xs = loadStrings("xs.txt");
    int[]xi = int(xs);
    String[] ys = loadStrings("ys.txt");
    int[]yi = int(ys);
    for (int i=0; i<xs.length; i++) {
      ConPlumon.drawStuff(xi[i], yi[i]);
    }
  }
}
void mousePressed() {

  ConPlumon.drawStuff(mouseX, mouseY);
}
void mouseDragged() {
  p = (p+1)%100;
  //  println(p);
  s1 = 17.0*(p/100.0);
  println(s1);
  s2 = 25.0*(p/100.0);
  ConPlumon.drawStuff(mouseX, mouseY);
  smooth();
}

class Dibujo {
  int drawState = 0;
  void drawStuff (int x, int y) {
    noStroke();
    if (drawState == 0) {
      fill(0, 255, 0, 100);
      // ellipse(x, y, s1, s2);
      ellipse(x, y, 17, 25);
      xa = append(xa, x);
      ya = append(ya, y);
    } else if (drawState == 1) {
      fill(mouseX, mouseY, 70, 50);
      rect(x, y, 12, 25);
    } else if (drawState == 2) {      
      fill(mouseX, mouseY, 70, 50);
      ellipse(x, y, 5, 5);
    }
  }
  void switchState(int newState) {
    drawState = newState;
  }
}