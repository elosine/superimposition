// DECLARE/INITIALIZE CLASS SET
SampleDisplaySet sampledisplayz = new SampleDisplaySet();
/********
 /// PUT IN SETUP ///
 osc.plug(sampledisplayz, "mk", "/mksamp");
 osc.plug(sampledisplayz, "rmv", "/rmvsamp");
 /// PUT IN DRAW ///
 sampledisplayz.drw();
 ********/
/////////////   CLASS     //////////////////////////////
class SampleDisplay {
  // CONSTRUCTOR VARIALBES //
  int ix, x, y;
  // CLASS VARIABLES //
  int jjj=0;
  float cx, l, r, t, b, w, h, m, c; 
  int edit = 0;
  String[]sampnames = new String[0];
  float[]samparray ;
  boolean sgate = true;
  boolean getsampgate = true;
  int currsamp = -1;
  String currsampname = "";
  float sampw = 0;
  int playtog = 0;
  float r1=0.0;
  float r2=0.0;
  boolean ranger = false;
  float currpx = 0;
  boolean loopcsr = false;
  float lcx;

  //// Draw waveform to offscreen buffer ///////////////////////////////////////////////////////////////////////////////////////
  PGraphics bufA, bufB;
  PImage imgA, imgB;

  // CONSTRUCTORS //
  /// Constructor 1 ///
  SampleDisplay(int aix, int ax, int ay) {
    ix = aix;
    x = ax;
    y = ay;
    l=x;
    t=y;
    w=800;
    h=100;
    r=l+w;
    b=t+h;
    c = l+(w/2);
    m = t+(h/2);
    cx=x;
    samparray = new float[ceil(w)];
    lcx = cx;
    for (int i=0; i<samparray.length; i++) samparray[i] = 0;

    //off screen buffers for waveforms
      bufA = createGraphics(int(w), int(h), JAVA2D);
      bufB = createGraphics(int(w), int(h), JAVA2D);
      renderWaveform(bufA); //render waveform display to offscreen buffer
      imgA= bufA.get(0, 0, bufA.width, bufA.height); //copy to a PImage
    
  } //end constructor 1
  //  DRAW METHOD //
  void drw() {
    //Sample Display Background
    noStroke();
    rectMode(CORNER);
    fill(clr.get("beet"));
    rect(l, t, w, h);
    //Update Cursor Value
    if(frameCount%2==0) osc.send("/getix", new Object[]{ix}, sc);
    
     

    //// Draw Waveform w offscreen buffer ////////////////////////////////////////////
    //render every x pixels
    if(int(cx)%30==0) render();
      bufB.beginDraw();
      bufB.image(imgA, 0, 0);
      bufB.endDraw();
      imgB = bufB.get(0, 0, bufB.width, bufB.height);
      image(imgB, l, t);
    
    //Manual Waveform Display ///////////////
    //for more continuous updates around cursor
    stroke(255, 153, 51);
    strokeWeight(1);
    for (int i=constrain((int(cx-l)-30), 1, samparray.length-1); i<constrain((int(cx-l)+30), 1, samparray.length-1); i++) line( i-1+l, m-( samparray[i-1]*(h/2) ), i+l, m-( samparray[i]*(h/2) ) );
    //for (int i=int(cx-l); i<constrain((int(cx-l)25), 0, samparray.length-1); i++) line( i-1+l, m-( samparray[i-1]*(h/2) ), i+l, m-( samparray[i]*(h/2) ) );



    // Range Selection ///////
    if (ranger) {
      noStroke();
      fill(0, 0, 255, 100);
      if (r1<=r2) rect( r1, t, r2-r1, h );
      else rect( r2, t, r1-r2, h );
    }
    //Loop Cursor
    if (loopcsr) {
      if(frameCount%2==0) osc.send("/getloopix", new Object[]{ix}, sc);
      strokeWeight(3);
      stroke(0, 0, 255);
      line(lcx, t, lcx, b);
    }
    //Cursor
    strokeWeight(3);
    stroke(153, 255, 0);
    line(cx, t, cx, b);
  } //End drw

  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Render Graphics to an off screen buffer /////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  void renderWaveform(PGraphics buffer) {
    buffer.beginDraw();
    
