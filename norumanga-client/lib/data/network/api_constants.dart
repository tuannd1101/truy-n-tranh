import 'package:flutter/foundation.dart';

class ApiConstants {
  /// Địa chỉ backend khi deploy production (Render). Truyền lúc build web bằng:
  ///   flutter build web --dart-define=API_BASE=https://<ten-app>.onrender.com
  /// Nếu không truyền, sẽ dùng cấu hình local bên dưới.
  static const String _prodApiBase = String.fromEnvironment('API_BASE');

  /// LAN IP của máy chạy backend (dùng cho phát triển trong cùng WiFi).
  /// Xem IP bằng lệnh `ipconfig`.
  static const String _lanHost = '192.168.1.121';

  static String get baseUrl {
    // Ưu tiên backend production nếu được cung cấp lúc build.
    if (_prodApiBase.isNotEmpty) {
      return '$_prodApiBase/api/v1';
    }
    // Cấu hình local (phát triển):
    if (kIsWeb) {
      return 'http://$_lanHost:8080/api/v1';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://$_lanHost:8080/api/v1';
    } else {
      return 'http://$_lanHost:8080/api/v1';
    }
  }

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String getMe = '/auth/me';
}
