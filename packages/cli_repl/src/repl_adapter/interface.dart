import 'dart:async';

import '../../cli_repl.dart';

class ReplAdapter {
  Repl repl;

  ReplAdapter(this.repl);

  Iterable<String> run() sync* {}

  Stream<String> runAsync() async* {}

  FutureOr<void> exit() {}
}
