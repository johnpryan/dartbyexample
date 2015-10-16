import 'dart:async';

main() async {
  var stream = numbersDownFrom(5);
  await for (int i in stream) {
    print('$i bottles of beer');
  }
}

Stream<int> numbersDownFrom(int n) async* {
  while (n >= 0) {
    await new Future.delayed(new Duration(milliseconds: 100));
    yield n--;
  }
}
