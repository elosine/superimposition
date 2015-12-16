class Arts {
  int ix;
  float x, y;
  Arts(int aix, float ax, float ay) {
    ix=aix;
    x=ax;
    y=ay+35;

    osc.send("/mksvg", new Object[]{0+(ix*100), "trill.svg", x, y}, me);
    osc.send("/mksvg", new Object[]{1+(ix*100), "tongueslap.svg", x+40, y}, me);
    osc.send("/mksvg", new Object[]{10+(ix*100), "Bartok_pizz.svg", x+40, y}, me);
    osc.send("/mksvg", new Object[]{2+(ix*100), "multi.svg", x+80, y+10}, me);
    osc.send("/mksvg", new Object[]{3+(ix*100), "flz.svg", x+120, y}, me);
    osc.send("/mksvg", new Object[]{11+(ix*100), "harmonic.svg", x+120, y}, me);
    clr();
  }
  void mode(String ar) {
    if (ar.equals("none")) clr();
    else {
      String[]ars = split(ar, ':');
      int[]ari=new int[0];
      for (int i=0; i<ars.length; i++)ari = append(ari, int(ars[i]));
      clr();
      for (int i=0; i<ari.length; i++) osc.send("/drsvg", new Object[]{ari[i]+(ix*100), 1}, me);
    }
  }
  void clr() {
    osc.send("/drsvg", new Object[]{0+(ix*100), 0}, me);
    osc.send("/drsvg", new Object[]{1+(ix*100), 0}, me);
    osc.send("/drsvg", new Object[]{2+(ix*100), 0}, me);
    osc.send("/drsvg", new Object[]{3+(ix*100), 0}, me);
    osc.send("/drsvg", new Object[]{10+(ix*100), 0}, me);
    osc.send("/drsvg", new Object[]{11+(ix*100), 0}, me);
  }
  //
}