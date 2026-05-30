import 'package:flutter/material.dart';
import '../data/models/creator.dart';
import '../data/network/creator_api_service.dart';
import '../data/network/api_exception.dart';

class CreatorProvider extends ChangeNotifier {
  final CreatorApiService _apiService;

  CreatorProvider(this._apiService);

  List<Creator> _creators = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Pagination state
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  List<Creator> get creators => _creators;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalPages => (_creators.length / _itemsPerPage).ceil();

  List<Creator> get paginatedCreators {
    if (_creators.isEmpty) return [];
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    if (startIndex >= _creators.length) return [];
    
    final endIndex = (startIndex + _itemsPerPage < _creators.length) 
        ? startIndex + _itemsPerPage 
        : _creators.length;
        
    return _creators.sublist(startIndex, endIndex);
  }

  void setPage(int page) {
    if (page >= 1 && page <= totalPages) {
      _currentPage = page;
      notifyListeners();
    }
  }

  Future<void> fetchCreators() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _creators = await _apiService.getAllCreators();
      // Reset to page 1 when data changes
      _currentPage = 1;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Failed to load creators: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCreator(CreatorRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCreator = await _apiService.createCreator(request);
      _creators.add(newCreator);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to add creator: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateCreator(String id, CreatorRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedCreator = await _apiService.updateCreator(id, request);
      final index = _creators.indexWhere((c) => c.id == id);
      if (index != -1) {
        _creators[index] = updatedCreator;
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update creator: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCreator(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteCreator(id);
      _creators.removeWhere((c) => c.id == id);
      
      // Adjust current page if the last item on the page was deleted
      if (_currentPage > totalPages && totalPages > 0) {
        _currentPage = totalPages;
      }
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete creator: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
