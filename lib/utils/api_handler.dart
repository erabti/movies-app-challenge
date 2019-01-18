import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map> requestMovies(String url) async {
  http.Response response = await http.get(url);
  return json.decode(response.body);
}

Future<Map> searchMovie(
  String query,
  int page,
  String year,
) async {
  String apiKey = "68fad02598f326ac555e3abc98deb428";
  String yearStmt = (year != "Any") || (year != null) ? "&year=$year" : "";

  String url = "https://api.themoviedb.org/3/search/movie?"
      "api_key=$apiKey&page=$page&query=$query$yearStmt";
  http.Response response = await http.get(url);
  return json.decode(response.body);
}
