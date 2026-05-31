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
    final Map<String, dynamic> queryParams = {'page': page, 'size': size};
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
    final mangas = contentList
        .map((item) => Manga.fromJson(item as Map<String, dynamic>))
        .toList();

    return PaginatedManga(
      mangas: mangas,
      totalPages: dataMap['totalPages'] as int? ?? 0,
      totalElements: dataMap['totalElements'] as int? ?? 0,
      currentPage: dataMap['number'] as int? ?? 0,
    );
  }

  /// Searches manga by an optional title [keyword], an optional [tagIds]
  /// filter, returning a paginated result.
  ///
  /// Endpoint selection mirrors the real backend contract:
  /// - When a non-blank [keyword] is supplied, the dedicated keyword endpoint
  ///   `GET /api/mangas/search?q=` is used (matches title/slug/description).
  /// - Otherwise the filter endpoint `GET /api/mangas/?tagId=` is used.
  ///
  /// The backend exposes no creator filter, so [creatorId] is NOT sent here;
  /// creator filtering is applied on the client by [SearchProvider].
  Future<PaginatedManga> searchMangas({
    String? keyword,
    String? creatorId, // accepted for API symmetry; not sent to the backend
    List<String>? tagIds,
    int page = 0,
    int size = 20,
  }) async {
    final hasKeyword = keyword != null && keyword.trim().isNotEmpty;

    final String url;
    final Map<String, dynamic> queryParams = {'page': page, 'size': size};

    if (hasKeyword) {
      // Dedicated keyword search endpoint: /api/mangas/search
      url =
          '${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/mangas')}/search';
      queryParams['q'] = keyword.trim();
    } else {
      // Filter endpoint: /api/mangas/
      url = _apiService.dio.options.baseUrl.replaceAll(
        '/api/v1',
        '/api/mangas',
      );
      if (tagIds != null && tagIds.isNotEmpty) {
        queryParams['tagId'] =
            tagIds; // Dio serializes a list as repeated params
      }
    }

    final response = await _apiService.dio.get(
      url,
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
    final mangas = contentList
        .map((item) => Manga.fromJson(item as Map<String, dynamic>))
        .toList();

    return PaginatedManga(
      mangas: mangas,
      totalPages: dataMap['totalPages'] as int? ?? 0,
      totalElements: dataMap['totalElements'] as int? ?? 0,
      currentPage: dataMap['number'] as int? ?? 0,
    );
  }

  Future<Manga> getMangaById(String id) async {
    final response = await _apiService.dio.get(
      '${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/mangas')}/$id',
    );

    final baseResponse = BaseApiResponse<Manga>.fromJson(
      response.data,
      (json) => Manga.fromJson(json as Map<String, dynamic>),
    );

    return baseResponse.data!;
  }

  /// Top 10 most recently updated manga (`GET /api/mangas/latest`).
  Future<List<Manga>> getLatestMangas() async {
    final response = await _apiService.dio.get(
      '${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/mangas')}/latest',
    );
    final baseResponse = BaseApiResponse<List<Manga>>.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) => Manga.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    return baseResponse.data ?? [];
  }

  /// Top 10 most viewed manga (`GET /api/mangas/recommended`).
  Future<List<Manga>> getRecommendedMangas() async {
    final response = await _apiService.dio.get(
      '${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/mangas')}/recommended',
    );
    final baseResponse = BaseApiResponse<List<Manga>>.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) => Manga.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    return baseResponse.data ?? [];
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
