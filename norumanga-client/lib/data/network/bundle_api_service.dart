import '../models/bundle.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class BundleApiService {
  final ApiService _apiService;

  BundleApiService(this._apiService);

  String get _baseUrl =>
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/bundles');

  /// Active bundles only (client view) or all bundles (admin view).
  Future<List<Bundle>> getBundles({bool all = false}) async {
    final response = await _apiService.dio.get(
      _baseUrl,
      queryParameters: all ? {'all': true} : null,
    );

    final baseResponse = BaseApiResponse<List<Bundle>>.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) => Bundle.fromJson(item as Map<String, dynamic>))
          .toList(),
    );

    return baseResponse.data ?? [];
  }

  Future<Bundle> getBundleById(String id) async {
    final response = await _apiService.dio.get('$_baseUrl/$id');
    final baseResponse = BaseApiResponse<Bundle>.fromJson(
      response.data,
      (json) => Bundle.fromJson(json as Map<String, dynamic>),
    );
    return baseResponse.data!;
  }

  Future<Bundle> createBundle(Map<String, dynamic> data) async {
    final response = await _apiService.dio.post(_baseUrl, data: data);
    final baseResponse = BaseApiResponse<Bundle>.fromJson(
      response.data,
      (json) => Bundle.fromJson(json as Map<String, dynamic>),
    );
    return baseResponse.data!;
  }

  Future<Bundle> updateBundle(String id, Map<String, dynamic> data) async {
    final response = await _apiService.dio.put('$_baseUrl/$id', data: data);
    final baseResponse = BaseApiResponse<Bundle>.fromJson(
      response.data,
      (json) => Bundle.fromJson(json as Map<String, dynamic>),
    );
    return baseResponse.data!;
  }

  Future<void> deleteBundle(String id) async {
    await _apiService.dio.delete('$_baseUrl/$id');
  }
}
