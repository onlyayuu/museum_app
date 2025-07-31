import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artwork.dart';

class ApiService {
  static const String baseUrl = 'https://api.artic.edu/api/v1/artworks';

  static Future<List<Artwork>> fetchArtworks() async {
    final response = await http.get(Uri.parse('$baseUrl?page=1&limit=20'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List artworks = data['data'];

      return artworks.map((json) => Artwork.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load artworks');
    }
  }
}
