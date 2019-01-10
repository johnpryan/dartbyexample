main() {

  // The ?? operator returns the first expression IFF it is not null
  var monday = 'doctor';
  var tuesday;
  var next = tuesday ?? monday;
  print('next appointment: $next');

  // the ??= operator assigns a value IFF it is not null
  var wednesday;
  next ??= wednesday;
  print('next appointment: $next');

  // the ? operator calls a function IFF the object is not null
  String thursday;
  var length = thursday?.length;
  print('length: $length');

}
