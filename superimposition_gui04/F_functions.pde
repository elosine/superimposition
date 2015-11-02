int[] rmArrayIx_int( int [] ar, int remIndex ) {
    for ( int i = remIndex; i < ar.length - 1; i++ ) {
    ar[ i ] = ar[ i + 1 ] ;
  }
  ar = shorten(ar);
  return ar;
}

float[] rmArrayIx_float( float [] ar, int remIndex ) {
    for ( int i = remIndex; i < ar.length - 1; i++ ) {
    ar[ i ] = ar[ i + 1 ] ;
  }
  ar = shorten(ar);
  return ar;
}

String[] rmArrayIx_str( String [] ar, int remIndex ) {
    for ( int i = remIndex; i < ar.length - 1; i++ ) {
    ar[ i ] = ar[ i + 1 ] ;
  }
  ar = shorten(ar);
  return ar;
}