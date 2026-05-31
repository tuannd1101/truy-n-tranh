import 'package:flutter/material.dart';
import '../data/models/favorite.dart';
import '../data/network/favorite_api_service.dart';
import '../data/network/api_exception.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteApiService _apiService;

  FavoriteProvider(this._apiService);

  List<Favorite> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Favorite> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchFavorites() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _favorites = await _apiService.getMyFavorites();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Không thể tải truyện yêu thích: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavoriteLocal(String mangaId) {
    return _favorites.any((f) => f.mangaId == mangaId);
  }

  Future<bool> isFavorite(String mangaId) async {
    try {
      return await _apiService.isFavorite(mangaId);
    } catch (_) {
      return isFavoriteLocal(mangaId);
    }
  }

  Future<bool> addFavorite(String mangaId) async {
    try {
      await _apiService.addFavorite(mangaId);
      await fetchFavorites();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Không thể thêm yêu thích: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavorite(String mangaId) async {
    try {
      await _apiService.removeFavorite(mangaId);
      _favorites.removeWhere((f) => f.mangaId == mangaId);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Không thể bỏ yêu thích: $e';
      notifyListeners();
      return false;
    }
  }

  /// Toggles favorite state for [mangaId]. Returns the new state.
  Future<bool> toggleFavorite(String mangaId) async {
    if (isFavoriteLocal(mangaId)) {
      await removeFavorite(mangaId);
      return false;
    } else {
      await addFavorite(mangaId);
      return true;
    }
  }
}
