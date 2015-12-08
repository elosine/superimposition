void maketuplets() {
  //Single
  setOTup.mk1(2, 2, 1, 0.0, totalbts);
  setOTup.mk1(3, 3, 1, 0.0, totalbts);
  setOTup.mk1(4, 4, 1, 0.0, totalbts);
  setOTup.mk1(5, 5, 1, 0.0, totalbts);
  setOTup.mk1(6, 6, 1, 0.0, totalbts);
  setOTup.mk1(7, 7, 1, 0.0, totalbts);
  setOTup.mk1(8, 8, 1, 0.0, totalbts);
  setOTup.mk1(9, 9, 1, 0.0, totalbts);
  setOTup.mk1(10, 10, 1, 0.0, totalbts);
  setOTup.mk1(11, 11, 1, 0.0, totalbts);

  setOTup.mk1(703, 7, 3, 0.0, totalbts); //7:3
  setOTup.mk1(703, 7, 2, 0.0, totalbts); //7:2
  setOTup.mk1(1109, 11, 9, 0.0, totalbts); //11:9
  setOTup.mk1(1304, 13, 4, 0.0, totalbts); //13:4
  setOTup.mk1(805, 8, 5, 0.0, totalbts); //8:5
  setOTup.mk1(1309, 13, 9, 0.0, totalbts); //13:9
  setOTup.mk1(1708, 17, 8, 0.0, totalbts); //17:8
  setOTup.mk1(1906, 19, 6, 0.0, totalbts); //19:6
  setOTup.mk1(21013, 21, 13, 0.0, totalbts); //21:13
  setOTup.mk1(509, 5, 9, 0.0, totalbts); //5:9
  setOTup.mk1(15023, 15, 23, 0.0, totalbts); //15:23
  setOTup.mk1(6011, 6, 11, 0.0, totalbts); //6:11
  setOTup.mk1(23017, 23, 17, 0.0, totalbts); //23:17
  setOTup.mk1(43058, 43, 58, 0.0, totalbts); //43:58
  setOTup.mk1(2104, 21, 4, 0.0, totalbts); //21:4

  //Double Nested
  setOTup.mk2(70109014, 7, 1, 9, 14, 0.0, totalbts); //7:1_9:14
  setOTup.mk2(611023017, 6, 11, 23, 17, 0.0, totalbts); //6:11_23:17
  setOTup.mk2(435801611, 43, 58, 16, 11, 0.0, totalbts); //43:58_16:11
  setOTup.mk2(15230702, 15, 23, 7, 2, 0.0, totalbts); //15:23_7:2
}

void mkrset() {

  ///// Rhythm Set 1 ///////////////////////////////////
  //int ix, int track
  setORhythmSetMkr.mk(1, 0);
  //int ix, float start, float end, int tuplet index
  setORhythmSetMkr.ad(1, 0.0, totalbts, 805);
  setORhythmSetMkr.ad(1, 0.0, totalbts, 611023017);

  ///// Rhythm Set 0 ///////////////////////////////////
  //int ix, int track
  setORhythmSetMkr.mk(0, 0);
  //int ix, float start, float end, int tuplet index
  setORhythmSetMkr.ad(0, 0.0, totalbts, 7);
  setORhythmSetMkr.ad(0, 0.0, totalbts, 70109014);


  ///// Rhythm Set 2 ///////////////////////////////////
  //int ix, int track
  setORhythmSetMkr.mk(2, 0);
  //int ix, float start, float end, int tuplet index
  setORhythmSetMkr.ad(2, 0.0, totalbts, 7);
  setORhythmSetMkr.ad(2, 0.0, totalbts, 1309);
  setORhythmSetMkr.ad(2, 0.0, totalbts, 435801611);

  ///// Rhythm Set 3 ///////////////////////////////////
  //int ix, int track
  setORhythmSetMkr.mk(3, 0);
  //int ix, float start, float end, int tuplet index
  setORhythmSetMkr.ad(3, 0.0, totalbts, 5);
  setORhythmSetMkr.ad(3, 0.0, totalbts, 1906);

  ///// Rhythm Set 4 ///////////////////////////////////
  //int ix, int track
  setORhythmSetMkr.mk(4, 0);
  //int ix, float start, float end, int tuplet index
  setORhythmSetMkr.ad(4, 0.0, totalbts, 2104);
  setORhythmSetMkr.ad(4, 0.0, totalbts, 9);
  setORhythmSetMkr.ad(4, 0.0, totalbts, 15230702);
}

