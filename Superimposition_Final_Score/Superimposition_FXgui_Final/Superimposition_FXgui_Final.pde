import netP5.*;
import oscP5.*;
//GLOBAL VARIABLES//////////////////////////////////////////////////////
////OSC//////////////////
OscP5 osc;
NetAddress sc, me;
////Text/////////////////
PFont font1;
////Buttons//////////////
int btct = 0;
boolean mkbt_m = false;
boolean mkbt_t = false;
////Sliders//////////////
int slct = 0;
boolean mksl = false;
////Waveform Display//////////////
int wfct = 0;
boolean mkwf = false;
//SETUP/////////////////////////////////////////////////////////////////
void setup() {
  size(850, 550);
  //OSC//////////////////////////////////////////
  OscProperties properties = new OscProperties();
  properties.setListeningPort(12322);
  properties.setDatagramSize(5136); 
  osc = new OscP5(this, properties);
  sc = new NetAddress("127.0.0.1", 57120);
  me = new NetAddress("127.0.0.1", 12322);
  //TEXT//////////////////////////////////////////
  font1 = loadFont("Monaco-12.vlw");
  textFont(font1);
  //OSC PLUGS/////////////////////////////////////
  osc.plug(pushmez, "mk", "/mkbt");
  osc.plug(pushmez, "mk2", "/mkbt2");
  osc.plug(pushmez, "rmv", "/rmvbt");
  osc.plug(pushmez, "rmall", "/btclear");
  osc.plug(sliderz, "mk", "/mksl");
  osc.plug(sliderz, "mk2", "/mksl2");
  osc.plug(sliderz, "rmv", "/rmsl");
  osc.plug(sliderz, "rmall", "/slclear");
  osc.plug(sliderz, "newval", "/slchg");
  osc.plug(sampledisplayz, "mk", "/mkwf");
  osc.plug(sampledisplayz, "rmv", "/rmvwf");
  osc.plug(sampledisplayz, "rmall", "/wfclear");
  osc.plug(sampledisplayz, "ix", "/ix");
  osc.plug(sampledisplayz, "loopix", "/loopix");
  osc.plug(sampledisplayz, "camp", "/camp");
  //Make a waveform display
  osc.send("/mkwf", new Object[]{0, 25, 25}, me);
  //osc.send("/mkwf", new Object[]{1, 25, 150}, me);
  //Button Bank 1
  osc.send("/mkbt2", new Object[]{0, 0, 25, 160, 70.0, 50.0, 1, "amplify", 34}, me);
  osc.send("/mkbt2", new Object[]{0, 1, 110, 160, 70.0, 50.0, 1, "greyhole", 24}, me);
  osc.send("/mkbt2", new Object[]{0, 2, 195, 160, 70.0, 50.0, 1, "petals", 28}, me);
  osc.send("/mkbt2", new Object[]{0, 3, 280, 160, 70.0, 50.0, 1, "icy", 10}, me);
  osc.send("/mkbt2", new Object[]{0, 4, 400, 160, 80.0, 80.0, 1, "player", 13}, me);
  osc.send("/mkbt2", new Object[]{0, 5, 500, 160, 80.0, 80.0, 1, "inpause", 7}, me);
}//end setup
//DRAW/////////////////////////////////////////////////////////////////
void draw() {
  background(0);
  pushmez.drw();
  sliderz.drw();
  sampledisplayz.drw();
}//end draw
//KEY PRESSED////////////////////////////////////////////////////////////
void keyPressed() {
  // b to make a new momentary button
  if (key=='b') {
    mkbt_m = true;
  }
  // t to make a new toggle button
  if (key=='t') {
    mkbt_t = true;
  }
  // s to make a new slider
  if (key=='s') {
    mksl = true;
  }
  // w to make a new waveform display
  if (key=='w') {
    mkwf = true;
  }
  pushmez.keyprs();
  sliderz.keyprs();
}//end keyPressed
//KEY RELEASED////////////////////////////////////////////////////////////
void keyReleased() {
  // b to make a new momentary button
  if (key=='b') {
    mkbt_m = false;
  }
  // t to make a new toggle button
  if (key=='t') {
    mkbt_t = false;
  }
  // s to make a new slider
  if (key=='s') {
    mksl = false;
  }
  // w to make a new waveform display
  if (key=='w') {
    mkwf = false;
  }
}//end keyPressed
//MOUSE PRESSED////////////////////////////////////////////////////////////
void mousePressed() {
  //Make a new momentary button when mouse pressed and 'b' key pressed
  if (mkbt_m) {
    osc.send("/mkbt", new Object[]{btct, mouseX, mouseY, 0}, me);
    btct++;
  }
  //Make a new toggle button when mouse pressed and 't' key pressed
  if (mkbt_t) {
    osc.send("/mkbt", new Object[]{btct, mouseX, mouseY, 1}, me);
    btct++;
  }
  //Make a new slider when mouse pressed and 's' key pressed
  if (mksl) {
    osc.send("/mksl", new Object[]{slct, mouseX, mouseY}, me);
    slct++;
  }
  //Make a new waveform display when mouse pressed and 'w' key pressed
  if (mkwf) {
    //  osc.send("/mkwf", new Object[]{wfct, mouseX, mouseY}, me);
    wfct++;
  }
  pushmez.msprs();
  sliderz.msprs();
  sampledisplayz.msprs();
}//end mouse pressed
//MOUSE RELEASED////////////////////////////////////////////////////////////
void mouseReleased() {
  pushmez.msrel();
  sampledisplayz.msrel();
}//end mouse released
//MOUSE MOVED////////////////////////////////////////////////////////////
void mouseMoved() {
  pushmez.msmvd();
  sliderz.msmvd();
}//end mouse pressed
//MOUSE DRAGGED////////////////////////////////////////////////////////////
void mouseDragged() {
  sampledisplayz.msdrg();
  sliderz.msdrg();
}//end mouse pressed
// OSCEVENT ///////////////////////////////////////////////////////////////
void oscEvent(OscMessage msg) {


  //Get waveform data and store in samparrays
  if ( msg.checkAddrPattern("/wavfrm") ) {
    int numpx = msg.get(0).intValue();
    int ix = msg.get(1).intValue();
    for (SampleDisplay inst : sampledisplayz.cset) {
      if (inst.ix==ix) {
        inst.samparray = new float[0];
        for (int i=2; i<(numpx+2); i++) {
          inst.samparray = append(inst.samparray, msg.get(i).floatValue());
        }
        break;
      }
    }
  }// end if ( msg.checkAddrPattern("/wavfrm") )
}//end osc event
//IS MOUSE OVER? FUNCTION////////////////////////////////////////////////
boolean mo( float l, float r, float t, float b ) {
  boolean on = false;
  if ( mouseX>=l && mouseX <=r && mouseY>=t && mouseY<=b) on = true;
  return on;
}