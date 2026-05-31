import '../models/admin_user.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class PaginatedUsers {
  final List<AdminUser> users;
  final int totalPages;
  final int totalElements;
  final int currentPage;

  PaginatedUsers({
    required this.users,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
  });
}

class UserApiService {
  final ApiService _apiService;

  UserApiService(this._apiService);

  String get _baseUrl =>
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/users');

  /// Paginated user list. Optional [keyword] and [roleId] filters.
  Future<PaginatedUsers> getUsers({
    String? keyword,
    String? roleId,
    int page = 0,
    int size = 20,
  }) async {
    final Map<String, dynamic> query = {'page': page, 'size': size};
    if (keyword != null && keyword.trim().isNotEmpty) {
      query['keyword'] = keyword.trim();
    }
    if (roleId != null && roleId.isNotEmpty) {
      query['roleId'] = roleId;
    }

    final response = await _apiService.dio.get(_baseUrl, queryParameters: query);

    final baseResponse = BaseApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    final dataMap = baseResponse.data;
    if (dataMap == null) {
      return PaginatedUsers(
          users: [], totalPages: 0, totalElements: 0, currentPage: 0);
    }

    final contentList = dataMap['content'] as List<dynamic>? ?? [];
    final users = contentList
        .map((item) => AdminUser.fromJson(item as Map<String, dynamic>))
        .toList();

    return PaginatedUsers(
      users: users,
      totalPages: dataMap['totalPages'] as int? ?? 0,
      totalElements: dataMap['totalElements'] as int? ?? 0,
      currentPage: dataMap['number'] as int? ?? 0,
    );
  }

  Future<AdminUser> getUserById(String id) async {
    final response = await _apiService.dio.get('$_baseUrl/$id');
    final baseResponse = BaseApiResponse<AdminUser>.fromJson(
      response.data,
      (json) => AdminUser.fromJson(json as Map<String, dynamic>),
    );
    return baseResponse.data!;
  }

  Future<AdminUser> updateUser(String id, Map<String, dynamic> data) async {
    final response = await _apiService.dio.put('$_baseUrl/$id', data: data);
    final baseResponse = BaseApiResponse<AdminUser>.fromJson(
      response.data,
      (json) => AdminUser.fromJson(json as Map<String, dynamic>),
    );
    return baseResponse.data!;
  }
}
