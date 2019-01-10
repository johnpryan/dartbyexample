// an ordered optional parameter
String yell(String str, [bool exclaim = false]) {
  var result = str.toUpperCase();
  if (exclaim) result = result + '!!!';
  return result;
}

// named optional parameters
String whisper(String str, {bool mysteriously: false}) {
  var result = str.toLowerCase();
  if (mysteriously) result = result + '...';
  return result;
}


main() {
  print(yell('Hello, World'));
  print(yell('Hello, World', true));
  print(whisper('Hello, World', mysteriously: true));
}
