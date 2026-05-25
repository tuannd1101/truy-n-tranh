# Routing & Navigation

## Route Names (app_routes.dart)

```dart
class AppRoutes {
  // Auth
  static const String login = '/login';
  static const String register = '/register';

  // Main
  static const String home = '/';
  static const String search = '/search';
  static const String library = '/library';
  static const String profile = '/profile';

  // Manga
  static const String mangaDetail = '/manga/:id';
  static const String mangaReading = '/manga/:mangaId/chapter/:chapterId';

  // Profile Sub-screens
  static const String readingHistory = '/reading-history';
  static const String favorites = '/favorites';
  static const String settings = '/settings';

  // Payment
  static const String subscription = '/subscription';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment-success';
  static const String paymentFailed = '/payment-failed';
}
```

## Route Generator (route_generator.dart)

```dart
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // Auth Routes
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      // Main Routes
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());

      case AppRoutes.library:
        return MaterialPageRoute(builder: (_) => const LibraryScreen());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      // Manga Routes
      case AppRoutes.mangaDetail:
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => MangaDetailScreen(mangaId: args),
          );
        }
        return _errorRoute();

      case AppRoutes.mangaReading:
        if (args is Map<String, String>) {
          return MaterialPageRoute(
            builder: (_) => MangaReadingScreen(
              mangaId: args['mangaId']!,
              chapterId: args['chapterId']!,
            ),
          );
        }
        return _errorRoute();

      // Profile Sub-screens
      case AppRoutes.readingHistory:
        return MaterialPageRoute(builder: (_) => const ReadingHistoryScreen());

      case AppRoutes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());

      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      // Payment Routes
      case AppRoutes.subscription:
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());

      case AppRoutes.payment:
        if (args is SubscriptionPlan) {
          return MaterialPageRoute(
            builder: (_) => PaymentScreen(plan: args),
          );
        }
        return _errorRoute();

      case AppRoutes.paymentSuccess:
        return MaterialPageRoute(builder: (_) => const PaymentSuccessScreen());

      case AppRoutes.paymentFailed:
        return MaterialPageRoute(builder: (_) => const PaymentFailedScreen());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}
```

## Navigation Helper (navigation_helper.dart)

```dart
import 'package:flutter/material.dart';

class NavigationHelper {
  // Navigate to a new screen
  static Future<T?> push<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
  }

  // Replace current screen
  static Future<T?> pushReplacement<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushReplacementNamed<T>(context, routeName, arguments: arguments);
  }

  // Clear stack and navigate
  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, String routeName, {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil<T>(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  // Go back
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }

  // Specific navigation methods
  static Future<void> toLogin(BuildContext context) {
    return pushAndRemoveUntil(context, AppRoutes.login);
  }

  static Future<void> toHome(BuildContext context) {
    return pushAndRemoveUntil(context, AppRoutes.home);
  }

  static Future<void> toMangaDetail(BuildContext context, String mangaId) {
    return push(context, AppRoutes.mangaDetail, arguments: mangaId);
  }

  static Future<void> toMangaReading(BuildContext context, String mangaId, String chapterId) {
    return push(
      context,
      AppRoutes.mangaReading,
      arguments: {'mangaId': mangaId, 'chapterId': chapterId},
    );
  }

  static Future<void> toSubscription(BuildContext context) {
    return push(context, AppRoutes.subscription);
  }

  static Future<void> toPayment(BuildContext context, SubscriptionPlan plan) {
    return push(context, AppRoutes.payment, arguments: plan);
  }
}
```

## Bottom Navigation Structure

```dart
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const LibraryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Thư viện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
```

## Deep Linking Setup (For Payment Callback)

### Android (AndroidManifest.xml)

```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="mangaapp"
        android:host="payment" />
</intent-filter>
```

### iOS (Info.plist)

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>mangaapp</string>
        </array>
    </dict>
</array>
```

### Handle Deep Link in main.dart

```dart
// Example: mangaapp://payment/success
void handleDeepLink(Uri uri) {
  if (uri.host == 'payment') {
    if (uri.pathSegments.contains('success')) {
      // Navigate to payment success screen
      NavigationHelper.push(context, AppRoutes.paymentSuccess);
    } else if (uri.pathSegments.contains('failed')) {
      // Navigate to payment failed screen
      NavigationHelper.push(context, AppRoutes.paymentFailed);
    }
  }
}
```
