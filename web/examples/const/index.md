---
title: Constants
template: web/templates/_example.mustache
---

In dart, compile-time constants can be created as long
as the object's deep structure can be determined at compile time.

<pre>
<code class="hljs dart">{{> web/examples/const/const.dart}}
</code>
</pre>

```bash
$ dart const.dart
greg
Rectangle (0, 0) 5 x 5
```
