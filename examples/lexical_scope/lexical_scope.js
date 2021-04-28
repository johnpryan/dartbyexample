var functions = [];

for (var i = 0; i < 3; i++) {
    functions[i] = function() { return i };
}

functions.forEach(function (fn) { console.log(fn())});