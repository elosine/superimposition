void score(int sys) {
  switch(sys) {
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    // SECTION A (3:30, 7 pages, 14 systems) - changes every page
    //// Page 1 (0:00-0:30, 0:30)
    ////// Rhythms: 2/9,1009/2
    ////// Pitch Set/Range: Open Pitch/Open Range
    //////////////////////////////////////////////////////////////////////////////
  case 0:  ////// P1.A1.1 - System 1
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    osc.send("/chgpitch", new Object[]{2, 0, 0}, me);
    osc.send("/chgpitch", new Object[]{9, 0, 0}, me);
    scrix = sys;
    break;
  case 1: ////// P1.A1.2 - System 2
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    osc.send("/chgpitch", new Object[]{1009, 0, 0}, me);
    osc.send("/chgpitch", new Object[]{1002, 0, 0}, me);
    scrix = sys;
    break;
    ///////////////////////////////////////////////////////////////////////////////
    //// Page 2 (0:30-1:00, 0:30)
    ////// Rhythms: 2/9,1009/2
    ////// Pitch Set/Range: Open Pitch/Compressed Range w/Outliers
    ///////////////////////////////////////////////////////////////////////////////
  case 2: ////// P2.A2.1 - System 1
    osc.send("/chgpitch", new Object[]{2, 1, 0}, me);  
    osc.send("/chgpitch", new Object[]{9, 1, 0}, me);  
    scrix = sys;
    break;
  case 3: ////// P2.A2.2 - System 2
    osc.send("/chgpitch", new Object[]{1009, 1, 0}, me);  
    osc.send("/chgpitch", new Object[]{1002, 1, 0}, me);
    scrix = sys;
    break;
    //////////////////////////////////////////////////////////////////////////////
    //// Page 3 (1:00-1:30, 0:30)
    ////// Rhythms: 2/9,1009/2
    ////// Pitch Set/Range: Open Pitch/Compressed Range w/Outliers
    ////// Sustained Notes
    //////////////////////////////////////////////////////////////////////////////
  case 4: ////// P3.A3.1 - System 1
    osc.send("/mksus", new Object[]{2, 5}, me);
    osc.send("/mksus", new Object[]{9, 3}, me);
    scrix = sys;
    break;
  case 5: ////// P3.A3.2 - System 2
    osc.send("/mksus", new Object[]{1009, 4}, me);
    osc.send("/mksus", new Object[]{1002, 2}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 4 (1:30-2:00, 0:30)
    ////// Rhythms: 2/9,1009/2
    ////// Pitch Set/Range: Open Pitch/Random Distribution
    ////// Sustained Notes
    /////////////////////////////////////////////////////////////////////////////
  case 6: ////// P4.A4.1 - System 1
    osc.send("/chgpitch", new Object[]{2, 2, 0}, me);  
    osc.send("/chgpitch", new Object[]{9, 2, 0}, me);  
    scrix = sys;
    break;
  case 7: ////// P4.A4.2 - System 2 
    osc.send("/chgpitch", new Object[]{1009, 2, 0}, me);  
    osc.send("/chgpitch", new Object[]{1002, 2, 0}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 5 (2:00-2:30, 0:30)
    ////// Rhythms: 2/9,1009/2
    ////// Pitch Set/Range: Open Pitch/Random Distribution
    ////// Sustained Notes
    ////// Dynamics: Random Leaps
    /////////////////////////////////////////////////////////////////////////////
  case 8: ////// P5.A5.1 - System 1
    osc.send("/mkdyn", new Object[]{2, 0, "2:15:1:7"}, me);
    osc.send("/mkdyn", new Object[]{9, 0, "2:17:1:7"}, me);
    scrix = sys;
    break;
  case 9: ////// P5.A5.2 - System 2
    scrix = sys;
    osc.send("/mkdyn", new Object[]{1009, 0, "2:13:1:7"}, me);
    osc.send("/mkdyn", new Object[]{1002, 0, "2:18:1:7"}, me);
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 6 (2:30-3:00, 0:30)
    ////// Rhythms: 2/9,1009/2
    ////// Pitch Set/Range: Messian Mode 3/Random Distribution
    ////// Sustained Notes
    ////// Dynamics: Random Leaps
    /////////////////////////////////////////////////////////////////////////////
  case 10: ////// P6.A6.1 - System 1
    osc.send("/chgpitch", new Object[]{2, 2,1}, me);  
    osc.send("/chgpitch", new Object[]{9, 2,1}, me);  
    scrix = sys;
    break;
  case 11: ////// P6.A6.2 - System 2
    osc.send("/chgpitch", new Object[]{1009, 2,1}, me);  
    osc.send("/chgpitch", new Object[]{1002, 2,1}, me);  
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 7 (3:00-3:30, 0:30)
    ////// Rhythms: 2/9,1009/2
    ////// Pitch Set/Range: Messian Mode 3/Random Distribution
    ////// Sustained Notes
    ////// Dynamics: Random Leaps
    ////// Articulations: LOOK AT THIS
    /////////////////////////////////////////////////////////////////////////////
  case 12: ////// P7.A7.1 - System 1
    ////// NEW ARTICULATION MENU //////
    scrix = sys;
    break;
  case 13: ////// P7.A7.2 - System 2
    ////// NEW ARTICULATION MENU //////
    scrix = sys;
    break;
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    // SECTION B (4:00, 8 pages, 14 systems) - changes every 2 pages
    //// Page 8 (4:00-4:30, 0:30)
    ////// Rhythms: 7/8,3/0
    ////// Pitch Set/Range: Tetrachord/Up & Down
    ////// Sustained Notes
    ////// Dynamics: Crescendos
    ////// Articulations: LOOK AT THIS
    //////////////////////////////////////////////////////////////////////////////
  case 14: ////// P8.B1.1 - System 1
    //Previous Page's Rhythms Off
    osc.send("/drh", new Object[]{2, 0, 0}, me);
    osc.send("/drh", new Object[]{9, 1, 0}, me);
    //New Rhythms On
    osc.send("/drh", new Object[]{7, 0, 1}, me);
    osc.send("/drh", new Object[]{8, 1, 1}, me);
    osc.send("/chgpitch", new Object[]{7,3,2}, me);  
    osc.send("/chgpitch", new Object[]{8,3,2}, me);  
    //Make Crescendos
    osc.send("/mkdyn", new Object[]{7, 1, "1:5:4:6:2.0:5.0:3.0"}, me);
    osc.send("/mkdyn", new Object[]{8, 1, "1:5:4:6:1.0:4.0:1.5"}, me);
    //Sustained Notes
    osc.send("/mksus", new Object[]{7, 7}, me);
    osc.send("/mksus", new Object[]{8, 7}, me);
    ////// NEW ARTICULATION MENU //////
    scrix = sys;
    break;
  case 15: ////// P8.B1.2 - System 2
    //Previous Page's Rhythms Off
    osc.send("/drh", new Object[]{1009, 2, 0}, me);
    osc.send("/drh", new Object[]{1002, 3, 0}, me);
    //New Rhythms On
    osc.send("/drh", new Object[]{3, 2, 1}, me);
    osc.send("/drh", new Object[]{0, 3, 1}, me);
    osc.send("/chgpitch", new Object[]{3,3,2}, me);  
    osc.send("/chgpitch", new Object[]{0,3,2}, me); 
    //Dynamics
    osc.send("/mkdyn", new Object[]{3, 1, "1:7:4:7:1.0:3.0:0.5"}, me);
    osc.send("/mkdyn", new Object[]{0, 1, "1:4:4:6:3.0:7.0:2.0"}, me);
    //Sustained Notes
    osc.send("/mksus", new Object[]{3, 5}, me);
    osc.send("/mksus", new Object[]{0, 6}, me);
    ////// NEW ARTICULATION MENU //////
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 9 (4:30-5:00, 0:30)  --  NO CHANGES
    ////// Rhythms: 7/8,3/0
    ////// Pitch Set/Range: Tetrachord/Up & Down
    ////// Sustained Notes
    ////// Dynamics: Crescendos
    ////// Articulations: LOOK AT THIS
    //////////////////////////////////////////////////////////////////////////////
  case 16: ////// P9.B2.1 - System 1
    scrix = sys;
    break;
  case 17: ////// P9.B2.2 - System 2
    scrix = sys;
    break;




  case 18: ////// P10.B3.1 - System 1
    scrix = sys;
    break;
  case 19: ////// P10.B3.2 - System 2
    scrix = sys;
    break;
  case 20: ////// P11.B4.1 - System 1
    scrix = sys;
    break;
  case 21: ////// P11.B4.2 - System 2
    scrix = sys;
    break;
  case 22: ////// P12.B5.1 - System 1
    scrix = sys;
    break;
  case 23: ////// P12.B5.2 - System 2
    scrix = sys;
    break;
  case 24: ////// P13.B6.1 - System 1
    scrix = sys;
    break;
  case 25: ////// P13.B6.2 - System 2
    scrix = sys;
    break;
  case 26: ////// P14.B7.1 - System 1
    scrix = sys;
    break;
  case 27: ////// P14.B7.2 - System 2
    scrix = sys;
    break;
  case 28: ////// P15.B8.1 - System 1
    scrix = sys;
    break;
  case 29: ////// P15.B8.2 - System 2
    scrix = sys;
    break;





  case 30: ////// A2.1 - System 1
    scrix = sys;
    break;
  case 31: ////// A2.1 - System 1
    scrix = sys;
    break;
  case 32: ////// A2.1 - System 1
    scrix = sys;
    break;
  case 33: ////// A2.1 - System 1
    scrix = sys;
    break;
  case 34: ////// A2.1 - System 1
    scrix = sys;
    break;
  case 35: ////// A2.1 - System 1
    scrix = sys;
    break;
  case 36: ////// A2.1 - System 1
    scrix = sys;
    break;
  case 37: ////// A2.1 - System 1
    scrix = sys;
    break;
  case 38: ////// A2.1 - System 1
    scrix = sys;
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
}

int scrn = 0;

void sys1clr() { 
  osc.send("/drh", new Object[]{0, 0, 0}, me);
  osc.send("/drh", new Object[]{1, 1, 0}, me);
  osc.send("/drh", new Object[]{2, 0, 0}, me);
  osc.send("/drh", new Object[]{4, 0, 0}, me);
  osc.send("/drh", new Object[]{5, 1, 0}, me);
  osc.send("/drh", new Object[]{7, 0, 0}, me);
  osc.send("/drh", new Object[]{8, 0, 0}, me);
  osc.send("/drh", new Object[]{8, 1, 0}, me);
  osc.send("/drh", new Object[]{9, 1, 0}, me);
  osc.send("/drh", new Object[]{9, 0, 0}, me);
  osc.send("/drh", new Object[]{10, 0, 0}, me);
  osc.send("/rmvnotedrw", new Object[]{0}, me);
  osc.send("/rmvnotedrw", new Object[]{2}, me);
  osc.send("/rmvnotedrw", new Object[]{4}, me);
}

void sys2clr() {
  osc.send("/drh", new Object[]{1000, 3, 0}, me);
  osc.send("/drh", new Object[]{1002, 2, 0}, me);
  osc.send("/drh", new Object[]{3, 2, 0}, me);
  osc.send("/drh", new Object[]{3, 3, 0}, me);
  osc.send("/drh", new Object[]{6, 2, 0}, me);
  osc.send("/drh", new Object[]{1007, 3, 0}, me);
  osc.send("/drh", new Object[]{1010, 2, 0}, me);
  osc.send("/drh", new Object[]{11, 2, 0}, me);
  osc.send("/drh", new Object[]{11, 3, 0}, me);
  osc.send("/drh", new Object[]{1009, 2, 0}, me);
  osc.send("/drh", new Object[]{1002, 3, 0}, me);
  osc.send("/rmvnotedrw", new Object[]{1}, me);
  osc.send("/rmvnotedrw", new Object[]{3}, me);
  osc.send("/rmvnotedrw", new Object[]{5}, me);
}