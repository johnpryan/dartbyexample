<!--
title: Unused Variables
-->

<pre>
<code class="hljs dart">{{> unnamed_variables.dart}}
</code>
</pre>

```bash
$ dartanalyzer web/examples/unnamed_parameters/unnamed_parameters.dart 
[hint] The value of the local variable 'i' is not used (unnamed_parameters.dart, line 2, col 12)
1 hint found.
```
