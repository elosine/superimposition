/*
Make a class
OSCify
check to see if the string file exists
 WAY TO EASLY ADJUST THICKNESS
 WAY TO ADJUST COLOR
 choose which line to draw
 
 */


PGraphics[] b1, b2;
PImage[] img, i2;
int[][]xr, yr;
int[] xw, yw;
int nbf = 5;
int six = 1;
int imix = 0;
boolean drwgate = false;

void setup() {
  size(900, 500);
  background(0);
  xr = new int [nbf][];
  yr = new int [nbf][];
  for (int i=0; i<nbf; i++) {
    String[] txs = loadStrings("xs" + str(i) + ".txt");
    xr[i] = int(txs);
    String[] tys = loadStrings("ys" + str(i) + ".txt");
    yr[i] = int(tys);
  }
  // Create an off-screen buffer.
  b1 = new PGraphics[nbf];
  for (int i=0; i<nbf; i++) b1[i] = createGraphics(900, 500, JAVA2D);
  b2 = new PGraphics[nbf];
  for (int i=0; i<nbf; i++) b2[i] = createGraphics(900, 500, JAVA2D);
  img = new PImage[nbf];
  i2 = new PImage[nbf];

  // Draw something complex in the off-screen buffer.
  for (int i=0; i<b1.length; i++) {
    renderImg(b1[i], xr[i], yr[i]);
    img[i] = b1[i].get(0, 0, b1[i].width, b1[i].height);
  }

  xw = new int[0];
  yw = new int[0];
}

void draw() {
  if (!drwgate) {
    background(0);
    //Add Buffer to Another Buffer
    b2[imix].beginDraw();
    b2[imix].image(img[imix], 0, 0);
    b2[imix].endDraw();
    i2[imix] = b2[imix].get(0, 0, b2[imix].width, b2[imix].height);
    image(i2[imix], 0, 0);
  }
}


void renderImg(PGraphics b1, int[]x, int[]y) {
  b1.beginDraw();
  b1.smooth();
  b1.fill(0, 255, 0, 100);
  b1.noStroke();
  for (int i=0; i<x.length; i++) {
    b1.ellipse(x[i], y[i], 17, 25);
  }
  b1.endDraw();
}

void mouseDragged() {
  fill(0, 255, 0, 100);
  noStroke();
  ellipse(mouseX, mouseY, 17, 25);
  xw = append(xw, mouseX);
  yw = append(yw, mouseY);
}

void mousePressed(){
  drwgate = true;
  background(0);
}

void mouseReleased(){
   drwgate = false;
}

void keyPressed() {
  if (key=='1') {
    saveStrings( "xs" + str(six) + ".txt", str(xw) );
    saveStrings( "ys" + str(six) + ".txt", str(yw) );
    xw = new int[0];
   yw = new int[0];
    six++;
  }

  if (key=='c') background(0);

  if (key=='i') imix = (imix+1)%nbf;
}