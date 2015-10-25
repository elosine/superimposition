// DECLARE/INITIALIZE CLASS SET
RhythmMkrSet setORhythmMkr = new RhythmMkrSet();


class RhythmMkr {
  // CONSTRUCTOR VARIALBES //
  int ix, tr;

  // CLASS VARIABLES //
  float[] dset= new float[0];
  int dr = 0;

  // CONSTRUCTORS //
  RhythmMkr(int aix, int atr) {
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
  
  // Make new set
  void alset(String al, int rhythmsetix){
    float[] rset = new float[0];
    for (int i=setORhythmSetMkr.cset.size()-1; i>=0; i--) {
      RhythmSetMkr inst = setORhythmSetMkr.cset.get(i); 
      if (inst.ix == rhythmsetix) {
        rset = inst.dset;
      }
    }
    int[]st = new int[0];
    String[] als = split(al, ',');
    for(int i=0;i<als.length;i++) st = append( st, int(als[i]) ); //converts string set to integers
    dset= new float[0];
    int i = st[0];
    int ii = 1;
    while(i<rset.length){
      println(i);
      dset = append(dset, rset[i]);
      i = i+st[ii%st.length];
      ii++;
    }
   // println(dset);
    
  }
  ////
}  //End class

//// CLASS SET CLASS ////
class RhythmMkrSet {
  ArrayList<RhythmMkr> cset = new ArrayList<RhythmMkr>(); 

  // Make Instance Method //
  void mk(int ix, int tr, String al, int rhythmsetix) {
    cset.add( new RhythmMkr(ix, tr) );
    for (int i=cset.size()-1; i>=0; i--) {
      RhythmMkr inst = cset.get(i); 
      if(inst.ix == ix) inst.alset(al, rhythmsetix);
      break;
    }  
  } //end mk method

  // Draw Set Method //
  void drw() {
    for (int i=cset.size ()-1; i>=0; i--) {
      RhythmMkr inst = cset.get(i); 
      inst.drw();
    }
  } //end dr method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      RhythmMkr inst = cset.get(i); 
      if (inst.ix == ix) {
        cset.remove(i); 
        break;
      }
    }
  } //End rmv method

  // Toggle Draw //
  void drtog(int ix, int tr, int on) {
    for (int i=cset.size ()-1; i>=0; i--) {
      RhythmMkr inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.tr = tr;
        inst.dr = on;
      }
    }
  } //End drtog method

  // Add Rhythm //
  void alset(int ix, String al, int rhythmsetix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      RhythmMkr inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.alset(al, rhythmsetix);
      }
    }
  } //End ad method
} //end class set class