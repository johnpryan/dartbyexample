import 'dart:io';

main() async {
  var server = await HttpServer.bind(InternetAddress.ANY_IP_V4, 8777);
  print('serving on port ${server.port}');

  // HttpServer extends Stream<HttpRequest>, so using await-for
  // will run the loop body when a request is added to the stream.
  await for (HttpRequest req in server) {
    // resposne
    req.response
      ..write("welcome to my dart server")
      ..close();
  }
}
