// DECLARE/INITIALIZE CLASS SET
RhythmSetMkrSet setORhythmSetMkr = new RhythmSetMkrSet();


class RhythmSetMkr {
  // CONSTRUCTOR VARIALBES //
  int ix, tr;

  // CLASS VARIABLES //
  float[] rset = new float[0];
  float[] dset= new float[0];
  int dr = 0;

  // CONSTRUCTORS //
  RhythmSetMkr(int aix, int atr) {
    ix = aix;
    tr = atr;
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
    if (dr==1) {
      strokeWeight(1);
      stroke(255, 0, 128);
      for (int i=0; i<dset.length; i++) {
        line( dset[i]+x0, tr*trht, dset[i]+x0, (tr*trht)+trht );
      }
    }
  } //End drw

  //  Add rhythm //
  void ad(float st, float end, int tix) {
    float[] tempset; 
    int ist=0;
    int iend=0; 
    for (int j=setOTup.cset.size ()-1; j>=0; j--) {
      Tup inst = setOTup.cset.get(j);
      if (inst.ix == tix) {
        tempset = inst.tset; 
        
        //compare the tuplet set to add with the existing rhythm set to remove duplicates
        for(int i=0;i<dset.length;i++){
          for(int k=0;k<tempset.length;k++){
            if( round(dset[i])==round(tempset[k]) ) tempset = rmArrayIx_float(tempset, k);
          }
        }
        //get beginning and end partials of the tuplet set that will fit into the track
        for (int i=0; i<tempset.length; i++) {
          if (tempset[i]>=(st*btw)) {
            ist = i; 
            break;
          }
        }
        for (int i=0; i<tempset.length; i++) {
          if (tempset[i]>(end*btw)) {
            iend = i-1; 
            break;
          }
          //
          else if (i==tempset.length-1) {
            iend=i;
          }
        }
        ///add partials from the tuplet to the rhythm set
        for (int i=ist; i<=iend; i++) {
          rset = append(rset, round(tempset[i]));
        }
      }
    }
    rset = sort(rset);
    dset = rset;
  } //End ad
  
  ////
}  //End class

//// CLASS SET CLASS ////
class RhythmSetMkrSet {
  ArrayList<RhythmSetMkr> cset = new ArrayList<RhythmSetMkr>(); 

  // Make Instance Method //
  void mk(int ix, int tr) {
    cset.add( new RhythmSetMkr(ix, tr) );
    //println("rhythmset ix:" + ix);
  } //end mk method

  // Draw Set Method //
  void drw() {
    for (int i=cset.size ()-1; i>=0; i--) {
      RhythmSetMkr inst = cset.get(i); 
      inst.drw();
    }
  } //end dr method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      RhythmSetMkr inst = cset.get(i); 
      if (inst.ix == ix) {
        cset.remove(i); 
        break;
      }
    }
  } //End rmv method

  // Toggle Draw //
  void drtog(int ix, int tr, int on) {
    for (int i=cset.size ()-1; i>=0; i--) {
      RhythmSetMkr inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.tr = tr;
        inst.dr = on;
      }
    }
  } //End drtog method

  // Add Rhythm //
  void ad(int ix, float st, float end, int tix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      RhythmSetMkr inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.ad(st, end, tix);
        // println(inst.rset);
      }
    }
  } //End ad method

} //end class set class