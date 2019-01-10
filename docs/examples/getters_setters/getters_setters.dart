import 'dart:math';

class Position {
  int _x;
  int _y;

  Position(this._x, this._y);

  double get rad => atan2(_y, _x);

  void set x(int val) {
    _x = val;
  }
}

main() {
  var p = new Position(2, 3);
  p.x = 10;
  print('x: ${p._x} y: ${p._y}');
  print('rad: ${p.rad}');
}
