library cli_repl;

import 'dart:async';

import 'src/repl_adapter.dart';

class Repl {
  /// Text displayed when prompting the user for a new statement.
  String prompt;

  /// Text displayed at start of continued statement line.
  String continuation;

  /// Called when a newline is entered to determine whether the queue a
  /// completed statement or allow for a continuation.
  StatementValidator validator;

  Repl(
      {this.prompt: '',
      String? continuation,
      StatementValidator? validator,
      this.maxHistory: 50})
      : continuation = continuation ?? ' ' * prompt.length,
        validator = validator ?? alwaysValid {
    _adapter = new ReplAdapter(this);
  }

  late ReplAdapter _adapter;

  /// Run the REPL, yielding complete statements synchronously.
  Iterable<String> run() => _adapter.run();

  /// Run the REPL, yielding complete statements asynchronously.
  ///
  /// Note that the REPL will continue if you await in an "await for" loop.
  Stream<String> runAsync() => _adapter.runAsync();

  /// Kills and cleans up the REPL.
  FutureOr<void> exit() => _adapter.exit();

  /// History is by line, not by statement.
  ///
  /// The first item in the list is the most recent history item.
  List<String> history = [];

  /// Maximum history that will be kept in the list.
  ///
  /// Defaults to 50.
  int maxHistory;
}

/// Returns true if [text] is a complete statement or false otherwise.
typedef bool StatementValidator(String text);

final StatementValidator alwaysValid = (text) => true;
