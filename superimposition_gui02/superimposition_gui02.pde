import oscP5.*;
import netP5.*;
import processing.serial.*;

OscP5 osc;
NetAddress sc;
int h = 1000;
int w = 1600;
int x0 = 0;
int trht, trhf;
float cx=0;
float[]tcx;
int numtrx = 4;
int[] rectogs, playtogs, rangex1, rangex2, ranger, trcsr;

int bufsize;
float[][] samparrays;

int totalbts = 16;
int btspermes = 4;
int totalmes = 4;
float mesw, trw;
float btw;

//To toggle the cursor between the staves
int csrtog = 0;
boolean csrg = true;

void setup() {
  size(1600, 1000);

  OscProperties properties= new OscProperties();
  //properties.setRemoteAddress("127.0.0.1", 57120);  //osc send port (to sc)
  properties.setListeningPort(12321);               //osc receive port (from sc)/*
  properties.setDatagramSize(5136);  //5136 is the minimum 
  osc= new OscP5(this, properties);
  sc = new NetAddress("127.0.0.1", 57120);
  osc.plug(this, "ix", "/ix");
  osc.plug(this, "trix", "/trix");
  
  osc.plug(setOTup, "mk1", "/mktup1");
  osc.plug(setOTup, "mk2", "/mktup2");
  osc.plug(setOTup, "drtog", "/dtup");
  osc.plug(setOTup, "rmv", "/rmvtup");
  osc.plug(setORhythmSetMkr, "mk", "/mkrhythmset");
  osc.plug(setORhythmSetMkr, "ad", "/adrhythm2set");
  osc.plug(setORhythmSetMkr, "drtog", "/drhset");
  osc.plug(setORhythmMkr, "mk", "/mkrhythm");
  osc.plug(setORhythmMkr, "drtog", "/drh");
  osc.plug(setORhythmMkr, "mksus", "/mksus");
  
  trw = w-x0;
  btw = trw/totalbts;
  mesw = btspermes*btw;
  trht = round(h/numtrx);

  trcsr = new int[numtrx];
  for (int i=0; i<trcsr.length; i++) trcsr[i]=0;
  tcx = new float[numtrx];
  for (int i=0; i<tcx.length; i++) tcx[i]=0.0;
  
  maketuplets();
  mkrset();
  mkr();

}

void draw() {
  background(255);

  //track background
  noStroke();
  for (int i=0; i<ceil (numtrx/2); i++) {
    //t1
    fill(0);
    rect(x0, trht*2*i, w, trht);
    //t2
    fill(25, 33, 47);
    rect(x0, (trht*2*i)+trht, w, trht);
  }
  
  noStroke();
  fill(255,127,0);
  rect(0,0, width, 20);

  //beat markers
  strokeWeight(1);
  ellipseMode(CENTER);
  fill(255);
  for (int j=0; j<numtrx; j++) {
    stroke(255);
    for (int i=0; i<totalmes; i++) line( (mesw*i)+x0, (trht*j)+(trht*0.3333), (mesw*i)+x0, (trht*j)+(trht*0.66667) );
    noStroke();
    for (int i=0; i<totalbts; i++) ellipse( (btw*i)+x0, (trht*j)+(trht/2), 7, 7 );
  }
  
  //draw rhythms
  setORhythmMkr.drw();
  setORhythmSetMkr.drw();
  setOTup.drw();
  
  
  
  
  
  
  //Cursor
  /**/ osc.send("/getidx", new Object[]{}, sc); //get current cursor location from sc
  //toggle cursor between staves when it reaches the end of 
  if(csrg){
    if( cx>=0 && cx<20 ){
      csrtog = (csrtog+1)%2;
      csrg = false;
    }
  }
  else{
    if( cx>20 ){
      csrg = true;
    }
    
  }
  strokeWeight(3);
  stroke(153, 255, 0);
  if(csrtog==0) line(cx, 0, cx, trht*2);
  else line(cx, trht*2, cx, height);

  //Track Cursors
  for (int i=0; i<numtrx; i++) {
    if (trcsr[i]==1) {
      /**/ osc.send("/gettridx", new Object[]{i}, sc); //get current cursor location from sc
      strokeWeight(3);
      stroke(0, 153, 255);
      line( tcx[i], trht*i, tcx[i], trht*(i+1) );
    }
  }
}


void oscEvent(OscMessage msg) {
  //get waveform data and store in samparrays
  if ( msg.checkAddrPattern("/sbuf") ) {
    int trkn = msg.get(0).intValue();
    for (int i=0; i<bufsize; i++) {
      if (i>0) samparrays[trkn][i] = msg.get(i).floatValue();
    }
  }
}

//Receives master index location
public void ix(float idx) {
  cx = (idx*trw) + x0;
}

//Receives track index location
public void trix(int tr, float idx) {
  tcx[tr] = (idx*trw) + x0;
}