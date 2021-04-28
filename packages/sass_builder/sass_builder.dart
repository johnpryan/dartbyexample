import 'dart:async';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;
import 'package:sass/sass.dart' as sass;

import 'src/build_importer.dart';

final outputStyleKey = 'outputStyle';

Builder sassBuilder(BuilderOptions options) =>
    new SassBuilder(outputStyle: options.config[outputStyleKey]);

PostProcessBuilder sassSourceCleanup(BuilderOptions options) =>
    new FileDeletingBuilder(['.scss', '.sass'],
        isEnabled: (options.config['enabled'] as bool) ?? false);

/// A `Builder` to compile `.css` files from `.scss` or `.sass` source using
/// the dart implementation of Sass.
class SassBuilder implements Builder {
  static final _defaultOutputStyle = sass.OutputStyle.expanded;
  final String _outputExtension;
  final String _outputStyle;

  SassBuilder({String outputExtension: '.css', String outputStyle})
      : this._outputExtension = outputExtension,
        this._outputStyle = outputStyle ?? _defaultOutputStyle.toString();

  @override
  Future build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;

    if (p.basename(inputId.path).startsWith('_')) {
      // Do not produce any output for .scss partials.
      log.fine('skipping partial file: ${inputId}');
      return;
    }

    // Compile the css.
    log.fine('compiling file: ${inputId.uri.toString()}');
    final cssOutput = await sass.compileStringAsync(
        await buildStep.readAsString(inputId),
        syntax: sass.Syntax.forPath(inputId.path),
        importers: [new BuildImporter(buildStep)],
        style: _getValidOutputStyle());

    // Write the builder output.
    final outputId = inputId.changeExtension(_outputExtension);
    await buildStep.writeAsString(outputId, '${cssOutput}\n');
    log.fine('wrote css file: ${outputId.path}');
  }

  /// Returns a valid `OutputStyle` value to the `style` argument of
  /// [sass.compileString] during a [build].
  ///
  /// * If [_outputStyle] is not `OutputStyle.compressed` or
  /// `OutputStyle.expanded`, a warning will be logged informing the user
  /// that the [_defaultOutputStyle] will be used.
  sass.OutputStyle _getValidOutputStyle() {
    if (_outputStyle == sass.OutputStyle.compressed.toString()) {
      return sass.OutputStyle.compressed;
    } else if (_outputStyle == sass.OutputStyle.expanded.toString()) {
      return sass.OutputStyle.expanded;
    } else {
      log.warning('Unknown outputStyle provided: "$_outputStyle". '
          'Supported values are: "expanded" and "compressed". The default '
          'value of "${_defaultOutputStyle.toString()}" will be used.');
      return _defaultOutputStyle;
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.scss': [_outputExtension],
        '.sass': [_outputExtension],
      };
}
