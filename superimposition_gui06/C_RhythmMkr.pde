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
  float t0, tb;
  //dynamics
  int numdi = 7;
  float dymx, dmid, dinc;
  float[][]dyn = new float[0][2];

  // CONSTRUCTORS //
  RhythmMkr(int aix, int atr) {
    ix = aix;
    tr = atr;
    t0 = tr*trht;
    tb = t0+trht;

    dymx = tb - (trht*0.3333);
    dmid = tb - ((trht*0.3333)/2.0);
    dinc = (trht*0.3333)/numdi;
  } //end constructor 1

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

  //// PITCH FUNCTION ////
  void pitch(int mode, String args ) { //mode: number of pitch distribution strategy, see below; args: string, args delimited by colon for each strategy
    String[]argl = split(args, ':');
    pitch = new float[dset.length][2];
    float rng = float(argl[0])*trht;
    float tmn = (float(argl[1])*trht)+t0;
    float tmx = (float(argl[2])*trht)+t0;
    float th = tmx-tmn;
    float thf = (th/2.0)+tmn;

    switch(mode) {
      //Jumping around: range(in percentage of track height), tessatura-min, tessatura-max
      //Repeated notes by small tessatura range
    case 0:
      for (int i=0; i<dset.length; i++) {
        //float rt = random( 0.05*trht, rng); //minimum range is 0.5% of track
        if (i%2==0) { //if i is even, every other put in different half of tessatura
          float y1 = random(tmn, thf);
          float y2 = constrain(y1 + rng, t0, tb);
          pitch[i][0] = y1;
          pitch[i][1] = y2;
        } 
        //
        else { //if i is odd, put in a different half of the tessatura
          float y1 = random(thf, tmx);
          //check to see if it has enough space at botttom for the range
          if ( y1 > (tb-rng) ) y1=tb-rng;
          else y1 = random(thf, tmx);
          float y2 = constrain( y1+rng, t0, tb );
          pitch[i][0] = y1;
          pitch[i][1] = y2;
        }
      }
      break;

      //Ascending & Descending - range, tessatura-min, tessatura-max, init direction, rate-by-numpart
    case 1:
      int ratet = int( argl[4] );
      float inct = th/ratet;
      int dir = int( argl[3] ); //start ascending; 1 is descending, but 3 lines down the direction changes
      for (int i=0; i<dset.length; i++) {
        int irt = i%ratet;
        if ( irt == 0 ) dir = dir * -1; //change direction every rate-by-numpart
        if ( dir == -1 ) { // if ascending
          float y1 = tmx + (inct*irt*dir);
          if ( y1 < (t0+rng) ) y1=t0+rng;//check to see if it has enough space at top for range
          float y2 = y1 - rng;
          pitch[i][0] = y1;
          pitch[i][1] = y2;
        }
        //
        else { //if descending
          float y1 = tmn + (inct*irt*dir);
          if ( y1 > (tb-rng) ) y1=tb-rng;//check to see if it has enough space at bottom for range
          float y2 = y1 + rng;
          pitch[i][0] = y1;
          pitch[i][1] = y2;
        }
      }
      break;

      //random w/random range
      //range, tessatura-min, tessatura-max
    case 2:
      for (int i=0; i<dset.length; i++) {
        float rt = random( 0.05*trht, rng); //minimum range is 0.5% of track
        float y1 = random(tmn, tmx);
        if ( y1 > (tmx-rt) ) y1=tmx-rt;
        else if ( y1 < (t0+rt) ) y1=t0+rt;
        float y2 = y1 + rt;
        pitch[i][0] = y1;
        pitch[i][1] = y2;
      }
      break;

      //random w/outliers
      //range, tessatura-min, tessatura-max, outlier-min-numpart, outlier-max-numpart
    case 3:
      int mnpt = int( argl[3] );
      int mxpt = int( argl[4] );
      int npt = round( random(mnpt, mxpt) ); //number of partials to next outlier
      int npixt = 0;//counter for next outlier
      for (int i=0; i<dset.length; i++) {
        npixt++;
        //outliers
        if ( npixt%npt == 0 && npixt!=0 ) {
          //flip coin for above tessatura-min or below tessatura-max
          int cft = floor(random(2));
          //check if there is room below and above tessatura
          if ( (t0+rng) > tmn ) cft = 1; 
          else if ( (tb-rng) < tmx ) cft = 0;
          if (cft==0) { //above tessatura-min
            float y1 = random(t0, (tmn/2));
            float y2 = y1+rng;
            pitch[i][0] = y1;
            pitch[i][1] = y2;
          }
          if (cft==1) { //below tessatura-max
            float y1 = random( tmx+((tb-tmx)/2), tb );
            if ( y1>(tb-rng) ) y1 = tb-rng;
            float y2 = y1+rng;
            pitch[i][0] = y1;
            pitch[i][1] = y2;
          }
          npt = round( random(mnpt, mxpt) ); //get new number of partials before next outlier
          npixt = 0;
          println(npt);
        }
        //
        else {
          float y1 = random(tmn, tmx);
          if ( y1 > (tmx-rng) ) y1=tmx-rng;
          else if ( y1 < (t0+rng) ) y1=t0+rng;
          float y2 = y1 + rng;
          pitch[i][0] = y1;
          pitch[i][1] = y2;
        }
      }
      break;
    }
  } //end pitch function

  //// SUSTAINED NOTES FUNCTION ////
  void mksus(int num) {
    int[] rn = new int[num];
    susset = new float[dset.length];
    for (int i=0; i<susset.length; i++) susset[i]=0; //reset all sus to 0
    for (int i=0; i<rn.length; i++) rn[i] = floor(random(susset.length)); //choose rand members of susset to be sustained
    for (int i=0; i<rn.length; i++) { //change them to 1
      float mxw = dset[ rn[i]+1 ] - dset[ rn[i] ] - 3; //maximum width is pixels to next articulation
      susset[ rn[i] ] = random( mxw*0.333, mxw); //choose a length of sustained note between 1/3 of the distance to the entire distance to the next articulation
    }
  } //end sustained notes function

  //// MAKE DYNAMICS & PITCH CLASS METHOD ////////////////////////////
  void mkdyn(int dmode, int pmode, String args) { 
    String[]ar = split(args, ':');
    float initdy = tb-(int(ar[0])*dinc);

    switch(dmode) {
      //Dynamic Jumps
      //init dynamic, num jumps, min num of inc, max num of inc
    case 0:
      int njs = int(ar[1]);
      int mninc = int(ar[2]);
      int mxinc = int(ar[3]);
      int dirtmp = 1;
      int dinctmp = 1;
      //set up dynamics array
      dyn = new float[1+(njs*2)][2]; //+1 for initial dynamic, and 2 per jump
      //Generate Xs
      dyn[0][0] = 0.0; //x = 0 for initial dynamic
      float seclentmp = width/njs; //length in px of each equally divided section
      for (int i=0; i<njs; i++) {
        float vtmp = round( random( i*seclentmp, (i*seclentmp)+seclentmp ) );
        dyn[dinctmp][0] = vtmp;
        dyn[dinctmp+1][0] = vtmp; //2 for each jump to achieve vertical jump
        dinctmp = dinctmp+2;
      }
      //Generate Ys
      dyn[0][1] = initdy; //initial dynamic
      // dyn[1][1] = initdy; //first jump will have vertex at initial dynamic first then another at jump height
      //every other starting at 1 will populate starting vertex and jumped to vertex
      for (int i=1; i<dyn.length; i++) {
        //calc jump increment
        int jinc = constrain( round(random(mninc, mxinc)), 1, numdi ); //constrain to between 1 and max number of dynamic increments
        //determine direction to jump based on if above or below the midline
        float curry = dyn[i-1][1];
        if (curry>=dmid) dirtmp = -1;
        else dirtmp = 1;
        float jy = (dinc*jinc*dirtmp)+curry; //calculate new y after jump
        if (jy>(tb-dinc)) jy=tb-dinc; //if jump goes below lowest dynamic then make it lowest dynamic
        if (jy<dymx) jy = dymx;//or above highest
        if (i%2==0)dyn[i][1] = jy;
        else dyn[i][1] = curry; //2 for each jump for vertical jump
      }
      break;

      //crescendos
      //init dynamic, max num cres, min num of inc, max num of inc, min length-beats, max length-beats, max beats between cres
    case 1:
      int njs = int(ar[1]);
      int mninc = int(ar[2]);
      int mxinc = int(ar[3]);
      int mnlen = int(ar[4]);
      int mxlen = int(ar[5]);
      int mxbtwn = int(ar[6]);
      float mxsppx = mxbtwn*btw;
      float mnlenpxtm = mnlen*btw;
      float mxlenpxtm = mxlen*btw;

      //Temp arrays to hold values because cannot append dyn which is a 2d array
      float[]tmpx = new float[0];
      float[]tmpy = new float[0];

      float pxtm = 0.0; //pixel counter for while below
      int itm = 0; //index for dyn array

      //find initial x for first crescendo
      //divide track in to numcresc sections
      float divtm = width/njs;
      //randomly select from 1st section
      float initxtmp = random(divtm);
      tmpx = append( tmpx, initxtmp);
      tmpy = append( tmpy, initdy );
      pxtm = initxtmp; //update pxtm

      //Calculate height of 1st crescendo
      float htm = random(mninc, mxinc)+initdy;
      //Calculate length of 1st crescendo
      float cltmp = random(mnlenpxtm, mxlenpxtm) + pxtm;
      tmpx = append( tmpx, cltmp );
      pxtm = cltmp; //update pxtm
      tmpy = append( tmpy, htm ); //store 2nd crescendo point

      //Draw as many crescendos as you can within parameters, while?
      //choose starting ending & y
      while (pxtm<width) {
        //Calculate space between crescendos
        float sptmp = random(mxsppx) + pxtm;
        if (sptmp>=width)break; //Stop loop if the beginning of the next cres is outside of track
        //point to jump down from to begin next cres
        tmpx = append( tmpx, sptmp ); 
        tmpy = append( tmpy, htm );  //last y
        pxtm = sptmp; //update pxtm
        //Jump down to 1st point of next cres
        tmpx = append( tmpx, sptmp ); //same x
        tmpy = append( tmpy, initdy );  //init y
        //Calculate length of crescendo
        cltmp = random(mnlenpxtm, mxlenpxtm) + pxtm;
        //Calculate height of crescendo
        htm = random(mninc, mxinc)+initdy;
        //Stop loop if the end of the next cres is outside of track
        //make last point x=width, y=height of crescendo, IOW - shorten last crescendo ending on end of track
        if (cltmp>=width) {
          tmpx = append( tmpx, width ); 
          tmpy = append( tmpy, htm );
          break;
        }
        //Otherwise make crescendo pt 2
        tmpx = append( tmpx, cltmp ); 
        tmpy = append( tmpy, htm );
        pxtm = cltmp; //update pxtm
      }




      //set up initial dynamic
      float intdyntmp =  tb - (idy*dinc);
      //calculate which partials to begin & end crescendo
      //divide track in to numcresc sections
      float divtmp = width/njs;
      //find first partial outside of 1st section
      for (int i=0; i<dset.length; i++) {
        if (dset[i]>divtmp) cres1p[0] = floor(random(i)); //grab one of the partials in the first section
        break;
      }
      //loop through number of crescendos
      for (int i=0; i<njs; i++) {
        //calculate length of crescendo
        //calculate which pixel to crescendo to
        float cresendpx = (round(random(mnlen, mxlen))*btw)+dset[p1tmp]; //which pixel to crescendo to: choose between min/max length in beats of crescendo * width of beat in pixels add current x
        //find 1st partial past this point
        int p2tmp; //partial to end first crescendo
        for (int i=0; i<dset.length; i++) {
          if (dset[i]>cresendpx) p2tmp = i-1; 
          break;
        }
      }






      //size of dynamics array
      dyn = new float[dset.length+1+njs][2]; //+1 for initial dynamic, and 1 extra per cres to make a vertical jump on that partial
      int[]jumps = new int[njs];
      int npart = round(dset.length/njs);
      for (int i=0; i<njs; i++) {
        jumps[i] = floor( random( i*npart, (i*npart)+npart ) );
      }
      //loop through partials, 2nd loop to see if they are the chosen partials
      for (int i=0; i<dset.length; i++) { 
        //create a vertex on current partial at current y
        dyn[ixt][0] = dset[i];
        dyn[ixt][1] = curry; //keep current y
        ixt++; //increment dyn index
        for (int j : jumps) {
          if ( i==j ) {
            //get cres inc
            int jinc = constrain( round(random(mninc, mxinc)), 1, numdi ); //constrain to between 1 and max number of dynamic increments
            //Which partial to cresendo to
            float cresendpx = (round(random(mnlen, mxlen))*btw)+dset[i]; //which pixel to crescendo to: choose between min/max length in beats of crescendo * width of beat in pixels add current x
            float cxtmp = dset[i];


            //determine direction to jump based on if above or below the midline
            if (curry>=dmid) dirt = -1;
            else dirt = 1;
            float jy = (dinc*jinc*dirt)+ curry; //calculate new y after jump
            if (jy>(tb-dinc)) jy=tb-dinc; //if jump goes below lowest dynamic then make it lowest dynamic
            if (jy<dymx) jy = dymx;//or above highest
            // println("dinc: " + dinc +" - " + "jinc: " + jinc +" - " + "y: " + jy +" - "+"curry: " + curry);
            dyn[ixt][0] = dset[i]; //jump to x (same)
            dyn[ixt][1] = jy; //jump to y
            ixt++; //advance dyn increment
            curry = jy; //update current y
          }
        }
      }
      break;
      */
    }
  } //end dynamics & pitch class


  //// DRAW DYNAMICS & PITCH CLASS METHOD
  void drwdyn() {
    if (dr==1) {
      //DRAW DYNAMIC CURVES & PITCH SET COLORS
      if (dyn.length > 0) {
        fill(0, 255, 0, 180); 
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

  // MAKE NEW SET OF RHYTHMS FUNCTION
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
      i = i+st[ii%st.length]; 
      ii++;
    }
  }
  ////
}  //End class


