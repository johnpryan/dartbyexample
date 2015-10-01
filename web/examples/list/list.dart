main() {

  // specifying the length is optional
  var list = new List(3);
  list[0] = 'a';
  list[1] = 'b';
  list[2] = 'c';
  print(list);

  // Lists can be defined using bracket literals:
  var list2 = ['x', 'y', 'z'];
  print(list2);

  // modifying growable lists during iteration can cause ConcurrentModificationErrors
  var list3 = [47, 3, 25];
  try {
    for (var item in list3) {
      if (item < 10) {
        list3.remove(item);
      }
    }
  } catch(e) {
    print('error');
  }
}
