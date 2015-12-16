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
    osc.send("/chgpitch", new Object[]{2, 2, 1}, me);  
    osc.send("/chgpitch", new Object[]{9, 2, 1}, me);  
    scrix = sys;
    break;
  case 11: ////// P6.A6.2 - System 2
    osc.send("/chgpitch", new Object[]{1009, 2, 1}, me);  
    osc.send("/chgpitch", new Object[]{1002, 2, 1}, me);  
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 7 (3:00-3:30, 0:30)
    ////// Rhythms: 2/9,1009/2
    ////// Pitch Set/Range: Messian Mode 3/Random Distribution
    ////// Sustained Notes
    ////// Dynamics: Random Leaps
    ////// Articulations: 
    /////////////////////////////////////////////////////////////////////////////
  case 12: ////// P7.A7.1 - System 1  
    osc.send("/chgart", new Object[]{2, "0:2", 1}, me);
    osc.send("/chgart", new Object[]{9, "10:11", 1}, me);
    scrix = sys;
    break;
  case 13: ////// P7.A7.2 - System 2 
    osc.send("/chgart", new Object[]{1009, "0:2", 1}, me);
    osc.send("/chgart", new Object[]{1002, "10:11", 1}, me);
    scrix = sys;
    break;
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    // SECTION B (4:00, 8 pages, 14 systems) - changes every 2 pages
    //// Page 8 (3:30-4:00, 0:30)
    ////// Rhythms: 7/8,3/0
    ////// Pitch Set/Range: Tetrachord/Up & Down
    ////// Sustained Notes
    ////// Dynamics: Crescendos
    ////// Articulations: 
    //////////////////////////////////////////////////////////////////////////////
  case 14: ////// P8.B1.1 - System 1
    //Previous Page's Rhythms Off
    osc.send("/drh", new Object[]{2, 0, 0}, me);
    osc.send("/drh", new Object[]{9, 1, 0}, me);
    //New Rhythms On
    osc.send("/drh", new Object[]{7, 0, 1}, me);
    osc.send("/drh", new Object[]{8, 1, 1}, me);
    osc.send("/chgpitch", new Object[]{7, 3, 2}, me);  
    osc.send("/chgpitch", new Object[]{8, 3, 2}, me);  
    //Make Crescendos
    osc.send("/mkdyn", new Object[]{7, 1, "1:5:4:6:2.0:5.0:3.0"}, me);
    osc.send("/mkdyn", new Object[]{8, 1, "1:5:4:6:1.0:4.0:1.5"}, me);
    //Sustained Notes
    osc.send("/mksus", new Object[]{7, 7}, me);
    osc.send("/mksus", new Object[]{8, 7}, me);
    //Articulations 
    osc.send("/chgart", new Object[]{7, "2:3", 2}, me);
    osc.send("/chgart", new Object[]{8, "10:2", 2}, me);
    scrix = sys;
    break;
  case 15: ////// P8.B1.2 - System 2
    //Previous Page's Rhythms Off
    osc.send("/drh", new Object[]{1009, 2, 0}, me);
    osc.send("/drh", new Object[]{1002, 3, 0}, me);
    //New Rhythms On
    osc.send("/drh", new Object[]{3, 2, 1}, me);
    osc.send("/drh", new Object[]{0, 3, 1}, me);
    osc.send("/chgpitch", new Object[]{3, 3, 2}, me);  
    osc.send("/chgpitch", new Object[]{0, 3, 2}, me); 
    //Dynamics
    osc.send("/mkdyn", new Object[]{3, 1, "1:7:4:7:1.0:3.0:0.5"}, me);
    osc.send("/mkdyn", new Object[]{0, 1, "1:4:4:6:3.0:7.0:2.0"}, me);
    //Sustained Notes
    osc.send("/mksus", new Object[]{3, 5}, me);
    osc.send("/mksus", new Object[]{0, 6}, me);
    //Articulations 
    osc.send("/chgart", new Object[]{3, "2:3", 2}, me);
    osc.send("/chgart", new Object[]{0, "10:2", 2}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 9 (4:00-4:30, 0:30)  --  NO CHANGES
    //////////////////////////////////////////////////////////////////////////////
  case 16: ////// P9.B2.1 - System 1
    scrix = sys;
    break;
  case 17: ////// P9.B2.2 - System 2
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 10 (4:30-5:00, 0:30)
    ////// Rhythms: 7/8,3/0
    ////// Pitch Set/Range: Open/Random
    ////// Sustained Notes
    ////// Dynamics: Crescendos
    ////// Articulations: 
    //////////////////////////////////////////////////////////////////////////////
  case 18: ////// P10.B3.1 - System 1
    //Change Pitch
    osc.send("/chgpitch", new Object[]{7, 2, 0}, me);  
    osc.send("/chgpitch", new Object[]{8, 2, 0}, me); 
    //Dynamics - Hairpins
    osc.send("/mkdyn", new Object[]{7, 3, "4:4:6:6:2.0:3.75:4.0:0.7"}, me);
    osc.send("/mkdyn", new Object[]{8, 3, "3:4:6:6:2.0:3.75:4.0:0.7"}, me);
    scrix = sys;
    break;
  case 19: ////// P10.B3.2 - System 2
    osc.send("/chgpitch", new Object[]{3, 2, 0}, me);  
    osc.send("/chgpitch", new Object[]{0, 2, 0}, me); 
    //Dynamics - Abrupt Changes
    osc.send("/mkdyn", new Object[]{3, 0, "5:11:3:7"}, me);
    osc.send("/mkdyn", new Object[]{0, 0, "3:13:3:7"}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 11 (5:00-5:30, 0:30)  --  NO CHANGES
    //////////////////////////////////////////////////////////////////////////////
  case 20: ////// P11.B4.1 - System 1
    scrix = sys;
    break;
  case 21: ////// P11.B4.2 - System 2
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 12 (5:30-6:00, 0:30)
    ////// Rhythms: 7/8,3/0
    ////// Pitch Set/Range: Messian Mode3/Up&down
    ////// Sustained Notes: new set
    ////// Dynamics
    ////// Articulations: new
    //////////////////////////////////////////////////////////////////////////////
  case 22: ////// P12.B5.1 - System 1
    osc.send("/chgpitch", new Object[]{7, 3, 1}, me);  
    osc.send("/chgpitch", new Object[]{8, 3, 1}, me); 
    //Sustained Notes(more)
    osc.send("/mksus", new Object[]{7, 15}, me);
    osc.send("/mksus", new Object[]{8, 11}, me);
    //Articulations 
    osc.send("/chgart", new Object[]{7, "1:2", 3}, me);
    osc.send("/chgart", new Object[]{8, "0:11", 3}, me);
    scrix = sys;
    break;
  case 23: ////// P12.B5.2 - System 2
    osc.send("/chgpitch", new Object[]{3, 3, 1}, me);  
    osc.send("/chgpitch", new Object[]{0, 3, 1}, me);
    //Sustained Notes(more)
    osc.send("/mksus", new Object[]{3, 15}, me);
    osc.send("/mksus", new Object[]{0, 11}, me);
    //Articulations 
    osc.send("/chgart", new Object[]{3, "1:2", 3}, me);
    osc.send("/chgart", new Object[]{0, "0:11", 3}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 13 (6:00-6:30, 0:30)  --  NO CHANGES
    //////////////////////////////////////////////////////////////////////////////
  case 24: ////// P13.B6.1 - System 1
    scrix = sys;
    break;
  case 25: ////// P13.B6.2 - System 2
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 14 (6:30-7:00, 0:30)
    ////// Rhythms: 7/8,3/0
    ////// Pitch Set/Range: Tetrachord/outliers
    ////// Sustained Notes
    ////// Dynamics
    ////// Articulations
    //////////////////////////////////////////////////////////////////////////////
  case 26: ////// P14.B7.1 - System 1
    osc.send("/chgpitch", new Object[]{7, 1, 2}, me);  
    osc.send("/chgpitch", new Object[]{8, 1, 2}, me);
    scrix = sys;
    break;
  case 27: ////// P14.B7.2 - System 2
    osc.send("/chgpitch", new Object[]{3, 1, 2}, me);  
    osc.send("/chgpitch", new Object[]{0, 1, 2}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 15 (7:00-7:30, 0:30)  --  NO CHANGES
    //////////////////////////////////////////////////////////////////////////////
  case 28: ////// P15.B8.1 - System 1
    scrix = sys;
    break;
  case 29: ////// P15.B8.2 - System 2
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 16 (7:30-8:00, 0:30)
    ////// Rhythms: 7/8,3/0
    ////// Pitch Set/Range: Open/Open
    ////// Sustained Notes
    ////// Dynamics: dynamics(smooth,5)
    ////// Articulations
    //////////////////////////////////////////////////////////////////////////////
  case 30: ////// P16.B9.1 - System 1
    //dynamics(smooth, 5)
    osc.send("/mkdyn", new Object[]{7, 0, "3:1:0:0"}, me);
    osc.send("/mkdyn", new Object[]{8, 0, "3:1:0:0"}, me);
    // Change pitch 
    osc.send("/chgpitch", new Object[]{7, 0, 0}, me);  
    osc.send("/chgpitch", new Object[]{8, 0, 0}, me);
    //Sustained Notes(more)
    osc.send("/mksus", new Object[]{7, 7}, me);
    osc.send("/mksus", new Object[]{8, 7}, me);
    //Articulations 
    osc.send("/chgart", new Object[]{7, "2", 1}, me);
    osc.send("/chgart", new Object[]{8, "2", 1}, me);
    scrix = sys;
    break;
  case 31: ////// P16.B9.2 - System 2
    //Dynamics - Smooth
    osc.send("/mkdyn", new Object[]{ 3, 0, "5:1:0:0"}, me);
    osc.send("/mkdyn", new Object[]{0, 0, "3:1:0:0"}, me);
    //Sustained Notes(more)
    osc.send("/mksus", new Object[]{3, 7}, me);
    osc.send("/mksus", new Object[]{0, 7}, me);
    // Change pitch 
    osc.send("/chgpitch", new Object[]{7, 0, 0}, me);  
    osc.send("/chgpitch", new Object[]{8, 0, 0}, me);
    //Articulations 
    osc.send("/chgart", new Object[]{7, "2", 1}, me);
    osc.send("/chgart", new Object[]{8, "2", 1}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 17 (8:00-8:30, 0:30)  --  NO CHANGES
    //////////////////////////////////////////////////////////////////////////////
  case 32: ////// P17.B10.1 - System 1
    scrix = sys;
    break;
  case 33: ////// P17.B10.2 - System 2
    scrix = sys;
    break;
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    // SECTION C (1:30, 3 pages, 6 systems) - changes every page
    //// Page 18 (8:30-9:00, 0:30)
    ////// Rhythms: 10,2
    ////// Pitch Set/Range: Tetrachord/Up & Down
    ////// Sustained Notes
    ////// Dynamics: Crescendos
    ////// Articulations: 
    //////////////////////////////////////////////////////////////////////////////
  case 34: ////// P18.C1.1 - System 1
    osc.send("/drh", new Object[]{7, 0, 0}, me);
    osc.send("/drh", new Object[]{8, 1, 0}, me);
    osc.send("/drh", new Object[]{10, 0, 1}, me);  
    osc.send("/mksus", new Object[]{10, 3}, me);
    osc.send("/mkdyn", new Object[]{10, 3, "1:3:6:6:7.0:9.0:0.5:0.5"}, me);
    osc.send("/chgpitch", new Object[]{10, 0, 0}, me); 
    //Articulations 
    osc.send("/chgart", new Object[]{10, "none", 0}, me);
    //Clone to 2nd Staff
    osc.send("/mknotedrw", new Object[]{0, 10, 1}, me);
    scrix = sys;
    break;
  case 35: ////// P18.C1.2 - System 2
    osc.send("/drh", new Object[]{3, 2, 0}, me);
    osc.send("/drh", new Object[]{0, 3, 0}, me);
    osc.send("/drh", new Object[]{2, 2, 1}, me);
    osc.send("/mksus", new Object[]{2, 3}, me);
    osc.send("/mkdyn", new Object[]{2, 3, "1:3:6:6:7.0:9.0:0.5:0.5"}, me);
    osc.send("/chgpitch", new Object[]{2, 0, 0}, me); 
    //Articulations 
    osc.send("/chgart", new Object[]{2, "none", 0}, me);
    //Clone to 2nd Staff
    osc.send("/mknotedrw", new Object[]{1, 2, 3}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 19 (9:00-9:30, 0:30)
    ////// Rhythms: 9,2
    ////// Pitch Set/Range: Open/Open
    ////// Sustained Notes
    ////// Dynamics
    ////// Articulations
    //////////////////////////////////////////////////////////////////////////////
  case 36: ////// P19.C2.1 - System 1
    //Old off
    osc.send("/rmvnotedrw", new Object[]{0}, me);
    osc.send("/drh", new Object[]{10, 0, 0}, me);
    //New
    osc.send("/drh", new Object[]{9, 0, 1}, me);
    osc.send("/mksus", new Object[]{9, 3}, me);
    osc.send("/mkdyn", new Object[]{9, 3, "1:4:6:6:6.0:10.0:0.5:0.6"}, me);
    osc.send("/chgpitch", new Object[]{9, 0, 0}, me); 
    osc.send("/chgart", new Object[]{9, "none", 0}, me);
    osc.send("/mknotedrw", new Object[]{2, 9, 1}, me);
    scrix = sys;
    break;
  case 37: ////// P19.C2.2 - System 2
    //Old off
    osc.send("/rmvnotedrw", new Object[]{1}, me);
    osc.send("/drh", new Object[]{2, 2, 0}, me);
    //New
    osc.send("/drh", new Object[]{11, 2, 1}, me);
    osc.send("/mksus", new Object[]{11, 5}, me);
    osc.send("/mkdyn", new Object[]{11, 1, "1:4:2:6:4.0:6.0:1.0"}, me);
    osc.send("/chgpitch", new Object[]{11, 0, 0}, me); 
    osc.send("/chgart", new Object[]{11, "none", 0}, me);
    osc.send("/mknotedrw", new Object[]{3, 11, 3}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 20 (9:30-10:00, 0:30)
    ////// Rhythms: 2,9
    ////// Pitch Set/Range: Open/Open
    ////// Sustained Notes
    ////// Dynamics
    ////// Articulations
    //////////////////////////////////////////////////////////////////////////////
  case 38: ////// P20.C3.1 - System 1
    //System 1 - off
    osc.send("/rmvnotedrw", new Object[]{2}, me);
    osc.send("/drh", new Object[]{9, 0, 0}, me);
    //System 1
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/mksus", new Object[]{2, 4}, me);
    osc.send("/mkdyn", new Object[]{2, 3, "1:3:6:6:7.0:9.0:0.5:0.5"}, me);
    osc.send("/chgpitch", new Object[]{2, 0, 0}, me); 
    osc.send("/chgart", new Object[]{2, "none", 0}, me);
    osc.send("/mknotedrw", new Object[]{4, 2, 1}, me);
    scrix = sys;
    break;
  case 39: ////// P20.C3.2 - System 2
    //System 2 - off
    osc.send("/rmvnotedrw", new Object[]{3}, me);
    osc.send("/drh", new Object[]{11, 2, 0}, me);
    //System 2
    osc.send("/drh", new Object[]{9, 2, 1}, me);
    osc.send("/mksus", new Object[]{9, 4}, me);
    osc.send("/mkdyn", new Object[]{9, 3, "1:3:6:6:7.0:9.0:0.5:0.5"}, me);
    osc.send("/chgpitch", new Object[]{9, 0, 0}, me); 
    osc.send("/chgart", new Object[]{9, "none", 0}, me);
    osc.send("/mknotedrw", new Object[]{5, 9, 3}, me);
    scrix = sys;
    break;
    //////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////
    // SECTION D (2:00, 4 pages, 8 systems) - changes every system unisons
    //// Page 21 (10:00-10:30, 0:30)
    ////// Rhythms: 0,2
    ////// Pitch Set/Range
    ////// Sustained Notes
    ////// Dynamics: Crescendos
    ////// Articulations: 
    //////////////////////////////////////////////////////////////////////////////
  case 40: ////// P21.D1.1 - System 1
    osc.send("/drh", new Object[]{2, 0, 0}, me);
    osc.send("/rmvnotedrw", new Object[]{4}, me);
    //Track 1
    osc.send("/drh", new Object[]{0, 0, 1}, me);
    osc.send("/mksus", new Object[]{0, 4}, me);
    osc.send("/mkdyn", new Object[]{0, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{0, 0, 0}, me);
    osc.send("/chgart", new Object[]{0, "0:1:2:3", 3}, me);
    //Track 2
    osc.send("/drh", new Object[]{1, 1, 1}, me);
    osc.send("/mksus", new Object[]{1, 4}, me);
    osc.send("/mkdyn", new Object[]{1, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{1, 0, 0}, me);
    osc.send("/chgart", new Object[]{1, "0:10:2:11", 3}, me); 
    scrix = sys;
    break;
  case 41: ////// P21.D1.2 - System 2 
    //Off
    osc.send("/drh", new Object[]{9, 2, 0}, me);
    osc.send("/rmarts", new Object[]{9}, me);
    osc.send("/rmvnotedrw", new Object[]{5}, me);
    //System 2, Track 1
    osc.send("/drh", new Object[]{2, 2, 1}, me);
    osc.send("/mksus", new Object[]{2, 1}, me);
    osc.send("/mkdyn", new Object[]{2, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{2, 1, 2}, me);
    osc.send("/chgart", new Object[]{2, "3", 3}, me);
    //System 2, Track 2
    osc.send("/drh", new Object[]{3, 3, 1}, me);
    osc.send("/mksus", new Object[]{3, 1}, me);
    osc.send("/mkdyn", new Object[]{3, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{3, 1, 2}, me);
    osc.send("/chgart", new Object[]{3, "2", 3}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 22 (10:30-11:00, 0:30)
    ////// Rhythms: 2,9
    ////// Pitch Set/Range: Open/Open
    ////// Sustained Notes
    ////// Dynamics
    ////// Articulations
    //////////////////////////////////////////////////////////////////////////////
  case 42: ////// P22.D2.1 - System 1 
    //system 1, Track 1 - off
    osc.send("/drh", new Object[]{0, 0, 0}, me);
    osc.send("/drh", new Object[]{1, 1, 0}, me);
    //system 1, Track 1
    osc.send("/drh", new Object[]{4, 0, 1}, me);
    osc.send("/mksus", new Object[]{4, 3}, me);
    osc.send("/mkdyn", new Object[]{4, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{4, 3, 1}, me);
    osc.send("/chgart", new Object[]{4, "0:1", 3}, me);
    //system 1, Track 2
    osc.send("/drh", new Object[]{5, 1, 1}, me);
    osc.send("/mksus", new Object[]{5, 1}, me);
    osc.send("/mkdyn", new Object[]{5, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{5, 3, 1}, me);
    osc.send("/chgart", new Object[]{5, "10:11", 3}, me);
    scrix = sys;
    break;
  case 43: ////// P22.D2.2 - System 2
    //system 2, Track 1/2 - off
    osc.send("/drh", new Object[]{2, 2, 0}, me);
    osc.send("/drh", new Object[]{3, 3, 0}, me);
    //system 2, Track 1
    osc.send("/drh", new Object[]{6, 2, 1}, me);
    osc.send("/mksus", new Object[]{6, 8}, me);
    osc.send("/mkdyn", new Object[]{6, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{6, 3, 0}, me);
    osc.send("/chgart", new Object[]{6, "none", 0}, me);
    //system 2, Track 2
    osc.send("/drh", new Object[]{7, 3, 1}, me);
    osc.send("/mksus", new Object[]{7, 8}, me);
    osc.send("/mkdyn", new Object[]{7, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{7, 3, 0}, me);
    osc.send("/chgart", new Object[]{7, "none", 0}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 23 (11:00-11:30, 0:30)
    ////// Rhythms: 2,9
    ////// Pitch Set/Range: Open/Open
    ////// Sustained Notes
    ////// Dynamics
    ////// Articulations
    //////////////////////////////////////////////////////////////////////////////
  case 44: ////// P23.D3.2 - System 1
    //IV - 5, system 1, Track 1 - off
    osc.send("/drh", new Object[]{4, 0, 0}, me);
    osc.send("/drh", new Object[]{5, 1, 0}, me);
    //IV - 5, system 1, Track 1
    osc.send("/drh", new Object[]{8, 0, 1}, me);
    osc.send("/mksus", new Object[]{8, 3}, me);
    osc.send("/mkdyn", new Object[]{8, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{8, 2, 2}, me);
    osc.send("/chgart", new Object[]{8, "0:1:2:3", 3}, me);
    //IV - 5, system 1, Track 2
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    osc.send("/mksus", new Object[]{9, 1}, me);
    osc.send("/mkdyn", new Object[]{9, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{9, 2, 2}, me);
    osc.send("/chgart", new Object[]{9, "0:10:2:11", 3}, me);
    scrix = sys;
    break;
  case 45: ////// P23.D3.2 - System 2
    //IV - 6, system 2, Track 1 - off
    osc.send("/drh", new Object[]{6, 2, 0}, me);
    osc.send("/drh", new Object[]{7, 3, 0}, me);
    //IV - 6, system 2, Track 1
    osc.send("/drh", new Object[]{10, 2, 1}, me);
    osc.send("/mksus", new Object[]{10, 8}, me);
    osc.send("/mkdyn", new Object[]{10, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{10, 1, 1}, me);
    osc.send("/chgart", new Object[]{10, "0", 3}, me);
    //IV - 6, system 2, Track 2
    osc.send("/drh", new Object[]{11, 3, 1}, me);
    osc.send("/mksus", new Object[]{11, 8}, me);
    osc.send("/mkdyn", new Object[]{11, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{11, 1, 1}, me);
    osc.send("/chgart", new Object[]{11, "0", 3}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 24 (11:30-12:00, 0:30)
    ////// Rhythms: 2,9
    ////// Pitch Set/Range: Open/Open
    ////// Sustained Notes
    ////// Dynamics
    ////// Articulations
    //////////////////////////////////////////////////////////////////////////////
  case 46: ////// P24.D4.2 - System 1
    //IV - 7, system 1, Track 1 - off
    osc.send("/drh", new Object[]{8, 0, 0}, me);
    osc.send("/drh", new Object[]{9, 1, 0}, me);
    //IV - 7, system 1, Track 1
    osc.send("/drh", new Object[]{4, 0, 1}, me);
    osc.send("/mksus", new Object[]{4, 3}, me);
    osc.send("/mkdyn", new Object[]{4, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{4, 3, 0}, me);
    osc.send("/chgart", new Object[]{4, "none", 0}, me);
    //IV - 7, system 1, Track 2
    osc.send("/drh", new Object[]{5, 1, 1}, me);
    osc.send("/mksus", new Object[]{5, 1}, me);
    osc.send("/mkdyn", new Object[]{5, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{5, 3, 0}, me);
    osc.send("/chgart", new Object[]{5, "none", 0}, me);
    scrix = sys;
    break;
  case 47: ////// P24.D4.2 - System 2
    //IV - 8, system 2, Track 1 - off
    osc.send("/drh", new Object[]{10, 2, 0}, me);
    osc.send("/drh", new Object[]{11, 3, 0}, me);
    //IV - 8, system 2, Track 1
    osc.send("/drh", new Object[]{6, 2, 1}, me);
    osc.send("/mksus", new Object[]{6, 8}, me);
    osc.send("/mkdyn", new Object[]{6, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{6, 0, 0}, me);
    osc.send("/chgart", new Object[]{6, "0:1:2:3", 3}, me);
    //IV - 8, system 2, Track 2
    osc.send("/drh", new Object[]{3, 3, 1}, me);
    osc.send("/mksus", new Object[]{3, 8}, me);
    osc.send("/mkdyn", new Object[]{3, 0, "5:3:2:6"}, me);
    osc.send("/chgpitch", new Object[]{3, 0, 0}, me);
    osc.send("/chgart", new Object[]{3, "0:10:2:11", 3}, me);
    scrix = sys;
    break;
    /////////////////////////////////////////////////////////////////////////////
    //// Page 25 (12:00-12:30, 0:30)
    ////// Rhythms: 2,9
    ////// Pitch Set/Range: Open/Open
    ////// Sustained Notes
    ////// Dynamics
    ////// Articulations
    //////////////////////////////////////////////////////////////////////////////
  case 48: ////// FIN
    //system 1 off
    osc.send("/drh", new Object[]{4, 0, 0}, me);
    osc.send("/drh", new Object[]{5, 1, 0}, me);
    osc.send("/chgart", new Object[]{4, "none", 0}, me);
    osc.send("/chgart", new Object[]{5, "none", 0}, me);
    break;
  case 49:
    //system 2 off
    osc.send("/drh", new Object[]{6, 2, 0}, me);
    osc.send("/drh", new Object[]{3, 3, 0}, me);
    osc.send("/chgart", new Object[]{6, "none", 0}, me);
    osc.send("/chgart", new Object[]{3, "none", 0}, me);
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
  if (key==';') score(29);
  if (key=='z') score(30);
  if (key=='x') score(31);
  if (key=='c') score(32);
  if (key=='v') score(33);
  if (key=='b') score(34);
  if (key=='n') score(35);
  if (key=='m') score(36);
  if (key==',') score(37);
  if (key=='!') score(38);
  if (key=='@') score(39);
  if (key=='£') score(40);
  if (key=='$') score(41);
  if (key=='%') score(42);
  if (key=='^') score(43);
  if (key=='&') score(44);
  if (key=='*') score(45);
  if (key=='(') score(46);
  if (key==')') score(47);
  if (key=='Q') score(48);
  if (key=='W') score(49);
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

void clrall() {
  osc.send("/clear", new Object[]{}, me);
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
  osc.send("/rmvnotedrw", new Object[]{1}, me);
  osc.send("/rmvnotedrw", new Object[]{3}, me);
  osc.send("/rmvnotedrw", new Object[]{5}, me);
  osc.send("/rmvnotedrw", new Object[]{0}, me);
  osc.send("/rmvnotedrw", new Object[]{2}, me);
  osc.send("/rmvnotedrw", new Object[]{4}, me);
  osc.send("/chgart", new Object[]{6, "none", 0}, me);
  osc.send("/chgart", new Object[]{3, "none", 0}, me);
  osc.send("/chgart", new Object[]{1000, "none", 0}, me);
  osc.send("/chgart", new Object[]{1002, "none", 0}, me);
  osc.send("/chgart", new Object[]{1007, "none", 0}, me);
  osc.send("/chgart", new Object[]{1010, "none", 0}, me);
  osc.send("/chgart", new Object[]{11, "none", 0}, me);
  osc.send("/chgart", new Object[]{1009, "none", 0}, me);
  osc.send("/chgart", new Object[]{7, "none", 0}, me);
  osc.send("/chgart", new Object[]{8, "none", 0}, me);
  osc.send("/chgart", new Object[]{9, "none", 0}, me);
  osc.send("/chgart", new Object[]{10, "none", 0}, me);
  osc.send("/chgart", new Object[]{2, "none", 0}, me);
}