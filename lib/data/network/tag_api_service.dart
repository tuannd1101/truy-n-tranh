import '../models/tag.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class TagApiService {
  final ApiService _apiService;

  TagApiService(this._apiService);

  Future<List<Tag>> getAllTags({String? group}) async {
    final response = await _apiService.dio.get(
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/tags'),
      queryParameters: group != null ? {'group': group} : null,
    );

    final baseResponse = BaseApiResponse<List<Tag>>.fromJson(
      response.data,
      (json) => (json as List).map((item) => Tag.fromJson(item)).toList(),
    );

    return baseResponse.data ?? [];
  }

  Future<Tag> createTag(TagRequest request) async {
    final response = await _apiService.dio.post(
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/tags'),
      data: request.toJson(),
    );

    final baseResponse = BaseApiResponse<Tag>.fromJson(
      response.data,
      (json) => Tag.fromJson(json as Map<String, dynamic>),
    );

    return baseResponse.data!;
  }

  Future<Tag> updateTag(String id, TagRequest request) async {
    final response = await _apiService.dio.put(
      '${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/tags')}/$id',
      data: request.toJson(),
    );

    final baseResponse = BaseApiResponse<Tag>.fromJson(
      response.data,
      (json) => Tag.fromJson(json as Map<String, dynamic>),
    );

    return baseResponse.data!;
  }

  Future<void> deleteTag(String id) async {
    await _apiService.dio.delete('${_apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/tags')}/$id');
  }
}
