import netP5.*;
import oscP5.*;

OscP5 osc;
NetAddress sc;

int nfx = 4;
String[] fxlbl = {"Amplify", "RingMod1", "RingMod2", "Freeze"};
String[] clrset = {"springgreen", "violetred", "dodgerblue", 
"sunshine", "dodgerblue", "peacock", "fig", "pink", "yellow", 
"mint", "papaya", "turquoiseblue"};
int bw = 200;
int bw2 = 300;
int bh = 80;
int b2h = 40;
PFont f1, f2;
int[]fxon, mofx, mos, smpf;
float[]sdurs;
String[] sampn;

void setup(){
  size(600, 800);
  OscProperties properties = new OscProperties();
  properties.setListeningPort(12321);
  properties.setDatagramSize(5136); 
  osc = new OscP5(this, properties);
  sc = new NetAddress("127.0.0.1", 57120);
  f1 = loadFont("Monaco-24.vlw");
  f2 = loadFont("Monaco-14.vlw");
  fxon = new int[nfx];
  for(int i=0;i<nfx;i++) fxon[i]=0;
  mofx = new int[nfx];
  for(int i=0;i<nfx;i++) mofx[i]=0;
  mos = new int[0];
  smpf = new int[0];
  sdurs = new float[0];
  sampn = new String[0];
}

void draw(){
  background(25, 33, 47);
  //draw fx buttons
  strokeWeight(8);
  for(int i=0;i<nfx;i++){
    //turn white when fx is active
    if(fxon[i]==1) fill(255);
    else if(fxon[i]>millis()) fill(255);
    else fill(clr.get(clrset[i]));
    //mouseover stroke
    if(mofx[i]==1) stroke(clr.get("orange"));
    else noStroke();
    rect(20, 20+((bh+10)*i), bw, bh);
    textAlign(CENTER, CENTER);
    fill(0);
    textFont(f1);
    text( fxlbl[i], (bw/2)+20, (bh/2)+((bh+10)*i)+20 );
  }
  
  //Sample Player
  strokeWeight(8);
  for(int i=0;i<sampn.length;i++){
    //mouseover stroke
    if(mos[i]==1) stroke(clr.get("limegreen"));
    else noStroke();
    //highlight white when playing
    if( smpf[i]>millis() ) fill(255);
    else fill(clr.get(clrset[i%clrset.length]));
    rect(20+bw+40, 20+((b2h+3)*i), bw2, b2h);
    textFont(f2);
    textAlign(CENTER, CENTER);
    fill(0);
    text( sampn[i], 20+bw+40+(bw2/2), 20+((b2h+3)*i)+(b2h/2) );
  }
}

void mousePressed(){
  ////Effects
  int wx = wfx();
  if(wx>=0){
    switch(wx){
      case 0:
      fxon[wx] = (fxon[wx]+1)%2;
      if(fxon[wx]==1)osc.send("/liveampon", new Object[]{}, sc);
      else osc.send("/liveampoff", new Object[]{}, sc);
      break;
      case 1:
      fxon[wx] = (fxon[wx]+1)%2;
      if(fxon[wx]==1)osc.send("/liverm1on", new Object[]{}, sc);
      else osc.send("/liverm1off", new Object[]{}, sc);
      break;
      case 2:
      fxon[wx] = (fxon[wx]+1)%2;
      if(fxon[wx]==1)osc.send("/liverm2on", new Object[]{}, sc);
      else osc.send("/liverm2off", new Object[]{}, sc);
      break;
      case 3:
      fxon[wx] = millis()+16000;
      osc.send("/livefreezeon", new Object[]{}, sc);
      break;
    }
  }
  //Samples
  if(wsmp()>=0){
    osc.send("/playsamp", new Object[]{wsmp()}, sc);
    smpf[wsmp()] = ceil(millis()+(sdurs[wsmp()]*1000));
  }
}

void mouseReleased(){
}

void mouseMoved(){
  //which fx moused over
  if(wfx()>=0){
    for(int i=0;i<nfx;i++){
      if(wfx()==i)mofx[i]=1;
      else mofx[i]=0;
    }
  }
  else for(int i=0;i<nfx;i++) mofx[i]=0;
  //which sample moused over
  if(wsmp()>=0){
    for(int i=0;i<sampn.length;i++){
      if(wsmp()==i)mos[i]=1;
      else mos[i]=0;
    }
  }
  else for(int i=0;i<sampn.length;i++) mos[i]=0;
}

int wfx(){
  int n = -1;
  for(int i=0;i<nfx;i++){
    if( mouseX>20 && mouseX<(20+bw) && 
    mouseY>20+((bh+10)*i) && mouseY<(20+((bh+10)*i)+bh) ){
      n=i;
    }
  }
  return n;
}

int wsmp(){
  int n = -1;
  for(int i=0;i<sampn.length;i++){
    if( mouseX>(20+bw+40) && mouseX<(20+bw+40+bw2) && 
    mouseY>20+((b2h+3)*i) && mouseY<(20+((b2h+3)*i)+b2h) ){
      n=i;
    }
  }
  return n;
}

void keyPressed(){
  if(key=='1') osc.send("/sfnames", new Object[]{}, sc);
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