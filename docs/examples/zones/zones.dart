import 'dart:async';

main() {
  // All Dart programs implicitly run in a root zone.
  // runZoned creates a new zone.  The new zone is a child of the root zone.
  runZoned(() async {
    await runServer();
  },
  // Any uncaught errors in the child zone are sent to the [onError] handler.
      onError: (e, stacktrace) {
    print('caught: $e');
  },
  // a ZoneSpecification allows for overriding functionality, like print()
    zoneSpecification: new ZoneSpecification(print: (Zone self, ZoneDelegate parent, Zone zone, String message) {
      parent.print(zone, '${new DateTime.now()}: $message');
    })
  );
}

Future runServer() async {
  await for (var r in requests()) {
    print('received request: $r');
    if (r == 'bar') throw('unrecognized request: $r');
  }
}

Stream<String> requests() async* {
  var dur = new Duration(milliseconds: 100);

  await new Future.delayed(dur);
  yield 'foo';

  await new Future.delayed(dur);
  yield 'bar';
}