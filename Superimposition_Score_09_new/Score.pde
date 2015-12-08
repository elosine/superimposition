void score(int sys) {
  switch(sys) {
    ////2 systems :30 INITIAL RHYTHMS WITH OPEN PITCH - Med-Sparce Density
  case 0:
    sys1clr();
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    scrix = sys;
    break;
  case 1:
    sys2clr();
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    scrix = sys;
    break;
  case 2:
    sys1clr();
    osc.send("/drh", new Object[]{7, 0, 1}, me);
    osc.send("/drh", new Object[]{8, 1, 1}, me);
    scrix = sys;
    break;
  case 3:
    sys2clr();
    osc.send("/drh", new Object[]{3, 2, 1}, me);
    osc.send("/drh", new Object[]{1000, 3, 1}, me);
    scrix = sys;
    break;
  case 4: 
    sys1clr();
    osc.send("/drh", new Object[]{10, 0, 1}, me);
    osc.send("/mknotedrw", new Object[]{0, 10, 1}, me);
    scrix = sys;
    break;
  case 5:
    sys2clr();
    osc.send("/drh", new Object[]{1002, 2, 1}, me);
    osc.send("/mknotedrw", new Object[]{1, 2, 3}, me);
    scrix = sys;
    break;
  case 6:
    sys1clr();
    osc.send("/drh", new Object[]{9, 0, 1}, me); 
    osc.send("/mknotedrw", new Object[]{2, 9, 1}, me);
    scrix = sys;
    break;
  case 7: 
    sys2clr();
    osc.send("/drh", new Object[]{11, 2, 1}, me);
    osc.send("/mknotedrw", new Object[]{3, 11, 3}, me);
    scrix = sys;
    break;
  case 8:
    sys1clr();
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/mknotedrw", new Object[]{4, 2, 1}, me);
    scrix = sys;
    break;
  case 9: 
    sys2clr();
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/mknotedrw", new Object[]{5, 9, 3}, me);
    scrix = sys;
    break;
  case 10:
    sys1clr();
    osc.send("/drh", new Object[]{0, 0, 1}, me);
    osc.send("/drh", new Object[]{1, 1, 1}, me);
    scrix = sys;
    break;
  case 11:
    sys2clr();
    osc.send("/drh", new Object[]{1002, 2, 1}, me);
    osc.send("/drh", new Object[]{3, 3, 1}, me);
    scrix = sys;
    break;
  case 12:
    sys1clr();
    osc.send("/drh", new Object[]{4, 0, 1}, me);
    osc.send("/drh", new Object[]{5, 1, 1}, me);
    scrix = sys;
    break;
  case 13:
    sys2clr();
    osc.send("/drh", new Object[]{6, 2, 1}, me);
    osc.send("/drh", new Object[]{1007, 3, 1}, me);
    scrix = sys;
    break;
  case 14:
    sys1clr();
    osc.send("/drh", new Object[]{8, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    scrix = sys;
    break;
  case 15:
    sys2clr();
    osc.send("/drh", new Object[]{1010, 2, 1}, me);
    osc.send("/drh", new Object[]{11, 3, 1}, me);
    scrix = sys;
    break;
  case 16:
    sys1clr();
    osc.send("/drh", new Object[]{4, 0, 1}, me);
    osc.send("/drh", new Object[]{5, 1, 1}, me);
    scrix = sys;
    break;
  case 17:
    sys2clr();
    osc.send("/drh", new Object[]{6, 2, 1}, me);//IV - 8, system 2, Track 2
    osc.send("/drh", new Object[]{3, 3, 1}, me);
    scrix = sys;
    break;
  case 18:
    sys1clr();
    sys2clr();
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