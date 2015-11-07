// DECLARE/INITIALIZE CLASS SET
NotationDrawSet setNotationDraw = new NotationDrawSet();

/**
 /// PUT IN SETUP ///
 meosc.plug(setNotationDraw, "mk", "/mknewclass");
 meosc.plug(setNotationDraw, "rmv", "/rmvnewclass");
 
 /// PUT IN DRAW ///
 setNotationDraw.drw();
 **/

setSVGdisplay.mk(ixtmp, art, dset[ixxtmp], arty); //make articulation

class NotationDraw {

  // CONSTRUCTOR VARIALBES //
  int ix, ogix;
  int tr;
  // CLASS VARIABLES //
  float[] dset = new float[0];
  int[] pcset = new int[0];
  float[] susset = new float[0]; //for sustaining notes
  float[][] pitch = new float[0][2];
  int dr = 0;
  float t0, tb;
  int ogtr;

  float[][]dyn = new float[0][2];
  int[]artnums;
  float[] artys = new float[0];

  // CONSTRUCTORS //

  /// Constructor 1 ///
  NotationDraw(int aix, int aogix, int atr) {
    ix = aix;
    ogix = aogix;
    tr = atr;
    t0 = tr*trht;
    tb = t0+trht;
    setSVGdisplay.mk(ixtmp, art, dset[ixxtmp], arty); //make articulation
    (ogix - ogtr)*trht + artys[i]; //track y for articulations
  } //end constructor 1

  //  DRAW METHOD //


  //  DRAW METHOD //
  void drw() {
    if (dr==1) {
      for (int i=0; i<dset.length; i++) {

        //DRAW SUSTAINED NOTES
        if (susset.length == dset.length) { //make sure there are items in the sus  set
          if (susset[i] > 0) {
            noStroke();
            fill(255, 0, 128, 140);
            rect( dset[i]+x0, t0, susset[i], trht );
          }
        }

        //DRAW RHYTHM LINES
        strokeWeight(1);
        stroke(255, 0, 128);
        line( dset[i]+x0, t0, dset[i]+x0, tb );

        //DRAW PITCH LINES
        //Pitch Class Colors
        stroke(255, 255, 0);
        if (pcset.length == dset.length) {
          switch(pcset[i]) {
          case 0:
            stroke(255, 255, 0); //yellow open
            break;
          case 1:
            stroke(255, 119, 255); //fuchia messiaen mode 3 in F: F, G, A, B, C, C#, D#, E
            break;
          case 2:
            stroke(57, 255, 20); //neon green tone row B=0: D#, A#, C#, D, C, G#, E, F€, F, A, G, B
            break;
          case 3:
            stroke(0, 255, 239); //turquoise messiaen mode 5 in A: A, Bb, D, D#, E, G#
            break;
          case 4:
            stroke(253, 128, 0); //orange tetrachord 0124 on F#: F#, G, G#, Bb
            break;
          }
        }
        strokeWeight(3);
        if (pitch.length == dset.length) { //make sure there are pitches in the pitch set
          //vertical lines
          line( dset[i]+x0, pitch[i][0], dset[i]+x0, pitch[i][1] );
          //horizontal lines
          //if ( i!=(dset.length-1) ) line( dset[i]+x0, pitch[i][0], dset[i+1]+x0, pitch[i+1][0] );
        }
      }
    }
  } //End drw//// DRAW DYNAMICS & PITCH CLASS METHOD
  void drwdyn() {
    if (dr==1) {
      //DRAW DYNAMIC CURVES
      if (dyn.length > 0) {
        //fill(0, 255, 0, 180); 
        fill(120); 
        noStroke(); 
        beginShape(); 
        vertex(0, tb); //control pt
        vertex(0, tb); // start point
        vertex(0, dyn[0][1]); 
        for (int i=1; i<dyn.length; i++) {
          vertex(dyn[i][0], dyn[i][1]);
        }
        vertex( width, dyn[dyn.length-1][1] ); 
        vertex(width, tb); 
        vertex(width, tb); 
        endShape();
      }
    }
  } //end dynamics & pitch class

  void rmarts() {
    //Scan through saved articulation-maker index number
    for (int i=0; i<artnums.length; i++) setSVGdisplay.rmv(artnums[i]); //remove from SVGdisplay set
    artnums = new int[0]; //reset articulation numbers set
  }

  //
  //
}  //End class

////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////

class NotationDrawSet {
  ArrayList<NotationDraw> cset = new ArrayList<NotationDraw>();

  // Make Instance Method //
  void mk(int ix, int tr) {
    cset.add( new NotationDraw(ix, tr) );
  } //end mk method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      NotationDraw inst = cset.get(i); 
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method

  // Draw Set Method //
  void drw() {
    for (NotationDraw inst : cset) {
      inst.drw();
    }
  }//end drw method
  //
  //
} // END CLASS SET CLASS