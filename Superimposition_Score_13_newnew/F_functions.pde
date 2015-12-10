//REMOVE MEMBER OF AN ARRAY BY INDEX NUMBER

int[] rmArrayIx_int( int [] array, int remIndex ) {
  int[]ar = new int[array.length];
  arrayCopy(array, ar);
  for ( int i = remIndex; i < ar.length - 1; i++ ) {
    ar[ i ] = ar[ i + 1 ] ;
  }
  ar = shorten(ar);
  return ar;
}

float[] rmArrayIx_float( float [] array, int remIndex ) {
  float[]ar = array;
  for ( int i = remIndex; i < ar.length - 1; i++ ) {
    ar[ i ] = ar[ i + 1 ] ;
  }
  ar = shorten(ar);
  return ar;
}

String[] rmArrayIx_str( String [] array, int remIndex ) {
  String[]ar = array;
  for ( int i = remIndex; i < ar.length - 1; i++ ) {
    ar[ i ] = ar[ i + 1 ] ;
  }
  ar = shorten(ar);
  return ar;
}


//RANDOMLY SHUFFLE AN ARRAY
int[] shuffleIntArray(int[] array) {
  int[]ats = array;
  // with code from WikiPedia; Fisher–Yates shuffle 
  //@ <a href="http://en.wikipedia.org/wiki/Fisher" target="_blank" rel="nofollow">http://en.wikipedia.org/wiki/Fisher</a>–Yates_shuffle
  Random rng = new Random();
  // i is the number of items remaining to be shuffled.
  for (int i = ats.length; i > 1; i--) {
    // Pick a random element to swap with the i-th element.
    int j = rng.nextInt(i);  // 0 <= j <= i-1 (0-based array)
    // Swap array elements.
    int tmp = ats[j];
    ats[j] = ats[i-1];
    ats[i-1] = tmp;
  }
  return ats;
}
String[] shuffleStrArray(String[] array) {
  String[]ats = array;
  // with code from WikiPedia; Fisher–Yates shuffle 
  //@ <a href="http://en.wikipedia.org/wiki/Fisher" target="_blank" rel="nofollow">http://en.wikipedia.org/wiki/Fisher</a>–Yates_shuffle
  Random rng = new Random();
  // i is the number of items remaining to be shuffled.
  for (int i = ats.length; i > 1; i--) {
    // Pick a random element to swap with the i-th element.
    int j = rng.nextInt(i);  // 0 <= j <= i-1 (0-based array)
    // Swap array elements.
    String tmp = ats[j];
    ats[j] = ats[i-1];
    ats[i-1] = tmp;
  }
  return ats;
}

int chooseInt(int[]set){
  int v = set[floor(random(set.length))];
  return v;
}