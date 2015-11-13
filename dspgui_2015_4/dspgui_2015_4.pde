import processing.serial.*;

import netP5.*;
import oscP5.*;


OscP5 osc;
NetAddress sc;

Serial ino; 
String serialmsg;
boolean serialon = false;


int nfx = 4;
String[] fxlbl = {"Amplify", "RingMod1", "RingMod2", "Freeze"};
String[] clrset = {"springgreen", "violetred", "dodgerblue", 
  "sunshine", "magenta", "indigo", "peacock", "papaya", "turquoiseblue", "pink", "fig", "yellow", 
  "mint"};
int marg = 20;
int gap1 = 50;
int gap2 = 10;
int gap3 = 15;
int gap4 = 5;
int bw = 200;
int bw2 = 20;
int bh = 50;
int bh2 = 20;
PFont f1, f2;
int[]fxon, mofx, mos, smpf, fxatv;
int[]fxonR, mofxR, fxatvR;
float[]sdurs;
String[] sampn;
int fxtogL = nfx;
int fxtogR = nfx;
int w = 390;
int h = 630;

int numsamps = 4;
int numsampfx = 4;

void setup() {
  size(600, 800);
  w = marg+bw+gap1+bw+marg;
  surface.setResizable(true);
  surface.setSize(w, h);
  OscProperties properties = new OscProperties();
  properties.setListeningPort(12321);
  properties.setDatagramSize(5136); 
  osc = new OscP5(this, properties);
  sc = new NetAddress("127.0.0.1", 57120);
  f1 = loadFont("Monaco-24.vlw");
  f2 = loadFont("Monaco-14.vlw");
  fxon = new int[nfx];
  for (int i=0; i<nfx; i++) fxon[i]=0;
  mofx = new int[nfx];
  for (int i=0; i<nfx; i++) mofx[i]=0;
  fxatv = new int[nfx];
  for (int i=0; i<nfx; i++) fxatv[i]=0;
  fxonR = new int[nfx];
  for (int i=0; i<nfx; i++) fxonR[i]=0;
  mofxR = new int[nfx];
  for (int i=0; i<nfx; i++) mofxR[i]=0;
  fxatvR = new int[nfx];
  for (int i=0; i<nfx; i++) fxatvR[i]=0;
  mos = new int[0];
  smpf = new int[0];
  sdurs = new float[0];
  sampn = new String[0];
  println( Serial.list() );
  if (serialon) {
    String portName = Serial.list()[5];
    ino = new Serial(this, portName, 9600);
  }
}

