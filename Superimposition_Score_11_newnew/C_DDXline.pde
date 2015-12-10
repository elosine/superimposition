class DDXline{
  int x1=0;
  int y=0;
  int w=width;
  int h=5;
  int mode=0;
  int gap=5;
  int n = 0;
  int[] x;
  String clr;
  
 DDXline(int ax1, int ay, int aw, int ah, int amode, int agap, String aclr){
    x1=ax1;
    y=ay;
    w=aw;
    h=ah;
    mode=amode;
    gap=agap;
    clr = aclr;
    n=ceil(w/(h+gap));
    x = new int[0];
   for(int i=0;i<n;i++) x = append( x, x1+(i*(gap+h)) );
  }
  
  void drw(){
     noStroke();
     fill(unhex(clr));
     ellipseMode(CORNER);
     rectMode(CORNER);
    switch(mode){
     case 0: //Solid
     rect(x1, y, w, h);
     break;
     case 1: //Dotted
     for(int i=0;i<n;i++) ellipse(x[i], y, h,h);
     break;
     case 2: //Dashed
     for(int i=0;i<n;i++) rect(x[i], y, h,h);
     break;
     case 3: //Dash-Dot
     for(int i=0;i<n;i++){
      if(i%2==0) rect(x[i], y, h,h);
      else ellipse(x[i], y, h,h);
     }
     break;
    }
  }
}