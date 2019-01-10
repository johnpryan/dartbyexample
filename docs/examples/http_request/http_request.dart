import 'dart:convert';
import 'package:http/http.dart' as http;

main() async {

  // The http package can be used to make HTTP requests using dart:io
  // or from the browser via XMLHttpRequests
  var query = 'dartlang';
  var requestUrl = 'http://hn.algolia.com/api/v1/search?query=$query';
  var response = await http.get(requestUrl);

  // decode the reponse into a Map
  var jsonResponse = json.decode(response.body);

  // print a link to the article
  var firstResult = jsonResponse['hits'][0];
  var firstTitle = firstResult['title'];
  var firstLink = firstResult['url'];
  print('$firstTitle : $firstLink');
}
