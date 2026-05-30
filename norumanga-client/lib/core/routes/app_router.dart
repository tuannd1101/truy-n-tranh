import 'package:flutter/material.dart';
import '../../presentation/screens/screens.dart';

/// Route generator for the app
class AppRouter {
  // Route names
  static const String splash = '/splash';
  static const String home = '/';
  static const String search = '/search';
  static const String mangaDetail = '/manga-detail';
  static const String reading = '/manga-reading';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String register = '/register';
  static const String subscription = '/subscription';
  static const String payment = '/payment';
  static const String paymentWebView = '/payment-webview';
  static const String paymentResult = '/payment-result';
  static const String create = '/create';
  static const String library = '/library';
  static const String adminDashboard = '/admin';
  static const String readingHistory = '/reading-history';
  static const String favorites = '/favorites';
  static const String settings = '/settings';

  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Extract route arguments
    final args = settings.arguments;

    // Route to appropriate screen
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case search:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
          settings: settings,
        );

      case create:
        return MaterialPageRoute(
          builder: (_) => const TaskBoardScreen(),
          settings: settings,
        );

      case library:
        return MaterialPageRoute(
          builder: (_) => const LibraryScreen(),
          settings: settings,
        );

      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardScreen(),
          settings: settings,
        );

      case mangaDetail:
        final mangaId = args is String ? args : '';
        return MaterialPageRoute(
          builder: (_) => MangaDetailScreen(mangaId: mangaId),
          settings: settings,
        );

      case reading:
        final readingArgs = args as Map<String, dynamic>?;
        final mangaId = readingArgs?['mangaId'] as String? ?? '';
        final chapterNumber = (readingArgs?['chapterNumber'] as num?)?.toDouble() ?? 1.0;
        return MaterialPageRoute(
          builder: (_) =>
              MangaReadingScreen(mangaId: mangaId, chapterNumber: chapterNumber),
          settings: settings,
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );

      case readingHistory:
        return MaterialPageRoute(
          builder: (_) => const ReadingHistoryScreen(),
          settings: settings,
        );

      case favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
          settings: settings,
        );

      case AppRouter.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case subscription:
        return MaterialPageRoute(
          builder: (_) => const SubscriptionScreen(),
          settings: settings,
        );

      case payment:
        final planArgs = args as Map<String, dynamic>? ?? {};
        final bundleId = planArgs['bundle_id'] as String?;
        final planName = planArgs['plan_name'] as String? ?? 'Premium 1 Tháng';
        final price = planArgs['price'] as int? ?? 49000;
        return MaterialPageRoute(
          builder: (_) => PaymentScreen(
            bundleId: bundleId,
            planName: planName,
            price: price,
          ),
          settings: settings,
        );

      case paymentWebView:
        final webViewArgs = args as Map<String, dynamic>?;
        final url = webViewArgs?['url'] as String? ?? '';
        final method = webViewArgs?['method'];
        return MaterialPageRoute(
          builder: (_) => const PlaceholderScreen(screenName: 'Payment WebView'),
          settings: settings,
        );

      case paymentResult:
        final resultArgs = args as Map<String, dynamic>?;
        final success = resultArgs?['success'] as bool? ?? false;
        final method = resultArgs?['method'] as String? ?? 'momo';
        final message = resultArgs?['message'] as String?;
        return MaterialPageRoute(
          builder: (_) => PaymentResultScreen(
            success: success,
            method: method,
            message: message,
          ),
          settings: settings,
        );

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  /// Generate error route
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
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
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(home, (route) => false);
                },
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
