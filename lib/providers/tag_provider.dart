import 'package:flutter/material.dart';
import '../data/models/tag.dart';
import '../data/network/tag_api_service.dart';
import '../data/network/api_exception.dart';

class TagProvider extends ChangeNotifier {
  final TagApiService _apiService;

  TagProvider(this._apiService);

  List<Tag> _tags = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Pagination state
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  List<Tag> get tags => _tags;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalPages => (_tags.length / _itemsPerPage).ceil();

  List<Tag> get paginatedTags {
    if (_tags.isEmpty) return [];
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    if (startIndex >= _tags.length) return [];
    
    final endIndex = (startIndex + _itemsPerPage < _tags.length) 
        ? startIndex + _itemsPerPage 
        : _tags.length;
        
    return _tags.sublist(startIndex, endIndex);
  }

  void setPage(int page) {
    if (page >= 1 && page <= totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  Future<void> fetchTags({String? group}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tags = await _apiService.getAllTags(group: group);
      // Reset to page 1 when data changes
      _currentPage = 1;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load tags: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTag(TagRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newTag = await _apiService.createTag(request);
      _tags.add(newTag);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to add tag: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTag(String id, TagRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedTag = await _apiService.updateTag(id, request);
      final index = _tags.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tags[index] = updatedTag;
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update tag: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTag(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteTag(id);
      _tags.removeWhere((t) => t.id == id);
      
      // Adjust current page if the last item on the page was deleted
      if (_currentPage > totalPages && totalPages > 0) {
        _currentPage = totalPages;
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete tag: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
