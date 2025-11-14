import 'package:dio/dio.dart';

class DioMochiService {
  final Dio _dio;
  DioMochiService({String baseUrl = 'https://example.com/api'}) : _dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 8), receiveTimeout: const Duration(seconds: 8)));

  Future<List<Map<String, dynamic>>> fetchPopular() async {
    final r = await _dio.get('/popular');
    return List<Map<String, dynamic>>.from(r.data);
  }

  Future<List<Map<String, dynamic>>> fetchSpecials() async {
    final r = await _dio.get('/specials');
    return List<Map<String, dynamic>>.from(r.data);
  }
}