    buffer.background(clr.get("beet"));
    buffer.smooth();
    buffer.noFill();
    buffer.stroke(255, 153, 51);
    buffer.strokeWeight(1);
    buffer.translate(-25, -25);
    for (int j=1; j<w; j++) buffer.line( j-1+l, m-( samparray[j-1]*(h/2) ), j+l, m-( samparray[j]*(h/2) ) );
    buffer.endDraw();
  }

  void render() {
    renderWaveform(bufA); //render waveform display to offscreen buffer
    imgA = bufA.get(0, 0, bufA.width, bufA.height);
  }




  //  ix method //
  void ix(float time, float amp) {
    float ixtmp = map(time, 0.0, 1.0, l, r);
    cx = ixtmp;
    samparray[constrain(round(cx-l), 0, samparray.length-1)] = amp;
  } //end ix method
  //  loopix method //
  void loopix(float time) {
    float ixtmp = map(time, 0.0, 1.0, l, r);
    lcx = ixtmp;
  } //end ix method


  //
}  //End class
////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////
class SampleDisplaySet {
  ArrayList<SampleDisplay> cset = new ArrayList<SampleDisplay>();
  // Make Instance Method //
  void mk(int ix, int x, int y) {
    cset.add( new SampleDisplay(ix, x, y) );
  } //end mk method
  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      SampleDisplay inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method
  // Remove All //
  void rmall() {
    cset.clear();
  } //End rmvall method
  // Draw Set Method //
  void drw() {
    for (SampleDisplay inst : cset) {
      inst.drw();
    }
  }//end drw method 
  // mouse pressed //////////////////////////////////////////
  void msprs() {
    for (SampleDisplay inst : cset) {
      //Left Click
      if (mouseButton==LEFT) { 
        //grab range
        if (mo(inst.l, inst.r, inst.t, inst.b)) { //if moused over main sample area
          inst.ranger = true;
          inst.r1 = mouseX;
          inst.r2 = mouseX;
        }//end if (mo(inst.l,inst.r,inst.t,inst.b))
      } //end if (mouseButton==LEFT)
      //Right Click
      else if (mouseButton==RIGHT) { 
        //grab range
        if (mo(inst.l, inst.r, inst.t, inst.b)) { //if moused over main sample area
          inst.loopcsr = false;
          osc.send("/mainix", new Object[]{inst.ix}, sc);
          inst.ranger = false;
        }//end if (mo(inst.l,inst.r,inst.t,inst.b))
      } //end else if (mouseButton==LEFT)
    } // end for (SampleDisplay inst : cset)
  }//end msprs method
  // mouse dragged //////////////////////////////////////////
  void msdrg() {
    for (SampleDisplay inst : cset) {
      //Left Drag
      if (mouseButton==LEFT) { 
        //grab range
        if (mo(inst.l, inst.r, inst.t, inst.b)) { //if moused over main sample area
          if (inst.edit==0) { //if not in editing mode
            inst.r2 = mouseX;
            break;
          }
        }//end if (mo(inst.l,inst.r,inst.t,inst.b))
      } //end else if (mouseButton==LEFT)
    } // end for (SampleDisplay inst : cset)
  }//end drg method
  // mouse released //////////////////////////////////////////
  void msrel() {
    for (SampleDisplay inst : cset) {
      //Left Rel
      if (mouseButton==LEFT) { 
        //grab range
        if (mo(inst.l, inst.r, inst.t, inst.b)) { //if moused over main sample area
          float start = norm(inst.r1, inst.l, inst.r);
          float end = norm(inst.r2, inst.l, inst.r);
          osc.send("/setix", new Object[]{inst.ix, min(start, end), max(start, end)}, sc );
          inst.loopcsr = true;
          break;
        }//end if (mo(inst.l,inst.r,inst.t,inst.b))
      } //end else if (mouseButton==LEFT)
    } // end for (SampleDisplay inst : cset)
  }//end drg method
  // ix Method //
  void ix(int ix, float time, float amp) {
    for (SampleDisplay inst : cset) {
      if (inst.ix == ix) {
        inst.ix(time, amp);
        break;
      }
    }
  }//end ix method 
  // ix Method //
  void loopix(int ix, float time) {
    for (SampleDisplay inst : cset) {
      if (inst.ix == ix) inst.loopix(time);
    }
  }//end ix method 

  //
} // END CLASS SET CLASS