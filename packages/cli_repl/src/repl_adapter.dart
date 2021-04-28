export 'repl_adapter/interface.dart'
    if (dart.library.io) 'repl_adapter/vm.dart'
    if (dart.library.js) 'repl_adapter/node.dart';
