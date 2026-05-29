import '../models/creator.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class CreatorApiService {
  final ApiService _apiService;

  CreatorApiService(this._apiService);

  Future<List<Creator>> getAllCreators() async {
    final response = await _apiService.dio.get(
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/creators'),
    );

    final baseResponse = BaseApiResponse<List<Creator>>.fromJson(
      response.data,
      (json) => (json as List).map((item) => Creator.fromJson(item)).toList(),
    );

    return baseResponse.data ?? [];
  }

  Future<Creator> createCreator(CreatorRequest request) async {
    final response = await _apiService.dio.post(
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/creators'),
      data: request.toJson(),
    );

    final baseResponse = BaseApiResponse<Creator>.fromJson(
      response.data,
      (json) => Creator.fromJson(json as Map<String, dynamic>),
    );

    return baseResponse.data!;
  }

  Future<Creator> updateCreator(String id, CreatorRequest request) async {
    final response = await _apiService.dio.put(
      '${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/creators')}/$id',
      data: request.toJson(),
    );

    final baseResponse = BaseApiResponse<Creator>.fromJson(
      response.data,
      (json) => Creator.fromJson(json as Map<String, dynamic>),
    );

    return baseResponse.data!;
  }

  Future<void> deleteCreator(String id) async {
    await _apiService.dio.delete('${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/creators')}/$id');
  }
}
