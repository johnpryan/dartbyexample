<!--
title: Libraries
-->

libraries are imported using the `import` keyword:

<pre>
<code class="hljs dart">{{> app.dart}}
</code>
</pre>

libraries can be split into *parts* using the `part` and `part of` syntax:

<pre>
<code class="hljs dart">{{> utils.dart}}
</code>
</pre>

<pre>
<code class="hljs dart">{{> whisper.dart}}
</code>
</pre>

```bash
$ app.dart
WELCOME!!!
welcome...
```
