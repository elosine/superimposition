// DECLARE/INITIALIZE CLASS SET
PressSet pressz = new PressSet();
/**
 *
 *
 /// PUT IN SETUP ///
 meosc.plug(pressz, "mk", "/mkpress");
 meosc.plug(pressz, "rmv", "/rmvpress");
 meosc.plug(pressz, "rmvall", "/rmvallpress");
 font1 = loadFont("Monaco-20.vlf"); //Create font Monaco-20 
 /// PUT IN DRAW ///
 pressz.drw();
 *
 *
 */


class Press {

  // CONSTRUCTOR VARIALBES //
  int ix, x, y, w, h;
  String cl, label;
  // CLASS VARIABLES //
  int t, b, l, r, val;
  float m, c;
  int on = 0;
  int on2 = 0;
  int focus = 0;
  int focus2 = 0;
  color focusclr = clr.get("white");
  color focusclr2 = clr.get("red");
  color onclr = clr.get("yellow");
  color on2clr = clr.getAlpha("red", 100);
  // CONSTRUCTORS //

  /// Constructor 1 ///
  Press(int aix, int ax, int ay, int aw, int ah, String aclr, String alabel) {
    ix = aix;
    x = ax;
    y = ay;
    w = aw;
    h = ah;
    cl = aclr;
    label = alabel;
    //Set Up Instance
    t = y;
    b = y+h;
    l = x;
    r = x+w;
    m = y+(h/2);
    c = x+(w/2);
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
    rectMode(CORNER);
    strokeWeight(5);
    if (focus2 == 1) {
      stroke(focusclr2);
      noFill();
      rect(x-4, y-4, w+8, h+8);
    }
    if (mo()==1 || focus==1) stroke(focusclr);
    if (mo()==0 && focus==0 && focus2==0) noStroke();
    if (on==1) fill(onclr);
    else fill(clr.get(cl));
    rect(x, y, w, h);
    textAlign(CENTER, CENTER);
    fill(0);
    textFont(font1);
    text( label, c, m );
    if(on2==1){ //secondary shading
    fill(on2clr);
    noStroke();
    rect(x, y, w, h);
    }
  } //End drw

  //// Mouse Over
  int mo() {
    int status=0;
    if (mouseX >= l && mouseX <= r && mouseY >= t && mouseY <= b) status = 1;
    return status;
  }
  //
  //
}  //End class

////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////

class PressSet {
  ArrayList<Press> cset = new ArrayList<Press>();

  // Make Instance Method //
  void mk(int ix, int x, int y, int w, int h, String clr, String label) {
    cset.add( new Press(ix, x, y, w, h, clr, label) );
  } //end mk method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Press inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Draw Set Method //
  void drw() {
    for (Press inst : cset) {
      inst.drw();
    }
  }//end drw method
  //
  //
} // END CLASS SET CLASS