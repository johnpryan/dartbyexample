main() {
  var iter = [1,5,10].iterator;
  while(iter.moveNext()) {
    print(iter.current);
  }

  var iterable = new Iterable.generate(3);
  var iter2 = iterable.map((n) => n*2).iterator;
  while(iter2.moveNext()) {
    print(iter2.current);
  }
}
