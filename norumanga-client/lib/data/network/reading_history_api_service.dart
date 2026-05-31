import '../models/reading_history.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class ReadingHistoryApiService {
  final ApiService _apiService;

  ReadingHistoryApiService(this._apiService);

  String get _baseUrl => _apiService.dio.options.baseUrl
      .replaceAll('/api/v1', '/api/reading-history');

  Future<List<ReadingHistoryEntry>> getMyHistory() async {
    final response = await _apiService.dio.get(_baseUrl);
    final baseResponse = BaseApiResponse<List<ReadingHistoryEntry>>.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) =>
              ReadingHistoryEntry.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    return baseResponse.data ?? [];
  }

  /// Records (upserts) that the user read a chapter of a manga.
  Future<void> record({
    required String mangaId,
    required double chapterNumber,
  }) async {
    await _apiService.dio.post(
      _baseUrl,
      data: {'mangaId': mangaId, 'chapterNumber': chapterNumber},
    );
  }

  Future<void> clear() async {
    await _apiService.dio.delete(_baseUrl);
  }
}
