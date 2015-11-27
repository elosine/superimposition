// DECLARE/INITIALIZE CLASS SET
RhythmMkrSet setORhythmMkr = new RhythmMkrSet();


class RhythmMkr {
  // CONSTRUCTOR VARIALBES //
  int ix, tr;

  // CLASS VARIABLES //
  float[] dset = new float[0];
  int[] pcset = new int[0];
  float[] susset = new float[0]; //for sustaining notes
  float[][] pitch = new float[0][2];
  int dr = 0;
  float t0, tb;
  //dynamics
  int numdi = 7;
  float dymx, dmid, dinc;
  float[][]dyn = new float[0][2];
  float dynhpct = 0.3333;
  float[] artys = new float[0];
  PShape[][] svgsetL;
  PShape[][] svgset_clone;
  int[][] svggates;

  // CONSTRUCTORS //
  RhythmMkr(int aix, int atr) {
    ix = aix;
    tr = atr;
    t0 = tr*trht;
    tb = t0+trht;

    dymx = tb - (trht*dynhpct);
    dmid = tb - ((trht*dynhpct)/2.0);
    dinc = (trht*dynhpct)/numdi;
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
        //Pitch Class Colors
        stroke(255, 255, 0);
        if (pcset.length == dset.length) {
          switch(pcset[i]) {
          case 0:
            stroke(255, 255, 0); //yellow open
            break;
          case 1:
            stroke(255, 119, 255); //fuchia messiaen mode 3 in F: F, G, A, B, C, C#, D#, E
            break;
          case 2:
            stroke(57, 255, 20); //neon green tone row B=0: D#, A#, C#, D, C, G#, E, F€, F, A, G, B
            break;
          case 3:
            stroke(0, 255, 239); //turquoise messiaen mode 5 in A: A, Bb, D, D#, E, G#
            break;
          case 4:
            stroke(253, 128, 0); //orange tetrachord 0124 on F#: F#, G, G#, Bb
            break;
          }
        }
        //PITCH LINES
        strokeWeight(3);
        if (pitch.length == dset.length) { //make sure there are pitches in the pitch set
          //vertical lines
          line( dset[i]+x0, pitch[i][0], dset[i]+x0, pitch[i][1] );
          //horizontal lines
          //if ( i!=(dset.length-1) ) line( dset[i]+x0, pitch[i][0], dset[i+1]+x0, pitch[i+1][0] );
        }
        //ARTICULATIONS
        shapeMode(CENTER);
        for (int j=0; j<svgset.length; j++) if (svggates[i][j]==1) shape(svgsetL[i][j], dset[i], artys[i]);
      }
    }
  } //End drw

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
    int ixx = st[0]; 
    int ii = 1; 
    while (ixx<rset.length) {
      dset = append(dset, rset[ixx]); 
      ixx = ixx+st[ii%st.length]; 
      ii++;
    }

    //Load new articulations enough for each partial to have its own
    svgsetL = new PShape[dset.length][svgset.length];
    svgset_clone = new PShape[dset.length][svgset.length];
    svggates = new int[dset.length][svgset.length];
    artys = new float[dset.length];
    for (int i=0; i<artys.length; i++)artys[i] = t0 + (trht/2.0);
    for (int i=0; i<dset.length; i++) {
      for (int j=0; j<svgset.length; j++) {
        svgsetL[i][j] = loadShape(svgfolder.listFiles()[j].getPath());
        svgset_clone[i][j] = loadShape(svgfolder.listFiles()[j].getPath());
        svggates[i][j] = 0;
      }
    }
    //println("svgset: " + svgsetL.length + "svggates: " + svggates.length +
  }//end alset

  //// PITCH SET METHOD ////
  void mkpitchset(int numchgs, String pitchsets) { 
    pcset = new int[dset.length];
    int pcsinc = 0;
    //Make int array of pitch sets to include
    String[]pcsst = split(pitchsets, ':');
    int[]pcs = new int[pcsst.length];
    for (int i=0; i<pcsst.length; i++) pcs[i] = int(pcsst[i]);
    pcs = shuffleIntArray(pcs); //shuffle pitchclasses
    int partperchg = round(dset.length/numchgs); //divide available partials by numchanges to distribute changes
    //Generate set of partials to change on
    int[]parttemp = new int[numchgs];
    for (int i=0; i<numchgs; i++)parttemp[i] = round( random( partperchg*i, (partperchg*i)+partperchg ) );
    // If one of the rhythm partials matches the chosen pitch change partials, make the change
    for (int i=0; i<pcset.length; i++) {
      pcset[i] = pcs[pcsinc%pcs.length]; //set the pitch class to one of the available pitch classes
      for (int j=0; j<parttemp.length; j++) {
        if (i == parttemp[j]) {
          pcsinc++;
          pcset[i] = pcs[pcsinc%pcs.length]; //set the pitch class to one of the available pitch classes
        }
      }
    }
  }
  ///////////////////////////////////////////////////////////////////////////////
  //// ARTICULATION METHOD ////  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  void mkarticul(int numart, int numsusart, String artset, String sartset) {
    //reset gates for all articulations to 0/off
    for (int i=0; i<dset.length; i++) for (int j=0; j<svgset.length; j++) svggates[i][j] = 0;
    int[]suses = new int[0];
    String[]arts = split(artset, ':'); //make set of available articulations
    String[]susarts = split(sartset, ':'); //make set of available articulations
    arts = shuffleStrArray(arts);
    susarts = shuffleStrArray(susarts);
    int[] artnumL = new int[arts.length];
    int[] susartnumL = new int[susarts.length];
    //get svg numbers for articulation names
    for (int i=0; i<arts.length; i++) for (int j=0; j<svgnames.length; j++) if (arts[i].equals(svgnames[j])) artnumL[i] = j;
    for (int i=0; i<susarts.length; i++) for (int j=0; j<svgnames.length; j++) if (susarts[i].equals(svgnames[j])) susartnumL[i] = j;

    int[] nonsusixs = new int[dset.length];//make set of available index numbers
    for (int i=0; i<nonsusixs.length; i++) nonsusixs[i]=i;
    //find out which notes are sustaining notes
    for (int i=0; i<susset.length; i++) if (susset[i]>0) suses = append(suses, i); //make array of indexes of sustaining notes
    suses = shuffleIntArray(suses); //shuffle sustaining partials

    //take out sustaining partials from available partials to non sustaining articulations
    for (int j=0; j<suses.length; j++) {
      for (int i=0; i<nonsusixs.length; i++) {
        if (nonsusixs[i]==suses[j])//non sustaining articulations should not be placed on sustaining partials
          if (nonsusixs.length>0)  nonsusixs = rmArrayIx_int(nonsusixs, i);
      }
    }

    //Make Non Sustaining Articulations
    //Check that there are not more articulations than partials
    if (numart>nonsusixs.length)numart=nonsusixs.length;
    for (int i=0; i<numart; i++) {
      //Only make articulations if there are rhythms available
      if (nonsusixs.length>0) {
        int ixxxtmp = floor( random(nonsusixs.length) );
        int ixxtmp = nonsusixs[ixxxtmp]; //choose a partial to place an articulation
        nonsusixs = rmArrayIx_int(nonsusixs, ixxxtmp);
        int art = artnumL[i%artnumL.length]; //choose an articulation from the set
        //add articulation to svg set
        if (dset.length>0 && pitch.length==dset.length) { //only make if there are rhythms and pitches
          //see if pitch is too close to top or bottom and position articulation acordingly
          float arty = pitch[ixxtmp][0]-16;
          //if ( !art.equals("multi.svg") ) { //multiphonic notation is special case
          if ( (arty-25)<t0 ) arty = pitch[ixxtmp][1]+16;//if pitch is too close to top move articulation to bottom of pitch range
          if ( (arty-25)<t0 && (pitch[ixxtmp][1]+25)>tb ) arty = t0+(trht*0.3333)-16; //if pitch range is too large so that there is no room at bottom either, move articulation to just above the 1/3 track point
          // }
          svggates[ixxtmp][art] = 1;
          artys[ixxtmp] = arty;
        }
      }
    }

    //Make Sustaining Articulations
    //Check that there are not more articulations than partials
    if (numsusart>suses.length)numsusart=suses.length;
    for (int i=0; i<numsusart; i++) {
      //Only make articulations if there are rhythms available
      if (suses.length>0) {
        int ixxxtmp = floor( random(suses.length) );
        int ixxtmp = suses[ ixxxtmp ]; //choose a partial to place an articulation
        suses = rmArrayIx_int(suses, ixxxtmp);
        int art = susartnumL[i%susartnumL.length]; //choose an articulation from the set
        //add articulation to svg set
        if (dset.length>0 && pitch.length==dset.length) { //only make if there are rhythms and pitches
          //see if pitch is too close to top or bottom and position articulation acordingly
          float arty = pitch[ixxtmp][0]-16;
          // if ( !art.equals("multi.svg") ) { //multiphonic notation is special case
          if ( (arty-25)<t0 ) arty = pitch[ixxtmp][1]+16;//if pitch is too close to top move articulation to bottom of pitch range
          if ( (arty-25)<t0 && (pitch[ixxtmp][1]+25)>tb ) arty = t0+(trht*0.3333)-16; //if pitch range is too large so that there is no room at bottom either, move articulation to just above the 1/3 track point
          // }
          svggates[ixxtmp][art] = 1;
          artys[ixxtmp] = arty;
        }
      }
    }
  }

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////
  //// PITCH FUNCTION ////  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
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


  //// DRAW DYNAMICS & PITCH CLASS METHOD
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
  void mkdyn(int ix, int dmode, String args) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.mkdyn(dmode, args);
      }
    }
  } //End method

  // Make Pitch Class Sets //
  void mkpitchset(int ix, int numchgs, String pitchsets) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.mkpitchset(numchgs, pitchsets);
      }
    }
  } //End method

  // Make Articulations //
  void mkart(int ix, int numart, int numsusart, String artset, String sartset) {
    for (RhythmMkr inst : cset) {
      if (inst.ix == ix) {
        inst.mkarticul(numart, numsusart, artset, sartset);
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