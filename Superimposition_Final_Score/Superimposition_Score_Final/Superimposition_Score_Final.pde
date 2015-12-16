import oscP5.*;
import netP5.*;
import processing.serial.*;
import java.util.Random;
import java.util.Arrays;

OscP5 osc;
NetAddress sc;
NetAddress me;

PFont font1;

float h = 1200;
float w = 1600;
float x0 = 0; //starting x of the track (in case you need a left-margin)
float trht, trhf;  //height of track and vertical half-way point of track
float cx=0; //x of main cursor
int numtrx = 4;

int bufsize;
float[][] samparrays;

int totalbts = 16;  //total beats per track
int btspermes = 4; //beats per measure
int totalmes = 4; //number of measures per track
float mesw, trw;
float btw;

//To toggle the cursor between the staves
int csrtog = 1;
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

//Dotted Dashed
DDXline lines[][][] = new DDXline[4][4][3];
String[]lclrs = {"FFFFFF00", "FFFF00FF", "FFFF8000"};

//Articulations
Arts[] arts = new Arts[4];

void setup() {
  size(1434, 900);
  surface.setResizable(true); // Allow the canvas to be resizeable
  surface.setSize(int(w), int(h)); 
  OscProperties properties= new OscProperties();
  properties.setListeningPort(12321); //osc receive port (from sc)
  properties.setDatagramSize(5136); //5136 is the minimum 
  osc= new OscP5(this, properties);
  sc = new NetAddress("127.0.0.1", 57120);
  me = new NetAddress("127.0.0.1", 12321);

  osc.plug(this, "scoreix", "/scoreix");

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
  osc.plug(setORhythmMkr, "mkdyn", "/mkdyn");
  osc.plug(setORhythmMkr, "mkart", "/mkart");
  osc.plug(setORhythmMkr, "pitch", "/chgpitch");
  osc.plug(setORhythmMkr, "art", "/chgart");
  osc.plug(setSVGdisplay, "mk", "/mksvg");
  osc.plug(setSVGdisplay, "mksz", "/mkszsvg");
  osc.plug(setSVGdisplay, "rmv", "/rmvsvg");
  osc.plug(setSVGdisplay, "dr", "/drsvg");
  osc.plug(setSVGdisplay, "rmvall", "/rmvallsvg");
  osc.plug(setNotationDraw, "mk", "/mknotedrw");
  osc.plug(setNotationDraw, "rmv", "/rmvnotedrw");
  osc.plug(this, "togcsr", "/togcsr");
  osc.plug(this, "scrclk", "/scrclk");
  osc.plug(this, "scrnum", "/scrnum");
  osc.plug(this, "scrrate", "/scrrate");
  osc.plug(this, "clrall", "/clrall");

  font1 = loadFont("Monaco-24.vlw");
  textFont(font1);

  trw = w-x0; //track width
  btw = trw/totalbts; //width of each beat in pixels
  mesw = btspermes*btw; //width of each measure in pixels
  trht = h/numtrx; //track height in pixels
  trhf = trht/2.0; //track half height in pixels

  cx = x0+(mesw*3);

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
  //Lines
  for (int i=0; i<4; i++) {
    for (int j=0; j<4; j++) {
      for (int k=0; k<3; k++) {
        lines[i][j][k] = new DDXline(x0, trht*i, w, 20, j, btw, lclrs[k]);
      }
    }
  }

  //Articulations
  for (int i=0; i<4; i++) arts[i] = new Arts(i, 20, i*trht);
  println(arts[3].ix);

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
    rectMode(CORNER);
    rect(x0, trht*2*i, w, trht);
    //t2
    fill(25, 33, 47);
    rect(x0, (trht*2*i)+trht, w, trht);
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

  //Score Numbers
  if (scrnumon == 1) {
    fill(255, 128, 0);
    text(scrix, width-30, 30);
  }
  //CURSOR
  osc.send("/getscoreidx", new Object[]{}, sc); //get current cursor location from sc
  //toggle cursor between staves when it reaches the end of 
  if (csrg) {
    if ( cx>=0 && cx<20 ) { //when cursor flips back to 0
      csrtog = (csrtog+1)%2;
      if (scrclkon == 1) {
        if (scrinc%srate == 0) { //
          scrix = scrix + 1; // increment score counter
          score(scrix); //up date with next score item
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
} //END DRAW

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
public void scoreix(float idx) {
  cx = (idx*trw) + x0;
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