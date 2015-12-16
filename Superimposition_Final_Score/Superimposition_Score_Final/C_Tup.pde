// DECLARE/INITIALIZE CLASS SET
TupSet setOTup = new TupSet();

class Tup {
  // CONSTRUCTOR VARIALBES //
  int ix;
  int nbts, div;
  float startbt, end;
  int nbts1, div1, nbts2, div2;
  float[] tset;
  int dr = 0;
  int tr = 0;

  // CLASS VARIABLES //

  // CONSTRUCTORS //
  Tup(int aix, int adiv, int anbts, float astartbt, float aend) {
    ix = aix;
    nbts = anbts;
    div = adiv;
    startbt = astartbt;
    end = aend;
    tset = tup1(nbts, div, startbt, end);
  } //end constructor 1
  
  Tup(int aix, int adiv1, int anbts1, int adiv2, int anbts2, float astartbt, float aend) {
    ix = aix;
    nbts1 = anbts1;
    div1 = adiv1;
    nbts2 = anbts2;
    div2 = adiv2;
    startbt = astartbt;
    end = aend;
    tset = tup2(nbts1, div1, nbts2, div2, startbt, end);
  } //end constructor 2
  
  //  DRAW METHOD //
  void drw() {
    if (dr==1) {
      strokeWeight(1);
      stroke(255, 0, 128);
      for (int i=0; i<tset.length; i++) {
        line( tset[i]+x0, tr*trht, tset[i]+x0, (tr*trht)+trht );
      }
    }
  } //End drw

}  //End class

//// CLASS SET CLASS ////
class TupSet {
  ArrayList<Tup> cset = new ArrayList<Tup>();

  // Make Instance Method //
  void mk1(int ix, int div, int nbts, float startbt, float end) {
    cset.add( new Tup(ix, div, nbts, startbt, end) );
  } //end mk method

  // Make Instance Method //
  void mk2(int ix, int div1, int nbts1, int div2, int nbts2, float startbt, float end) {
    cset.add( new Tup(ix, div1, nbts1, div2, nbts2, startbt, end) );
  } //end mk method

  // Draw Set Method //
  void drw() {
    for (int i=cset.size ()-1; i>=0; i--) {
      Tup inst = cset.get(i); 
      inst.drw();
    }
  } //end dr method

  // Toggle Draw //
  void drtog(int ix, int tr, int on) {
    for (int i=cset.size ()-1; i>=0; i--) {
      Tup inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.tr = tr;
        inst.dr = on;
      }
    }
  } //End drtog method

  // Remove Instance Method //
  void rmv(int ix) {
    for (int i=cset.size()-1; i>=0; i--) {
      Tup inst = cset.get(i);
      if (inst.ix == ix) {
        cset.remove(i);
        break;
      }
    }
  } //End rmv method
} //end class set class