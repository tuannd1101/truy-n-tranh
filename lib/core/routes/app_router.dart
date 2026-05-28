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

      case reading:
        final readingArgs = args as Map<String, dynamic>?;
        final mangaId = readingArgs?['mangaId'] as int? ?? 0;
        final chapterId = readingArgs?['chapterId'] as int? ?? 0;
        return MaterialPageRoute(
          builder: (_) =>
              MangaReadingScreen(mangaId: mangaId, chapterId: chapterId),
          settings: settings,
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
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
