void score(int sys) {
  switch(sys) {
    ////2 systems :30 INITIAL RHYTHMS WITH OPEN PITCH - Med-Sparce Density
  case 0:
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
    
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/drh", new Object[]{9, 1, 1}, me);
    break;
  case 1:
    osc.send("/drh", new Object[]{1009, 2, 1}, me);
    osc.send("/drh", new Object[]{1002, 3, 1}, me);
    break;

  case 2:
    osc.send("/drh", new Object[]{2, 0, 0}, me);
    osc.send("/drh", new Object[]{9, 1, 0}, me);
    //turn on section 2
    osc.send("/drh", new Object[]{7, 0, 1}, me);
    osc.send("/drh", new Object[]{8, 1, 1}, me);
    break;
  case 3:
    osc.send("/drh", new Object[]{1009, 2, 0}, me);
    osc.send("/drh", new Object[]{1002, 3, 0}, me);
    //turn on section 2
    osc.send("/drh", new Object[]{3, 2, 1}, me);
    osc.send("/drh", new Object[]{0, 3, 1}, me);
    break;

  case 4: 
    //SECTION III - UNISONS AND SUSTAINED NOTES, 3 PAGES 1:30 //sparce rhythm, several sustains, a few articulations, smooth dynamics, pitch range w/outliers, single pitch class - 4 rhythm sets, repeat 2 everything else same - 9, 2, generate 2 more //13 - System 1
    osc.send("/drh", new Object[]{7, 0, 0}, me);
    osc.send("/drh", new Object[]{8, 1, 0}, me);
    osc.send("/drh", new Object[]{10, 0, 1}, me);
    osc.send("/mknotedrw", new Object[]{0, 10, 1}, me);
    break;
  case 5://System 2
    osc.send("/drh", new Object[]{3, 2, 0}, me);
    osc.send("/drh", new Object[]{0, 3, 0}, me);
    osc.send("/drh", new Object[]{2, 2, 1}, me);
    osc.send("/mknotedrw", new Object[]{1, 2, 3}, me);
    break;
  case 6://14 - System 1 off
    osc.send("/rmvnotedrw", new Object[]{0}, me);
    osc.send("/drh", new Object[]{10, 0, 0}, me);
    //14 - System 1
    osc.send("/drh", new Object[]{9, 0, 1}, me); 
    osc.send("/mknotedrw", new Object[]{2, 9, 1}, me);
    break;
  case 7: //System 2 - off
    osc.send("/rmvnotedrw", new Object[]{1}, me);
    osc.send("/drh", new Object[]{2, 2, 0}, me);
    //System 2
    osc.send("/drh", new Object[]{11, 2, 1}, me);
    osc.send("/mknotedrw", new Object[]{3, 11, 3}, me);
    break;
  case 8:
    //15 - System 1 - off
    osc.send("/rmvnotedrw", new Object[]{2}, me);
    osc.send("/drh", new Object[]{9, 0, 0}, me);
    //15 - System 1
    osc.send("/drh", new Object[]{2, 0, 1}, me);
    osc.send("/mknotedrw", new Object[]{4, 2, 1}, me);
    break;
  case 9: 
    //System 2 - off
    osc.send("/rmvnotedrw", new Object[]{3}, me);
    osc.send("/drh", new Object[]{11, 2, 0}, me);
    //System 2
    osc.send("/drh", new Object[]{9, 2, 1}, me);
    osc.send("/mknotedrw", new Object[]{5, 9, 3}, me);
    break;
  case 10:
    osc.send("/drh", new Object[]{2, 0, 0}, me);
    osc.send("/rmvnotedrw", new Object[]{4}, me);
    //IV - 1, system 1, Track 1
    osc.send("/drh", new Object[]{0, 0, 1}, me);
    osc.send("/drh", new Object[]{1, 1, 1}, me);
    break;
  case 11:
    //IV - 2, system 2, Track 1 - off
    osc.send("/drh", new Object[]{ 9, 2, 0}, me);
    osc.send("/rmvnotedrw", new Object[]{5}, me);
    //IV - 2, system 2, Track 1
    osc.send("/drh", new Object[]{2, 2, 1}, me);
    osc.send("/drh", new Object[]{3, 3, 1}, me);
    break;
  case 12:
    //IV - 3, system 1, Track 1 - off
    osc.send("/drh", new Object[]{0, 0, 0}, me);
    osc.send("/drh", new Object[]{1, 1, 0}, me);
    //IV - 3, system 1, Track 1
    osc.send("/drh", new Object[]{4, 0, 1}, me);
    osc.send("/drh", new Object[]{5, 1, 1}, me);
    break;
  case 13:
    //IV - 4, system 2, Track 1 - off
    osc.send("/drh", new Object[]{2, 2, 0}, me);
    osc.send("/drh", new Object[]{3, 3, 0}, me);
    osc.send("/drh", new Object[]{6, 2, 1}, me);
    osc.send("/drh", new Object[]{7, 3, 1}, me);
    break;
  case 14:
    //IV - 5, system 1, Track 1 - off
    osc.send("/drh", new Object[]{4, 0, 0}, me);
    osc.send("/drh", new Object[]{5, 1, 0}, me);
    //IV - 5, system 1, Track 1
    osc.send("/drh", new Object[]{8, 0, 1}, me);

    osc.send("/drh", new Object[]{9, 1, 1}, me);
    break;
  case 15:
    //IV - 6, system 2, Track 1 - off
    osc.send("/drh", new Object[]{6, 2, 0}, me);
    osc.send("/drh", new Object[]{7, 3, 0}, me);
    osc.send("/drh", new Object[]{10, 2, 1}, me);

    osc.send("/drh", new Object[]{11, 3, 1}, me);
    break;
  case 16:
    //IV - 7, system 1, Track 1 - off
    osc.send("/drh", new Object[]{8, 0, 0}, me);
    osc.send("/drh", new Object[]{9, 1, 0}, me);
    osc.send("/drh", new Object[]{4, 0, 1}, me);

    osc.send("/drh", new Object[]{5, 1, 1}, me);
    break;
  case 17:
    //IV - 8, system 2, Track 1 - off
    osc.send("/drh", new Object[]{10, 2, 0}, me);
    osc.send("/drh", new Object[]{11, 3, 0}, me);
    //IV - 8, system 2, Track 1
    osc.send("/drh", new Object[]{6, 2, 1}, me);//IV - 8, system 2, Track 2
    osc.send("/drh", new Object[]{3, 3, 1}, me);
    break;
  case 18:
    //system 1 off
    osc.send("/drh", new Object[]{4, 2, 0}, me);
    osc.send("/drh", new Object[]{5, 3, 0}, me);
    //system 2 off 
    osc.send("/drh", new Object[]{6, 2, 0}, me);
    osc.send("/drh", new Object[]{3, 3, 0}, me);
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