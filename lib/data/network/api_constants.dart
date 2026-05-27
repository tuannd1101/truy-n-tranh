class ApiConstants {
  // Đang chạy trên Windows Desktop nên phải dùng localhost hoặc 127.0.0.1 thay vì 10.0.2.2
  static const String baseUrl = 'http://localhost:8080/api/v1';

  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String getMe = '/auth/me';
}
