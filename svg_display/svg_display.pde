

String svgspath;
File svgfolder;
PShape[] svgset;
IntDict svgnames;
float[][] svgwh; //width & height of svgPShape noteshape;

PShape noteshape;
int svgnum;
//String svgname = "Bartok_pizz.svg";
//String svgname = "tongueslap.svg";
//String svgname = "accent.svg";
//String svgname = "trill.svg"; //tremelo
//String svgname = "multi.svg"; //also slap strings
//String svgname = "harmonic.svg";
String svgname = "flz.svg";
float svgscale = 0.8;
float w, h;


void setup() {
  size(500, 500);

  svgnames = new IntDict();
  svgspath = sketchPath("svgs/");
  svgfolder = new File(svgspath);

  //Load SVGs from folder, store names in an IntDict
  if (svgfolder.exists() && svgfolder.isDirectory()) {
    svgset = new PShape[svgfolder.listFiles().length];
    svgwh = new float[svgfolder.listFiles().length][2];
    for (int i=0; i<svgfolder.listFiles ().length; i++) {
      if (!svgfolder.listFiles()[i].getName().equals(".DS_Store")) {
        svgset[i] = loadShape(svgfolder.listFiles()[i].getPath());
        svgnames.set(svgfolder.listFiles()[i].getName(), i);
        svgwh[i][0] = svgset[i].getWidth();
        svgwh[i][1] = svgset[i].getHeight();
      }
    }
  }
  svgnum = svgnames.get(svgname);
  noteshape = svgset[svgnum];
  w=svgwh[svgnum][0];
  h = svgwh[svgnum][1];
} //end setup

void draw() {
  //background(25, 33, 47);
  // background(255);
  background(0);

  shapeMode(CENTER);
  noteshape.disableStyle();
  stroke(255);
  strokeWeight(1);
  noFill();
  noStroke();
   fill(255);
  shape(noteshape, width/2, height/2, w*svgscale, h*svgscale);
}