/// Route names for the application
class AppRoutes {
  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';

  // Main Routes
  static const String home = '/';
  static const String main = '/main';
  static const String search = '/search';
  static const String library = '/library';
  static const String profile = '/profile';

  // Detail Routes
  static const String mangaDetail = '/manga-detail';
  static const String reading = '/reading';

  // Profile Sub-Routes
  static const String history = '/history';
  static const String favorites = '/favorites';
  static const String settings = '/settings';

  // Subscription Routes
  static const String subscription = '/subscription';
  static const String payment = '/payment';

  // Prevent instantiation
  AppRoutes._();
}
