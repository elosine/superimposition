// DECLARE/INITIALIZE CLASS SET
RhythmMkrSet setORhythmMkr = new RhythmMkrSet();


class RhythmMkr {
  // CONSTRUCTOR VARIALBES //
  int ix, tr;

  // CLASS VARIABLES //
  float[] dset = new float[0];
  float[] susset = new float[0]; //for sustaining notes
  float[][] pitch = new float[0][2];
  int dr = 0;
  float t0;

  // CONSTRUCTORS //
  RhythmMkr(int aix, int atr) {
    ix = aix;
    tr = atr;
    t0 = tr*trht;
  } //end constructor 1

  //  DRAW METHOD //
  void drw() {
    if (dr==1) {
      for (int i=0; i<dset.length; i++) {
        //Draw Sustained Notes
        if (susset[i] > 0) {
          noStroke();
          fill(255, 0, 128, 70);
          rect( dset[i]+x0, t0, susset[i], trht );
        }
        //draw lines
        strokeWeight(1);
        stroke(255, 0, 128);
        line( dset[i]+x0, t0, dset[i]+x0, t0+trht );

        //pitch lines
        stroke(255, 255, 0);
        strokeWeight(3);
        if (pitch.length == dset.length) { //make sure there are pitches in the pitch set
          //vertical lines
          line( dset[i]+x0, pitch[i][0], dset[i]+x0, pitch[i][1] );
          //horizontal lines
          //if ( i!=(dset.length-1) ) line( dset[i]+x0, pitch[i][0], dset[i+1]+x0, pitch[i+1][0] );
        }
      }
    }
  } //End drw

  //// PITCH ////
  void pitch(int mode, String args ) { //mode: number of pitch distribution strategy, see below; args: string, args delimited by colon for each strategy
    String[]argl = split(args, ':');
    pitch = new float[dset.length][2];


    switch(mode) {
      //Jumping around: range(in percentage of track height), tessatura-min, tessatura-max
    case 0:
      float rng = float(argl[0])*trht;
      float tmn = (float(argl[1])*trht)+t0;
      float tmx = (float(argl[2])*trht)+t0;
      float thf = (tmx-tmn)/2.0;
      float tb = t0+trht;
      for (int i=0; i<dset.length; i++) {
        float rt = random( 0.05*trht, rng); //minimum range is 0.5% of track
        if (i%2==0) { //if i is even, every other put in different half of tessatura
          float y1 = random(tmn, thf);
          float y2 = constrain(y1 + rt, t0, tb);
          pitch[i][0] = y1;
          pitch[i][1] = y2;
        } else { //if i is odd, put in a different half of the tessatura
          float y1 = random(thf, tmx);
          float y2 = constrain(y1-rt, t0, tb);
          pitch[i][0] = y1;
          pitch[i][1] = y2;
          println("y2: " + pitch[i][0]);
        }
      }
      break;
    }
  }

  //// SUSTAINED NOTES ////
  void mksus(int num) {
    int[] rn = new int[num];
    for (int i=0; i<susset.length; i++) susset[i]=0; //reset all sus to 0
    for (int i=0; i<rn.length; i++) rn[i] = floor(random(susset.length)); //choose rand members of susset to be sustained
    for (int i=0; i<rn.length; i++) { //change them to 1
      float mxw = dset[ rn[i]+1 ] - dset[ rn[i] ] - 3; //maximum width is pixels to next articulation
      susset[ rn[i] ] = random( mxw*0.333, mxw); //choose a length of sustained note between 1/3 of the distance to the entire distance to the next articulation
    }
  }

  // Make new set
  void alset(String al, int rhythmsetix) {
    float[] rset = new float[0];
    for (int i=setORhythmSetMkr.cset.size()-1; i>=0; i--) {
      RhythmSetMkr inst = setORhythmSetMkr.cset.get(i); 
      if (inst.ix == rhythmsetix) {
        rset = inst.dset;
      }
    }
    int[]st = new int[0];
    String[] als = split(al, ',');
    for (int i=0; i<als.length; i++) st = append( st, int(als[i]) ); //converts string set to integers
    dset = new float[0];
    int i = st[0];
    int ii = 1;
    while (i<rset.length) {
      dset = append(dset, rset[i]);
      susset = append(susset, 0);
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
      if (inst.ix == ix) inst.alset(al, rhythmsetix);
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

  // Make Sustained Notes //
  void mksus(int ix, int num) {
    for (int i=cset.size ()-1; i>=0; i--) {
      RhythmMkr inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.mksus(num);
      }
    }
  } //End method

  // Make Pitches //
  void mkpitch(int ix, int mode, String args) {
    for (int i=cset.size ()-1; i>=0; i--) {
      RhythmMkr inst = cset.get(i); 
      if (inst.ix == ix) {
        inst.pitch(mode, args);
      }
    }
  } //End method

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