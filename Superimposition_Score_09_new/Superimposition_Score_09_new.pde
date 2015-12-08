import oscP5.*;
import netP5.*;
import processing.serial.*;
import java.util.Random;
import java.util.Arrays;

OscP5 osc;
NetAddress sc;
NetAddress me;

PFont font1;

float h = 900;
float w = 1434;
float x0 = 0; //starting x of the track (in case you need a left-margin)
float trht, trhf;  //height of track and vertical half-way point of track
float cx=0; //x of main cursor
float[]tcx; //x values of individual track cursors
int numtrx = 4;
int[] rectogs, playtogs, rangex1, rangex2, ranger, trcsr;

int bufsize;
float[][] samparrays;

int totalbts = 16;  //total beats per track
int btspermes = 4; //beats per measure
int totalmes = 4; //number of measures per track
float mesw, trw;
float btw;

//To toggle the cursor between the staves
int csrtog = 0;
boolean csrg = false;

//SVGs
String svgspath;
File svgfolder;
PShape[] svgset;
String[] svgnames;
float[][] svgwh; //width & height of svgPShape

//Score
int scrix = 0;
int scrclkon = 1;
int scrinc = 1;
int srate = 1;
int scrnumon = 1;

void setup() {
  size(1434, 900);
  surface.setResizable(true); // Allow the canvas to be resizeable
  surface.setSize(int(w), int(h)); 
  //fullScreen();
  OscProperties properties= new OscProperties();
  //properties.setRemoteAddress("127.0.0.1", 57120); //osc send port (to sc)
  properties.setListeningPort(12321); //osc receive port (from sc)
  properties.setDatagramSize(5136); //5136 is the minimum 
  osc= new OscP5(this, properties);
  sc = new NetAddress("127.0.0.1", 57120);
  me = new NetAddress("127.0.0.1", 12321);
  
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
  osc.plug(setORhythmMkr, "clear", "/clear");
  osc.plug(setORhythmMkr, "mksus", "/mksus");
  osc.plug(setORhythmMkr, "mkpitch", "/mkpitch");
  osc.plug(setORhythmMkr, "rmpitch", "/rmpitch");
  osc.plug(setORhythmMkr, "mkdyn", "/mkdyn");
  osc.plug(setORhythmMkr, "mkpitchset", "/mkpitchset");
  osc.plug(setORhythmMkr, "mkart", "/mkart");
  osc.plug(setSVGdisplay, "mk", "/mksvg");
  osc.plug(setSVGdisplay, "mksz", "/mkszsvg");
  osc.plug(setSVGdisplay, "rmv", "/rmvsvg");
  osc.plug(setSVGdisplay, "rmvall", "/rmvallsvg");
  osc.plug(setNotationDraw, "mk", "/mknotedrw");
  osc.plug(setNotationDraw, "rmv", "/rmvnotedrw");
  osc.plug(this, "togcsr", "/togcsr");
  osc.plug(this, "scrclk", "/scrclk");
  osc.plug(this, "scrnum", "/scrnum");
  osc.plug(this, "scrrate", "/scrrate");
  
  font1 = loadFont("Monaco-24.vlw");
  textFont(font1);

  trw = w-x0; //track width
  btw = trw/totalbts; //width of each beat in pixels
  mesw = btspermes*btw; //width of each measure in pixels
  trht = h/numtrx; //track height in pixels
  trhf = trht/2.0; //track half height in pixels

  trcsr = new int[numtrx]; //gates for individual track cursors
  for (int i=0; i<trcsr.length; i++) trcsr[i]=0;
  tcx = new float[numtrx]; //individual track cursor x positions
  for (int i=0; i<tcx.length; i++) tcx[i]=0.0;

  //For Loops
  rangex1 = new int[numtrx];
  for (int i=0; i<rangex1.length; i++) rangex1[i]=0;
  rangex2 = new int[numtrx];
  for (int i=0; i<rangex2.length; i++) rangex2[i]=width;
  ranger = new int[numtrx];
  for (int i=0; i<ranger.length; i++) ranger[i]=0;

  //SVGs
  svgnames = new String[0];
  svgspath = sketchPath("svgs/");
  svgfolder = new File(svgspath);
  //Load SVGs from folder, store names in an IntDict
  if (svgfolder.exists() && svgfolder.isDirectory()) {
    svgset = new PShape[svgfolder.listFiles().length];
    svgwh = new float[svgfolder.listFiles().length][2];
    for (int i=0; i<svgfolder.listFiles ().length; i++) {
      if (!svgfolder.listFiles()[i].getName().equals(".DS_Store")) {
        svgset[i] = loadShape(svgfolder.listFiles()[i].getPath());
        //svgnames.set(svgfolder.listFiles()[i].getName(), i);
        svgnames = append( svgnames, svgfolder.listFiles()[i].getName() );
        svgwh[i][0] = svgset[i].getWidth();
        svgwh[i][1] = svgset[i].getHeight();
      }
    }
  }

  // FUNCTIONS FOR SETTING UP AND DRAWING NOTATION
  maketuplets();
  mkrset();
  mkr();
  score(0);

}

