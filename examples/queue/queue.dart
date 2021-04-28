import 'dart:collection';

main() {
  // Queues are optimized for adding to the head or tail
  // Items cannot be accessed by their index.
  var q = new Queue.from([300, 200, 100, 500]);

  // Queues implement Iterable:
  print(q.takeWhile((i) => i > 100));

  // Consuming a queue
  while(q.first > 100) {
    q.removeFirst();
  }
  print(q);
}