void draw() {
  background(25, 33, 47);
  //read serial port
  if (serialon) {
    if ( ino.available() > 0) {
      serialmsg = ino.readString();
      String[] smsgs = split(serialmsg, ";");
      smsgs = shorten(smsgs); //because last semi-colon adds extra item
      for (int i=0; i<smsgs.length; i++) {
        String[]smsg = split(smsgs[i], ":");

        //// BUTTON 0 ////////////////////////////////
        if ( smsg[0].equals("bt0") ) {
          if (fxtogL<nfx) {
            switch(fxtogL) {
            case 0:
              fxon[ fxtogL ] = int(smsg[1]);
              if (fxon[fxtogL]==1)osc.send("/liveampon", new Object[]{}, sc);
              else osc.send("/liveampoff", new Object[]{}, sc);
              break;
            case 1:
              fxon[fxtogL] = int(smsg[1]);
              if (fxon[fxtogL]==1)osc.send("/liverm1on", new Object[]{}, sc);
              else osc.send("/liverm1off", new Object[]{}, sc);
              break;
            case 2:
              fxon[fxtogL] = int(smsg[1]);
              if (fxon[fxtogL]==1)osc.send("/liverm2on", new Object[]{}, sc);
              else osc.send("/liverm2off", new Object[]{}, sc);
              break;
            case 3:
              if (int(smsg[1]) == 1) {
                fxon[fxtogL] = millis()+16000;
                osc.send("/livefreezeon", new Object[]{}, sc);
              }
              break;
            }
          }
        }

        //// BUTTON 1 ////////////////////////////////
        if ( smsg[0].equals("bt1") ) {
          if (fxtogR<nfx) {
            switch(fxtogR) {
            case 0:
              fxonR[ fxtogR ] = int(smsg[1]);
              if (fxonR[fxtogR]==1)osc.send("/liveampon", new Object[]{}, sc);
              else osc.send("/liveampoff", new Object[]{}, sc);
              break;
            case 1:
              fxonR[fxtogR] = int(smsg[1]);
              if (fxonR[fxtogR]==1)osc.send("/liverm1on", new Object[]{}, sc);
              else osc.send("/liverm1off", new Object[]{}, sc);
              break;
            case 2:
              fxonR[fxtogR] = int(smsg[1]);
              if (fxonR[fxtogR]==1)osc.send("/liverm2on", new Object[]{}, sc);
              else osc.send("/liverm2off", new Object[]{}, sc);
              break;
            case 3:
              if (int(smsg[1]) == 1) {
                fxonR[fxtogR] = millis()+16000;
                osc.send("/livefreezeon", new Object[]{}, sc);
              }
              break;
            }
          }
        }

        //// BUTTON 2 ////////////////////////////////
        if ( smsg[0].equals("bt2") ) {
          fxtogL = ( fxtogL + int(smsg[1]) )%(nfx+1); //toggle through fx
          for (int j=0; j<nfx; j++) fxatv[j] = 0;//mark all fx inactive
          if (fxtogL<nfx)fxatv[fxtogL] = 1; //activate current fx
        }

        //// BUTTON 3 ////////////////////////////////
        if ( smsg[0].equals("bt3") ) {
          fxtogR = ( fxtogR + int(smsg[1]) )%(nfx+1); //toggle through fx
          for (int j=0; j<nfx; j++) fxatvR[j] = 0;//mark all fx inactive
          if (fxtogR<nfx)fxatvR[fxtogR] = 1; //activate current fx
        }

        //// BUTTON 4 ////////////////////////////////
        if ( smsg[0].equals("bt4") ) {
        }
      }
    }
  }

  //draw fx buttons
  strokeWeight(8);
  //fx Left
  for (int i=0; i<nfx; i++) {
    //turn white when fx is active
    if (fxon[i]==1) fill(255);
    else if (fxon[i]>millis()) fill(255);
    else fill(clr.get(clrset[i]));
    //mouseover stroke
    if (mofx[i]==1 || fxatv[i]==1) {
      //Active Button Highlight
      stroke(clr.get("orange"));
    }//
    else noStroke();
    rect(marg, marg+((bh+gap2)*i), bw, bh);
    textAlign(CENTER, CENTER);
    fill(0);
    textFont(f1);
    text( fxlbl[i], (bw/2)+marg, (bh/2)+((bh+gap2)*i)+marg );

    //Samples Sub-Menu
    for (int j=0; j<numsamps; j++) {
      noStroke();
      fill(255);
      rect(marg, marg+( ((bh+gap2)*nfx) + gap3 + ( (bh+gap2+gap4+bh2)*j )  ), bw, bh);
      for (int k=0; k<numsampfx; k++) {
        noStroke();
        fill( clr.get( clrset[(k+8)%clrset.length] ) );
        rect(marg + ( (bw2+gap4)*k ), marg+( ((bh+gap2)*nfx) + gap3 + ( (bh+gap2+gap4+bh2)*j ) + bh + gap4 ), bw2, bh2);
      }
    }
  }

  //fx Right
  for (int i=0; i<nfx; i++) {
    //turn white when fx is active
    if (fxonR[i]==1) fill(255);
    else if (fxonR[i]>millis()) fill(255);
    else fill(clr.get(clrset[i]));
    //mouseover stroke
    if (mofxR[i]==1 || fxatvR[i]==1) stroke(clr.get("orange"));
    else noStroke();
    rect(marg+gap1+bw, marg+((bh+gap2)*i), bw, bh);
    textAlign(CENTER, CENTER);
    fill(0);
    textFont(f1);
    text( fxlbl[i], (bw/2)+marg+gap1+bw, (bh/2)+((bh+gap2)*i)+marg );

    //Samples Sub-Menu
    for (int j=0; j<numsamps; j++) {
      noStroke();
      fill(255);
      rect(marg+gap1+bw, marg+( ((bh+gap2)*nfx) + gap3 + ( (bh+gap2+gap4+bh2)*j )  ), bw, bh);
      for (int k=0; k<numsampfx; k++) {
        noStroke();
        fill( clr.get( clrset[(k+8)%clrset.length] ) );
        rect(marg+gap1+bw + ( (bw2+gap4)*k ), marg+( ((bh+gap2)*nfx) + gap3 + ( (bh+gap2+gap4+bh2)*j ) + bh + gap4 ), bw2, bh2);
      }
    }
  }

  //Sample Player
  strokeWeight(8);
  for (int i=0; i<sampn.length; i++) {
    //mouseover stroke
    if (mos[i]==1) stroke(clr.get("limegreen"));
    else noStroke();
    //highlight white when playing
    if ( smpf[i]>millis() ) fill(255);
    else fill(clr.get(clrset[i%clrset.length]));
    rect(marg+bw+40, marg+((bh2+3)*i), bw2, bh2);
    textFont(f2);
    textAlign(CENTER, CENTER);
    fill(0);
    text( sampn[i], marg+bw+40+(bw2/2), marg+((bh2+3)*i)+(bh2/2) );
  }
}

