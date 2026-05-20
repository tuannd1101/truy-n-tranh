/// Route names for the application navigation system.
///
/// This file contains all route constants used throughout the app.
/// All route names follow a consistent naming convention using lowercase
/// with forward slashes for hierarchical routes.
///
/// Reference: Requirements 13.1 - Navigation and Routing System
class RouteNames {
  // Private constructor to prevent instantiation
  RouteNames._();

  // ============================================================================
  // Splash & Initial Routes
  // ============================================================================

  /// Splash screen route - Initial loading screen
  static const String splash = '/splash';

  /// Initial route - Entry point of the app
  static const String initial = '/';

  // ============================================================================
  // Authentication Routes
  // ============================================================================

  /// Login screen route
  static const String login = '/login';

  /// Register screen route
  static const String register = '/register';

  // ============================================================================
  // Main Navigation Routes (Bottom Navigation Bar)
  // ============================================================================

  /// Home screen route - Main landing page with featured manga
  static const String home = '/home';

  /// Search screen route - Search and filter manga
  static const String search = '/search';

  /// Library screen route - User's reading list and favorites
  static const String library = '/library';

  /// Profile screen route - User profile and settings
  static const String profile = '/profile';

  // ============================================================================
  // Content Detail Routes
  // ============================================================================

  /// Manga detail screen route - Shows manga information and chapters
  /// Expects mangaId as route parameter
  static const String mangaDetail = '/manga/detail';

  /// Reading screen route - Manga chapter reading interface
  /// Expects mangaId and chapterId as route parameters
  static const String reading = '/manga/reading';

  // ============================================================================
  // Profile Sub-Routes
  // ============================================================================

  /// Reading history screen route - Shows user's reading history
  static const String history = '/history';

  /// Favorites screen route - Shows user's favorite manga
  static const String favorites = '/favorites';

  /// Settings screen route - App settings and preferences
  static const String settings = '/settings';

  // ============================================================================
  // Subscription & Payment Routes
  // ============================================================================

  /// Subscription plans screen route - Shows available subscription plans
  static const String subscription = '/subscription';

  /// Payment screen route - Payment processing interface
  /// Expects planId as route parameter
  static const String payment = '/payment';

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Returns manga detail route with mangaId parameter
  static String mangaDetailWithId(String mangaId) {
    return '$mangaDetail?id=$mangaId';
  }

  /// Returns reading route with mangaId and chapterId parameters
  static String readingWithParams(String mangaId, String chapterId) {
    return '$reading?mangaId=$mangaId&chapterId=$chapterId';
  }

  /// Returns payment route with planId parameter
  static String paymentWithPlanId(String planId) {
    return '$payment?planId=$planId';
  }

  /// List of all route names for validation
  static const List<String> allRoutes = [
    splash,
    initial,
    login,
    register,
    home,
    search,
    library,
    profile,
    mangaDetail,
    reading,
    history,
    favorites,
    settings,
    subscription,
    payment,
  ];

  /// Routes that require authentication
  static const List<String> protectedRoutes = [
    library,
    favorites,
    history,
    settings,
    subscription,
    payment,
  ];

  /// Routes that should redirect to home if user is already authenticated
  static const List<String> authOnlyRoutes = [
    login,
    register,
  ];

  /// Routes accessible to guest users
  static const List<String> guestAccessibleRoutes = [
    splash,
    initial,
    login,
    register,
    home,
    search,
    mangaDetail,
  ];
}
