import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prm393_project/core/routes/app_routes.dart';
import 'package:prm393_project/providers/auth_provider.dart';
import 'package:prm393_project/presentation/screens/placeholder_screen.dart';

/// Route generator with authentication and premium content guards
class AppRouter {
  /// Global navigator key for accessing navigation context
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Get auth provider from context
    final context = navigatorKey.currentContext;
    final authProvider = context != null
        ? Provider.of<AuthProvider>(context, listen: false)
        : null;

    // Extract route arguments
    final args = settings.arguments as Map<String, dynamic>?;

    // Check authentication guards
    if (_requiresAuth(settings.name) &&
        (authProvider == null || !authProvider.isAuthenticated)) {
      // Redirect to login with return route
      return MaterialPageRoute(
        builder: (_) => const PlaceholderScreen(screenName: 'Login Screen'),
        settings: RouteSettings(
          name: AppRoutes.login,
          arguments: {'redirect': settings.name},
        ),
      );
    }

    // Check premium content guards
    if (_requiresPremium(settings.name, args) &&
        (authProvider == null || !authProvider.isPremium)) {
      // Show premium upgrade dialog or redirect to subscription
      return MaterialPageRoute(
        builder: (_) =>
            const PlaceholderScreen(screenName: 'Subscription Screen'),
        settings: const RouteSettings(name: AppRoutes.subscription),
      );
    }

    // Route to appropriate screen
    switch (settings.name) {
      case AppRoutes.home:
      case AppRoutes.main:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(screenName: 'Main Screen'),
          settings: settings,
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(screenName: 'Login Screen'),
          settings: settings,
        );

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) =>
              const PlaceholderScreen(screenName: 'Register Screen'),
          settings: settings,
        );

      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(screenName: 'Search Screen'),
          settings: settings,
        );

      case AppRoutes.library:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(screenName: 'Library Screen'),
          settings: settings,
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(screenName: 'Profile Screen'),
          settings: settings,
        );

      case AppRoutes.mangaDetail:
        final mangaId = args?['mangaId'] as String?;
        if (mangaId == null) {
          return _errorRoute('Manga ID is required');
        }
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            screenName: 'Manga Detail Screen\nID: $mangaId',
          ),
          settings: settings,
        );

      case AppRoutes.reading:
        final mangaId = args?['mangaId'] as String?;
        final chapterId = args?['chapterId'] as String?;
        final isPremium = args?['isPremium'] as bool? ?? false;

        if (mangaId == null || chapterId == null) {
          return _errorRoute('Manga ID and Chapter ID are required');
        }

        // Check if chapter is premium and user has access
        if (isPremium && (authProvider == null || !authProvider.isPremium)) {
          return MaterialPageRoute(
            builder: (_) => _PremiumContentBlockedScreen(
              contentType: 'chapter',
              onUpgrade: () {
                Navigator.of(navigatorKey.currentContext!)
                    .pushNamed(AppRoutes.subscription);
              },
            ),
            settings: settings,
          );
        }

        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            screenName:
                'Reading Screen\nManga: $mangaId\nChapter: $chapterId',
          ),
          settings: settings,
        );

      case AppRoutes.history:
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(screenName: 'History Screen'),
          settings: settings,
        );

      case AppRoutes.favorites:
        return MaterialPageRoute(
          builder: (_) =>
              const PlaceholderScreen(screenName: 'Favorites Screen'),
          settings: settings,
        );

      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) =>
              const PlaceholderScreen(screenName: 'Settings Screen'),
          settings: settings,
        );

      case AppRoutes.subscription:
        return MaterialPageRoute(
          builder: (_) =>
              const PlaceholderScreen(screenName: 'Subscription Screen'),
          settings: settings,
        );

      case AppRoutes.payment:
        final planId = args?['planId'] as String?;
        if (planId == null) {
          return _errorRoute('Plan ID is required');
        }
        return MaterialPageRoute(
          builder: (_) => PlaceholderScreen(
            screenName: 'Payment Screen\nPlan: $planId',
          ),
          settings: settings,
        );

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  /// Check if route requires authentication
  static bool _requiresAuth(String? route) {
    const authRoutes = [
      AppRoutes.library,
      AppRoutes.favorites,
      AppRoutes.history,
      AppRoutes.subscription,
      AppRoutes.payment,
      AppRoutes.settings,
    ];
    return authRoutes.contains(route);
  }

  /// Check if route requires premium access
  static bool _requiresPremium(String? route, Map<String, dynamic>? args) {
    // Check if accessing premium content
    if (route == AppRoutes.reading) {
      return args?['isPremium'] as bool? ?? false;
    }
    return false;
  }

  /// Generate error route
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Navigation Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.home,
                    (route) => false,
                  );
                },
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Navigate to a route with arguments
  static Future<T?> navigateTo<T>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to a route and remove all previous routes
  static Future<T?> navigateAndRemoveUntil<T>(
    String routeName, {
    Map<String, dynamic>? arguments,
  }) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Navigate back
  static void goBack<T>([T? result]) {
    navigatorKey.currentState!.pop(result);
  }

  /// Check if can go back
  static bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }
}

/// Screen shown when user tries to access premium content without subscription
class _PremiumContentBlockedScreen extends StatelessWidget {
  final String contentType;
  final VoidCallback onUpgrade;

  const _PremiumContentBlockedScreen({
    required this.contentType,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Content'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.amber,
              ),
              const SizedBox(height: 24),
              Text(
                'Premium Content',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'This $contentType is only available for Premium users.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onUpgrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Upgrade to Premium',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
