import '../models/favorite.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class FavoriteApiService {
  final ApiService _apiService;

  FavoriteApiService(this._apiService);

  String get _baseUrl =>
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/favorites');

  Future<List<Favorite>> getMyFavorites() async {
    final response = await _apiService.dio.get(_baseUrl);
    final baseResponse = BaseApiResponse<List<Favorite>>.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) => Favorite.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    return baseResponse.data ?? [];
  }

  Future<void> addFavorite(String mangaId) async {
    await _apiService.dio.post('$_baseUrl/$mangaId');
  }

  Future<void> removeFavorite(String mangaId) async {
    await _apiService.dio.delete('$_baseUrl/$mangaId');
  }

  Future<bool> isFavorite(String mangaId) async {
    final response = await _apiService.dio.get('$_baseUrl/$mangaId/status');
    final baseResponse = BaseApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
    return (baseResponse.data?['favorite'] as bool?) ?? false;
  }
}
