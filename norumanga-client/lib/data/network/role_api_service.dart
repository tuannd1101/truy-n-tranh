import '../models/role.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class RoleApiService {
  final ApiService _apiService;

  RoleApiService(this._apiService);

  String get _baseUrl =>
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/roles');

  Future<List<Role>> getAllRoles() async {
    final response = await _apiService.dio.get(_baseUrl);
    final baseResponse = BaseApiResponse<List<Role>>.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) => Role.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    return baseResponse.data ?? [];
  }

  Future<Role> getRoleById(String id) async {
    final response = await _apiService.dio.get('$_baseUrl/$id');
    final baseResponse = BaseApiResponse<Role>.fromJson(
      response.data,
      (json) => Role.fromJson(json as Map<String, dynamic>),
    );
    return baseResponse.data!;
  }
}