void mkr() {
  //int ix, int track, 
  //String algorithim("5,3,4" - would be advance 5 partials, select that one, advance 3 partials, select, adv 4, select etc), 
  //int rhythmsetix(which rhythm set to grab from)
  //int ix, int tr, String al, int rhythmsetix
  setORhythmMkr.mk(0, 0, "5,3,9,11,2,7,4,8,2,3", 0); //33 partials
  setORhythmMkr.mk(1, 0, "2,3,1,4,1,3,2", 1); //15 partials sparce
  setORhythmMkr.mk(2, 0, "1,2,1,3,1,3,2,2,1,5", 1);// 18 partials med
  setORhythmMkr.mk(3, 0, "2,4,5,1,7,3", 3); //34 partials
  setORhythmMkr.mk(4, 0, "2,10,4,6,11,7,3,8,3", 4); //40 partials dense
  setORhythmMkr.mk(5, 0, "2,6,3,1,4,5", 2); //42 partials dense
  setORhythmMkr.mk(6, 0, "3,5,4,9,3,7,2,1", 0); //43 partials
  setORhythmMkr.mk(7, 0, "2,3,15,3,2,1,4,13,1,4,1,17", 0); //31 partials med
  setORhythmMkr.mk(8, 0, "5,4,15,3,5,24,4,1,19,2", 4); //29 partials med
  setORhythmMkr.mk(9, 0, "8,2,15,2,4,17,3,1", 2); // partials sparceish
  setORhythmMkr.mk(10, 0, "2,1,4,27,2,3,29,2,5,3,2,4,17,1,2,24", 3); //sparce
  setORhythmMkr.mk(11, 0, "5,4,35,3,5,4,7,62,70,3,100", 4); //29 partials med
  
  /////DUPLICATES
  setORhythmMkr.mk(1000, 0, "5,3,9,11,2,7,4,8,2,3", 0); //33 partials
  setORhythmMkr.mk(1001, 0, "2,3,1,4,1,3,2", 1); //15 partials sparce
  setORhythmMkr.mk(1002, 0, "1,2,1,3,1,3,2,2,1,5", 1);// 18 partials med
  setORhythmMkr.mk(1003, 0, "2,4,5,1,7,3", 3); //34 partials
  setORhythmMkr.mk(1004, 0, "2,10,4,6,11,7,3,8,3", 4); //40 partials dense
  setORhythmMkr.mk(1005, 0, "2,6,3,1,4,5", 2); //42 partials dense
  setORhythmMkr.mk(1006, 0, "3,5,4,9,3,7,2,1", 0); //43 partials
  setORhythmMkr.mk(1007, 0, "2,3,15,3,2,1,4,13,1,4,1,17", 0); //31 partials med
  setORhythmMkr.mk(1008, 0, "5,4,15,3,5,24,4,1,19,2", 4); //29 partials med
  setORhythmMkr.mk(1009, 0, "8,2,15,2,4,17,3,1", 2); // partials sparceish
  setORhythmMkr.mk(1010, 0, "2,1,4,27,2,3,29,2,5,3,2,4,17,1,2,24", 3); //sparce
  setORhythmMkr.mk(1011, 0, "5,4,35,3,5,4,7,62,70,3,100", 4); //29 partials med
}