// DECLARE/INITIALIZE CLASS SET
RmkrSet setORmkr = new RmkrSet();


class Rmkr {
  // CONSTRUCTOR VARIALBES //
  int ix, tr;

  // CLASS VARIABLES //
  float[] rset = new float[0];
  float[] dset= new float[0];
  int dr = 0;

  // CONSTRUCTORS //
  Rmkr(int aix, int atr) {
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

        for (int i=ist; i<=iend; i++) {
          rset = append(rset, tempset[i]);
        }
      }
    }
    dset = rset;
  } //End ad
  
  // Make new set
  void alset(String al){
    int[]st = new int[0];
    String[] als = split(al, ',');
    for(int i=0;i<als.length;i++) st = append( st, int(als[i]) );
    dset= new float[0];
    int i = st[0];
    int ii = 1;
    while(i<rset.length){
      dset = append(dset, rset[i]);
      i = i+st[ii%st.length];
      ii++;
    }
    println(dset);
    
  }
  ////
}  //End class

//// CLASS SET CLASS ////
class RmkrSet {
  ArrayList<Rmkr> cset = new ArrayList<Rmkr>(); 

  // Make Instance Method //
  void mk(int ix, int tr) {
    cset.add( new Rmkr(ix, tr) );
  } //end mk method

  // Draw Set Method //
  void drw() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Rmkr inst = cset.get(i); 
      inst.drw();
    }
  } //end dr method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Rmkr inst = cset.get(i); 
      if (inst.ix == ix) {
        cset.remove(i); 
        break;
      }
    }
  } //End rmv method

  // Remove Instance Method //
  void trk(int ix, int trx) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Rmkr inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.tr = trx;
      }
    }
  } //End rmv method

  // Toggle Draw //
  void drtog(int ix, int on) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Rmkr inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.dr = on;
      }
    }
  } //End drtog method

  // Add Rhythm //
  void ad(int ix, float st, float end, int tix) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Rmkr inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.ad(st, end, tix);
        // println(inst.rset);
      }
    }
  } //End ad method

  // Add Rhythm //
  void alset(int ix, String al) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Rmkr inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.alset(al);
      }
    }
  } //End ad method
} //end class set class

