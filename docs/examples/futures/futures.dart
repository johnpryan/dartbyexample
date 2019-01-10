import 'dart:async';

main() {

  // Passing a callback to then() will invoke
  // that callback when the future completes
  onReady.then((String status) {
    print(status);
  });

  // Futures can be chained:
  onReady
      .then(print)
      .then((_) => print('done!'));

  // Futures can throw errors:
  onReady.catchError(() {
    print('error!');
  });
}

Future<String> get onReady {
  var dur = new Duration(seconds: 1);
  var oneSecond = new Future.delayed(dur);

  // then() returns a new future that completes
  // with the value of the callback.
  return oneSecond.then((_) {
    return 'loaded!';
  });
}