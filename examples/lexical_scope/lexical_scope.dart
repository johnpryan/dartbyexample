main() {
  var functions = [];

  for (var i = 0; i < 3; i++) {
    functions.add(() => i);
  }

  functions.forEach((fn) => print(fn()));

}
