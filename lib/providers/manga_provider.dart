import 'package:flutter/material.dart';
import '../data/models/manga.dart';
import '../data/network/manga_api_service.dart';
import '../data/network/api_exception.dart';

class MangaProvider extends ChangeNotifier {
  final MangaApiService _apiService;

  MangaProvider(this._apiService);

  List<Manga> _mangas = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Server-side Pagination State (0-indexed for Backend, but we expose 1-indexed to UI)
  int _currentPage = 0;
  int _totalPages = 0;
  int _totalElements = 0;
  final int _pageSize = 10;

  // Active filters
  String? _activeTagId;
  String? _activeStatus;

  List<Manga> get mangas => _mangas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage + 1; // Expose 1-indexed to UI
  int get totalPages => _totalPages;
  int get totalElements => _totalElements;
  int get pageSize => _pageSize;

  Future<void> fetchMangas({int? page, String? tagId, String? status}) async {
    _isLoading = true;
    _errorMessage = null;
    if (tagId != null) _activeTagId = tagId;
    if (status != null) _activeStatus = status;
    notifyListeners();

    try {
      final targetPage = page ?? _currentPage;
      final paginatedData = await _apiService.getMangas(
        page: targetPage,
        size: _pageSize,
        tagId: _activeTagId,
        status: _activeStatus,
      );

      _mangas = paginatedData.mangas;
      _totalPages = paginatedData.totalPages;
      _totalElements = paginatedData.totalElements;
      _currentPage = paginatedData.currentPage;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load mangas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setPage(int page) async {
    if (page >= 1 && page <= _totalPages) {
      await fetchMangas(page: page - 1);
    }
  }

  Future<void> clearFilters() async {
    _activeTagId = null;
    _activeStatus = null;
    await fetchMangas(page: 0);
  }

  Future<bool> addManga(Map<String, dynamic> mangaData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.createManga(mangaData);
      await fetchMangas(page: 0); // Reload first page
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to add manga: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateManga(String id, Map<String, dynamic> mangaData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedManga = await _apiService.updateManga(id, mangaData);
      final index = _mangas.indexWhere((m) => m.id == id);
      if (index != -1) {
        _mangas[index] = updatedManga;
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update manga: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteManga(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteManga(id);
      await fetchMangas(); // Refresh current page
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete manga: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
