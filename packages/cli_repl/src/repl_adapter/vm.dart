import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';

import '../../cli_repl.dart';
import 'codes.dart';

class ReplAdapter {
  Repl repl;

  ReplAdapter(this.repl);

  Iterable<String> run() sync* {
    try {
      // Try to set up for interactive session
      stdin.echoMode = false;
      stdin.lineMode = false;
    } on StdinException {
      // If it can't, print both input and prompts (useful for testing)
      yield* linesToStatements(inputLines());
      return;
    }
    while (true) {
      try {
        var result = readStatement();
        if (result == null) {
          print("");
          break;
        }
        yield result;
      } on Exception catch (e) {
        print(e);
      }
    }
    exit();
  }

  Iterable<String> inputLines() sync* {
    while (true) {
      try {
        String? line = stdin.readLineSync();
        if (line == null) break;
        yield line;
      } on StdinException {
        break;
      }
    }
  }

  Stream<String> runAsync() {
    bool interactive = true;
    try {
      stdin.echoMode = false;
      stdin.lineMode = false;
    } on StdinException {
      interactive = false;
    }

    late StreamController<String> controller;
    controller = StreamController(
        onListen: () async {
          try {
            var charQueue =
                this.charQueue = StreamQueue<int>(stdin.expand((data) => data));
            while (true) {
              if (!interactive && !(await charQueue.hasNext)) {
                this.charQueue = null;
                controller.close();
                return;
              }

              var result = await _readStatementAsync(charQueue);
              if (result == null) {
                print("");
                break;
              }
              controller.add(result);
            }
          } catch (error, stackTrace) {
            controller.addError(error, stackTrace);
            await exit();
            controller.close();
          }
        },
        onCancel: exit,
        sync: true);

    return controller.stream;
  }

  FutureOr<void> exit() {
    try {
      stdin.lineMode = true;
      stdin.echoMode = true;
    } on StdinException {}

    var future = charQueue?.cancel(immediate: true);
    charQueue = null;
    return future;
  }

  Iterable<String> linesToStatements(Iterable<String> lines) sync* {
    String previous = "";
    for (var line in lines) {
      write(previous == "" ? repl.prompt : repl.continuation);
      previous += line;
      stdout.writeln(line);
      if (repl.validator(previous)) {
        yield previous;
        previous = "";
      } else {
        previous += '\n';
      }
    }
  }

  StreamQueue<int>? charQueue;

  List<int> buffer = [];
  int cursor = 0;

  setCursor(int c) {
    if (c < 0) {
      c = 0;
    } else if (c > buffer.length) {
      c = buffer.length;
    }
    moveCursor(c - cursor);
    cursor = c;
  }

  write(String text) {
    stdout.write(text);
  }

  writeChar(int char) {
    stdout.writeCharCode(char);
  }

  int historyIndex = -1;
  String currentSaved = "";

  String previousLines = "";
  bool inContinuation = false;

  String? readStatement() {
    startReadStatement();
    while (true) {
      int char = stdin.readByteSync();
      if (char == eof && buffer.isEmpty) return null;
      if (char == escape) {
        var char = stdin.readByteSync();
        if (char == c('[') || char == c('O')) {
          var ansi = stdin.readByteSync();
          if (!handleAnsi(ansi)) {
            write('^[');
            input(char);
            input(ansi);
          }
          continue;
        }
        write('^[');
      }
      var result = processCharacter(char);
      if (result != null) return result;
    }
  }

  Future<String?> _readStatementAsync(StreamQueue<int> charQueue) async {
    startReadStatement();
    while (true) {
      int char = await charQueue.next;
      if (char == eof && buffer.isEmpty) return null;
      if (char == escape) {
        char = await charQueue.next;
        if (char == c('[') || char == c('O')) {
          var ansi = await charQueue.next;
          if (!handleAnsi(ansi)) {
            write('^[');
            input(char);
            input(ansi);
          }
          continue;
        }
        write('^[');
      }
      var result = processCharacter(char);
      if (result != null) return result;
    }
  }

