// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as p;

Future<String> readFileAsString(Uri uri) {
  var path = uri.toFilePath(windows: Platform.isWindows);
  return new File(path).readAsString();
}

String packagePathForRoot(String package, Uri root) {
  if (root.scheme != 'file') return null;

  var libLink = p.join(p.fromUri(root), package);
  if (!new Link(libLink).existsSync()) return null;

  return p.dirname(new Link(libLink).resolveSymbolicLinksSync());
}
