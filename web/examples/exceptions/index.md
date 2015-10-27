<!--
title: Exceptions
-->

<pre>
<code class="hljs dart">{{> exceptions.dart}}
</code>
</pre>

```bash
$ dart exceptions.dart
nope nope nope
caught a flying potato
Unhandled exception:
Bad state: your potato is spoiled
#0      Potato.peel (file:///exceptions.dart:13:7)
#1      main (file:///exceptions.dart:36:5)
#2      _startIsolate.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:261)
#3      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:148)
```
