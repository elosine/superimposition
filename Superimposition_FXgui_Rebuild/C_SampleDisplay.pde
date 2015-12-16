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

  // CONSTRUCTORS //
  /// Constructor 1 ///
  SampleDisplay(int aix, int ax, int ay) {
    ix = aix;
    x = ax;
    y = ay;
    l=x;
    t=y;
    w=1000;
    h=150;
    r=l+w;
    b=t+h;
    c = l+(w/2);
    m = t+(h/2);
    cx=x;
    samparray = new float[ceil(w)];
    for (int i=0; i<samparray.length; i++) samparray[i] = 0;
  } //end constructor 1
  //  DRAW METHOD //
  void drw() {
    //Sample Display Background
    noStroke();
    rectMode(CORNER);
    fill(clr.get("beet"));
    rect(l, t, w, h);
    //Update Cursor Value
    osc.send("/getix", new Object[]{ix}, sc);
    //Waveform Display ///////////////
    stroke(255, 153, 51);
    strokeWeight(1);
    for (int i=1; i<samparray.length; i++) line( i-1+l, m-( samparray[i-1]*(h/2) ), i+l, m-( samparray[i]*(h/2) ) );
    //Cursor
    strokeWeight(3);
    stroke(153, 255, 0);
    line(cx, t, cx, b);
    // Range Selection ///////
    if (ranger) {
      noStroke();
      fill(0, 0, 255, 100);
      if (r1<=r2) rect( r1, t, r2-r1, h );
      else rect( r2, t, r1-r2, h );
    }
  } //End drw
  //  ix method //
  void ix(float time, float amp) {
    float ixtmp = map(time, 0.0, 1.0, l, r);
    cx = ixtmp;
    samparray[round(cx-l)] = amp;
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
          if (inst.edit==0) { //if not in editing mode
            inst.ranger = true;
            inst.r1 = mouseX;
            inst.r2 = mouseX;
          }
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
          osc.send("/setix", new Object[]{inst.ix, inst.currsamp, min(start, end), max(start, end)}, sc );
          break;
        }//end if (mo(inst.l,inst.r,inst.t,inst.b))
      } //end else if (mouseButton==LEFT)
    } // end for (SampleDisplay inst : cset)
  }//end drg method
  // ix Method //
  void ix(int ix, float time, float amp) {
    for (SampleDisplay inst : cset) {
      if (inst.ix == ix) inst.ix(time, amp);
    }
  }//end ix method 

  //
} // END CLASS SET CLASS