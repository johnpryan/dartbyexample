import 'dart:math';

// compile-time constants are defined using 'const'
const name = "greg";

// Objects can also be declared at compile-time
const Rectangle<int> bounds = const Rectangle(0, 0, 5, 5);

main() {
  print(name);
  print(bounds);
}