  void startReadStatement() {
    write(repl.prompt);
    buffer.clear();
    cursor = 0;
    historyIndex = -1;
    currentSaved = "";
    inContinuation = false;
    previousLines = "";
  }

  List<int> yanked = [];

  String? processCharacter(int char) {
    switch (char) {
      case eof:
        if (cursor != buffer.length) delete(1);
        break;
      case clear:
        clearScreen();
        break;
      case backspace:
        if (cursor > 0) {
          setCursor(cursor - 1);
          delete(1);
        }
        break;
      case killToEnd:
        yanked = delete(buffer.length - cursor);
        break;
      case killToStart:
        int oldCursor = cursor;
        setCursor(0);
        yanked = delete(oldCursor);
        break;
      case yank:
        yanked.forEach(input);
        break;
      case startOfLine:
        setCursor(0);
        break;
      case endOfLine:
        setCursor(buffer.length);
        break;
      case forward:
        setCursor(cursor + 1);
        break;
      case backward:
        setCursor(cursor - 1);
        break;
      case carriageReturn:
      case newLine:
        String contents = new String.fromCharCodes(buffer);
        setCursor(buffer.length);
        input(char);
        if (repl.history.isEmpty || contents != repl.history.first) {
          repl.history.insert(0, contents);
        }
        while (repl.history.length > repl.maxHistory) {
          repl.history.removeLast();
        }
        if (char == carriageReturn) {
          write('\n');
        }
        if (repl.validator(previousLines + contents)) {
          return previousLines + contents;
        }
        previousLines += contents + '\n';
        buffer.clear();
        cursor = 0;
        inContinuation = true;
        write(repl.continuation);
        break;
      default:
        input(char);
        break;
    }
    return null;
  }

  input(int char) {
    buffer.insert(cursor++, char);
    write(new String.fromCharCodes(buffer.skip(cursor - 1)));
    moveCursor(-(buffer.length - cursor));
  }

  List<int> delete(int amount) {
    if (amount <= 0) return [];
    int wipeAmount = buffer.length - cursor;
    if (amount > wipeAmount) amount = wipeAmount;
    write(' ' * wipeAmount);
    moveCursor(-wipeAmount);
    var result = buffer.sublist(cursor, cursor + amount);
    for (int i = 0; i < amount; i++) {
      buffer.removeAt(cursor);
    }
    write(new String.fromCharCodes(buffer.skip(cursor)));
    moveCursor(-(buffer.length - cursor));
    return result;
  }

  replaceWith(String text) {
    moveCursor(-cursor);
    write(' ' * buffer.length);
    moveCursor(-buffer.length);
    write(text);
    buffer.clear();
    buffer.addAll(text.codeUnits);
    cursor = buffer.length;
  }

  bool handleAnsi(int char) {
    switch (char) {
      case arrowLeft:
        setCursor(cursor - 1);
        return true;
      case arrowRight:
        setCursor(cursor + 1);
        return true;
      case arrowUp:
        if (historyIndex + 1 < repl.history.length) {
          if (historyIndex == -1) {
            currentSaved = new String.fromCharCodes(buffer);
          } else {
            repl.history[historyIndex] = new String.fromCharCodes(buffer);
          }
          replaceWith(repl.history[++historyIndex]);
        }
        return true;
      case arrowDown:
        if (historyIndex > 0) {
          repl.history[historyIndex] = new String.fromCharCodes(buffer);
          replaceWith(repl.history[--historyIndex]);
        } else if (historyIndex == 0) {
          historyIndex--;
          replaceWith(currentSaved);
        }
        return true;
      case home:
        setCursor(0);
        return true;
      case end:
        setCursor(buffer.length);
        return true;
      default:
        return false;
    }
  }

  moveCursor(int amount) {
    if (amount == 0) return;
    int amt = amount < 0 ? -amount : amount;
    String dir = amount < 0 ? 'D' : 'C';
    write('$ansiEscape[$amt$dir');
  }

  clearScreen() {
    write('$ansiEscape[2J'); // clear
    write('$ansiEscape[H'); // return home
    write(inContinuation ? repl.continuation : repl.prompt);
    write(new String.fromCharCodes(buffer));
    moveCursor(cursor - buffer.length);
  }
}
