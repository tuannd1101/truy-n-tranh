import 'package:dio/dio.dart';
import '../network/api_constants.dart';
import '../network/api_exception.dart';
import '../network/api_service.dart';
import '../network/base_api_response.dart';
import '../models/user.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<String> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final baseResponse = BaseApiResponse.fromJson(response.data, (json) => json as Map<String, dynamic>);
      
      final data = baseResponse.data;
      if (data != null && data.containsKey('token')) {
        return data['token'] as String;
      }
      
      throw ApiException(message: "Không lấy được token đăng nhập.");
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(message: "Lỗi đăng nhập không xác định.");
    }
  }

  Future<String> register(String fullName, String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.register,
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
        },
      );

      final baseResponse = BaseApiResponse.fromJson(response.data, (json) => json as String?);
      return baseResponse.message;
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(message: "Lỗi đăng ký không xác định.");
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.getMe);
      
      final baseResponse = BaseApiResponse.fromJson(
        response.data, 
        (json) => User.fromJson(json as Map<String, dynamic>)
      );

      if (baseResponse.data != null) {
        return baseResponse.data!;
      }
      
      throw ApiException(message: "Không thể lấy thông tin người dùng.");
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(message: "Lỗi lấy thông tin không xác định.");
    }
  }
}
