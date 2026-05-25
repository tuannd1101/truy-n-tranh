# API Integration with Dio

## API Service Setup (api_service.dart)

```dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(LogInterceptor(
      requestBody: kDebugMode,
      responseBody: kDebugMode,
      error: kDebugMode,
    ));

    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Error handler
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Request cancelled';

      default:
        return 'Network error. Please check your connection.';
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Resource not found';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Something went wrong';
    }
  }
}
```

## Auth Interceptor (Attach JWT Token)

```dart
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage = SecureStorageService();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Get token from secure storage
    final token = await _secureStorage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
```

## Error Interceptor (Handle 403 for Premium Content)

```dart
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 403) {
      // Premium content - show upgrade dialog
      // You can use a global navigator key or event bus
      _showUpgradeDialog();
    }

    handler.next(err);
  }

  void _showUpgradeDialog() {
    // Implementation to show upgrade dialog
    // This could use a global navigator key or event system
  }
}
```

## API Endpoints (api_endpoints.dart)

```dart
class ApiEndpoints {
  static const String baseUrl = 'https://your-api-domain.com/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String currentUser = '/auth/me';

  // Manga
  static const String mangas = '/mangas';
  static String mangaDetail(String id) => '/mangas/$id';
  static String mangaChapters(String id) => '/mangas/$id/chapters';
  static const String featuredMangas = '/mangas/featured';
  static const String recentMangas = '/mangas/recent';
  static const String recommendedMangas = '/mangas/recommended';
  static const String searchMangas = '/mangas/search';

  // Chapters
  static String chapterDetail(String id) => '/chapters/$id';
  static String chapterImages(String id) => '/chapters/$id/images';

  // Favorites
  static const String favorites = '/favorites';
  static String addFavorite(String mangaId) => '/favorites/$mangaId';
  static String removeFavorite(String mangaId) => '/favorites/$mangaId';

  // Reading History
  static const String readingHistory = '/reading-history';
  static String saveProgress = '/reading-history/progress';

  // User
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';

  // Subscription
  static const String subscriptionPlans = '/subscriptions/plans';
  static const String createPayment = '/payments/create';
  static const String verifyPayment = '/payments/verify';

  // Genres
  static const String genres = '/genres';
}
```

## Repository Examples

### Auth Repository

```dart
class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiService.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data;
  }

  Future<Map<String, dynamic>> register(String fullName, String email, String password) async {
    final response = await _apiService.post(
      ApiEndpoints.register,
      data: {
        'full_name': fullName,
        'email': email,
        'password': password,
      },
    );
    return response.data;
  }

  Future<User> getCurrentUser(String token) async {
    final response = await _apiService.get(ApiEndpoints.currentUser);
    return User.fromJson(response.data);
  }

  Future<void> logout() async {
    await _apiService.post(ApiEndpoints.logout);
  }
}
```

### Manga Repository

```dart
class MangaRepository {
  final ApiService _apiService = ApiService();

  Future<List<Manga>> getFeaturedMangas() async {
    final response = await _apiService.get(ApiEndpoints.featuredMangas);
    return (response.data as List).map((json) => Manga.fromJson(json)).toList();
  }

  Future<List<Manga>> getRecentMangas() async {
    final response = await _apiService.get(ApiEndpoints.recentMangas);
    return (response.data as List).map((json) => Manga.fromJson(json)).toList();
  }

  Future<List<Manga>> getRecommendedMangas() async {
    final response = await _apiService.get(ApiEndpoints.recommendedMangas);
    return (response.data as List).map((json) => Manga.fromJson(json)).toList();
  }

  Future<List<Manga>> searchMangas(String query, {List<String>? genres}) async {
    final response = await _apiService.get(
      ApiEndpoints.searchMangas,
      queryParameters: {
        'q': query,
        if (genres != null) 'genres': genres.join(','),
      },
    );
    return (response.data as List).map((json) => Manga.fromJson(json)).toList();
  }

  Future<Manga> getMangaById(String id) async {
    final response = await _apiService.get(ApiEndpoints.mangaDetail(id));
    return Manga.fromJson(response.data);
  }

  Future<List<Chapter>> getChapters(String mangaId) async {
    final response = await _apiService.get(ApiEndpoints.mangaChapters(mangaId));
    return (response.data as List).map((json) => Chapter.fromJson(json)).toList();
  }
}
```

### Favorites Repository

```dart
class FavoritesRepository {
  final ApiService _apiService = ApiService();

  Future<List<Favorite>> getFavorites(String token) async {
    final response = await _apiService.get(ApiEndpoints.favorites);
    return (response.data as List).map((json) => Favorite.fromJson(json)).toList();
  }

  Future<void> addFavorite(String token, String mangaId) async {
    await _apiService.post(ApiEndpoints.addFavorite(mangaId));
  }

  Future<void> removeFavorite(String token, String mangaId) async {
    await _apiService.delete(ApiEndpoints.removeFavorite(mangaId));
  }
}
```

### Payment Repository

```dart
class PaymentRepository {
  final ApiService _apiService = ApiService();

  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    final response = await _apiService.get(ApiEndpoints.subscriptionPlans);
    return (response.data as List).map((json) => SubscriptionPlan.fromJson(json)).toList();
  }

  Future<String> createPayment(String planId, String paymentMethod) async {
    final response = await _apiService.post(
      ApiEndpoints.createPayment,
      data: {
        'plan_id': planId,
        'payment_method': paymentMethod, // 'momo' or 'vnpay'
      },
    );
    return response.data['payment_url']; // URL to redirect to payment gateway
  }

  Future<bool> verifyPayment(String transactionId) async {
    final response = await _apiService.post(
      ApiEndpoints.verifyPayment,
      data: {'transaction_id': transactionId},
    );
    return response.data['success'] == true;
  }
}
```

## Mock Data for Development

```dart
class MockData {
  static List<Manga> getMockMangas() {
    return [
      Manga(
        id: '1',
        title: 'One Piece',
        author: 'Eiichiro Oda',
        description: 'Câu chuyện về Luffy và băng hải tặc Mũ Rơm...',
        coverImageUrl: 'https://via.placeholder.com/300x400',
        genres: ['Action', 'Adventure', 'Comedy'],
        status: MangaStatus.ongoing,
        totalChapters: 1090,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isFeatured: true,
        rating: 4.8,
      ),
      // Add more mock data...
    ];
  }

  static List<Chapter> getMockChapters(String mangaId) {
    return List.generate(
      50,
      (index) => Chapter(
        id: 'chapter_$index',
        mangaId: mangaId,
        chapterNumber: index + 1,
        title: 'Chapter ${index + 1}',
        imageUrls: List.generate(20, (i) => 'https://via.placeholder.com/800x1200'),
        isPremium: index > 10, // First 10 chapters are free
        publishedAt: DateTime.now().subtract(Duration(days: 50 - index)),
        viewCount: 1000 * (50 - index),
      ),
    );
  }
}
```
