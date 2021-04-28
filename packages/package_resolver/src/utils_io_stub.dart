// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

Future<String> readFileAsString(Uri uri) => throw UnsupportedError(
    'Reading files is only supported where dart:io is available.');

String packagePathForRoot(String package, Uri root) => throw UnsupportedError(
    'Computing package paths from a root is only supported where dart:io is '
    'available.');
