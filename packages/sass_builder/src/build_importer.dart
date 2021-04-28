import 'dart:async';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;
import 'package:sass/sass.dart' as sass;

/// A [sass.AsyncImporter] for use during a [BuildStep] that supports Dart
/// package imports of Sass files.
///
/// All methods are heavily inspired by functions from for import priorities:
/// https://github.com/sass/dart-sass/blob/f8b2c9111c1d5a3c07c9c8c0828b92bd87c548c9/lib/src/importer/utils.dart
class BuildImporter extends sass.AsyncImporter {
  final BuildStep _buildStep;

  BuildImporter(this._buildStep);

  @override
  FutureOr<Uri> canonicalize(Uri url) async =>
      (await _resolveImport(url.toString()))?.uri;

  @override
  FutureOr<sass.ImporterResult> load(Uri url) async {
    final id = new AssetId.resolve(url.toString(), from: _buildStep.inputId);
    final sourceMapId = id.addExtension('.map');
    return new sass.ImporterResult(
      await _buildStep.readAsString(id),
      sourceMapUrl: sourceMapId.uri,
      syntax: sass.Syntax.forPath(id.path),
    );
  }

  /// Resolves [import] using the same logic as the filesystem importer.
  ///
  /// This tries to fill in extensions and partial prefixes and check if a
  /// directory default. If no file can be found, it returns `null`.
  Future<AssetId> _resolveImport(String import) async {
    final extension = p.extension(import);
    if (extension == '.sass' || extension == '.scss') {
      return _exactlyOne(await _tryImport(import));
    }

    return _exactlyOne(await _tryImportWithExtensions(import)) ??
        _tryImportAsDirectory(import);
  }

  /// Like [_tryImport], but checks both `.sass` and `.scss` extensions.
  Future<List<AssetId>> _tryImportWithExtensions(String import) async =>
      await _tryImport(import + '.sass') + await _tryImport(import + '.scss');

  /// Returns the [AssetId] for [import] and/or the partial with the same name,
  /// if either or both exists.
  ///
  /// If neither exists, returns an empty list.
  Future<List<AssetId>> _tryImport(String import) async {
    final imports = <AssetId>[];
    final partialId = new AssetId.resolve(
        p.url.join(p.dirname(import), '_${p.basename(import)}'),
        from: _buildStep.inputId);
    if (await _buildStep.canRead(partialId)) imports.add(partialId);
    final importId = new AssetId.resolve(import, from: _buildStep.inputId);
    if (await _buildStep.canRead(importId)) imports.add(importId);
    return imports;
  }

  /// Returns the resolved index file for [import] if [import] is a directory
  /// and the index file exists.
  ///
  /// Otherwise, returns `null`.
  Future<AssetId> _tryImportAsDirectory(String import) async =>
      _exactlyOne(await _tryImportWithExtensions(p.url.join(import, 'index')));

  /// If [imports] contains exactly one import [AssetId], returns that import.
  ///
  /// If it contains no assets, returns `null`. If it contains more than one,
  /// throws an exception.
  AssetId _exactlyOne(List<AssetId> imports) {
    if (imports.isEmpty) return null;
    if (imports.length == 1) return imports.first;

    throw new FormatException('It is not clear which file to import. Found:\n' +
        imports.map((import) => '  ${p.prettyUri(import.uri)}').join('\n'));
  }
}
