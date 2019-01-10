import 'dart:async';

main() {

  // Future() schedules a task on the event queue:
  new Future(() => print('world'));
  print('hello');

  // scheduleMicrotask() will add the task to the microtask queue:
  // Tasks on the microtask queue are executed before the next
  // run-loop on the event queue.
  scheduleMicrotask(() => print('beautiful'));

  print('there');
}
