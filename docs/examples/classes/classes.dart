import 'dart:math';

class Position {
  // properties
  int x;
  int y;

  // methods
  double distanceTo(Position other) {
    var dx = other.x - x;
    var dy = other.y - y;
    return sqrt(dx * dx + dy * dy);
  }
}

main() {
  var origin = new Position()
    ..x = 0
    ..y = 0;

  var p = new Position()
    ..x = -5
    ..y = 6;

  print(origin.distanceTo(p));
}
