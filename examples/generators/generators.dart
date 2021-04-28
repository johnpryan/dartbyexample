main() {
  evenNumbersDownFrom(7).forEach(print);
}

// sync* functions return an iterable
Iterable<int> evenNumbersDownFrom(int n) sync* {
  // the body isn't executed until an iterator invokes moveNext()
  int k = n;
  while (k >= 0) {
    if (k % 2 == 0) {
      // 'yield' suspends the function
      yield k;
    }
    k--;
  }

  // when the end of the function is executed,
  // there are no more values in the Iterable, and
  // moveNext() returns false to the caller
}
