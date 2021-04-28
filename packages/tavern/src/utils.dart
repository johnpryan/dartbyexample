library tavern.utils;

import 'package:path/path.dart' as path;

const String metadataExtension = '.metadata.json';
const String templatesPath = 'web/templates/';

String getMetadataPath(String p) {
  var dirname = path.dirname(p);
  var basename = path.basenameWithoutExtension(p);
  var filename = basename + metadataExtension;
  return path.join(dirname, filename);
}

String getHtmlPath(String p) {
  // input path/to/file.txt
  var dirname = path.dirname(p); // path/to/
  var basename = path.basenameWithoutExtension(p); // file
  var dirnamePath = path.split(dirname); // ['path', to']
  var filename = basename + '.html';
  var result = ['/'];
  result.addAll(dirnamePath.sublist(1));
  result.add(filename);
  return path.joinAll(result);
}

String stripTrailingSlash(String s) {
  while (s?.endsWith('/') ?? false) {
    s = s.substring(0, s.length - 1);
  }
  return s;
}

String addLeadingSlash(String s) {
  if (s != null && !s.startsWith('/')) {
    s = '/$s';
  }
  return s;
}
