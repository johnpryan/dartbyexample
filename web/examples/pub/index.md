<!--
title: Pub
-->

Pub is the package manager for Dart.

A typical package has this file structure:

```
cool_package/
  bin/
    ice
  lib/
    sodas.dart
    src/
      pepsi.dart
      coke.dart
  example/
    soda_example.dart
  web/
    cool_app.dart
    index.html
    style.css
  pubspec.yaml
  README.md
```

```yaml
# pubspec.yaml

name: cool_package # use separate package names with underscores
version: 1.2.3 # use semver
description: >
  A really cool package that allows you to
  reticulate your splines and transmogrify
  your unidirectional dataflow.
author: John Ryan
homepage: johnpryan.github.io
environment:
  sdk: ">=0.12.0"
documentation: http://docs.coolpackagedartlang.com
dependencies:
  yaml: ^2.1.0
  frappe: ^0.4.0
dev_dependencies:
  test: ^0.12.0
dependency_overrides:
  stream_transformers: 0.2.0
  yaml:
    path: ../yaml
```

`dependency_override`s force all packages
in the dependency graph to use a specific version
(since only one version of a package is allowed.)

`path:` dependencies are convenient if multiple packages 
are being developed on a local machine.

For details, see [pub package layout conventions](https://www.dartlang.org/tools/pub/package-layout.html).
