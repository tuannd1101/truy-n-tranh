# State Management with Provider

## Setup in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<AuthProvider, MangaProvider>(
          create: (_) => MangaProvider(),
          update: (_, auth, manga) => manga!..updateAuth(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (_) => UserProvider(),
          update: (_, auth, user) => user!..updateAuth(auth),
        ),
        ChangeNotifierProxyProvider<AuthProvider, FavoritesProvider>(
          create: (_) => FavoritesProvider(),
          update: (_, auth, favorites) => favorites!..updateAuth(auth),
        ),
        ChangeNotifierProvider(create: (_) => ChapterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
```

## 1. Auth Provider

```dart
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isPremium => _user?.isPremium ?? false;

  final AuthRepository _authRepository = AuthRepository();
  final SecureStorageService _secureStorage = SecureStorageService();

  // Initialize - Check if user is already logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _token = await _secureStorage.getToken();
      if (_token != null) {
        _user = await _authRepository.getCurrentUser(_token!);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(email, password);
      _token = response['token'];
      _user = User.fromJson(response['user']);

      await _secureStorage.saveToken(_token!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(String fullName, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.register(fullName, email, password);
      // After register, auto login or redirect to login
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _secureStorage.deleteToken();
    _user = null;
    _token = null;
    notifyListeners();
  }

  // Update user (after upgrade to premium)
  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }
}
```

## 2. Manga Provider

```dart
import 'package:flutter/foundation.dart';

class MangaProvider extends ChangeNotifier {
  List<Manga> _featuredMangas = [];
  List<Manga> _recentMangas = [];
  List<Manga> _recommendedMangas = [];
  List<Manga> _searchResults = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Manga> get featuredMangas => _featuredMangas;
  List<Manga> get recentMangas => _recentMangas;
  List<Manga> get recommendedMangas => _recommendedMangas;
  List<Manga> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final MangaRepository _mangaRepository = MangaRepository();
  AuthProvider? _authProvider;

  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  // Fetch home data
  Future<void> fetchHomeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _mangaRepository.getFeaturedMangas(),
        _mangaRepository.getRecentMangas(),
        _mangaRepository.getRecommendedMangas(),
      ]);

      _featuredMangas = results[0];
      _recentMangas = results[1];
      _recommendedMangas = results[2];

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search mangas
  Future<void> searchMangas(String query, {List<String>? genres}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchResults = await _mangaRepository.searchMangas(query, genres: genres);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get manga detail
  Future<Manga?> getMangaDetail(String mangaId) async {
    try {
      return await _mangaRepository.getMangaById(mangaId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Get chapters for a manga
  Future<List<Chapter>> getChapters(String mangaId) async {
    try {
      return await _mangaRepository.getChapters(mangaId);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return [];
    }
  }
}
```

## 3. Favorites Provider

```dart
import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  List<Favorite> _favorites = [];
  Set<String> _favoriteMangaIds = {};
  bool _isLoading = false;

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;

  final FavoritesRepository _favoritesRepository = FavoritesRepository();
  AuthProvider? _authProvider;

  void updateAuth(AuthProvider authProvider) {
    _authProvider = authProvider;
    if (authProvider.isAuthenticated) {
      fetchFavorites();
    }
  }

  bool isFavorite(String mangaId) {
    return _favoriteMangaIds.contains(mangaId);
  }

  // Fetch favorites
  Future<void> fetchFavorites() async {
    if (_authProvider?.token == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _favorites = await _favoritesRepository.getFavorites(_authProvider!.token!);
      _favoriteMangaIds = _favorites.map((f) => f.mangaId).toSet();
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add to favorites
  Future<bool> addFavorite(String mangaId) async {
    if (_authProvider?.token == null) return false;

    try {
      await _favoritesRepository.addFavorite(_authProvider!.token!, mangaId);
      _favoriteMangaIds.add(mangaId);
      notifyListeners();

      // Refresh list
      await fetchFavorites();
      return true;
    } catch (e) {
      debugPrint('Error adding favorite: $e');
      return false;
    }
  }

  // Remove from favorites
  Future<bool> removeFavorite(String mangaId) async {
    if (_authProvider?.token == null) return false;

    try {
      await _favoritesRepository.removeFavorite(_authProvider!.token!, mangaId);
      _favoriteMangaIds.remove(mangaId);
      notifyListeners();

      // Refresh list
      await fetchFavorites();
      return true;
    } catch (e) {
      debugPrint('Error removing favorite: $e');
      return false;
    }
  }

  // Toggle favorite
  Future<bool> toggleFavorite(String mangaId) async {
    if (isFavorite(mangaId)) {
      return await removeFavorite(mangaId);
    } else {
      return await addFavorite(mangaId);
    }
  }
}
```

## 4. Chapter Provider (Reading State)

```dart
import 'package:flutter/foundation.dart';

class ChapterProvider extends ChangeNotifier {
  Chapter? _currentChapter;
  int _currentPage = 0;
  bool _isLoading = false;
  ReadingMode _readingMode = ReadingMode.vertical;

  Chapter? get currentChapter => _currentChapter;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  ReadingMode get readingMode => _readingMode;

  final ChapterRepository _chapterRepository = ChapterRepository();

  // Load chapter
  Future<void> loadChapter(String chapterId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentChapter = await _chapterRepository.getChapterById(chapterId);
      _currentPage = 0;
    } catch (e) {
      debugPrint('Error loading chapter: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update current page
  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();

    // Save progress
    _saveProgress();
  }

  // Change reading mode
  void setReadingMode(ReadingMode mode) {
    _readingMode = mode;
    notifyListeners();
  }

  // Save reading progress
  Future<void> _saveProgress() async {
    if (_currentChapter == null) return;

    // Save to local storage or API
    await StorageService.saveReadingProgress(
      chapterId: _currentChapter!.id,
      currentPage: _currentPage,
      totalPages: _currentChapter!.totalPages,
    );
  }
}

enum ReadingMode {
  vertical,
  horizontal,
}
```

## Usage in Widgets

```dart
// Consuming provider
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MangaProvider>(
      builder: (context, mangaProvider, child) {
        if (mangaProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: [
            // Featured section
            ...mangaProvider.featuredMangas.map((manga) => MangaCard(manga)),
          ],
        );
      },
    );
  }
}

// Accessing provider without rebuild
class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        authProvider.logout();
      },
      child: Text('Logout'),
    );
  }
}
```
