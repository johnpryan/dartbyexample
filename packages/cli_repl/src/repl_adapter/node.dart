import 'dart:async';

import 'package:async/async.dart';
import 'package:js/js.dart';

import '../../cli_repl.dart';

class ReplAdapter {
  Repl repl;

  ReplAdapter(this.repl);

  Iterable<String> run() sync* {
    throw new UnsupportedError('Synchronous REPLs not supported in Node');
  }

  ReadlineInterface? rl;

  Stream<String> runAsync() {
    var output = stdinIsTTY ? stdout : null;
    var rl = this.rl = readline.createInterface(
        new ReadlineOptions(input: stdin, output: output, prompt: repl.prompt));
    var statement = "";
    var prompt = repl.prompt;

    late StreamController<String> runController;
    runController = StreamController<String>(
        onListen: () async {
          try {
            var lineController = StreamController<String>();
            var lineQueue = StreamQueue<String>(lineController.stream);
            rl.on('line',
                allowInterop((value) => lineController.add(value as String)));

            while (true) {
              if (stdinIsTTY) stdout.write(prompt);
              var line = await lineQueue.next;
              if (!stdinIsTTY) print('$prompt$line');
              statement += line;
              if (repl.validator(statement)) {
                runController.add(statement);
                statement = "";
                prompt = repl.prompt;
                rl.setPrompt(repl.prompt);
              } else {
                statement += '\n';
                prompt = repl.continuation;
                rl.setPrompt(repl.continuation);
              }
            }
          } catch (error, stackTrace) {
            runController.addError(error, stackTrace);
            await exit();
            runController.close();
          }
        },
        onCancel: exit);

    return runController.stream;
  }

  FutureOr<void> exit() {
    rl?.close();
    rl = null;
  }
}

@JS('require')
external ReadlineModule require(String name);

final readline = require('readline');

bool get stdinIsTTY => stdin.isTTY ?? false;

@JS('process.stdin')
external Stdin get stdin;

@JS()
class Stdin {
  external bool? get isTTY;
}

@JS('process.stdout')
external Stdout get stdout;

@JS()
class Stdout {
  external void write(String data);
}

@JS()
class ReadlineModule {
  external ReadlineInterface createInterface(ReadlineOptions options);
}

@JS()
@anonymous
class ReadlineOptions {
  external get input;
  external get output;
  external String get prompt;
  external factory ReadlineOptions({input, output, String? prompt});
}

@JS()
class ReadlineInterface {
  external void on(String event, void callback(object));
  external void question(String prompt, void callback(object));
  external void close();
  external void pause();
  external void setPrompt(String prompt);
}
