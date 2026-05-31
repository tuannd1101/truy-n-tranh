import 'package:flutter/material.dart';
import '../data/models/role.dart';
import '../data/network/role_api_service.dart';
import '../data/network/api_exception.dart';

class RoleProvider extends ChangeNotifier {
  final RoleApiService _apiService;

  RoleProvider(this._apiService);

  List<Role> _roles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Role> get roles => _roles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchRoles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _roles = await _apiService.getAllRoles();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách vai trò: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Role? roleById(String? id) {
    if (id == null) return null;
    try {
      return _roles.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
