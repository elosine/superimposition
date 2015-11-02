float[] tup1(int nbts, int div, float startbt, float end) {
  float[] set = new float[0];
  float inc =  (btw*nbts)/div ;
  float rx = startbt;
  while (rx<(end*btw)) {
    set = append(set, rx);
    rx = rx + inc;
  }
  //println(set);
  return set;
}

float[] tup2(int nbts1, int div1, int nbts2, int div2, float startbt, float end) {
  float[] set = new float[0];
  float[] set0 = new float[0];
  float inc =  (btw*nbts1)/div1 ;
  float rx = 0;
  while (rx<w) {
    //println(rx);
    set0 = append(set0, rx);
    rx = rx + inc;
  }
  
  float btw2 = set0[1]-set0[0];
 // println(set0);
  
  float inc2 = round( (btw2*nbts2)/div2 );
  float rx2 = startbt;
  while (rx2<(end*btw)) {
    set = append(set, rx2);
    rx2 = rx2 + inc2;
  }
  
  return set;
}