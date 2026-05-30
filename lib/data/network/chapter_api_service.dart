import '../models/chapter.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class ChapterApiService {
  final ApiService _apiService;

  ChapterApiService(this._apiService);

  Future<List<Chapter>> getChaptersByManga(String mangaId) async {
    try {
      final baseUrl = _apiService.dio.options.baseUrl.replaceAll('/api/v1', '');
      final response = await _apiService.dio.get('$baseUrl/api/mangas/$mangaId/chapters');
      
      final baseResponse = BaseApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => Chapter.fromJson(e as Map<String, dynamic>)).toList(),
      );

      if (baseResponse.data != null) {
        return baseResponse.data!;
      }
      throw Exception(baseResponse.getErrorMessage());
    } catch (e) {
      rethrow;
    }
  }

  Future<Chapter> createChapter(String mangaId, Map<String, dynamic> data) async {
    try {
      final baseUrl = _apiService.dio.options.baseUrl.replaceAll('/api/v1', '');
      final response = await _apiService.dio.post(
        '$baseUrl/api/mangas/$mangaId/chapters',
        data: data,
      );
      
      final baseResponse = BaseApiResponse.fromJson(
        response.data,
        (data) => Chapter.fromJson(data as Map<String, dynamic>),
      );

      if (baseResponse.data != null) {
        return baseResponse.data!;
      }
      throw Exception(baseResponse.getErrorMessage());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteChapter(String mangaId, String chapterId) async {
    try {
      final baseUrl = _apiService.dio.options.baseUrl.replaceAll('/api/v1', '');
      await _apiService.dio.delete('$baseUrl/api/mangas/$mangaId/chapters/$chapterId');
    } catch (e) {
      rethrow;
    }
  }
}
