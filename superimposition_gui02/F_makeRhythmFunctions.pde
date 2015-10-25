void maketuplets(){
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
  
  setOTup.mk1(703, 3, 7, 0.0, totalbts); //7:3
  setOTup.mk1(1109, 11,9, 0.0, totalbts); //11:9
  setOTup.mk1(1304, 13,4, 0.0, totalbts); //13:4
  setOTup.mk1(805, 8,5, 0.0, totalbts); //8:5
  setOTup.mk1(1309, 13,9, 0.0, totalbts); //13:9
  setOTup.mk1(1708, 17,8, 0.0, totalbts); //17:8
  setOTup.mk1(1906, 19,6, 0.0, totalbts); //19:6
  setOTup.mk1(21013, 21,13, 0.0, totalbts); //21:13
  setOTup.mk1(509, 5,9, 0.0, totalbts); //5:9
  setOTup.mk1(15023, 15,23, 0.0, totalbts); //15:23
  
  //Double Nested
  setOTup.mk2(70109014, 7, 1, 9, 14, 0.0, totalbts); //7:1_9:14
}

void mkrset(){
  setORhythmSetMkr.mk(0, 0);
  setORhythmSetMkr.ad(0, 0.0, totalbts, 7);
  setORhythmSetMkr.ad(0, 0.0, totalbts, 70109014);
}

void mkr(){
  setORhythmMkr.mk(0, 0, "5,3,9,11,2,7,4, 8, 2,3", 0);
}