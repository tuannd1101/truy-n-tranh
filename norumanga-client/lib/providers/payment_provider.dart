import 'package:flutter/material.dart';
import '../data/models/payment.dart';
import '../data/network/payment_api_service.dart';
import '../data/network/api_exception.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentApiService _apiService;

  PaymentProvider(this._apiService);

  List<Payment> _payments = [];
  bool _isLoading = false;
  String? _errorMessage;
  Payment? _lastPayment;

  List<Payment> get payments => _payments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Payment? get lastPayment => _lastPayment;

  /// Purchases a bundle. Returns the created payment on success, null on error.
  Future<Payment?> purchase({
    required String bundleId,
    String method = 'MOMO',
    String? transactionRef,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final payment = await _apiService.purchase(
        bundleId: bundleId,
        method: method,
        transactionRef: transactionRef,
      );
      _lastPayment = payment;
      return payment;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return null;
    } catch (e) {
      _errorMessage = 'Thanh toán thất bại: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads the authenticated user's transaction history.
  Future<void> fetchMyPayments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _payments = await _apiService.getMyPayments();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Không thể tải lịch sử giao dịch: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Admin: all transactions (read-only, server paginated) ────────────────
  List<Payment> _allPayments = [];
  int _currentPage = 0; // 0-based backend index
  int _totalPages = 0;
  int _totalElements = 0;
  final int _pageSize = 20;

  List<Payment> get allPayments => _allPayments;
  int get currentPage => _currentPage + 1; // 1-based for UI
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;

  /// Loads all transactions for the admin view.
  Future<void> fetchAllPayments({int? page}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _apiService.getAllPayments(
        page: page ?? _currentPage,
        size: _pageSize,
      );
      _allPayments = result.payments;
      _totalPages = result.totalPages;
      _totalElements = result.totalElements;
      _currentPage = result.currentPage;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Không thể tải lịch sử giao dịch: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setPage(int oneBasedPage) async {
    if (oneBasedPage >= 1 && oneBasedPage <= _totalPages) {
      await fetchAllPayments(page: oneBasedPage - 1);
    }
  }
}
