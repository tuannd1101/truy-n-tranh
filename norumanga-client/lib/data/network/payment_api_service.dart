import '../models/payment.dart';
import 'api_service.dart';
import 'base_api_response.dart';

class PaymentApiService {
  final ApiService _apiService;

  PaymentApiService(this._apiService);

  String get _baseUrl =>
      _apiService.dio.options.baseUrl.replaceAll('/api/v1', '/api/payments');

  /// Purchase a bundle as the authenticated user. On success the backend
  /// records the transaction and upgrades the user's role.
  Future<Payment> purchase({
    required String bundleId,
    String method = 'MOMO',
    String? transactionRef,
  }) async {
    final response = await _apiService.dio.post(
      _baseUrl,
      data: {
        'bundleId': bundleId,
        'method': method,
        if (transactionRef != null) 'transactionRef': transactionRef,
      },
    );

    final baseResponse = BaseApiResponse<Payment>.fromJson(
      response.data,
      (json) => Payment.fromJson(json as Map<String, dynamic>),
    );
    return baseResponse.data!;
  }

  /// The authenticated user's transaction history (read-only).
  Future<List<Payment>> getMyPayments() async {
    final response = await _apiService.dio.get('$_baseUrl/me');
    final baseResponse = BaseApiResponse<List<Payment>>.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) => Payment.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
    return baseResponse.data ?? [];
  }

  /// All transactions (admin, read-only). Returns the parsed page content.
  Future<PaginatedPayments> getAllPayments({int page = 0, int size = 20}) async {
    final response = await _apiService.dio.get(
      _baseUrl,
      queryParameters: {'page': page, 'size': size},
    );

    final baseResponse = BaseApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );

    final dataMap = baseResponse.data;
    if (dataMap == null) {
      return PaginatedPayments(
          payments: [], totalPages: 0, totalElements: 0, currentPage: 0);
    }

    final contentList = dataMap['content'] as List<dynamic>? ?? [];
    final payments = contentList
        .map((item) => Payment.fromJson(item as Map<String, dynamic>))
        .toList();

    return PaginatedPayments(
      payments: payments,
      totalPages: dataMap['totalPages'] as int? ?? 0,
      totalElements: dataMap['totalElements'] as int? ?? 0,
      currentPage: dataMap['number'] as int? ?? 0,
    );
  }
}

class PaginatedPayments {
  final List<Payment> payments;
  final int totalPages;
  final int totalElements;
  final int currentPage;

  PaginatedPayments({
    required this.payments,
    required this.totalPages,
    required this.totalElements,
    required this.currentPage,
  });
}
