import 'package:flutter/material.dart';
import '../data/models/genre.dart';
import '../data/network/genre_api_service.dart';
import '../data/network/api_exception.dart';

class GenreProvider extends ChangeNotifier {
  final GenreApiService _apiService;

  GenreProvider(this._apiService);

  List<Genre> _genres = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Pagination state
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  List<Genre> get genres => _genres;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalPages => (_genres.length / _itemsPerPage).ceil();

  List<Genre> get paginatedGenres {
    if (_genres.isEmpty) return [];
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    if (startIndex >= _genres.length) return [];
    
    final endIndex = (startIndex + _itemsPerPage < _genres.length) 
        ? startIndex + _itemsPerPage 
        : _genres.length;
        
    return _genres.sublist(startIndex, endIndex);
  }

  void setPage(int page) {
    if (page >= 1 && page <= totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  Future<void> fetchGenres() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _genres = await _apiService.getAllGenres();
      // Reset to page 1 when data changes
      _currentPage = 1;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load genres: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addGenre(GenreRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newGenre = await _apiService.createGenre(request);
      _genres.add(newGenre);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to add genre: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateGenre(String id, GenreRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedGenre = await _apiService.updateGenre(id, request);
      final index = _genres.indexWhere((g) => g.id == id);
      if (index != -1) {
        _genres[index] = updatedGenre;
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update genre: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteGenre(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteGenre(id);
      _genres.removeWhere((g) => g.id == id);
      
      // Adjust current page if the last item on the page was deleted
      if (_currentPage > totalPages && totalPages > 0) {
        _currentPage = totalPages;
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete genre: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
