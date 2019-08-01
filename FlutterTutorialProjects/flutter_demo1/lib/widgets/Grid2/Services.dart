import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/album.dart';
import '../../models/albums.dart';

class Services {
  static const String url = "https://jsonplaceholder.typicode.com/photos";

  static Future<Albums> getPhotos() async {
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Albums list = parsePhotos(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Albums parsePhotos(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    List<Album> albums =
        parsed.map<Album>((json) => Album.fromJson(json)).toList();
    Albums u = Albums();
    u.albums = albums;
    return u;
  }
}
