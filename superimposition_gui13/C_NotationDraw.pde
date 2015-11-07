// DECLARE/INITIALIZE CLASS SET
NotationDrawSet setNotationDraw = new NotationDrawSet();

/**
 /// PUT IN SETUP ///
 meosc.plug(setNotationDraw, "mk", "/mknewclass");
 meosc.plug(setNotationDraw, "rmv", "/rmvnewclass");
 
 /// PUT IN DRAW ///
 setNotationDraw.drw();
 **/


class NotationDraw {

  // CONSTRUCTOR VARIALBES //
  int ix;
  // CLASS VARIABLES //

  // CONSTRUCTORS //

  /// Constructor 1 ///
  NotationDraw(int aix) {
    ix = aix;
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
  } //End drw
  //
  //
}  //End class

////////////////////////////////////////////////////////////
/////////////   CLASS SET     //////////////////////////////
////////////////////////////////////////////////////////////

class NotationDrawSet {
  ArrayList<NotationDraw> cset = new ArrayList<NotationDraw>();

  // Make Instance Method //
  void mk(int ix) {
    cset.add( new NotationDraw(ix) );
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