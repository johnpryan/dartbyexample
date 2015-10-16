import 'dart:async';

main() async {
  await for (String msg in printNumbersDownAsync(5)) {
    print(msg);
  }
}

Stream<String> printNumbersDownAsync(int n) async* {

  int k = n;
  while (k >= 0) {
    yield await loadMessageForNumber(k--);
  }
}

Future<String> loadMessageForNumber(int i) async {
  await new Future.delayed(new Duration(milliseconds: 50));
  if (i % 2 == 0) {
    return '$i is even';
  } else {
    return '$i is odd';
  }
}