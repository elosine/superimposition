void score(int sys) {
  switch(sys) {
    ////2 systems :30 INITIAL RHYTHMS WITH OPEN PITCH - Med-Sparce Density
  case 0:
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    break;
  case 1:
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    break;

    ////2 systems :30 - PITCH CONTOUR WITH OPEN PITCH Compressed range w/outliers & open pitch
  case 2:
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    osc.send("/mkpitch", new Object[]{2, 3, "0.05:0.4:0.6:2:4"}, me);
    osc.send("/mkpitch", new Object[]{9, 3, "0.05:0.4:0.6:2:4"}, me);
    break;
  case 3:
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    osc.send("/mkpitch", new Object[]{1002, 3, "0.05:0.4:0.6:2:4"}, me);
    osc.send("/mkpitch", new Object[]{1009, 3, "0.05:0.4:0.6:2:4"}, me);
    break;
    //3a - 2 systems :30 ADD SUSTAINED NOTES
  case 4:
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    osc.send("/mksus", new Object[]{2, 5}, me);
    osc.send("/mksus", new Object[]{9, 3}, me);
    break;
  case 5:
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    osc.send("/mksus", new Object[]{1009, 4}, me);
    osc.send("/mksus", new Object[]{1002, 2}, me);
    break;
    //4a - 2 systems :30 CHANGE PITCH CONTOUR
  case 6:
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    osc.send("/mkpitch", new Object[]{2, 0, "0.05:0.1:0.9"}, me);
    osc.send("/mkpitch", new Object[]{9, 0, "0.05:0.1:0.9"}, me);
    break;   
  case 7:
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    osc.send("/mkpitch", new Object[]{1009, 0, "0.05:0.1:0.9"}, me);
    osc.send("/mkpitch", new Object[]{1002, 0, "0.05:0.1:0.9"}, me);
    break;
    //5a - 4 systems 1:00 DYNAMICS
  case 8:
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    osc.send("/mkdyn", new Object[]{2, 0, "2:15:1:7"}, me);
    osc.send("/mkdyn", new Object[]{9, 0, "2:17:1:7"}, me);
    break;
  case 9:
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    osc.send("/mkdyn", new Object[]{1009, 0, "2:13:1:7"}, me);
    osc.send("/mkdyn", new Object[]{1002, 0, "2:18:1:7"}, me);
    break;
    //6a - 2 systems :30-PITCH SETS
  case 10:
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    osc.send("/mkpitchset", new Object[]{2, 1, "1:3"}, me);
    osc.send("/mkpitchset", new Object[]{9, 1, "1:3"}, me);
    break;
  case 11:
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    osc.send("/mkpitchset", new Object[]{1009, 1, "2:4"}, me);
    osc.send("/mkpitchset", new Object[]{1002, 1, "2:4"}, me);
    break;
    //7a - 4 systems 1:00 - ARTICULATIONS
  case 12:
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    osc.send("/mkart", new Object[]{2, 3, 2, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "trill.svg"}, me);
    osc.send("/mkart", new Object[]{9, 3, 2, "trill.svg:Bartok_pizz.svg:accent.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
  case 13:
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    osc.send("/mkart", new Object[]{1009, 4, 2, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg"}, me);
    osc.send("/mkart", new Object[]{1002, 4, 2, "trill.svg:Bartok_pizz.svg:accent.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
    //SECTION II - Change 2 things every 4 systems x4 - 5:00
    //8 - System 1 - turn off section 1 turn on section 2 rhythms
  case 14:
    osc.send("/drh", new Object[]{2, 0, 0}, me);
    osc.send("/drh", new Object[]{9, 1, 0}, me);
    //turn on section 2
    osc.send("/drh", new Object[]{7, 0, 1}, me);
    osc.send("/drh", new Object[]{8, 1, 1}, me);
    //make pitches
    osc.send("/mkpitch", new Object[]{7, 2, "0.33:0.1:0.9"}, me);
    osc.send("/mkpitch", new Object[]{8, 2, "0.33:0.1:0.9"}, me);
    //choose pitch set
    String ps1 = str(chooseInt(new int[]{1, 2, 3, 4}));
    String ps2 = str(chooseInt(new int[]{1, 2, 3, 4}));
    osc.send("/mkpitchset", new Object[]{7, 1, ps1}, me);
    osc.send("/mkpitchset", new Object[]{8, 1, ps2}, me);
    //Make Crescendos
    osc.send("/mkdyn", new Object[]{7, 1, "1:5:4:6:2.0:5.0:3.0"}, me);
    osc.send("/mkdyn", new Object[]{8, 1, "1:5:4:6:1.0:4.0:1.5"}, me);
    //Sustained Notes
    osc.send("/mksus", new Object[]{7, 7}, me);
    osc.send("/mksus", new Object[]{8, 7}, me);
    //Articulations
    osc.send("/mkart", new Object[]{7, 4, 2, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg"}, me);
    osc.send("/mkart", new Object[]{8, 4, 2, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
  case 15:
    osc.send("/drh", new Object[]{1009, 2, 0}, me);
    osc.send("/drh", new Object[]{1002, 3, 0}, me);
    //turn on section 2
    osc.send("/drh", new Object[]{3, 2, 1}, me);
    osc.send("/drh", new Object[]{0, 3, 1}, me);
    //make pitches
    osc.send("/mkpitch", new Object[]{3, 2, "0.33:0.1:0.9"}, me);
    osc.send("/mkpitch", new Object[]{0, 2, "0.33:0.1:0.9"}, me);
    //choose pitch set
    String ps3 = str(chooseInt(new int[]{1, 2, 3, 4}));
    String ps4 = str(chooseInt(new int[]{1, 2, 3, 4}));
    osc.send("/mkpitchset", new Object[]{3, 1, ps3}, me);
    osc.send("/mkpitchset", new Object[]{0, 1, ps4}, me);
    //Dynamics
    osc.send("/mkdyn", new Object[]{3, 1, "1:7:4:7:1.0:3.0:0.5"}, me);
    osc.send("/mkdyn", new Object[]{0, 1, "1:4:4:6:3.0:7.0:2.0"}, me);
    //Sustained Notes
    osc.send("/mksus", new Object[]{3, 5}, me);
    osc.send("/mksus", new Object[]{0, 6}, me);
    //Articulations
    osc.send("/mkart", new Object[]{3, 3, 2, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    osc.send("/mkart", new Object[]{8, 4, 2, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);   
    break;

    //9 - Change 1: pitch sets, dynamics
  case 16:
    String ps5 = str(chooseInt(new int[]{1, 2, 3, 4}));
    String ps6 = str(chooseInt(new int[]{1, 2, 3, 4}));
    osc.send("/mkpitchset", new Object[]{7, 2, ps5}, me);
    osc.send("/mkpitchset", new Object[]{8, 2, ps6}, me);
    //Dynamics - Hairpins
    osc.send("/mkdyn", new Object[]{7, 3, "4:4:6:6:2.0:3.75:4.0:0.7"}, me);
    osc.send("/mkdyn", new Object[]{8, 3, "3:4:6:6:2.0:3.75:4.0:0.7"}, me);
    break;

  case 17:
    String ps7 = str(chooseInt(new int[]{1, 2, 3, 4}));
    String ps8 = str(chooseInt(new int[]{1, 2, 3, 4}));
    osc.send("/mkpitchset", new Object[]{3, 2, ps7}, me);
    osc.send("/mkpitchset", new Object[]{0, 2, ps8}, me);
    //Dynamics - Abrupt Changes
    osc.send("/mkdyn", new Object[]{3, 0, "5:11:3:7"}, me);
    osc.send("/mkdyn", new Object[]{0, 0, "3:13:3:7"}, me);
    break;

    //10 - Change 2: pitch distribution(up/down), sustained notes, articulations 
    //Pitch Contour(up/down)

  case 18:
    osc.send("/mkpitch", new Object[]{7, 1, "0.05:0.0:1.0:-1.0:8"}, me);
    osc.send("/mkpitch", new Object[]{8, 1, "0.05:0.0:1.0:-1.0:5"}, me);
    //Sustained Notes(more)
    osc.send("/mksus", new Object[]{7, 15}, me);
    osc.send("/mksus", new Object[]{8, 11}, me);
    //Change Articulations
    osc.send("/mkart", new Object[]{7, 4, 4, "tongueslap.svg", "multi.svg"}, me);
    osc.send("/mkart", new Object[]{8, 4, 2, "tongueslap.svg:Bartok_pizz.svg", "accent.svg"}, me);
    break;

  case 19:
    //System 2 - Pitch Contour(up/down)
    osc.send("/mkpitch", new Object[]{ 3, 1, "0.05:0.0:1.0:-1.0:8"}, me);
    osc.send("/mkpitch", new Object[]{0, 1, "0.05:0.0:1.0:-1.0:5"}, me);
    //Sustained Notes(more)
    osc.send("/mksus", new Object[]{ 3, 15}, me);
    osc.send("/mksus", new Object[]{0, 11}, me);
    //Change Articulations
    osc.send("/mkart", new Object[]{3, 4, 4, "tongueslap.svg", "multi.svg"}, me);
    osc.send("/mkart", new Object[]{0, 4, 2, "tongueslap.svg:Bartok_pizz.svg", "accent.svg"}, me);
    break;

    //11 - Change 3: pitch set(more), pitch distribution(random) //System 1 //Pitch Set
  case 20:
    String ps9 = str(chooseInt(new int[]{1, 2, 3, 4}));
    String ps10 = str(chooseInt(new int[]{1, 2, 3, 4}));
    osc.send("/mkpitchset", new Object[]{7, 3, ps9}, me);
    osc.send("/mkpitchset", new Object[]{8, 3, ps10}, me);
    osc.send("/mkpitch", new Object[]{7, 3, "0.05:0.3:0.5:3:7"}, me);
    osc.send("/mkpitch", new Object[]{8, 3, "0.05:0.3:0.5:3:7"}, me);
    break;
  case 21:
    String ps11 = str(chooseInt(new int[]{1, 2, 3, 4}));
    String ps12 = str(chooseInt(new int[]{1, 2, 3, 4}));
    osc.send("/mkpitchset", new Object[]{3, 3, ps11}, me);
    osc.send("/mkpitchset", new Object[]{0, 3, ps12}, me);
    osc.send("/mkpitch", new Object[]{3, 3, "0.05:0.3:0.5:3:7"}, me);
    osc.send("/mkpitch", new Object[]{0, 3, "0.05:0.3:0.5:3:7"}, me);
    break;
  case 22:
    //12 - Change 4: dynamics(smooth,5), pitch contour, articulations, pitch set //System 1 //Dynamics - Smooth
    osc.send("/mkdyn", new Object[]{7, 0, "3:1:0:0"}, me);
    osc.send("/mkdyn", new Object[]{8, 0, "3:1:0:0"}, me);
    //Pitch Contour
    osc.send("/mkpitch", new Object[]{7, 0, "0.05:0.2:0.8"}, me);
    osc.send("/mkpitch", new Object[]{8, 0, "0.05:0.2:0.8"}, me);
    //Sustained Notes(more)
    osc.send("/mksus", new Object[]{7, 7}, me);
    osc.send("/mksus", new Object[]{8, 7}, me);
    //Articulations
    osc.send("/mkart", new Object[]{7, 6, 4, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    osc.send("/mkart", new Object[]{8, 9, 2, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    //Pitch Set
    osc.send("/mkpitchset", new Object[]{7, 2, "1:2:3:4"}, me);
    osc.send("/mkpitchset", new Object[]{8, 2, "1:2:3:4"}, me);
    break;
  case 23:
    //System 2//Dynamics - Smooth
    osc.send("/mkdyn", new Object[]{ 3, 0, "5:1:0:0"}, me);
    osc.send("/mkdyn", new Object[]{0, 0, "3:1:0:0"}, me);
    //Pitch Contour
    osc.send("/mkpitch", new Object[]{3, 0, "0.05:0.2:0.8"}, me);
    osc.send("/mkpitch", new Object[]{0, 0, "0.05:0.2:0.8"}, me);
    //Sustained Notes(more)
    osc.send("/mksus", new Object[]{3, 7}, me);
    osc.send("/mksus", new Object[]{0, 7}, me);
    //Articulations
    osc.send("/mkart", new Object[]{3, 6, 4, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    osc.send("/mkart", new Object[]{0, 9, 2, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    //Pitch Set
    osc.send("/mkpitchset", new Object[]{3, 2, "1:2:3:4"}, me);
    osc.send("/mkpitchset", new Object[]{0, 2, "1:2:3:4"}, me);
    break;  
  case 24: 
    //SECTION III - UNISONS AND SUSTAINED NOTES, 3 PAGES 1:30 //sparce rhythm, several sustains, a few articulations, smooth dynamics, pitch range w/outliers, single pitch class - 4 rhythm sets, repeat 2 everything else same - 9, 2, generate 2 more //13 - System 1
    osc.send("/drh", new Object[]{7, 0, 0}, me);
    osc.send("/drh", new Object[]{8, 1, 0}, me);
    osc.send("/drh", new Object[]{10, 0, 1}, me);
    osc.send("/mksus", new Object[]{10, 3}, me);
    osc.send("/mkpitch", new Object[]{10, 3, "0.05:0.35:0.55:2:5"}, me);
    osc.send("/mkpitchset", new Object[]{10, 1, "2"}, me);
    osc.send("/mkdyn", new Object[]{10, 3, "1:3:6:6:7.0:9.0:0.5:0.5"}, me);
    osc.send("/mkart", new Object[]{10, 2, 0, "accent.svg:tongueslap.svg", "trill.svg"}, me);
    osc.send("/mknotedrw", new Object[]{0, 10, 1}, me);
    break;
  case 25://System 2
    osc.send("/drh", new Object[]{3, 2, 0}, me);
    osc.send("/drh", new Object[]{0, 3, 0}, me);
    osc.send("/drh", new Object[]{2, 2, 1}, me);
    osc.send("/mksus", new Object[]{2, 3}, me);
    osc.send("/mkpitch", new Object[]{2, 3, "0.05:0.35:0.55:2:5"}, me);
    osc.send("/mkpitchset", new Object[]{2, 1, "2"}, me);
    osc.send("/mkdyn", new Object[]{2, 3, "1:3:6:6:7.0:9.0:0.5:0.5"}, me);
    osc.send("/mkart", new Object[]{2, 2, 0, "accent.svg:tongueslap.svg", "trill.svg"}, me);
    osc.send("/mknotedrw", new Object[]{1, 2, 3}, me);
    break;
  case 26://14 - System 1 off
    osc.send("/rmvnotedrw", new Object[]{0}, me);
    osc.send("/drh", new Object[]{10, 0, 0}, me);
    //14 - System 1
    osc.send("/drh", new Object[]{9, 0, 1}, me);
    osc.send("/mksus", new Object[]{9, 3}, me);
    osc.send("/mkpitch", new Object[]{9, 3, "0.05:0.35:0.55:2:5"}, me);
    osc.send("/mkpitchset", new Object[]{9, 1, "1"}, me);
    osc.send("/mkdyn", new Object[]{9, 3, "1:4:6:6:6.0:10.0:0.5:0.6"}, me);
    osc.send("/mkart", new Object[]{9, 2, 1, "accent.svg:tongueslap.svg", "trill.svg"}, me);
    osc.send("/mknotedrw", new Object[]{2, 9, 1}, me);
    break;
  case 27: //System 2 - off
    osc.send("/rmvnotedrw", new Object[]{1}, me);
    osc.send("/drh", new Object[]{2, 2, 0}, me);
    //System 2
    osc.send("/drh", new Object[]{11, 2, 1}, me);
    osc.send("/mksus", new Object[]{11, 5}, me);
    osc.send("/mkpitch", new Object[]{11, 1, "0.08:0.0:1.0:-1:7"}, me);
    osc.send("/mkpitchset", new Object[]{11, 2, "1"}, me);
    osc.send("/mkdyn", new Object[]{11, 1, "1:4:2:6:4.0:6.0:1.0"}, me);
    osc.send("/mkart", new Object[]{11, 2, 3, "accent.svg:tongueslap.svg", "trill.svg"}, me);
    osc.send("/mknotedrw", new Object[]{3, 11, 3}, me);
    break;
  case 28:
    //15 - System 1 - off
    osc.send("/rmvnotedrw", new Object[]{2}, me);
    osc.send("/drh", new Object[]{9, 0, 0}, me);
    //15 - System 1
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/mksus", new Object[]{2, 4}, me);
    osc.send("/mkpitch", new Object[]{2, 3, "0.05:0.35:0.55:2:5"}, me);
    osc.send("/mkpitchset", new Object[]{2, 1, "3"}, me);
    osc.send("/mkdyn", new Object[]{2, 3, "1:3:6:6:7.0:9.0:0.5:0.5"}, me);
    osc.send("/mkart", new Object[]{2, 5, 4, "accent.svg:tongueslap.svg", "trill.svg:multi.svg"}, me);
    osc.send("/mknotedrw", new Object[]{4, 2, 1}, me);
    break;
  case 29: 
    //System 2 - off
    osc.send("/rmvnotedrw", new Object[]{3}, me);
    osc.send("/drh", new Object[]{11, 2, 0}, me);
    //System 2
    osc.send("/drh", new Object[]{9, 2, 1}, me);
    osc.send("/mksus", new Object[]{9, 4}, me);
    osc.send("/mkpitch", new Object[]{9, 3, "0.05:0.35:0.55:2:5"}, me);
    osc.send("/mkpitchset", new Object[]{9, 1, "3"}, me);
    osc.send("/mkdyn", new Object[]{9, 3, "1:3:6:6:7.0:9.0:0.5:0.5"}, me);
    osc.send("/mkart", new Object[]{9, 5, 4, "accent.svg:tongueslap.svg", "trill.svg:multi.svg"}, me);
    osc.send("/mknotedrw", new Object[]{5, 9, 3}, me);
    break;
  case 30:
    osc.send("/drh", new Object[]{2, 0, 0}, me);
    osc.send("/rmarts", new Object[]{2}, me);
    osc.send("/rmvnotedrw", new Object[]{4}, me);
    //IV - 1, system 1, Track 1
    osc.send("/drh", new Object[]{0, 0, 1}, me);
    osc.send("/mksus", new Object[]{0, 4}, me);
    osc.send("/mkpitch", new Object[]{0, 0, "0.05:0.0:1.0"}, me);
    osc.send("/mkpitchset", new Object[]{0, 1, "4"}, me);
    osc.send("/mkdyn", new Object[]{0, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{0, 7, 2, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    //SECTION IV - DENSE RHYTHMS, CHANGES EVERY SYSTEM, 4 PAGES 2:00 //make 8, 1 system formations, go through the different possibilities; 
    //IV - 1, system 1, Track 1 off
    //IV - 1, system 1, Track 2
    osc.send("/drh", new Object[]{1, 1, 1}, me);
    osc.send("/mksus", new Object[]{1, 4}, me);
    osc.send("/mkpitch", new Object[]{1, 0, "0.05:0.0:1.0"}, me);
    osc.send("/mkpitchset", new Object[]{1, 1, "4"}, me);
    osc.send("/mkdyn", new Object[]{1, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{1, 6, 2, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
  case 31:

    //IV - 2, system 2, Track 1 - off
    osc.send("/drh", new Object[]{ 9, 2, 0}, me);
    osc.send("/rmarts", new Object[]{9}, me);
    osc.send("/rmvnotedrw", new Object[]{5}, me);
    //IV - 2, system 2, Track 1
    osc.send("/drh", new Object[]{2, 2, 1}, me);
    osc.send("/mksus", new Object[]{2, 1}, me);
    osc.send("/mkpitch", new Object[]{2, 1, "0.08:0.0:1.0:-1:7"}, me);
    osc.send("/mkpitchset", new Object[]{2, 1, "1"}, me);
    osc.send("/mkdyn", new Object[]{2, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{2, 5, 1, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    //IV - 2, system 2, Track 2
    osc.send("/drh", new Object[]{3, 3, 1}, me);
    osc.send("/mksus", new Object[]{3, 1}, me);
    osc.send("/mkpitch", new Object[]{3, 1, "0.08:0.0:1.0:-1:7"}, me);
    osc.send("/mkpitchset", new Object[]{3, 1, "1"}, me);
    osc.send("/mkdyn", new Object[]{3, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{3, 4, 1, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
  case 32:
    //IV - 3, system 1, Track 1 - off
    osc.send("/drh", new Object[]{0, 0, 0}, me);
    osc.send("/rmarts", new Object[]{0}, me);
    osc.send("/drh", new Object[]{1, 1, 0}, me);
    osc.send("/rmarts", new Object[]{1}, me);
    //IV - 3, system 1, Track 1
    osc.send("/drh", new Object[]{4, 0, 1}, me);
    osc.send("/mksus", new Object[]{4, 3}, me);
    osc.send("/mkpitch", new Object[]{4, 2, "0.25:0.2:0.8"}, me);
    osc.send("/mkpitchset", new Object[]{4, 1, "2"}, me);
    osc.send("/mkdyn", new Object[]{4, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{4, 3, 1, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    //IV - 3, system 1, Track 2
    osc.send("/drh", new Object[]{5, 1, 1}, me);
    osc.send("/mksus", new Object[]{5, 1}, me);
    osc.send("/mkpitch", new Object[]{5, 2, "0.25:0.2:0.8"}, me);
    osc.send("/mkpitchset", new Object[]{5, 1, "2"}, me);
    osc.send("/mkdyn", new Object[]{5, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{5, 2, 0, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
  case 33:
    //IV - 4, system 2, Track 1 - off
    osc.send("/drh", new Object[]{2, 2, 0}, me);
    osc.send("/rmarts", new Object[]{2, 2, 0}, me);
    osc.send("/drh", new Object[]{3, 3, 0}, me);
    osc.send("/rmarts", new Object[]{3}, me);
    //IV - 4, system 2, Track 1
    osc.send("/drh", new Object[]{6, 2, 1}, me);
    osc.send("/mksus", new Object[]{6, 8}, me);
    osc.send("/mkpitch", new Object[]{6, 3, "0.05:0.45:0.55:3:7"}, me);
    osc.send("/mkpitchset", new Object[]{6, 1, "3"}, me);
    osc.send("/mkdyn", new Object[]{6, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{6, 9, 5, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    //IV - 4, system 2, Track 2
    osc.send("/drh", new Object[]{7, 3, 1}, me);
    osc.send("/mksus", new Object[]{7, 8}, me);
    osc.send("/mkpitch", new Object[]{7, 3, "0.05:0.45:0.55:3:7"}, me);
    osc.send("/mkpitchset", new Object[]{7, 1, "3"}, me);
    osc.send("/mkdyn", new Object[]{7, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{7, 7, 3, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
  case 34:
    //IV - 5, system 1, Track 1 - off
    osc.send("/drh", new Object[]{4, 0, 0}, me);
    osc.send("/rmarts", new Object[]{4}, me);
    osc.send("/drh", new Object[]{5, 1, 0}, me);
    osc.send("/rmarts", new Object[]{5}, me);
    //IV - 5, system 1, Track 1
    osc.send("/drh", new Object[]{8, 0, 1}, me);
    osc.send("/mksus", new Object[]{8, 3}, me);
    osc.send("/mkpitch", new Object[]{8, 3, "0.05:0.45:0.55:3:7"}, me);
    osc.send("/mkpitchset", new Object[]{8, 1, "3"}, me);
    osc.send("/mkdyn", new Object[]{8, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{8, 3, 1, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    //IV - 5, system 1, Track 2
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    osc.send("/mksus", new Object[]{9, 1}, me);
    osc.send("/mkpitch", new Object[]{9, 3, "0.05:0.45:0.55:3:7"}, me);
    osc.send("/mkpitchset", new Object[]{9, 1, "3"}, me);
    osc.send("/mkdyn", new Object[]{9, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{9, 2, 0, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
  case 35:
    //IV - 6, system 2, Track 1 - off
    osc.send("/drh", new Object[]{6, 2, 0}, me);
    osc.send("/rmarts", new Object[]{6}, me);
    osc.send("/drh", new Object[]{7, 3, 0}, me);
    osc.send("/rmarts", new Object[]{7}, me);
    //IV - 6, system 2, Track 1
    osc.send("/drh", new Object[]{10, 2, 1}, me);
    osc.send("/mksus", new Object[]{10, 8}, me);
    osc.send("/mkpitch", new Object[]{10, 0, "0.05:0.0:1.0"}, me);
    osc.send("/mkpitchset", new Object[]{10, 1, "4"}, me);
    osc.send("/mkdyn", new Object[]{10, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{10, 9, 5, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    //IV - 6, system 2, Track 2
    osc.send("/drh", new Object[]{11, 3, 1}, me);
    osc.send("/mksus", new Object[]{11, 8}, me);
    osc.send("/mkpitch", new Object[]{11, 0, "0.05:0.0:1.0"}, me);
    osc.send("/mkpitchset", new Object[]{11, 1, "4"}, me);
    osc.send("/mkdyn", new Object[]{11, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{11, 7, 3, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
  case 36:
    //IV - 7, system 1, Track 1 - off
    osc.send("/drh", new Object[]{8, 0, 0}, me);
    osc.send("/rmarts", new Object[]{8}, me);
    osc.send("/drh", new Object[]{9, 1, 0}, me);
    osc.send("/rmarts", new Object[]{9}, me);
    //IV - 7, system 1, Track 1
    osc.send("/drh", new Object[]{4, 0, 1}, me);
    osc.send("/mksus", new Object[]{4, 3}, me);
    osc.send("/mkpitch", new Object[]{4, 1, "0.08:0.0:1.0:-1:7"}, me);
    osc.send("/mkpitchset", new Object[]{4, 1, "1"}, me);
    osc.send("/mkdyn", new Object[]{4, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{4, 3, 1, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    //IV - 7, system 1, Track 2
    osc.send("/drh", new Object[]{5, 1, 1}, me);
    osc.send("/mksus", new Object[]{5, 1}, me);
    osc.send("/mkpitch", new Object[]{5, 1, "0.08:0.0:1.0:-1:7"}, me);
    osc.send("/mkpitchset", new Object[]{5, 1, "1"}, me);
    osc.send("/mkdyn", new Object[]{5, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{5, 2, 0, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
  case 37:
    //IV - 8, system 2, Track 1 - off
    osc.send("/drh", new Object[]{10, 2, 0}, me);
    osc.send("/rmarts", new Object[]{10}, me);
    osc.send("/drh", new Object[]{11, 3, 0}, me);
    osc.send("/rmarts", new Object[]{11}, me);
    //IV - 8, system 2, Track 1
    osc.send("/drh", new Object[]{6, 2, 1}, me);
    osc.send("/mksus", new Object[]{6, 8}, me);
    osc.send("/mkpitch", new Object[]{6, 1, "0.08:0.0:1.0:-1:7"}, me);
    osc.send("/mkpitchset", new Object[]{6, 1, "3"}, me);
    osc.send("/mkdyn", new Object[]{6, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{6, 9, 5, "trill.svg:accent.svg:tongueslap.svg:flz.svg:multi.svg", "multi.svg:flz.svg:trill.svg:accent.svg"}, me);
    //IV - 8, system 2, Track 2
    osc.send("/drh", new Object[]{3, 3, 1}, me);
    osc.send("/mksus", new Object[]{3, 8}, me);
    osc.send("/mkpitch", new Object[]{3, 1, "0.08:0.0:1.0:-1:7"}, me);
    osc.send("/mkpitchset", new Object[]{3, 1, "1"}, me);
    osc.send("/mkdyn", new Object[]{3, 0, "5:3:2:6"}, me);
    osc.send("/mkart", new Object[]{3, 7, 3, "trill.svg:Bartok_pizz.svg:harmonic.svg:tongueslap.svg:multi.svg", "accent.svg"}, me);
    break;
  case 38:
    //system 1 off
    osc.send("/drh", new Object[]{4, 2, 0}, me);
    osc.send("/drh", new Object[]{5, 3, 0}, me);
    //system 2 off
    osc.send("/drh", new Object[]{6, 2, 0}, me);
    osc.send("/drh", new Object[]{3, 3, 0}, me);
    break;
  }
}

void keyPressed() {
  if (key=='1') score(0);
  if (key=='2') score(1);
  if (key=='3') score(2);
  if (key=='4') score(3);
  if (key=='5') score(4);
  if (key=='6') score(5);
  if (key=='7') score(6);
  if (key=='8') score(7);
  if (key=='9') score(8);
  if (key=='0') score(9);
  if (key=='q') score(10);
  if (key=='w') score(11);
  if (key=='e') score(12);
  if (key=='r') score(13);
  if (key=='t') score(14);
  if (key=='y') score(15);
  if (key=='u') score(16);
  if (key=='i') score(17);
  if (key=='o') score(18);
  if (key=='p') score(19);
  if (key=='a') score(20);
  if (key=='s') score(21);
  if (key=='d') score(22);
  if (key=='f') score(23);
  if (key=='g') score(24);
  if (key=='h') score(25);
  if (key=='j') score(26);
  if (key=='k') score(27);
  if (key=='l') score(28);
  if (key=='z') score(29);
  if (key=='x') score(30);
  if (key=='c') score(31);
  if (key=='v') score(32);
  if (key=='b') score(33);
  if (key=='n') score(34);
  if (key=='m') score(35);
}