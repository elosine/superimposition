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
String[] fxlbls = {"Amplify", "RingMod1", "RingMod2", "Freeze", "Samps"};
int[] myserialnums = {}; // The numbers of serial ports that you wish to use from the Serial.list() print out when you run the app

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
int btbx1;
int btby1;
//// OSC /////////////////////////////////////////////////////////////////////////////////
OscP5 osc; //OSC Machine
NetAddress sc; // Supercollider Language/Client Side As Remote Destination
//// Serial ///////////////////////////////////////////////////////////////////////////////
Serial[] myserials; // Create a list of Serial objects from the Serial class
////// Serial Data
//For each of the serial devices, populate serialheaders with the appropriate strings for each serial device
//The number of arrays in serialheaders needs to be the same as the number of devices in myserialnums
String[][] serialheaders = { {"bt0", "bt1", "bt2"}, { "accel0" } }; // 2D array to hold the headers you wish to use for each serial device
int[][] serialgates; // A 2D array to store gates for serial events per serial device, per header
String[][] serialdatas; // A 2D array to store serial data per serial device, per header
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
    myserials[i] = new Serial(this, portnametemp, 9600); //populate myserials and open the ports
  }  // End for myserialnums
  // Initialize serialgates and serialdatas with 0s & empty strings respectively
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
  //// Classes ///////////////////////////////////////////////////////////////////////////////
  ////// Press (Buttons) ///////////////////////////////////////////////////////////////////////////////
  osc.plug(pressz, "mk", "/mkpress");
  osc.plug(pressz, "rmv", "/rmvpress");
  osc.plug(pressz, "rmvall", "/rmvallpress");
  //////// Make Buttons ///////////////////////////////////////////////////////////////////////////////
  ////////// Left - indexes 0, 1...
  for (int i=0; i<nfx; i++) pressz.mk(i, margin, margin + (btby1*i), bw1, bh1, clrset[i%clrset.length], fxlbls[i%fxlbls.length]);
  ////////// Right - indexes 100, 101...
  for (int i=0; i<nfx; i++) pressz.mk(100+i, margin+hgap1+bw1, margin + (btby1*i), bw1, bh1, clrset[i%clrset.length], fxlbls[i%fxlbls.length]);
} // End Setup
/////////////////////////////////////////////////////////////////////////////////////////////////
// DRAW /////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
  background(0);
  pressz.drw(); //draw buttons
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
  String[] smsgsplittmp = split(serialmsgtmp, ":"); // split the message at the ':'
  String headertmp = smsgsplittmp[0]; // incomming header
  String serialdatatmp = smsgsplittmp[1]; // incomming data
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