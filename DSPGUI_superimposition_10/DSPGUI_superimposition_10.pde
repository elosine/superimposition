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
int nsamps = 4; //number of sample banks
int nsampfx = 3;
String[] fxlbls = {"Amplify", "RingMod1", "RingMod2", "Freeze", "Petals"};
int[] myserialnums = {5}; // The numbers of serial ports that you wish to use from the Serial.list() print out when you run the app
//int[] myserialnums = {}; 
//For each of the serial devices, populate serialheaders with the appropriate strings for each serial device
//The number of arrays in serialheaders needs to be the same as the number of devices in myserialnums
String[][] serialheaders = { {"bt0", "bt1", "bt2", "bt3", "bt4", "bt5", "bt6", "bt7", "bt8", "bt9", "cs0", "cs1"} }; // 2D array to hold the headers you wish to use for each serial device
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
Serial[] myserials; // Create a list of Serial objects from the Serial class
////// Serial Data
int[][] serialgates; // A 2D array to store gates for serial events per serial device, per header
String[][] serialdatas; // A 2D array to store serial data per serial device, per header
//// Other ///////////////////////////////////////////////////////////////////////////////////////
int fxtogL = nfx-1; //a toggle for the left bank of fx
int fxtogR = nfx-1; //a toggle for the right bank of fx
int samptogL = nsamps-1;
int samptogR = nsamps-1;
int samprectogL = nsamps-1;
int samprectogR = nsamps-1;
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
  printArray(Serial.list()); // Print a list of available serial ports
  myserials = new Serial[myserialnums.length]; // Make a blank array with the amount of slots to accomodate the number of devices you listed in myserialnums
  // Get the ports you listed in myserialnums and populate myserials:
  for (int i=0; i<myserialnums.length; i++) {
    String portnametemp = Serial.list()[ myserialnums[i] ]; //get name of port
    myserials[i] = new Serial(this, portnametemp, 19200); //populate myserials and open the ports
    myserials[i].bufferUntil(10); //this will buffer the serial message until it gets a hard return (ASCII code 10) and then forward to serialEvent
  }  // End for myserialnums
  // Initialize serialgates and serialdatas with 0s & empty strings respectively
  serialgates = new int[myserialnums.length][0];
  serialdatas = new String[myserialnums.length][0];
  for (int i=0; i<myserialnums.length; i++) {
    for (int j=0; j<serialheaders[i].length; j++) {
      serialgates[i] = append(serialgates[i], 0);
      serialdatas[i] = append(serialdatas[i], "");
    }
  }
  for (int i=0; i<myserialnums.length; i++) {
    for (int j=0; j<serialheaders[i].length; j++) {
      serialgates[i][j] = 0;
      serialdatas[i][j] = "";
    } // end for serialheaders
  } //end myserialnums
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
  // SERIAL DEVICE ACTIONS ///////////////////////////////////////////////////////////////////////////////////////////////////////
  if (myserialnums.length>0) { //only if there are listed serial device
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// Device-0, Header-"bt2" - serialgates/datas[0][2] - Toggle Left Fx /////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (serialgates[0][0] == 1) { //if serialgates[0][0] == 1, means that the serialEvent has opened a gate for device:0, header:0
      int valtmp = int(serialdatas[0][0]);
      fxtogL = (fxtogL + valtmp)%nfx; // increment fxtogL //put this line here for on press
      for (Press inst : pressz.cset) { //cycle through all of the buttons
        if (inst.ix<ixfxR) { //because the right fx bank starts @100
          if (inst.ix==fxtogL) { // if the index of the button equals the current fxtogL
            inst.focus = 1; //bring that button to focus
          }// end if inst
          else inst.focus = 0; //otherwise turn focus off all other buttons
        } //end if inst.ix<100
      } //end for Press
      // fxtogL = (fxtogL + int(serialdatas[0][0]))%nfx; // increment fxtogL //put this line here for on release
      serialgates[0][0] = 0; // Reset gate to 0 to wait for next message
    } //end Device-0, Header-"bt0"
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// Device-0, Header-"bt1" - - serialgates/datas[0][6] -  Toggle Rfx ///////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (serialgates[0][4] == 1) { //if serialgates[0][0] == 1, means that the serialEvent has opened a gate for device:0, header:1
      int valtmp = int(serialdatas[0][4]);
      fxtogR = (fxtogR + valtmp)%nfx; // increment fxtogL
      for (Press inst : pressz.cset) { //cycle through all of the buttons
        if (inst.ix>=ixfxR && inst.ix<ixsmpL) { //because the right fx bank starts @100
          if (inst.ix==(fxtogR+ixfxR)) { // if the index of the button equals the current fxtogR, right button indexes start at 100
            inst.focus = 1; //bring that button to focus
          }// end if inst
          else inst.focus = 0; //otherwise turn focus off all other buttons
        } //ind if inst.ix>=100
      } //end for Press
      serialgates[0][4] = 0; // Reset gate to 0 to wait for next message
    } //end Device-0, Header-"bt1"
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// Device-0, Header-"bt2", [0][0] - Turn on effect left ///////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (serialgates[0][8] == 1) { //if serialgates[0][0] == 1, means that the serialEvent has opened a gate for device:0, header:1
      int valtmp = int(serialdatas[0][8]);
      for (Press inst : pressz.cset) { //cycle through all of the buttons
        if (inst.ix<ixfxR) { //because the right fx bank starts @100
          if (inst.ix==fxtogL) { // if the index of the button equals the current fxtogR, right button indexes start at 100
            inst.on = valtmp; //bring that button to focus
            osc.send("/" + inst.label, new Object[]{0, valtmp}, sc); //send name of effect, which channel, valtemp which is 1 or 0 on or off
          }// end if inst
        } //ind if inst.ix<100
      } //end for Press
      serialgates[0][8] = 0; // Reset gate to 0 to wait for next message
    } //end Device-0, Header-"bt1"
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// Device-0, Header-"bt3",[0][1] - Turn on effect right ///////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (serialgates[0][9] == 1) { //if serialgates[0][0] == 1, means that the serialEvent has opened a gate for device:0, header:1
      int valtmp = int(serialdatas[0][9]);
      for (Press inst : pressz.cset) { //cycle through all of the buttons
        if (inst.ix>=ixfxR && inst.ix<ixsmpL) { //because the right fx bank starts @100
          if (inst.ix==(fxtogR+ixfxR)) { // if the index of the button equals the current fxtogR, right button indexes start at 100
            inst.on = valtmp; //bring that button to focus
            osc.send("/" + inst.label, new Object[]{1, valtmp}, sc); //send name of effect, which channel, valtemp which is 1 or 0 on or off
          }// end if inst
        } //ind if inst.ix<100
      } //end for Press
      serialgates[0][9] = 0; // Reset gate to 0 to wait for next message
    } //end Device-0, Header-"bt1"
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// Device-0, Header-"bt3" - serialgates/datas[0][3] - Toggle Left Samps -play /////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (serialgates[0][1] == 1) { //if serialgates[0][0] == 1, means that the serialEvent has opened a gate for device:0, header:0
      int valtmp = int(serialdatas[0][1]);
      samptogL = (samptogL + valtmp)%nsamps; // increment fxtogL //put this line here for on press
      for (Press inst : pressz.cset) { //cycle through all of the buttons
        if (inst.ix>=ixsmpL && inst.ix<ixsmpR) { //because the right fx bank starts @100
          if (inst.ix==samptogL+ixsmpL) { // if the index of the button equals the current fxtogL
            inst.focus = 1; //bring that button to focus
          }// end if inst
          else inst.focus = 0; //otherwise turn focus off all other buttons
        } //end if (inst.ix>=ixsmpL && inst.ix<ixsmpR)
      } //end for Press
      serialgates[0][1] = 0; // Reset gate to 0 to wait for next message
    } //end Device-0, Header-"bt0"
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// Device-0, Header-"bt7" - serialgates/datas[0][7] - Toggle Right Samps-play /////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (serialgates[0][5] == 1) { //if serialgates[0][0] == 1, means that the serialEvent has opened a gate for device:0, header:0
      int valtmp = int(serialdatas[0][5]);
      samptogR = (samptogR + valtmp)%nsamps; // increment fxtogL //put this line here for on press
      for (Press inst : pressz.cset) { //cycle through all of the buttons
        if (inst.ix>=ixsmpR /*&& inst.ix<ixsmpR*/) { //because the right fx bank starts @100
          if (inst.ix==samptogR+ixsmpR) { // if the index of the button equals the current fxtogL
            inst.focus = 1; //bring that button to focus
          }// end if inst
          else inst.focus = 0; //otherwise turn focus off all other buttons
        } //end if (inst.ix>=ixsmpL && inst.ix<ixsmpR)
      } //end for Press
      serialgates[0][5] = 0; // Reset gate to 0 to wait for next message
    } //end Device-0, Header-"bt0"
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// Device-0, Header-"cs0" - serialgates/datas[0][10] - Play Left Samp /////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (serialgates[0][10] == 1) { //if serialgates[0][0] == 1, means that the serialEvent has opened a gate for device:0, header:0
      int valtmp = int(serialdatas[0][10]);
      for (Press inst : pressz.cset) { //cycle through all of the buttons
        if (inst.ix>=ixsmpL && inst.ix<ixsmpR) { //because the right fx bank starts @100
          if (inst.ix==samptogL+ixsmpL) { // if the index of the button equals the current fxtogL
            inst.on = valtmp; //bring that button to focus
            osc.send("/playsamp", new Object[]{samptogL, valtmp}, sc); //send playsamp
          }// end if inst
        } //end if (inst.ix>=ixsmpL && inst.ix<ixsmpR)
      } //end for Press
      serialgates[0][10] = 0; // Reset gate to 0 to wait for next message
    } //end Device-0, Header-"bt0"
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// Device-0, Header-"cs1" - serialgates/datas[0][11] - Play Right Samps /////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (serialgates[0][11] == 1) { //if serialgates[0][0] == 1, means that the serialEvent has opened a gate for device:0, header:0
      int valtmp = int(serialdatas[0][11]);
      for (Press inst : pressz.cset) { //cycle through all of the buttons
        if (inst.ix>=ixsmpR /*&& inst.ix<ixsmpR*/) { //because the right fx bank starts @100
          if (inst.ix==samptogR+ixsmpR) { // if the index of the button equals the current fxtogL
            inst.on = valtmp; //bring that button to focus
            osc.send("/playsamp", new Object[]{samptogR, valtmp}, sc); //send playsamp
          }// end if inst
        } //end if (inst.ix>=ixsmpL && inst.ix<ixsmpR)
      } //end for Press
      serialgates[0][11] = 0; // Reset gate to 0 to wait for next message
    } //end Device-0, Header-"bt0"
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //// Device-0, Header-"bt2" - serialgates/datas[0][2] - Toggle Left Samps-rec /////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    if (serialgates[0][2] == 1) { //if serialgates[0][0] == 1, means that the serialEvent has opened a gate for device:0, header:0
      int valtmp = int(serialdatas[0][2]);
      samprectogL = (samprectogL + valtmp)%nsamps; // increment fxtogL //put this line here for on press
      for (Press inst : pressz.cset) { //cycle through all of the buttons
        if (inst.ix>=ixsmpL && inst.ix<ixsmpR) { //because the right fx bank starts @100
          if (inst.ix==samprectogL+ixsmpL) { // if the index of the button equals the current fxtogL
            inst.focus2 = 1; //bring that button to focus
          }// end if inst
          else inst.focus2 = 0; //otherwise turn focus off all other buttons
        } //end if (inst.ix>=ixsmpL && inst.ix<ixsmpR)
      } //end for Press
      serialgates[0][2] = 0; // Reset gate to 0 to wait for next message
    } //end Device-0, Header-"bt0"
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  } //end if(myserialnums.length>0) {

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
        line( sl+j-1, st+(sh/2)-( (sh/2)*samparrays[i+nsamps][j-1]), sl+j, st+(sh/2)-((sh/2)*samparrays[+nsamps][j]));
      }
    } // end for Press
  } //end for nsamps
} // End draw
////////////////////////////////////////////////////////////////////////////////////////////////////////
// SERIAL EVENT /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//By invoking the serialEvent, and using a gate system,
//you can store data incomming via the serial ports
//and use it 
void serialEvent(Serial serialport) {
  int portnumtmp = -1; // variable to hold the number of the port:
  // Iterate over the list of ports opened, check if it is one in myserials, and match the one that generated this event:
  for (int i=0; i<myserials.length; i++) {
    if (serialport == myserials[i]) {
      //Incomming port number
      portnumtmp = i; // Capture the number of serial device in myserials that sent this event
    } //end if serialport
  } //end for myserials
  // Read the incomming message
  // Split the message at the ':' to get the header and the data
  String serialmsgtmp = myserials[portnumtmp].readString(); // read the incomming string from the serial port
  String[] stmp = split(serialmsgtmp, '\n'); // processing adds the hard return so this split puts it in stmp[1] and next line grabs just the message
  String[] smsgsplittmp = split(stmp[0], ":"); // split the message at the ':'
  String headertmp = smsgsplittmp[0]; // incomming header
  String serialdatatmp = smsgsplittmp[1]; // incomming data
  serialdatatmp = trim(serialdatatmp);
  // Check if this header exsists for this device in your list serialheaders
  for (int i=0; i<serialheaders[portnumtmp].length; i++) {
    if ( headertmp.equals(serialheaders[portnumtmp][i]) ) { // Check if this header exsists for this device in your list serialheaders
      serialgates[portnumtmp][i] = 1; // open the gate so draw can see that a valid serial event is waiting
      serialdatas[portnumtmp][i] = serialdatatmp; //store serial data as a string to be parced appropriately by other functions
    } // end if headertmp
  } // end for serialheaders
} // end serialEvent
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