import '../models/manga.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class PaginatedManga {
  final List<Manga> mangas;
  final int totalPages;
  final int totalElements;
  final int currentPage;

  PaginatedManga({
    required this.mangas,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
  });
}

class MangaApiService {
  final ApiService _apiService;

  MangaApiService(this._apiService);

  Future<PaginatedManga> getMangas({
    int page = 0,
    int size = 20,
    String? tagId,
    String? status,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'size': size,
    };
    if (tagId != null && tagId.isNotEmpty) {
      queryParams['tagId'] = tagId;
    }
    if (status != null && status.isNotEmpty) {
      queryParams['status'] = status;
    }

    final response = await _apiService.dio.get(
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/mangas'),
      queryParameters: queryParams,
    );

    final baseResponse = BaseApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    final dataMap = baseResponse.data;
    if (dataMap == null) {
      return PaginatedManga(
        mangas: [],
        totalPages: 0,
        totalElements: 0,
        currentPage: 0,
      );
    }

    final contentList = dataMap['content'] as List<dynamic>? ?? [];
    final mangas = contentList.map((item) => Manga.fromJson(item as Map<String, dynamic>)).toList();

    return PaginatedManga(
      mangas: mangas,
      totalPages: dataMap['totalPages'] as int? ?? 0,
      totalElements: dataMap['totalElements'] as int? ?? 0,
      currentPage: dataMap['number'] as int? ?? 0,
    );
  }

  Future<Manga> createManga(Map<String, dynamic> mangaData) async {
    final response = await _apiService.dio.post(
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/mangas'),
      data: mangaData,
    );

    final baseResponse = BaseApiResponse<Manga>.fromJson(
      response.data,
      (json) => Manga.fromJson(json as Map<String, dynamic>),
    );

    return baseResponse.data!;
  }

  Future<Manga> updateManga(String id, Map<String, dynamic> mangaData) async {
    final response = await _apiService.dio.put(
      '${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/mangas')}/$id',
      data: mangaData,
    );

    final baseResponse = BaseApiResponse<Manga>.fromJson(
      response.data,
      (json) => Manga.fromJson(json as Map<String, dynamic>),
    );

    return baseResponse.data!;
  }

  Future<void> deleteManga(String id) async {
    await _apiService.dio.delete(
      '${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/mangas')}/$id',
    );
  }
}
