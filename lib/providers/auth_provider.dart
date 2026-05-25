import 'package:flutter/foundation.dart';
import 'package:prm393_project/data/models/user.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
}

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  AuthStatus _status = AuthStatus.unauthenticated;

  User? get currentUser => _currentUser;
  AuthStatus get status => _status;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isGuest => _currentUser == null;
  bool get isPremium => _currentUser?.isPremium ?? false;
  bool get isFree => _currentUser?.isFree ?? false;

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    notifyListeners();

    // Mock login - in real app, this would call an API
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(
      id: '1',
      name: 'Test User',
      email: email,
      role: UserRole.free,
    );
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    _status = AuthStatus.loading;
    notifyListeners();

    // Mock registration - in real app, this would call an API
    await Future.delayed(const Duration(seconds: 1));

    _currentUser = User(
      id: '1',
      name: name,
      email: email,
      role: UserRole.free,
    );
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    // Mock check - in real app, this would check stored token
    await Future.delayed(const Duration(milliseconds: 500));
    // For now, always start as unauthenticated
    _status = AuthStatus.unauthenticated;
    notifyListeners();
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
