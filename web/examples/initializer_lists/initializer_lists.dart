import 'dart:math';

class Position {
  final int x;
  final int y;
  final rad;

  // An initializer list allows
  // fields to be defined before the constructor body.
  // This is required for final fields.
  Position(int x, int y)
      : this.x = x,
        this.y = y,
        rad = atan2(x, y);
}

main() {
  var p = new Position(2, 3);
  print('x: ${p.x} y: ${p.y}');
  print('rad: ${p.rad}');
}
