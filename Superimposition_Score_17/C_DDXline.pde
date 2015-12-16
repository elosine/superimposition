class DDXline {
  float x1=0;
  float y=0;
  float y2;
  float w=width;
  float h=5;
  int mode=0;
  float gap=5;
  int n = 0;
  float[] x;
  String clr;

  DDXline(float ax1, float ay, float aw, float ah, int amode, float agap, String aclr) {
    x1=ax1;
    y=ay;
    w=aw;
    h=ah;
    mode=amode;
    gap=agap;
    clr = aclr;
    y2 = y+(h/2.0);
    n=ceil(w/gap);
    x = new float[0];
    for (int i=0; i<n; i++) x = append( x, x1+(i*gap) );
  }

  void drw() {
    noStroke();
    fill(unhex(clr));
    ellipseMode(CENTER);
    rectMode(CENTER);
    switch(mode) {
    case 0: //Solid
      rectMode(CORNER);
      rect(x1, y, w, h);
      break;
    case 1: //Dotted
      for (int i=0; i<n; i++) ellipse(x[i], y2, h, h);
      break;
    case 2: //Dashed
      for (int i=0; i<n; i++) rect(x[i], y2, h, h);
      break;
    case 3: //Dash-Dot
      for (int i=0; i<n; i++) {
        if (i%2==0) rect(x[i], y2, h, h);
        else ellipse(x[i], y2, h, h);
      }
      break;
    }
  }
}