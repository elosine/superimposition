// DECLARE/INITIALIZE CLASS SET
RhythmMkrSet setORhythmMkr = new RhythmMkrSet();
class RhythmMkr {
  // CONSTRUCTOR VARIALBES /////////////////////////////////////////
  int ix, tr;
  // CLASS VARIABLES /////////////////////////////////////////////
  float[] dset = new float[0];
  float[] susset = new float[0]; //for sustaining notes
  int dr = 0;
  float t0, tb;
  //dynamics
  int numdi = 7;
  float dymx, dmid, dinc;
  float[][]dyn = new float[0][2];
  float dynhpct = 0.3333;
  //Pitch
  int pitchset = 1;
  int pitchmode = 2;
  int artdens=0;
  String artmode="";
  // CONSTRUCTORS ///////////////////////////////////////////////////
  RhythmMkr(int aix, int atr) {
    ix = aix;
    tr = atr;
    t0 = tr*trht;
    tb = t0+trht;
    dymx = tb - (trht*dynhpct);
    dmid = tb - ((trht*dynhpct)/2.0);
    dinc = (trht*dynhpct)/numdi;
  } //end constructor /
  //  DRAW METHOD ///////////////////////////////////////////////////////////////////////////////////////////////////////
  void drw() {
    if (dr==1) { //drawgate
      //// PITCH SET/PITCH RANGE /////////////////////////////////////////////////////////////////////////////////////
      noStroke();
      ///////////////////////////////////////////////////////////////////////////////////////////////////////////
      //// ForLoop for all things attached to rhythmic partials
      for (int i=0; i<dset.length; i++) {
        //// DRAW SUSTAINED NOTES ////////////////////////////////////////////////////////////////////////////////////////
        if (susset.length == dset.length) { //make sure there are items in the sus  set
          if (susset[i] > 0) {
            noStroke();
            fill(255, 0, 128, 140);
            rectMode(CORNER);
            rect( dset[i]+x0, t0, susset[i], trht );
          } //end if (susset[i] > 0)
        } //end if (susset.length == dset.length)
        //// DRAW RHYTHM LINES ///////////////////////////////////////////////////////////////////////////////////////////
        strokeWeight(1);
        stroke(255, 0, 128);
        line( dset[i]+x0, t0, dset[i]+x0, tb );
      } //end  for (int i=0; i<dset.length; i++)
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
    } // end if (dr==1) { //drawgate
  } //End drw
  // MAKE NEW SET OF RHYTHMS FUNCTION /////////////////////////////////////////////////////////////////////////////
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
    int ixx = st[0]; 
    int ii = 1; 
    while (ixx<rset.length) {
      dset = append(dset, rset[ixx]); 
      ixx = ixx+st[ii%st.length]; 
      ii++;
    }
  }//end alset function
  //// SUSTAINED NOTES FUNCTION ///////////////////////////////////////////////////////////////////////////////////////
  void mksus(int num) {
    int[] rn = new int[0];
    //Make sure the total requested sustained partials does not exceed the available partials
    if (num>dset.length) rn = new int[dset.length];
    else rn = new int[num];
    int[] ixstmp = new int[dset.length]; //temp array of available index numbers
    for (int i=0; i<ixstmp.length; i++) ixstmp[i] = i; //fill temp array with corresponding indexes
    susset = new float[dset.length];
    for (int i=0; i<susset.length; i++) susset[i]=0; //reset all sus to 0
    //Choose partials to be sustained
    for (int i=0; i<rn.length; i++) {
      int rntmp = ixstmp[ floor(random(ixstmp.length)) ]; //choose a random partial to be sustained, ixstmp holds all available index numbers
      rn[i] = rntmp; //store in the sustained notes array
      for (int j=0; j<ixstmp.length; j++) if (ixstmp[j]==rntmp) ixstmp = rmArrayIx_int(ixstmp, j);//remove from available set so no repeats
    }

    for (int i=0; i<rn.length; i++) { 
      float mxw = 0.0;
      if ( rn[i]==(dset.length-1) ) mxw = width - dset[ rn[i] ]-3; //if one of the chosen sustained notes is the last partial
      else mxw = dset[ rn[i]+1 ] - dset[ rn[i] ]-3; //maximum width is pixels to next articulation
      susset[ rn[i] ] = random( mxw*0.333, mxw); //choose a length of sustained note between 1/3 of the distance to the entire distance to the next articulation
    }
  } //end sustained notes function

  //// MAKE DYNAMICS ////////////////////////////
  void mkdyn(int dmode, String args) { 
    String[]ar = split(args, ':');
    float initdy = tb-(int(ar[0])*dinc); //initial dynamic y
    //Args applicable to all modes
    int njs = int(ar[1]);
    int mninc = int(ar[2]);
    int mxinc = int(ar[3]);
    float mnlen;
    float mxlen;
    float mxbtwn;
    float mxsppx; //maximum space between crescendi in pixels
    float mnlenpxtm; //minimum length of crescendo in pixels
    float mxlenpxtm; //maximum length of crescendo in pixels
    float mnhtpxtm; //minimum height of crescendo in pixels
    float mxhtpxtm; //minimum height of crescendo in pixels
    float[]tmpx, tmpy;
    float pxtm;
    float divtm;
    int maxparttmp; //1 for initial dynamic, 3 vertices for each crescendo, -1 vertex because last crescendo does not drop back down to initial dynamic
    float initxtmp;
    //Calculate height of 1st crescendo
    float htm ;
    //Calculate length of 1st crescendo
    float cltmp;
    float hpratio;
    switch(dmode) {
      //Dynamic Jumps
      //init dynamic, num jumps, min num of inc, max num of inc
    case 0:
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
      mnlen = float(ar[4]);
      mxlen = float(ar[5]);
      mxbtwn = float(ar[6]);
      mxsppx = mxbtwn*btw; //maximum space between crescendi in pixels
      mnlenpxtm = mnlen*btw; //minimum length of crescendo in pixels
      mxlenpxtm = mxlen*btw; //maximum length of crescendo in pixels
      mnhtpxtm = mninc*dinc; //minimum height of crescendo in pixels
      mxhtpxtm = mxinc*dinc; //minimum height of crescendo in pixels

      //Temp arrays to hold values because cannot append dyn which is a 2d array
      tmpx = new float[0];
      tmpy = new float[0];
      //maximum length of temp array for max num of crescendi
      maxparttmp = 1+(njs*2); //1 for initial dynamic, 2 vertices for each crescendo

      pxtm = 0.0; //pixel counter for while below
      //initial dynamic @ x=0
      tmpx = append( tmpx, 0);
      tmpy = append( tmpy, initdy );

      //find initial x for first crescendo
      //divide track in to numcresc sections
      divtm = width/njs;
      //randomly select from 1st section
      initxtmp = random(divtm);
      tmpx = append( tmpx, initxtmp);
      tmpy = append( tmpy, initdy );
      pxtm = initxtmp; //update pxtm

      //Calculate height of 1st crescendo
      htm = initdy-random(mnhtpxtm, mxhtpxtm);
      //Calculate length of 1st crescendo
      cltmp = random(mnlenpxtm, mxlenpxtm) + pxtm;
      tmpx = append( tmpx, cltmp );
      pxtm = cltmp; //update pxtm
      tmpy = append( tmpy, htm ); //store 2nd crescendo point

      //Draw as many crescendos as you can within parameters, while?
      //choose starting ending & y
      while (pxtm<width) {
        if ( (tmpx.length-1) >= maxparttmp) break; //if maximum number of crescendi has been reached break loop
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
        htm = initdy - random(mnhtpxtm, mxhtpxtm);
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
      //Create and populate dyn array
      dyn = new float[tmpx.length][2];
      for (int i=0; i<tmpx.length; i++) {
        dyn[i][0] = tmpx[i];
        dyn[i][1] = tmpy[i];
      }
      break;

      //Decrescendos
      //init dynamic, max num cres, min num of inc, max num of inc, min length-beats, max length-beats, max beats between cres
    case 2:
      mnlen = float(ar[4]);
      mxlen = float(ar[5]);
      mxbtwn = float(ar[6]);
      mxsppx = mxbtwn*btw; //maximum space between crescendi in pixels
      mnlenpxtm = mnlen*btw; //minimum length of crescendo in pixels
      mxlenpxtm = mxlen*btw; //maximum length of crescendo in pixels
      mnhtpxtm = mninc*dinc; //minimum height of crescendo in pixels
      mxhtpxtm = mxinc*dinc; //minimum height of crescendo in pixels

      //Temp arrays to hold values because cannot append dyn which is a 2d array
      tmpx = new float[0];
      tmpy = new float[0];
      //maximum length of temp array for max num of crescendi
      maxparttmp = 1+(njs*2); //1 for initial dynamic, 2 vertices for each crescendo

      pxtm = 0.0; //pixel counter for while below
      //initial dynamic @ x=0
      tmpx = append( tmpx, 0);
      tmpy = append( tmpy, initdy );

      //find initial x for first crescendo
      //divide track in to numcresc sections
      divtm = width/njs;
      //randomly select from 1st section
      initxtmp = random(divtm);
      tmpx = append( tmpx, initxtmp);
      tmpy = append( tmpy, initdy );
      pxtm = initxtmp; //update pxtm

      //Calculate height of 1st crescendo
      htm = initdy+random(mnhtpxtm, mxhtpxtm);
      //Calculate length of 1st crescendo
      cltmp = random(mnlenpxtm, mxlenpxtm) + pxtm;
      tmpx = append( tmpx, cltmp );
      pxtm = cltmp; //update pxtm
      tmpy = append( tmpy, htm ); //store 2nd crescendo point

      //Draw as many crescendos as you can within parameters, while?
      //choose starting ending & y
      while (pxtm<width) {
        if ( (tmpx.length-1) >= maxparttmp) break; //if maximum number of crescendi has been reached break loop
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
        htm = initdy + random(mnhtpxtm, mxhtpxtm);
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
      //Create and populate dyn array
      dyn = new float[tmpx.length][2];
      for (int i=0; i<tmpx.length; i++) {
        dyn[i][0] = tmpx[i];
        dyn[i][1] = tmpy[i];
      }
      break;

      //Hairpins
      //init dynamic, max num cres, min num of inc, max num of inc, min length-beats, max length-beats, max beats between cres, ratio in percentage
    case 3:
      mnlen = float(ar[4]);
      mxlen = float(ar[5]);
      mxbtwn = float(ar[6]);
      hpratio = float(ar[7]);
      mxsppx = mxbtwn*btw; //maximum space between crescendi in pixels
      mnlenpxtm = mnlen*btw; //minimum length of crescendo in pixels
      mxlenpxtm = mxlen*btw; //maximum length of crescendo in pixels
      mnhtpxtm = mninc*dinc; //minimum height of crescendo in pixels
      mxhtpxtm = mxinc*dinc; //minimum height of crescendo in pixels

      //Temp arrays to hold values because cannot append dyn which is a 2d array
      tmpx = new float[0];
      tmpy = new float[0];
      //maximum length of temp array for max num of crescendi
      maxparttmp = 1+(njs*2); //1 for initial dynamic, 2 vertices for each crescendo

      pxtm = 0.0; //pixel counter for while below
      //initial dynamic @ x=0
      tmpx = append( tmpx, 0);
      tmpy = append( tmpy, initdy );

      //find initial x for first crescendo
      //divide track in to numcresc sections
      divtm = width/njs;
      //randomly select from 1st section
      initxtmp = random(divtm);
      tmpx = append( tmpx, initxtmp);
      tmpy = append( tmpy, initdy );
      pxtm = initxtmp; //update pxtm

      //Calculate height of 1st crescendo
      htm = initdy-random(mnhtpxtm, mxhtpxtm);
      //Calculate length of 1st crescendo
      float hplentmp = random(mnlenpxtm, mxlenpxtm);
      cltmp = (hplentmp*hpratio) + pxtm; 
      tmpx = append( tmpx, cltmp );
      pxtm = cltmp; //update pxtm
      tmpy = append( tmpy, htm ); //store 2nd crescendo point
      //Calculate length of 1st decrescendo
      cltmp = ( hplentmp*(1.0-hpratio) ) + pxtm; 
      tmpx = append( tmpx, cltmp );
      pxtm = cltmp; //update pxtm
      tmpy = append( tmpy, initdy ); //store 2nd crescendo point

      //Draw as many crescendos as you can within parameters, while?
      //choose starting ending & y
      while (pxtm<width) {
        if ( (tmpx.length-1) >= maxparttmp) break; //if maximum number of crescendi has been reached break loop
        //Calculate space between crescendos
        float sptmp = random(mxsppx) + pxtm;
        if (sptmp>=width)break; //Stop loop if the beginning of the next cres is outside of track
        //begin next cres
        tmpx = append( tmpx, sptmp ); 
        tmpy = append( tmpy, initdy );  
        pxtm = sptmp; //update pxtm
        //Calculate height of  crescendo
        htm = initdy-random(mnhtpxtm, mxhtpxtm);
        //Calculate length of  crescendo
        hplentmp = random(mnlenpxtm, mxlenpxtm);
        cltmp = (hplentmp*hpratio) + pxtm; 
        if (cltmp>=width) {
          tmpx = append( tmpx, width );
          tmpy = append( tmpy, htm ); //store 2nd crescendo point
          break;
        }
        tmpx = append( tmpx, cltmp );
        pxtm = cltmp; //update pxtm
        tmpy = append( tmpy, htm ); //store 2nd crescendo point
        //Calculate length of  decrescendo
        cltmp = ( hplentmp*(1.0-hpratio) ) + pxtm;  
        if (cltmp>=width) {
          tmpx = append( tmpx, width );
          tmpy = append( tmpy, initdy ); //store 2nd crescendo point
          break;
        }
        tmpx = append( tmpx, cltmp );
        pxtm = cltmp; //update pxtm
        tmpy = append( tmpy, initdy ); //store 2nd crescendo point
      }
      //Create and populate dyn array
      dyn = new float[tmpx.length][2];
      for (int i=0; i<tmpx.length; i++) {
        dyn[i][0] = tmpx[i];
        dyn[i][1] = tmpy[i];
      }
      break;
    }
  } //end dynamics & pitch class
  //// DRAW DYNAMICS ///////////////////////////////////////////////////////////////////////////////////////////////
  void drwdyn() {
    if (dr==1) {
      //DRAW DYNAMIC CURVES
      if (dyn.length > 0) {
        //fill(0, 255, 0, 180); 
        fill(120); 
        noStroke(); 
        beginShape(); 
        vertex(x0, tb); //control pt
        vertex(x0, tb); // start point
        vertex(x0, dyn[0][1]); 
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
      if (inst.ix == ix) {
        inst.alset(al, rhythmsetix); 
        break;
      }
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
        inst.t0 = inst.tr*trht;
        inst.tb = inst.t0+trht;
        inst.dr = on;
        inst.dymx = inst.tb - (trht*inst.dynhpct);
        inst.dmid = inst.tb - ((trht*inst.dynhpct)/2.0);
        inst.dinc = (trht*inst.dynhpct)/inst.numdi;
      }
    }
  } //End drtog method
  // Clear All //
  void clear() {
    for (RhythmMkr inst : cset) inst.dr = 0;
  } //End method
  // Make Sustained Notes //
  void mksus(int ix, int num) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.mksus(num);
      }
    }
  } //End method
  // Make Dynamics //
  void mkdyn(int ix, int dmode, String args) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.mkdyn(dmode, args);
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
  // Change Pitch //
  void pitch(int ix, int mode, int set) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.pitchmode = mode;
        inst.pitchset = set;
      }
    }
  } //End ad method
  // Change Articulations //
  void art(int ix, String mode, int dens) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        arts[inst.tr].mode(mode);
        inst.artmode = mode;
        inst.artdens = dens;
      }
    }
  } //End ad method
  //
} //end class set class