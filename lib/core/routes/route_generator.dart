import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prm393_project/core/routes/app_routes.dart';
import 'package:prm393_project/providers/auth_provider.dart';
import 'package:prm393_project/presentation/screens/placeholder_screen.dart';

/// Route generator with authentication guards and parameter extraction.
///
/// This class handles:
/// - Route generation for all app screens
/// - Authentication guards for protected routes
/// - Route parameter extraction for dynamic routes
/// - Redirect after login for protected routes
///
/// Reference: Requirements 13.5, 13.6, 13.7, 13.8, 13.9
class RouteGenerator {
  /// Private constructor to prevent instantiation
  RouteGenerator._();

  /// Global navigator key for accessing context outside of widget tree
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// List of routes that require authentication
  static const List<String> _protectedRoutes = [
    AppRoutes.library,
    AppRoutes.profile,
    AppRoutes.reading,
    AppRoutes.favorites,
    AppRoutes.history,
    AppRoutes.settings,
    AppRoutes.subscription,
    AppRoutes.payment,
  ];

  /// Generates routes based on route settings
  ///
  /// Implements authentication guards and parameter extraction
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Get auth provider from context
    final context = navigatorKey.currentContext;
    if (context == null) {
      return _errorRoute('Context not available');
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if route requires authentication
    if (_requiresAuth(settings.name) && !authProvider.isAuthenticated) {
      // Store the intended route for redirect after login
      return MaterialPageRoute(
        builder: (_) => PlaceholderScreen(
          screenName: 'Login Required - Please login to access this feature',
        ),
        settings: RouteSettings(
          name: AppRoutes.login,
          arguments: {'redirect': settings.name, 'redirectArgs': settings.arguments},
        ),
      );
    }

    // Extract route parameters
    final uri = Uri.parse(settings.name ?? '');
    final pathSegments = uri.pathSegments;
    final queryParams = uri.queryParameters;

    // Route to appropriate screen based on route name
    switch (settings.name) {
      // Auth Routes
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(
            screenName: 'Login Screen',
          ),
          settings: settings,
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(
            screenName: 'Register Screen',
          ),
          settings: settings,
        );

      // Main Routes
      case AppRoutes.home:
      case AppRoutes.main:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(
            screenName: 'Home Screen',
          ),
          settings: settings,
        );

      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(
            screenName: 'Search Screen',
          ),
          settings: settings,
        );

      case AppRoutes.library:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(
            screenName: 'Library Screen',
          ),
          settings: settings,
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(
            screenName: 'Profile Screen',
          ),
          settings: settings,
        );

      // Detail Routes with parameter extraction
      case AppRoutes.mangaDetail:
        final mangaId = _extractParam(settings, 'id') ??
            _extractParam(settings, 'mangaId');
        if (mangaId == null) {
          return _errorRoute('Manga ID is required');
        }
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            screenName: 'Manga Detail - ID: $mangaId',
          ),
          settings: settings,
        );

      case AppRoutes.reading:
        final mangaId = _extractParam(settings, 'mangaId');
        final chapterId = _extractParam(settings, 'chapterId');
        if (mangaId == null || chapterId == null) {
          return _errorRoute('Manga ID and Chapter ID are required');
        }
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            screenName: 'Reading - Manga: $mangaId, Chapter: $chapterId',
          ),
          settings: settings,
        );

      // Profile Sub-Routes
      case AppRoutes.history:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(
            screenName: 'Reading History',
          ),
          settings: settings,
        );

      case AppRoutes.favorites:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(
            screenName: 'Favorites',
          ),
          settings: settings,
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(
            screenName: 'Settings',
          ),
          settings: settings,
        );

      // Subscription Routes
      case AppRoutes.subscription:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(
            screenName: 'Subscription Plans',
          ),
          settings: settings,
        );

      case AppRoutes.payment:
        final planId = _extractParam(settings, 'planId');
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            screenName: planId != null
                ? 'Payment - Plan: $planId'
                : 'Payment',
          ),
          settings: settings,
        );

      // Default route (404)
      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  /// Checks if a route requires authentication
  static bool _requiresAuth(String? route) {
    if (route == null) return false;
    return _protectedRoutes.any((protectedRoute) => route.startsWith(protectedRoute));
  }

  /// Extracts route parameter from settings
  ///
  /// Supports both query parameters and route arguments
  static String? _extractParam(RouteSettings settings, String paramName) {
    // Try to extract from URI query parameters
    final uri = Uri.parse(settings.name ?? '');
    if (uri.queryParameters.containsKey(paramName)) {
      return uri.queryParameters[paramName];
    }

    // Try to extract from route arguments
    final args = settings.arguments;
    if (args is Map<String, dynamic> && args.containsKey(paramName)) {
      return args[paramName]?.toString();
    }

    return null;
  }

  /// Creates an error route for invalid navigation
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final context = navigatorKey.currentContext;
                    if (context != null) {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                    }
                  },
                  child: const Text('Go to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigates to a route with parameters
  ///
  /// Helper method for type-safe navigation
  static Future<T?> navigateTo<T>(
    BuildContext context,
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    return Navigator.of(context).pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigates to manga detail screen
  static Future<void> navigateToMangaDetail(
    BuildContext context,
    String mangaId,
  ) {
    return navigateTo(
      context,
      '${AppRoutes.mangaDetail}?id=$mangaId',
    );
  }

  /// Navigates to reading screen
  static Future<void> navigateToReading(
    BuildContext context,
    String mangaId,
    String chapterId,
  ) {
    return navigateTo(
      context,
      '${AppRoutes.reading}?mangaId=$mangaId&chapterId=$chapterId',
    );
  }

  /// Navigates to payment screen
  static Future<void> navigateToPayment(
    BuildContext context,
    String planId,
  ) {
    return navigateTo(
      context,
      '${AppRoutes.payment}?planId=$planId',
    );
  }

  /// Handles redirect after successful login
  ///
  /// If a redirect route was stored, navigates to it
  /// Otherwise, navigates to home
  static void handlePostLoginRedirect(BuildContext context, dynamic loginArgs) {
    if (loginArgs is Map<String, dynamic> && loginArgs.containsKey('redirect')) {
      final redirectRoute = loginArgs['redirect'] as String?;
      final redirectArgs = loginArgs['redirectArgs'];
      
      if (redirectRoute != null) {
        Navigator.of(context).pushReplacementNamed(
          redirectRoute,
          arguments: redirectArgs,
        );
        return;
      }
    }
    
    // Default: navigate to home
    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
  }
}