//////////////////////////////////////////////////////////
//// CLASS SET CLASS /////////////////////////////////////
//////////////////////////////////////////////////////////
class RhythmMkrSet {
  ArrayList<RhythmMkr> cset = new ArrayList<RhythmMkr>(); 

  // Make Instance Method //
  void mk(int ix, int tr, String al, int rhythmsetix) {
    cset.add( new RhythmMkr(ix, tr) ); 
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) inst.alset(al, rhythmsetix); 
      break;
    }
  } //end mk method

  // Draw Set Method //
  void drw() {
    for (RhythmMkr inst : cset) {
      inst.drw();
    }
  } //end dr method

  // Draw Dynamics Method //
  void drdyn() {
    for (RhythmMkr inst : cset) {
      inst.drwdyn();
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
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.tr = tr; 
        inst.dr = on;
      }
    }
  } //End drtog method

  // Make Sustained Notes //
  void mksus(int ix, int num) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.mksus(num);
      }
    }
  } //End method

  // Make Pitches //
  void mkpitch(int ix, int mode, String args) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.pitch(mode, args);
      }
    }
  } //End method

  // Make Dynamics //
  void mkdyn(int ix, int dmode, int pmode, String args) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.mkdyn(dmode, pmode, args);
      }
    }
  } //End method

  // Remove Pitches //
  void rmpitch(int ix) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.pitch = new float[0][2];
      }
    }
  } //End method

  // Add Rhythm //
  void alset(int ix, String al, int rhythmsetix) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.alset(al, rhythmsetix);
      }
    }
  } //End ad method
} //end class set class