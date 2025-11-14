import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpMochiService {
  final String baseUrl;
  HttpMochiService({this.baseUrl = 'https://example.com/api'});

  Future<List<Map<String, dynamic>>> fetchPopular() async {
    final res = await http.get(Uri.parse('$baseUrl/popular'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(data);
    }
    throw Exception('HTTP Popular failed: ${res.statusCode}');
  }

  Future<List<Map<String, dynamic>>> fetchSpecials() async {
    final res = await http.get(Uri.parse('$baseUrl/specials'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(data);
    }
    throw Exception('HTTP Specials failed: ${res.statusCode}');
  }
}
