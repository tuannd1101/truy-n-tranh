import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class UploadApiService {
  final ApiService _apiService = ApiService();

  Future<String> uploadImage(XFile imageFile, {String folder = 'prm_manga_covers'}) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        ),
        'folder': folder,
      });

      final response = await _apiService.dio.post(
        '/uploads/image',
        data: formData,
      );

      final baseResponse = BaseApiResponse.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (baseResponse.data != null && baseResponse.data!['url'] != null) {
        return baseResponse.data!['url'] as String;
      }
      throw Exception('Upload failed: No URL returned');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> uploadImages(List<XFile> imageFiles, {String folder = 'prm_manga_pages'}) async {
    try {
      final formData = FormData.fromMap({
        'folder': folder,
      });

      for (var file in imageFiles) {
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(
            file.path,
            filename: file.name,
          ),
        ));
      }

      final response = await _apiService.dio.post(
        '/uploads/images',
        data: formData,
      );

      final baseResponse = BaseApiResponse.fromJson(
        response.data,
        (data) => (data as List).map((e) => e as Map<String, dynamic>).toList(),
      );

      if (baseResponse.data != null) {
        final List<Map<String, dynamic>> responseData = List<Map<String, dynamic>>.from(baseResponse.data as List);
        return responseData.map((e) => e['url'] as String).toList();
      }
      throw Exception('Upload failed: No URLs returned');
    } catch (e) {
      rethrow;
    }
  }
}
