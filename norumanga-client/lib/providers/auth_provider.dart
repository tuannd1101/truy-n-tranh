import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prm393_project/data/models/user.dart';
import 'package:prm393_project/data/repositories/auth_repository.dart';
import 'package:prm393_project/data/network/api_exception.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  User? _currentUser;
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isGuest => _currentUser == null;
  bool get isPremium => _currentUser?.isPremium ?? false;
  bool get isFree => _currentUser?.isFree ?? false;
  bool get isAdminOrManager =>
      (_currentUser?.isAdmin ?? false) || (_currentUser?.isManager ?? false);

  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading();

    try {
      final token = await _authRepository.login(email, password);

      // Save token
      await _storage.write(key: 'jwt_token', value: token);

      // Fetch user info
      await fetchCurrentUser();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      if (e is ApiException) {
        _errorMessage = e.toString();
      } else {
        _errorMessage = e.toString();
      }
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    _setLoading();

    try {
      await _authRepository.register(name, email, password);

      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      if (e is ApiException) {
        _errorMessage = e.toString();
      } else {
        _errorMessage = e.toString();
      }
      notifyListeners();
      rethrow;
    }
  }

  /// Requests a password reset email. Returns the server message on success,
  /// throws ApiException on failure.
  Future<String> forgotPassword(String email) async {
    return _authRepository.forgotPassword(email);
  }

  /// Resets the password with the emailed token. Returns the server message.
  Future<String> resetPassword(String token, String newPassword) async {
    return _authRepository.resetPassword(token, newPassword);
  }

  Future<void> fetchCurrentUser() async {
    try {
      final user = await _authRepository.getCurrentUser();
      _currentUser = user;
      _status = AuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      await logout();
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = await _storage.read(key: 'jwt_token');
    if (token != null) {
      _status = AuthStatus.loading;
      notifyListeners();
      await fetchCurrentUser();
    } else {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  void upgradeToPremium() {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        role: UserRole.premium,
        premiumExpiryDate: DateTime.now().add(const Duration(days: 30)),
      );
      notifyListeners();
    }
  }
}
