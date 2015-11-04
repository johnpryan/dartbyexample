main() {
  for (var i in new Iterable.generate(1)) {
    print('not using "i"');
  }

  // using an underscore silences "local variable is not used"
  // warnings when running dartanalyzer
  for (var _ in new Iterable.generate(1)) {
    print('no warnings');
  }
}
