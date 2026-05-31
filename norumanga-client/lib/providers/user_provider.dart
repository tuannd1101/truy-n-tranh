import 'package:flutter/material.dart';
import '../data/models/admin_user.dart';
import '../data/network/user_api_service.dart';
import '../data/network/api_exception.dart';

class UserProvider extends ChangeNotifier {
  final UserApiService _apiService;

  UserProvider(this._apiService);

  List<AdminUser> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filters
  String _keyword = '';
  String? _roleId;

  // Server-side pagination (0-based backend index, 1-based for UI)
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  final int _pageSize = 20;

  List<AdminUser> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get keyword => _keyword;
  String? get roleId => _roleId;

  int get currentPage => _currentPage + 1; // 1-based for UI
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;

  Future<void> fetchUsers({int? page, String? keyword, String? roleId, bool resetFilters = false}) async {
    _isLoading = true;
    _errorMessage = null;
    if (resetFilters) {
      _keyword = '';
      _roleId = null;
    }
    if (keyword != null) _keyword = keyword;
    if (roleId != null) _roleId = roleId.isEmpty ? null : roleId;
    notifyListeners();

    try {
      final result = await _apiService.getUsers(
        keyword: _keyword,
        roleId: _roleId,
        page: page ?? _currentPage,
        size: _pageSize,
      );
      _users = result.users;
      _totalPages = result.totalPages;
      _totalElements = result.totalElements;
      _currentPage = result.currentPage;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách người dùng: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sets a role filter (null/empty = all) and reloads from page 0.
  Future<void> filterByRole(String? roleId) async {
    _roleId = (roleId == null || roleId.isEmpty) ? null : roleId;
    await fetchUsers(page: 0);
  }

  /// Sets the search keyword and reloads from page 0.
  Future<void> search(String keyword) async {
    _keyword = keyword;
    await fetchUsers(page: 0);
  }

  Future<void> setPage(int oneBasedPage) async {
    if (oneBasedPage >= 1 && oneBasedPage <= _totalPages) {
      await fetchUsers(page: oneBasedPage - 1);
    }
  }

  Future<AdminUser?> getUserDetail(String id) async {
    try {
      return await _apiService.getUserById(id);
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'Không thể tải chi tiết người dùng: $e';
      notifyListeners();
      return null;
    }
  }

  Future<bool> updateUser(String id, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updated = await _apiService.updateUser(id, data);
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        _users[index] = updated;
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Không thể cập nhật người dùng: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
