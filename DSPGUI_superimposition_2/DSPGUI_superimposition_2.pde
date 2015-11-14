/////////////////////////////////////////////////////////////////////////////////////////
// IMPORT LIBRARIES /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
import processing.serial.*;
import netP5.*;
import oscP5.*;
/////////////////////////////////////////////////////////////////////////////////////////
// GLOBAL VARIABLES /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
//// Variable Variables /////////////////////////////////////////////////////////////////
int nfx = 5; //number of fx
//// Text ///////////////////////////////////////////////////////////////////////////////
String[] fxlbls = {"Amplify", "RingMod1", "RingMod2", "Freeze", "Samps"};
PFont font1, font2;
//// Drawing ///////////////////////////////////////////////////////////////////////////////
int w = 500; //canvas width, reset later in setup
int h = 500; //canvas height, reset later in setup
String[] clrset = {"springgreen", "violetred", "dodgerblue", "sunshine", "magenta", 
  "indigo", "peacock", "papaya", "turquoiseblue", "pink", "fig", "yellow", "mint"};
int margin = 10; // x & y margins
//// OSC /////////////////////////////////////////////////////////////////////////////////
OscP5 osc; //OSC Machine
NetAddress sc; // Supercollider Language/Client Side As Remote Destination
//// Serial ///////////////////////////////////////////////////////////////////////////////
int[] myserialnums = {5}; // The numbers of serial ports that you wish to use from the Serial.list() print out when you run the app
Serial[] myserials; // Create a list of Serial objects from the Serial class
int[] myserialdatas = new int[0]; // A list to hold data from the serial ports
////// Serial Data
String[] serialheaders = {"bt0", "bt1", bt
IntDict headernumss = new IntDict();
////////////////////////////////////////////////////////////////////////////////////////////
// SETUP /////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  //// Canvas  /////////////////////////////////////////////////////////////////////////////////
  size(500, 500);
  ////// Calculate width and height of canvas based on GUI
  // w = margin+bw+gap1+bw+margin; 
  // h = margin+bw+gap1+bw+margin; 
  surface.setResizable(true); // Allow the canvas to be resizeable
  surface.setSize(w, h); // Resize the canvas to the calculated width and height
  //// Serial  /////////////////////////////////////////////////////////////////////////////////
  printArray(Serial.list()); // Print a list of available serial ports
  myserials = new Serial[myserialnums.length]; // Make a blank array with the amount of slots to accomodate the number of devices you listed in myserialnums
  // Get the ports you listed in myserialnums and populate myserials:
  for (int i=0; i<myserialnums.length; i++) {
    String portnametemp = Serial.list()[ myserialnums[i] ]; //get name of port
    myserials[i] = new Serial(this, portnametemp, 9600); //populate myserials and open the ports
  }  // End for myserialnums
} // End Setup
/////////////////////////////////////////////////////////////////////////////////////////////////
// DRAW /////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
} // End draw
////////////////////////////////////////////////////////////////////////////////////////////////////////
// SERIAL EVENT /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
void serialEvent(Serial serialport) {
  int portnumtmp = -1; // variable to hold the number of the port:
  // Iterate over the list of ports opened, and match the one that generated this event:
  for (int i=0; i<myserials.length; i++) {
    if (serialport == myserials[i]) {
      //Incomming port number
      portnumtmp = i; // Capture the number of serial device in myserials that sent this event
    } //end if serialport
  } //end for myserials
  // Read the incomming message
  // Split the message at the ':' to get the header and the data
  // Store data into 2D array - serialdatabyportbytag
  String serialmsgtmp = myserials[portnumtmp].readString(); // read the incomming string from the serial port
  String[] smsgsplittmp = split(serialmsgtmp, ":"); // split the message at the ':'
  String headertmp = smsgsplittmp[0]; // incomming header
  String serialdatatmp = smsgsplittmp[1]; // incomming data
  
  
  
  //write function to store data into portnum, header, data, trig
  //write function that checks if portnum header trig is true
  //grabs data and runs function