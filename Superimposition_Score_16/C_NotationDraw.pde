// DECLARE/INITIALIZE CLASS SET
NotationDrawSet setNotationDraw = new NotationDrawSet();
/*********************/
class NotationDraw {
  // CONSTRUCTOR VARIALBES //
  int ix, ogix;
  int tr;
  // CLASS VARIABLES //
  float[] dset = new float[0];
  float[] susset = new float[0]; //for sustaining notes
  int dr = 0;
  float t0, tb;
  int ogtr;
  float trydif=0;
  float[][]dyn = new float[0][2];
  //Pitch
  int pitchset = 1;
  int pitchmode = 2;
  int artdens=0;
  // End Class Variables
  /// Constructor ////////////////////////////////////////////////////////////////////////////////////////////
  NotationDraw(int aix, int aogix, int atr) {
    ix = aix;
    ogix = aogix;
    tr = atr;
    t0 = tr*trht;
    tb = t0+trht;
    for (RhythmMkr inst : setORhythmMkr.cset) {
      if (inst.ix == ogix) { // Find Original Rhythm to Duplicate
        //Pitch
        pitchset = inst.pitchset;
        pitchmode = inst.pitchmode;
        artdens=inst.artdens;
        arts[tr].mode(inst.artmode);
        //// Get Rhythmic Partial Locations
        for (int i=0; i<inst.dset.length; i++) dset = append(dset, inst.dset[i]);       
        for (int i=0; i<inst.susset.length; i++) susset = append(susset, inst.susset[i]); 
        trydif = int(t0 - inst.t0);  //minus original track-y from this track-y to get y adjustment
        //Update dynamics array
        dyn = new float[inst.dyn.length][2];
        for (int i=0; i<dyn.length; i++) {
          dyn[i][0]= inst.dyn[i][0];
          dyn[i][1] = inst.dyn[i][1]+trydif;
        }
        break;
      } //end if (inst.ix == ogix)
    } //end for (RhythmMkr inst : setORhythmMkr.cset)
    dr = 1;
  } //end constructor
  //  DRAW METHOD //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void drw() {
    if (dr==1) { //drawgate
      for (int i=0; i<dset.length; i++) {
        //// All Items in the ForLoop Are Attached to Rhythmic Partials
        ////// DRAW SUSTAINED NOTES ///////////////////////////////////////////////////////////////////
        if (susset.length == dset.length) { //make sure there are items in the sus set
          if (susset[i] > 0) {
            noStroke();
            fill(255, 0, 128, 140);
            rectMode(CORNER);
            rect( dset[i]+x0, t0, susset[i], trht );
          } //end  if (susset[i] > 0) {
        } // end if (susset.length == dset.length)
        ////// DRAW RHYTHM LINES ////////////////////////////////////////////////////////////////////////////
        strokeWeight(1);
        stroke(255, 0, 128);
        line( dset[i]+x0, t0, dset[i]+x0, tb );
      } //end for (int i=0; i<dset.length; i++)
      ////// Pitch Set/Mode //////
      lines[tr][pitchmode][pitchset].drw();
      ////// Articulations //////
      if (artdens>0) {
        noStroke();
        rectMode(CORNER);
        switch(artdens) {
        case 1:
          fill(0, 255, 0);
          break;
        case 2:
          fill(255, 255, 0);
          break;
        case 3:
          fill(255, 0, 0);
          break;
        }
        rect(x0+160, t0+30, 50, 20, 4);
      }
    } //end  if (dr==1) { //drawgate
  } //End drw
  //// DRAW DYNAMICS METHOD //////////////////////////////////////////////////////////////////////////////
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
  } //end dynamics
  //
}  //End class

////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////

class NotationDrawSet {
  ArrayList<NotationDraw> cset = new ArrayList<NotationDraw>();

  // Make Instance Method //
  void mk(int ix, int ogix, int tr) {
    cset.add( new NotationDraw(ix, ogix, tr) );
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

  // Draw Dynamics Method //
  void drdyn() {
    for (NotationDraw inst : cset) {
      inst.drwdyn();
    }
  } //end dr method
  //
  //
} // END CLASS SET CLASS