void draw() {
  background(255);


  //TRACK BACKGROUND
  noStroke();
  for (int i=0; i<ceil (numtrx/2); i++) {
    //t1
    fill(0);
    rect(x0, trht*2*i, w, trht);
    //t2
    fill(25, 33, 47);
    rect(x0, (trht*2*i)+trht, w, trht);
  }
  
  //Score Numbers
  if(scrnumon ==1){
    fill(255, 128, 0);
    text(scrix, width-30, 30);
  }

  //DRAW DYNAMICS & PITCH CLASS
  setORhythmMkr.drdyn();
  setNotationDraw.drdyn();

  //BEAT MARKERS
  strokeWeight(1);
  ellipseMode(CENTER);
  fill(255);
  for (int j=0; j<numtrx; j++) {
    stroke(255);
    for (int i=0; i<totalmes; i++) line( (mesw*i)+x0, (trht*j)+(trht*0.3333), (mesw*i)+x0, (trht*j)+(trht*0.66667) );
    noStroke();
    for (int i=0; i<totalbts; i++) ellipse( (btw*i)+x0, (trht*j)+(trht/2), 7, 7 );
  }

  //DRAW RHYTHMS
  setNotationDraw.drw();
  setORhythmMkr.drw();
  setSVGdisplay.drw();
  setORhythmSetMkr.drw();
  setOTup.drw();

  //RANGER FOR LOOPS
  for (int i=0; i<numtrx; i++) {
    if (ranger[i]==1) {
      noStroke();
      fill(255, 0, 255, 100);
      rect(rangex1[i], trht*i, rangex2[i]-rangex1[i], trht);
    }
  }

  //CURSOR
  osc.send("/getidx", new Object[]{}, sc); //get current cursor location from sc
  //toggle cursor between staves when it reaches the end of 
  if (csrg) {
    if ( cx>=0 && cx<20 ) { //when cursor flips back to 0
      csrtog = (csrtog+1)%2;
      if (scrclkon == 1) {
        if (scrinc%srate == 0) { //
         // score(scrix); //up date with next score item
         // scrix = scrix + 1; // increment score counter
        }
        scrinc++;
      }
      csrg = false;
    }
  } //
  else { //when it passes 20 reset gate
    if ( cx>20 ) {
      csrg = true;
    }
  }
  strokeWeight(3);
  stroke(153, 255, 0);
  if (csrtog==0) line(cx, 0, cx, trht*2);//top system
  else line(cx, trht*2, cx, height); //bottom system

  //INDIVIDUAL TRACK CURSORS
  for (int i=0; i<numtrx; i++) {
    if (trcsr[i]==1) {
      osc.send("/gettridx", new Object[]{i}, sc); //get current cursor location from sc
      strokeWeight(3);
      stroke(0, 153, 255);
      line( tcx[i], trht*i, tcx[i], trht*(i+1) );
    }
  }
} //END DRAW

void mousePressed() {
  //REMOVE LOOP AND GO BACK TO MAIN CURSOR IF TRACK IS RIGHT-CLICKED
  for (int i=0; i<numtrx; i++) {
    if (mouseButton == RIGHT) { 
      if ( whichtrack()==i && mouseX>x0 ) {
        ranger[i] = 0;
        trcsr[i] = 0;
        osc.send("/setidx", new Object[]{ -1, 0, 1, 1 }, sc);
      }
    }
    if (mouseButton == LEFT) {
      //Begin Loop Range
      if ( mouseX>=x0 && mouseY>(trht*i) && mouseY<(trht*(i+1)) ) {
        ranger[i] = 1;
        rangex1[i] = mouseX;
        rangex2[i] = mouseX;
      }
    }
  } //end for loop
} //END MOUSE PRESSED

void mouseReleased() {
  if (mouseButton == LEFT) {

    //End of Loop Range, sends range to SC and moves to new phasor
    for (int i=0; i<numtrx; i++) {
      // if ( mouseX>=x0 && mouseY>(trht*i) && mouseY<(trht*(i+1)) ) {
      if ( whichtrack()==i && mouseX>=x0) {
        float rx1 = norm(rangex1[i], x0, width);
        float rx2 = norm(rangex2[i], x0, width);
        trcsr[i] = 1;
        osc.send("/setidx", new Object[]{ i, rx1, rx2, 1 }, sc);
      }
      // }
    }
  }
} //end mousereleased

void mouseDragged() {
  if (mouseButton == LEFT) {

    //Makes Loop Range
    for (int i=0; i<numtrx; i++) {
      if ( mouseX>=x0 && mouseY>(trht*i) && mouseY<(trht*(i+1)) ) {
        rangex2[i] = mouseX;
      }
    }
  }
} //End mouseDragged

//// OSC EVENT METHOD ////
void oscEvent(OscMessage msg) {
  //get waveform data and store in samparrays
  if ( msg.checkAddrPattern("/sbuf") ) {
    int trkn = msg.get(0).intValue();
    for (int i=0; i<bufsize; i++) {
      if (i>0) samparrays[trkn][i] = msg.get(i).floatValue();
    }
  }
}

//// MASTER INDEX FUNCTION ////
//Receives master index location
public void ix(float idx) {
  cx = (idx*trw) + x0;
}

//// TRACK INDEX FUNCTION ////
//Receives track index location
public void trix(int tr, float idx) {
  tcx[tr] = (idx*trw) + x0;
}

//// FUNCTION TO DETERMINE WHICH TRACK BY MOUSE-Y POSITION
int whichtrack() {
  int trk=0;
  for (int i=0; i<numtrx; i++) {
    if ( mouseY>(trht*i) && mouseY<((trht*i)+trht) ) trk = i;
  }
  return trk;
}

//TOGGLE THE CURSOR BETWEEN SYSTEMS
void togcsr(int pos) {
  csrtog = pos;
}
//Control the Score Clock
void scrclk(int on) {
  scrclkon = on;
}
//Go To System Num
void scrnum(int sys) {
  scrix = sys;
  score(sys);
}
//Change page turn rate
void scrrate(int rate) {
  srate = rate;
}