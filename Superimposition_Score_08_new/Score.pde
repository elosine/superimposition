void score(int sys) {
  switch(sys) {
    ////2 systems :30 INITIAL RHYTHMS WITH OPEN PITCH - Med-Sparce Density
  case 0:
    sys1clr();
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    break;
  case 1:
    sys2clr();
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    break;
  case 2:
    sys1clr();
    osc.send("/drh", new Object[]{7, 0, 1}, me);
    osc.send("/drh", new Object[]{8, 1, 1}, me);
    break;
  case 3:
    sys2clr();
    osc.send("/drh", new Object[]{3, 2, 1}, me);
    osc.send("/drh", new Object[]{0, 3, 1}, me);
    break;
  case 4: 
    sys1clr();
    osc.send("/drh", new Object[]{10, 0, 1}, me);
    osc.send("/mknotedrw", new Object[]{0, 10, 1}, me);
    break;
  case 5:
    sys2clr();
    osc.send("/drh", new Object[]{2, 2, 1}, me);
    osc.send("/mknotedrw", new Object[]{1, 2, 3}, me);
    break;
  case 6:
    sys1clr();
    osc.send("/drh", new Object[]{9, 0, 1}, me); 
    osc.send("/mknotedrw", new Object[]{2, 9, 1}, me);
    break;
  case 7: 
    sys2clr();
    osc.send("/drh", new Object[]{11, 2, 1}, me);
    osc.send("/mknotedrw", new Object[]{3, 11, 3}, me);
    break;
  case 8:
    sys1clr();
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/mknotedrw", new Object[]{4, 2, 1}, me);
    break;
  case 9: 
    sys2clr();
    osc.send("/drh", new Object[]{9, 2, 1}, me);
    osc.send("/mknotedrw", new Object[]{5, 9, 3}, me);
    break;
  case 10:
    sys1clr();
    osc.send("/drh", new Object[]{0, 0, 1}, me);
    osc.send("/drh", new Object[]{1, 1, 1}, me);
    break;
  case 11:
    sys2clr();
    osc.send("/drh", new Object[]{2, 2, 1}, me);
    osc.send("/drh", new Object[]{3, 3, 1}, me);
    break;
  case 12:
    sys1clr();
    osc.send("/drh", new Object[]{4, 0, 1}, me);
    osc.send("/drh", new Object[]{5, 1, 1}, me);
    break;
  case 13:
    sys2clr();
    osc.send("/drh", new Object[]{6, 2, 1}, me);
    osc.send("/drh", new Object[]{7, 3, 1}, me);
    break;
  case 14:
    sys1clr();
    osc.send("/drh", new Object[]{8, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    break;
  case 15:
    sys2clr();
    osc.send("/drh", new Object[]{10, 2, 1}, me);
    osc.send("/drh", new Object[]{11, 3, 1}, me);
    break;
  case 16:
    sys1clr();
    osc.send("/drh", new Object[]{4, 0, 1}, me);
    osc.send("/drh", new Object[]{5, 1, 1}, me);
    break;
  case 17:
    sys2clr();
    osc.send("/drh", new Object[]{6, 2, 1}, me);//IV - 8, system 2, Track 2
    osc.send("/drh", new Object[]{3, 3, 1}, me);
    break;
  case 18:
    sys1clr();
    break;
  }
}


void keyPressed() {
  if (key=='2') {
    score(scrn);
    scrn++;
    scrix = scrn;
  }
  if (key=='1') {
    score(scrn);
    scrn--;
    scrix = scrn;
  }
}

int scrn = 0;

void sys1clr() { 
  osc.send("/drh", new Object[]{2, 0, 0}, me);
  osc.send("/drh", new Object[]{9, 1, 0}, me);
  osc.send("/drh", new Object[]{7, 0, 0}, me);
  osc.send("/drh", new Object[]{8, 1, 0}, me);
  osc.send("/rmvnotedrw", new Object[]{0}, me);
  osc.send("/drh", new Object[]{10, 0, 0}, me);
  osc.send("/rmvnotedrw", new Object[]{2}, me);
  osc.send("/drh", new Object[]{9, 0, 0}, me);
  osc.send("/drh", new Object[]{2, 0, 0}, me);
  osc.send("/rmvnotedrw", new Object[]{4}, me);
  osc.send("/drh", new Object[]{ 9, 2, 0}, me);
  osc.send("/rmvnotedrw", new Object[]{5}, me);
  osc.send("/drh", new Object[]{0, 0, 0}, me);
  osc.send("/drh", new Object[]{1, 1, 0}, me);
  osc.send("/drh", new Object[]{4, 0, 0}, me);
  osc.send("/drh", new Object[]{5, 1, 0}, me);
  osc.send("/drh", new Object[]{8, 0, 0}, me);
  osc.send("/drh", new Object[]{9, 1, 0}, me);
  osc.send("/drh", new Object[]{4, 2, 0}, me);
  osc.send("/drh", new Object[]{5, 3, 0}, me);
}

void sys2clr() {
  osc.send("/drh", new Object[]{1009, 2, 0}, me);
  osc.send("/drh", new Object[]{1002, 3, 0}, me);
  osc.send("/drh", new Object[]{3, 2, 0}, me);
  osc.send("/drh", new Object[]{0, 3, 0}, me);
  osc.send("/rmvnotedrw", new Object[]{1}, me);
  osc.send("/drh", new Object[]{2, 2, 0}, me);
  osc.send("/rmvnotedrw", new Object[]{3}, me);
  osc.send("/drh", new Object[]{11, 2, 0}, me);
  osc.send("/drh", new Object[]{ 9, 2, 0}, me);
  osc.send("/rmvnotedrw", new Object[]{5}, me);
  osc.send("/drh", new Object[]{2, 2, 0}, me);
  osc.send("/drh", new Object[]{3, 3, 0}, me);
  osc.send("/drh", new Object[]{6, 2, 0}, me);
  osc.send("/drh", new Object[]{7, 3, 0}, me);
  osc.send("/drh", new Object[]{6, 2, 0}, me);
  osc.send("/drh", new Object[]{3, 3, 0}, me);
}