library tavern.metadata;

import 'package:build/build.dart';
import 'package:tavern/src/extensions.dart';
import 'package:yaml/yaml.dart';
import 'dart:async';
import 'dart:convert';
import 'package:tavern/src/utils.dart';

Builder metadataBuilder(_) => MetadataBuilder();

class MetadataBuilder implements Builder {
  Future build(BuildStep buildStep) async {
    var inputId = buildStep.inputId;

    var metadataOutputId = inputId.changeExtension(Extensions.metadata);
    var contentsOutputId = inputId.changeExtension(Extensions.markdownContent);

    var contents = await buildStep.readAsString(inputId);
    var metadata = extractMetadata(contents, inputId.path);

    if (metadata == null) {
      return;
    }

    await Future.wait([
      buildStep.writeAsString(contentsOutputId, metadata.content),
      buildStep.writeAsString(metadataOutputId, json.encode(metadata.metadata)),
    ]);
  }

  Map<String, List<String>> get buildExtensions {
    return {
      Extensions.markdown: [
        Extensions.metadata,
        Extensions.markdownContent,
      ]
    };
  }
}

MetadataOutput extractMetadata(String fileContents, String path) {
  const separator = '---';
  var lines = fileContents.split('\n');
  if (!lines.first.startsWith(separator)) return null;
  int first;
  int last;
  for (var i = 0; i < lines.length; i++) {
    if (lines[i].startsWith(separator)) {
      if (first == null) {
        first = i;
        continue;
      }
      last = i;
      continue;
    }
  }
  if (first == null || last == null) return null;
  var yamlStr = lines.getRange(first + 1, last).join('\n');
  var yaml = loadYaml(yamlStr);
  if (yaml is! Map) {
    throw ('unexpected metadata');
  }

  var metadata = new Map<String, dynamic>.from(yaml);
  metadata['url'] = getHtmlPath(path);

  lines.removeRange(first, last + 1);
  return new MetadataOutput(metadata, lines.join('\n'));
}

class MetadataOutput {
  final Map<String, dynamic> metadata;
  final String content;
  MetadataOutput(this.metadata, this.content);
}
