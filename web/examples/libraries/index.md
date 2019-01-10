---
title: Libraries
template: web/templates/_example.mustache
---

libraries are imported using the `import` keyword:

<pre>
<code class="hljs dart">{{> web/examples/libraries/app.dart}}
</code>
</pre>

libraries can be split into *parts* using the `part` and `part of` syntax:

<pre>
<code class="hljs dart">{{> web/examples/libraries/utils.dart}}
</code>
</pre>

<pre>
<code class="hljs dart">{{> web/examples/libraries/whisper.dart}}
</code>
</pre>

```bash
$ app.dart
WELCOME!!!
welcome...
```
