import '../models/genre.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class GenreApiService {
  final ApiService _apiService;

  GenreApiService(this._apiService);

  Future<List<Genre>> getAllGenres() async {
    final response = await _apiService.dio.get(
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/genres'),
    );

    final baseResponse = BaseApiResponse<List<Genre>>.fromJson(
      response.data,
      (json) => (json as List).map((item) => Genre.fromJson(item)).toList(),
    );

    return baseResponse.data ?? [];
  }

  Future<Genre> createGenre(GenreRequest request) async {
    final response = await _apiService.dio.post(
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/genres'),
      data: request.toJson(),
    );

    final baseResponse = BaseApiResponse<Genre>.fromJson(
      response.data,
      (json) => Genre.fromJson(json as Map<String, dynamic>),
    );

    return baseResponse.data!;
  }

  Future<Genre> updateGenre(String id, GenreRequest request) async {
    final response = await _apiService.dio.put(
      '${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/genres')}/$id',
      data: request.toJson(),
    );

    final baseResponse = BaseApiResponse<Genre>.fromJson(
      response.data,
      (json) => Genre.fromJson(json as Map<String, dynamic>),
    );

    return baseResponse.data!;
  }

  Future<void> deleteGenre(String id) async {
    await _apiService.dio.delete('${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/genres')}/$id');
  }
}
