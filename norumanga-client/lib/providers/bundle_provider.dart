import 'package:flutter/material.dart';
import '../data/models/bundle.dart';
import '../data/network/bundle_api_service.dart';
import '../data/network/api_exception.dart';

class BundleProvider extends ChangeNotifier {
  final BundleApiService _apiService;

  BundleProvider(this._apiService);

  List<Bundle> _bundles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Bundle> get bundles => _bundles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Loads bundles. [all] = true for the admin view (includes inactive).
  Future<void> fetchBundles({bool all = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _bundles = await _apiService.getBundles(all: all);
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách gói: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addBundle(Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final created = await _apiService.createBundle(data);
      _bundles = [..._bundles, created];
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Không thể tạo gói: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBundle(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _apiService.updateBundle(id, data);
      final index = _bundles.indexWhere((b) => b.id == id);
      if (index != -1) {
        _bundles[index] = updated;
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Không thể cập nhật gói: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteBundle(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteBundle(id);
      _bundles.removeWhere((b) => b.id == id);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Không thể xóa gói: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
