/////////////////////////////////////////////////////////////////////////////////////////
// IMPORT LIBRARIES /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
import processing.serial.*;
import netP5.*;
import oscP5.*;
/////////////////////////////////////////////////////////////////////////////////////////
// GLOBAL VARIABLES /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
//// USER DEFINED Variables /////////////////////////////////////////////////////////////////
int nfx = 5; //number of fx
int nsamps = 4; //number of sample banks per side
int nsampfx = 3; //number of fx per sample per side
String[] fxlbls = {"Amplify", "RingMod1", "RingMod2", "Freeze", "Petals"};
//// Text ///////////////////////////////////////////////////////////////////////////////
PFont font1, font2;
//// Drawing ///////////////////////////////////////////////////////////////////////////////
int cw = 390; //canvas width, reset later in setup
int ch = 630; //canvas height, reset later in setup
String[] clrset = {"springgreen", "violetred", "dodgerblue", "sunshine", "magenta", 
  "indigo", "peacock", "papaya", "turquoiseblue", "pink", "fig", "yellow", "mint"};
int margin = 10; // x & y margins
int bw1 = 200; // button width
int bh1 = 45; // button height
int vgap1 = 10; // vertical space between buttons
int hgap1 = 30; // horizontal space between buttons
int btbx1; //total pixels between left side of any two buttons
int btby1; //total pixels between tops of any two butttons
int fxsh; //total height of fx bank
/////// Samples ////////////////////
int vgap2=5;//gap between sample button and sample effect buttons
int bw2 = 25; //width of sample fx buttons
int bh2 = 25; //height of sample fx buttons
//space between sample banks use vgap1
int hgap2 = 5; //horiz gap between sample effects buttons
int btby2; //total pixels between tops of any two sample banks
float[]sampix;
float[][]samparrays;
////// initial button index numbers
int ixfxL = 0;
int ixfxR = 100;
int ixsmpL = 200;
int ixsmpR = 300;
//// OSC /////////////////////////////////////////////////////////////////////////////////
OscP5 osc; //OSC Machine
NetAddress sc; // Supercollider Language/Client Side As Remote Destination
//// Serial ///////////////////////////////////////////////////////////////////////////////
Serial ino; 
String serialmsg;
boolean serialon = true;
int serialport = 5;
//// Other ///////////////////////////////////////////////////////////////////////////////////////
int fxtogL = nfx-1; //a toggle for the left bank of fx
int fxtogR = nfx-1; //a toggle for the right bank of fx
int samptogL = nsamps-1;
int samptogR = nsamps-1;
int samprectog = (nsamps*2)-1;
////////////////////////////////////////////////////////////////////////////////////////////
// SETUP /////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  //// Canvas  /////////////////////////////////////////////////////////////////////////////////
  size(500, 500);
  ////// Calculate width and height of canvas based on GUI
  cw = margin+bw1+hgap1+bw1+margin; 
  // h = margin+bw+gap1+bw+margin; 
  surface.setResizable(true); // Allow the canvas to be resizeable
  surface.setSize(cw, ch); // Resize the canvas to the calculated width and height
  //// OSC  /////////////////////////////////////////////////////////////////////////////////
  // OSC is being set up like this so it can receive large arrays, maybe something to do with setDatagramSize
  OscProperties properties = new OscProperties();
  properties.setListeningPort(12321);
  properties.setDatagramSize(5136); 
  osc = new OscP5(this, properties);
  sc = new NetAddress("127.0.0.1", 57120);
  //// Serial  /////////////////////////////////////////////////////////////////////////////////
  printArray(Serial.list());
  if (serialon) {
    String portName = Serial.list()[serialport];
    ino = new Serial(this, portName, 9600);
  }
  //// Text /////////////////////////////////////////////////////////////////////////////////////
  font1 = loadFont("Monaco-20.vlw");
  //// Drawing  /////////////////////////////////////////////////////////////////////////////////
  btby1 = bh1+vgap1; // vertical space between one button and the next
  btbx1 = bw1+hgap1; // horizontal space betwwen one button and the next
  fxsh = margin + (btby1*nfx); //total height in pixels of top fx section
  btby2 = bh1+vgap2+bh2+vgap1; // vertical space between one button and the next
  //// Samples  /////////////////////////////////////////////////////////////////////////////////
  sampix = new float[nsamps*2]; //hold index values for samples
  for (int i=0; i<sampix.length; i++) sampix[i]=0.0; //populate w/0
  samparrays = new float[nsamps*2][bw1];
  for (int i=0; i<samparrays.length; i++) {
    for (int j=0; j<samparrays[i].length; j++) samparrays[i][j]=0.0;
  }
  //// Classes ///////////////////////////////////////////////////////////////////////////////
  ////// Press (Buttons) ///////////////////////////////////////////////////////////////////////////////
  osc.plug(pressz, "mk", "/mkpress");
  osc.plug(pressz, "rmv", "/rmvpress");
  osc.plug(pressz, "rmvall", "/rmvallpress");
  ////// Get Index function
  osc.plug(this, "ix", "/ix");
  //////// Make Buttons ///////////////////////////////////////////////////////////////////////////////
  ////////// Left FX - indexes 0, 1...
  for (int i=0; i<nfx; i++) pressz.mk(i+ixfxL, margin, margin + (btby1*i), bw1, bh1, clrset[i%clrset.length], fxlbls[i%fxlbls.length]);
  ////////// Right FX - indexes 100, 101...
  for (int i=0; i<nfx; i++) pressz.mk(ixfxR+i, margin+hgap1+bw1, margin + (btby1*i), bw1, bh1, clrset[i%clrset.length], fxlbls[i%fxlbls.length]);
  ////////// Left Samps - indexes 200, 201...
  for (int i=0; i<nsamps; i++) pressz.mk(ixsmpL+i, margin, fxsh+(btby2*i), bw1, bh1, "orange", ""); //sample buttons
  //for (int i=0; i<nsamps; i++) pressz.mk(200+i, margin, fxsh+(btby2*i), bw1, bh1, "orange", ""); //sample buttons
  ////////// Right Samps - indexes 300, 301...
  for (int i=0; i<nsamps; i++) pressz.mk(ixsmpR+i, margin+hgap1+bw1, fxsh+(btby2*i), bw1, bh1, "orange", "");
} // End Setup
/////////////////////////////////////////////////////////////////////////////////////////////////
// DRAW /////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
  background(0);
  // READ SERIAL PORT(S) ///////////////////////////////////////////////////////////////////////////////////////////////////////
  if (serialon) { //change this in global variables if you have/have not an arduino plugged in
    if ( ino.available() > 0) {
      serialmsg = trim( ino.readString() ); //rim because sometimes there are extra line feeds and spaes
      String[] msg = split(serialmsg, ":");
      if (msg[0]!=null && msg[1]!=null) { //Check to see if there is a message
        String stag = msg[0];
        String sval = msg[1];
        switch(stag) { //Switch on message tag
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //// bt0 - TOGGLE LEFT FX /////////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case "bt0":
          fxtogL = (fxtogL+int(sval))%nfx; // increment fxtogL //put this line here for on press
          for (Press inst : pressz.cset) { //cycle through all of the buttons
            if (inst.ix<ixfxR) { //because the right fx bank starts @100
              if (inst.ix==fxtogL) { // if the index of the button equals the current fxtogL
                inst.focus = 1; //bring that button to focus
              }// end if (inst.ix==fxtogL)
              else inst.focus = 0; //otherwise turn focus off all other buttons
            } //end if (inst.ix<ixfxR)
          } //end for (Press inst : pressz.cset)
          //fxtogL = (fxtogL+int(sval))%nfx; // increment fxtogL //put this line here for on release
          break;
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //// bt4 - TOGGLE RIGHT FX /////////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case "bt4":
          fxtogR = (fxtogR + int(sval))%nfx; // increment fxtogL
          for (Press inst : pressz.cset) { //cycle through all of the buttons
            if (inst.ix>=ixfxR && inst.ix<ixsmpL) { //because the right fx bank starts @100 and the left sample bank indexes start at 200
              if (inst.ix==(fxtogR+ixfxR)) { // if the index of the button equals the current fxtogR, right button indexes start at 100
                inst.focus = 1; //bring that button to focus
              }// end if inst
              else inst.focus = 0; //otherwise turn focus off all other buttons
            } // end if (inst.ix>=ixfxR && inst.ix<ixsmpL)
          } //end for (Press inst : pressz.cset)
          break;
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //// bt8 - Turn on effect left ///////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case "bt8":
          for (Press inst : pressz.cset) { //cycle through all of the buttons
            if (inst.ix<ixfxR) { //because the right fx bank starts @100
              if (inst.ix==fxtogL) { // if the index of the button equals the current fxtogR, right button indexes start at 100
                inst.on = int(sval); //bring that button to focus
                osc.send("/" + inst.label, new Object[]{0, int(sval)}, sc); //send name of effect, which channel, valtemp which is 1 or 0 on or off
              }// end if (inst.ix==fxtogL)
            } // end if (inst.ix<ixfxR)
          } // end for (Press inst : pressz.cset)
          break;
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //// bt9 - Turn on effect right ///////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case "bt9":
          for (Press inst : pressz.cset) { //cycle through all of the buttons
            if (inst.ix>=ixfxR && inst.ix<ixsmpL) { //because the right fx bank starts @100
              if (inst.ix==(fxtogR+ixfxR)) { // if the index of the button equals the current fxtogR, right button indexes start at 100
                inst.on = int(sval); //bring that button to focus
                osc.send("/" + inst.label, new Object[]{1, int(sval)}, sc); //send name of effect, which channel, sval which is 1 or 0 on or off
              }// end if (inst.ix==(fxtogR+ixfxR))
            } // end if (inst.ix>=ixfxR && inst.ix<ixsmpL)
          } // end for (Press inst : pressz.cset)
          break;
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //// bt1 - Toggle Left Samps Play /////////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case "bt1":
          samptogL = (samptogL + int(sval))%nsamps; // increment fxtogL //put this line here for on press
          for (Press inst : pressz.cset) { //cycle through all of the buttons
            if (inst.ix>=ixsmpL && inst.ix<ixsmpR) { //because the right fx bank starts @100
              if (inst.ix==samptogL+ixsmpL) { // if the index of the button equals the current fxtogL
                inst.focus = 1; //bring that button to focus
              }// end if (inst.ix==samptogL+ixsmpL)
              else inst.focus = 0; //otherwise turn focus off all other buttons
            } //end if (inst.ix>=ixsmpL && inst.ix<ixsmpR)
          } //end for for (Press inst : pressz.cset)
          break;
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //// bt5 - Toggle Right Samps-play /////////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case "bt5":
          samptogR = (samptogR + int(sval))%nsamps; // increment fxtogL //put this line here for on press
          for (Press inst : pressz.cset) { //cycle through all of the buttons
            if (inst.ix>=ixsmpR ) { //because the right fx bank starts @100
              if (inst.ix==samptogR+ixsmpR) { // if the index of the button equals the current fxtogL
                inst.focus = 1; //bring that button to focus
              }// end if inst
              else inst.focus = 0; //otherwise turn focus off all other buttons
            } //end if (inst.ix>=ixsmpL && inst.ix<ixsmpR)
          } //end for Press
          break;
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //// cs0 - Play Left Samp /////////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case "cs0":
          for (Press inst : pressz.cset) { //cycle through all of the buttons
            if (inst.ix>=ixsmpL && inst.ix<ixsmpR) { //because the right fx bank starts @100
              if (inst.ix==samptogL+ixsmpL) { // if the index of the button equals the current fxtogL
                inst.on = int(sval); //bring that button to focus
                osc.send("/play", new Object[]{samptogL, int(sval), 0}, sc); //send playsamp
              }// end if (inst.ix==samptogL+ixsmpL)
            } //end if (inst.ix>=ixsmpL && inst.ix<ixsmpR)
          } //end for (Press inst : pressz.cset)
          break;
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //// cs1 - Play Right Samps /////////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case "cs1":
          for (Press inst : pressz.cset) { //cycle through all of the buttons
            if (inst.ix>=ixsmpR ) { //because the right fx bank starts @100
              if (inst.ix==samptogR+ixsmpR) { // if the index of the button equals the current fxtogL
                inst.on = int(sval); //bring that button to focus
                osc.send("/play", new Object[]{samptogR+nsamps, int(sval), 1}, sc); //send playsamp
              }// end if (inst.ix==samptogR+ixsmpR)
            } //end if (inst.ix>=ixsmpR )
          } //end for (Press inst : pressz.cset)
          break;
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //// bt2 - Toggle Samps Record /////////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case "bt2":
          samprectog = (samprectog + int(sval))%(nsamps*2); // increment fxtogL //put this line here for on press
          int sampix = samprectog;
          if (samprectog<nsamps)  sampix = samprectog+ixsmpL; //if it is the first half it is on sample bank L
          else  sampix = samprectog-nsamps+ixsmpR; //if samprectog is in the second half it is on sample bank R
          for (Press inst : pressz.cset) { //cycle through all of the buttons
            if (inst.ix>=ixsmpL) { //because the left fx bank starts @100
              if (inst.ix==sampix) { // if the index of the button equals the current fxtogL
                inst.focus2 = 1; //bring that button to focus
              }// end if (inst.ix==samprectogL+ixsmpL) 
              else inst.focus2 = 0; //otherwise turn focus off all  other buttons
            } //end if (inst.ix>=ixsmpL && inst.ix<ixsmpR)
          } //end for (Press inst : pressz.cset)
          break;
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
          //// bt6 - Toggle Record /////////////////////////////////////////////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case "bt6":
          for (Press inst : pressz.cset) { //cycle through all of the buttons
            if (inst.ix>=ixsmpL) { //because the right fx bank starts @100
              int sampix2 = samprectog;
              if (samprectog<nsamps)  sampix2 = samprectog+ixsmpL; //if it is the first half it is on sample bank L
              else  sampix2 = samprectog-nsamps+ixsmpR; //if samprectog is in the second half it is on sample bank R
              if (inst.ix==sampix2) { // if the index of the button equals the current fxtogL
                if (int(sval)==1) {
                  inst.on2 = (inst.on2+int(sval))%2; //bring that button to focus
                  if (inst.on2 == 1) {
                    if (samprectog<nsamps) {
                      int recch = 0;
                      osc.send("/rec", new Object[]{samprectog, inst.on2, recch}, sc); //send playsamp
                    } // end if (samprectog<nsamps)
                    else {
                      int recch = 0;
                      osc.send("/rec", new Object[]{samprectog, inst.on2, recch}, sc); //send playsamp
                    } // end else
                  } // end if (inst.on2 == 1)
                  else osc.send("/rec", new Object[]{samprectog, inst.on2, 0}, sc);
                } // end if (int(sval)==1)
              }// end if (inst.ix==samprectogR+ixsmpR)
            } //end if (inst.ix>=ixsmpR)
          } //end for (Press inst : pressz.cset)
          break;
        } // end switch(msg[0])
      } // end if(stag!=null)
      //
    } // end if ( ino.available() > 0)
  } // end if (serialon)
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //// END SERIAL /////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  //  DRAW BUTTONS ////////////////////////////////////////////////////////////////////////////
  pressz.drw(); //draw button
  //  DRAW SAMPLE INDEXES ////////////////////////////////////////////////////////////////////////////
  //left samples
  for (int i=0; i<nsamps; i++) {
    osc.send("/getidx", new Object[]{i}, sc);
    int sl = 0;
    int st = 0;
    int sb = 0;
    int sh = 0;
    float sw = 0.0;
    for (Press inst : pressz.cset) {
      if (inst.ix == (i+ixsmpL) ) {
        sl = inst.l;
        st = inst.t;
        sb = inst.b;
        sw = inst.w;
        sh = inst.h;
      } //end if inst.ix
      stroke(153, 255, 0);
      strokeWeight(1);
      line( sl+(sampix[i]*sw), st, sl+(sampix[i]*sw), sb );
      //waveform display
      stroke(0, 0, 255);
      strokeWeight(1);
      for (int j=1; j<bw1; j++) {
        line( sl+j-1, st+(sh/2)-( (sh/2)*samparrays[i][j-1]), sl+j, st+(sh/2)-((sh/2)*samparrays[i][j]));
      }
    } // end for Press
  } //end for nsamps

  //right samples
  for (int i=0; i<nsamps; i++) {
    osc.send("/getidx", new Object[]{i+nsamps}, sc);
    int sl = 0;
    int st = 0;
    int sb = 0;
    int sh = 0;
    float sw = 0.0;
    for (Press inst : pressz.cset) {
      if (inst.ix == (i+ixsmpR) ) {
        sl = inst.l;
        st = inst.t;
        sb = inst.b;
        sw = inst.w;
        sh = inst.h;
      } //end if inst.ix
      stroke(153, 255, 0);
      strokeWeight(1);
      line( sl+(sampix[i+nsamps]*sw), st, sl+(sampix[i+nsamps]*sw), sb );
      //waveform display
      stroke(0, 0, 255);
      strokeWeight(1);
      for (int j=1; j<bw1; j++) {
        line( sl+j-1, st+(sh/2)-( (sh/2)*samparrays[i+nsamps][j-1]), sl+j, st+(sh/2)-((sh/2)*samparrays[i+nsamps][j]));
      }
    } // end for Press
  } //end for nsamps
} // End draw
////////////////////////////////////////////////////////////////////////////////////////////////////////
// MOUSE PRESSED /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
void mousePressed() {
  for (Press inst : pressz.cset) { //for loop through all of the buttons in the pressz class set
    if (inst.mo()==1) { //if a button is moused over
      inst.on = 1; // each button is momentary, 1 in mousepressed, 0 in mouse released
      buttonActions(inst.ix, 1); //calls function buttonActions with index and button state
    } // end if inst.mo
  } // end for Press
} // end mousePressed
////////////////////////////////////////////////////////////////////////////////////////////////////////
// MOUSE RELEASED /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
void mouseReleased() {
  for (Press inst : pressz.cset) { //for loop through all of the buttons in the pressz class set
    if (inst.mo()==1) { //if a button is moused over
      inst.on = 0; // each button is momentary, 1 in mousepressed, 0 in mouse released
      buttonActions(inst.ix, 0); //calls function buttonActions with index and button state
    } // end if inst.mo
  } // end for Press
} // end mousePressed
////////////////////////////////////////////////////////////////////////////////////////////////////////
// BUTTON ACTIONS /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
void buttonActions(int ix, int state) {
  switch(ix) {
    // LEFT SIDE /////////////////////////////////////////////////////////////////////////////////
    ////Button Left 0 - Amplify ////////////////////////////////////////////////////////////
  case 0:
    if (state==1) osc.send("/liveampon", new Object[]{0}, sc); // if button state = 1, turn amplification on ch0
    else osc.send("/liveampoff", new Object[]{0}, sc); // if button state = 0, turn amplification off ch0
    break;
    ////Button Left 1 - Ring Modulation 1 ////////////////////////////////////////////////////////////
  case 1:
    if (state==1) osc.send("/liverm1on", new Object[]{0}, sc); // if button state = 1, turn rm1 on ch0
    else osc.send("/liverm1off", new Object[]{0}, sc); // if button state = 0, turn rm1 off ch0
    break;
    ////Button Left 2 - Ring Modulation 2 ////////////////////////////////////////////////////////////
  case 2:
    if (state==1) osc.send("/liverm2on", new Object[]{0}, sc);// if button state = 1, turn rm1 on ch0
    else osc.send("/liverm2off", new Object[]{0}, sc);  // if button state = 0, turn rm1 off ch0
    break;
    ////Button Left 3 - Freeze ////////////////////////////////////////////////////////////
  case 3:
    osc.send("/livefreezeon", new Object[]{0}, sc); //freeze
    break;
    ////Button Left 4 - Samples ////////////////////////////////////////////////////////////
  case 4:
    break;
    // RIGHT SIDE /////////////////////////////////////////////////////////////////////////////////
    ////Button Left 0 - Amplify ////////////////////////////////////////////////////////////
  case 100:
    if (state==1) osc.send("/liveampon", new Object[]{1}, sc); // if button state = 1, turn amplification on ch0
    else osc.send("/liveampoff", new Object[]{1}, sc); // if button state = 0, turn amplification off ch0
    break;
    ////Button Right 1 - Ring Modulation 1 ////////////////////////////////////////////////////////////
  case 101:
    if (state==1) osc.send("/liverm1on", new Object[]{1}, sc); // if button state = 1, turn rm1 on ch0
    else osc.send("/liverm1off", new Object[]{1}, sc); // if button state = 0, turn rm1 off ch0
    break;
    ////Button Right 2 - Ring Modulation 2 ////////////////////////////////////////////////////////////
  case 102:
    if (state==1) osc.send("/liverm2on", new Object[]{1}, sc);// if button state = 1, turn rm1 on ch0
    else osc.send("/liverm2off", new Object[]{1}, sc);  // if button state = 0, turn rm1 off ch0
    break;
    ////Button Right 3 - Freeze ////////////////////////////////////////////////////////////
  case 103:
    osc.send("/livefreezeon", new Object[]{1}, sc); //freeze
    break;
    ////Button Left 4 - Samples ////////////////////////////////////////////////////////////
  case 104:
    break;
  } // end switch
} // end button actions
////////////////////////////////////////////////////////////////////////////////////////////////////////
// IX Function /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
void ix(int sampnum, float val) {
  sampix[sampnum] = val;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////
// OSCEVENT /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
void oscEvent(OscMessage msg) {
  //get waveform data and store in samparrays
  if ( msg.checkAddrPattern("/sbuf") ) {
    int sampnum = msg.get(0).intValue();
    for (int i=0; i<bw1; i++) {
      if (i>0) samparrays[sampnum][i] = msg.get(i).floatValue();
    }
  }
}