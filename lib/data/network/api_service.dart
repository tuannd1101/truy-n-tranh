import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_constants.dart';
import 'api_exception.dart';
import 'base_api_response.dart';

class ApiService {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Gắn token vào header nếu có
          final token = await _storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Parse lỗi về custom ApiException dựa trên BaseApiResponse
          String message = 'Đã có lỗi xảy ra. Vui lòng thử lại.';
          Map<String, dynamic>? errors;

          if (e.response != null && e.response?.data != null) {
            try {
              final responseData = e.response!.data as Map<String, dynamic>;
              final baseResponse = BaseApiResponse.fromJson(responseData, null);
              message = baseResponse.message;
              errors = baseResponse.errors;
            } catch (_) {
              // Nếu không parse được JSON chuẩn
              message = _handleStatusCode(e.response?.statusCode);
            }
          } else {
            message = _handleDioError(e.type);
          }

          final customException = ApiException(
            message: message,
            errors: errors,
            statusCode: e.response?.statusCode,
          );
          
          return handler.next(
            DioException(
              requestOptions: e.requestOptions,
              error: customException,
              type: DioExceptionType.unknown,
            ),
          );
        },
      ),
    );
  }

  Dio get dio => _dio;

  String _handleDioError(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối mạng quá hạn. Vui lòng kiểm tra lại mạng.';
      case DioExceptionType.connectionError:
        return 'Lỗi kết nối. Không thể kết nối tới máy chủ.';
      default:
        return 'Có lỗi mạng xảy ra.';
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Dữ liệu không hợp lệ.';
      case 401:
        return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      case 403:
        return 'Bạn không có quyền thực hiện thao tác này.';
      case 404:
        return 'Không tìm thấy dữ liệu.';
      case 500:
        return 'Lỗi máy chủ nội bộ. Vui lòng thử lại sau.';
      default:
        return 'Có lỗi xảy ra (Mã lỗi: $statusCode).';
    }
  }
}
