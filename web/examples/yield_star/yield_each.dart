import 'dart:async';

main() async {
  await for (int i in numbersDownFrom(5)) {
    print('$i bottles of beer');
  }
}

Stream<int> numbersDownFrom(int n) async* {
  if (n >= 0) {
    await new Future.delayed(new Duration(milliseconds: 100));
    yield n;
    yield* numbersDownFrom(n - 1);
  }
}