void mousePressed() {
  ////Effects
  //Left
  int wx = wfx();
  if (wx>=0) {
    switch(wx) {
    case 0:
      fxon[wx] = (fxon[wx]+1)%2;
      if (fxon[wx]==1)osc.send("/liveampon", new Object[]{0}, sc);
      else osc.send("/liveampoff", new Object[]{0}, sc);
      break;
    case 1:
      fxon[wx] = (fxon[wx]+1)%2;
      if (fxon[wx]==1)osc.send("/liverm1on", new Object[]{0}, sc);
      else osc.send("/liverm1off", new Object[]{0}, sc);
      break;
    case 2:
      fxon[wx] = (fxon[wx]+1)%2;
      if (fxon[wx]==1)osc.send("/liverm2on", new Object[]{0}, sc);
      else osc.send("/liverm2off", new Object[]{0}, sc);
      break;
    case 3:
      fxon[wx] = millis()+16000;
      osc.send("/livefreezeon", new Object[]{0}, sc);
      break;
    }
  }

  //Right
  int wxr = wfxR();
  if (wxr>=0) {
    switch(wxr) {
    case 0:
      fxon[wxr] = (fxon[wxr]+1)%2;
      if (fxon[wxr]==1)osc.send("/liveampon", new Object[]{1}, sc);
      else osc.send("/liveampoff", new Object[]{1}, sc);
      break;
    case 1:
      fxon[wxr] = (fxon[wxr]+1)%2;
      if (fxon[wxr]==1)osc.send("/liverm1on", new Object[]{1}, sc);
      else osc.send("/liverm1off", new Object[]{1}, sc);
      break;
    case 2:
      fxon[wxr] = (fxon[wxr]+1)%2;
      if (fxon[wxr]==1)osc.send("/liverm2on", new Object[]{1}, sc);
      else osc.send("/liverm2off", new Object[]{}, sc);
      break;
    case 3:
      fxon[wxr] = millis()+16000;
      osc.send("/livefreezeon", new Object[]{1}, sc);
      break;
    }
  }

  //Samples
  if (wsmp()>=0) {
    osc.send("/playsamp", new Object[]{wsmp()}, sc);
    smpf[wsmp()] = ceil(millis()+(sdurs[wsmp()]*1000));
  }
}

void mouseReleased() {
}

void mouseMoved() {
  //which fx moused over
  //Left
  if (wfx()>=0) {
    for (int i=0; i<nfx; i++) {
      if (wfx()==i)mofx[i]=1;
      else mofx[i]=0;
    }
  }
  //
  else for (int i=0; i<nfx; i++) mofx[i]=0;

  //Right
  if (wfxR()>=0) {
    for (int i=0; i<nfx; i++) {
      if (wfxR()==i)mofxR[i]=1;
      else mofxR[i]=0;
    }
  }
  //
  else for (int i=0; i<nfx; i++) mofxR[i]=0;

  //which sample moused over
  if (wsmp()>=0) {
    for (int i=0; i<sampn.length; i++) {
      if (wsmp()==i)mos[i]=1;
      else mos[i]=0;
    }
  }
  //
  else for (int i=0; i<sampn.length; i++) mos[i]=0;
}

int wfx() {
  int n = -1;
  for (int i=0; i<nfx; i++) {
    if ( mouseX>marg && mouseX<(marg+bw) && 
      mouseY>marg+((bh+gap2)*i) && mouseY<(marg+((bh+gap2)*i)+bh) ) {
      n=i;
    }
  }
  return n;
}
int wfxR() {
  int n = -1;
  for (int i=0; i<nfx; i++) {
    if ( mouseX>(gap1+bw) && mouseX<(gap1+bw+bw) && 
      mouseY>marg+((bh+gap2)*i) && mouseY<(marg+((bh+gap2)*i)+bh) ) {
      n=i;
    }
  }
  return n;
}

int wsmp() {
  int n = -1;
  for (int i=0; i<sampn.length; i++) {
    if ( mouseX>(marg+bw+40) && mouseX<(marg+bw+40+bw2) && 
      mouseY>marg+((bh2+3)*i) && mouseY<(marg+((bh2+3)*i)+bh2) ) {
      n=i;
    }
  }
  return n;
}

void keyPressed() {
  if (key=='1') osc.send("/sfnames", new Object[]{}, sc);
}

void oscEvent(OscMessage msg) {
  if ( msg.checkAddrPattern("/sfs") ) {
    int sz = msg.get(0).intValue();
    for (int i=1; i<sz; i++) {
      sampn = append( sampn, msg.get(i).stringValue() );
      mos = append(mos, 0);
      smpf = append(smpf, 0);
    }
  }
  if ( msg.checkAddrPattern("/sdurs") ) {
    int sz = msg.get(0).intValue();
    for (int i=1; i<sz; i++) {
      sdurs = append( sdurs, msg.get(i).floatValue() );
    }
  }
}