class Position {
  // a static function
  static int get maxX => 100;

  // a static property
  static int maxY = 200;
}

main() {
  print(Position.maxX);
  print(Position.maxY);
}
