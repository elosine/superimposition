// DECLARE/INITIALIZE CLASS SET
TupSet setOTup = new TupSet();

class Tup {
  // CONSTRUCTOR VARIALBES //
  int ix;
  int nbts, div;
  float startbt, end;
  int nbts1, div1, nbts2, div2;
  float[] tset;

  // CLASS VARIABLES //

  // CONSTRUCTORS //
  Tup(int aix, int anbts, int adiv, float astartbt, float aend) {
    ix = aix;
    nbts = anbts;
    div = adiv;
    startbt = astartbt;
    end = aend;
    tset = tup1(nbts, div, startbt, end);
  } //end constructor 1
  
  Tup(int aix, int anbts1, int adiv1, int anbts2, int adiv2, float astartbt, float aend) {
    ix = aix;
    nbts1 = anbts1;
    div1 = adiv1;
    nbts2 = anbts2;
    div2 = adiv2;
    startbt = astartbt;
    end = aend;
    tset = tup2(nbts1, div1, nbts2, div2, startbt, end);
  } //end constructor 2

}  //End class

//// CLASS SET CLASS ////
class TupSet {
  ArrayList<Tup> cset = new ArrayList<Tup>();

  // Make Instance Method //
  void mk1(int ix, int nbts, int div, float startbt, float end) {
    cset.add( new Tup(ix, nbts, div, startbt, end) );
  } //end mk method

  // Make Instance Method //
  void mk2(int ix, int nbts1, int div1, int nbts2, int div2, float startbt, float end) {
    cset.add( new Tup(ix, nbts1, div1, nbts2, div2, startbt, end) );
  } //end mk method

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

