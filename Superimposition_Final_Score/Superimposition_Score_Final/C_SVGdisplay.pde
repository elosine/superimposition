

// DECLARE/INITIALIZE CLASS SET
SVGdisplaySet setSVGdisplay = new SVGdisplaySet();

/*
 /// PUT IN SETUP ///
 osc.plug(setSVGdisplay, "mk", "/mksvg");
 osc.plug(setSVGdisplay, "rmv", "/rmvsvg");
 osc.plug(setSVGdisplay, "rmvall", "/rmvallsvg");
 
 /// PUT IN DRAW ///
 setSVGdisplay.drw();
 */


class SVGdisplay {
  // CONSTRUCTOR VARIALBES ////////////
  int ix;
  String name;
  float x, y, mxw, mxh;
  // CLASS VARIABLES //////////////////
  PShape svg;
  int svgnum;
  float scale;
  int drg = 0; //draw gate
  float w, h;
  // CONSTRUCTORS /////////////////////

  //// Constructor 1 //////////////////
  SVGdisplay(int aix, String aname, float ax, float ay) {
    ix = aix;
    name = aname;
    x = ax;
    y = ay;

    //set-up
    //if name exsists in svg list
    for (int i=0; i<svgnames.length; i++) {
      if ( name.equals(svgnames[i]) ) {
        svgnum = i; 
        svg = svgset[svgnum]; //get svg
        drg = 1; //open draw gate
        //Set w & h to original width & height
        w = svgwh[svgnum][0]; 
        h = svgwh[svgnum][1]; 
        scale = 1; 
        break;
      }
    }
  } //end constructor 1

  //// Constructor 2 - Designate max-width & max height //////////////////
  SVGdisplay(int aix, String aname, float ax, float ay, float amxw, float amxh) {
    ix = aix; 
    name = aname; 
    x = ax; 
    y = ay; 
    mxw = amxw; 
    mxh = amxh; 

    //set-up
    //if name exsists in svg list
    for (int i=0; i<svgnames.length; i++ ) {
      if ( name.equals(svgnames[i]) ) {
        svgnum = i; 
        svg = svgset[svgnum]; //get svg
        drg = 1; //open draw gate
        //Set w & h to original width & height
        w = svgwh[svgnum][0]; 
        h = svgwh[svgnum][1]; 
        //Calculate width & height and scale it
        float scalex = mxw/w; //width
        float scaley = mxh/h; //height
        scale = min(scalex, scaley); //take the smallest to scale both dimensions
        break;
      }
    }
  } //end constructor 1

  //  DRAW METHOD /////////////////////
  void drw() {
    if (drg==1) {
      shapeMode(CENTER); 
      shape(svg, x, y, w*scale, h*scale);
    }
  } //End drw
  //
} //End class

////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////
class SVGdisplaySet {
  ArrayList<SVGdisplay> cset = new ArrayList<SVGdisplay>(); 

  // Make Instance Method /////////////
  void mk(int ix, String name, float x, float y) {
    cset.add( new SVGdisplay(ix, name, x, y) ); 
    //  println(ix);
  } //end mk method

  // Make Instance Method /////////////
  void mksz(int ix, String name, float x, float y, float mxw, float mxh) {
    cset.add( new SVGdisplay(ix, name, x, y, mxw, mxh) );
  } //end mksz method

  // Remove Instance Method //////////
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      SVGdisplay inst = cset.get(i); 
      if (inst.ix == ix) {
        cset.remove(i); 
        break;
      }
    }
  } //End rmv method

  // Draw Set Method /////////////////
  void drw() {
    for (SVGdisplay inst : cset) inst.drw();
  }//end drw method

  // Draw Set Method /////////////////
  void dr(int ix, int m) {
    for (SVGdisplay inst : cset) {
      if(inst.ix == ix){
        inst.drg=m;
      }
    }
  }//end drw method
  //
} // END CLASS SET CLASS