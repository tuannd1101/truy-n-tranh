import 'package:flutter/material.dart';
import '../data/models/manga.dart';
import '../data/models/creator.dart';
import '../data/models/tag.dart';
import '../data/network/manga_api_service.dart';
import '../data/network/api_exception.dart';

/// Lifecycle status of the manga search.
enum SearchStatus { idle, loading, success, empty, error }

/// Holds the current Search_Criteria, results, Result_Count, pagination state,
/// and request status for the Search_Screen.
class SearchProvider extends ChangeNotifier {
  final MangaApiService _apiService;

  SearchProvider(this._apiService);

  // ── Search_Criteria ──────────────────────────────────────────────
  String _keyword = '';
  Creator? _creator; // Creator_Filter (null = none)
  List<Tag> _tags = []; // Tag_Filter (empty = none)

  // ── Results & pagination ─────────────────────────────────────────
  List<Manga> _results = [];
  int _resultCount = 0; // Result_Count == totalElements
  int _currentPage = 0; // 0-based page index
  int _totalPages = 0;
  final int _pageSize = 20;

  // The backend has no creator filter, so when a creator is selected we fetch a
  // larger candidate set, filter by creator on the client, and paginate that
  // filtered list locally. This cache holds the full filtered list.
  static const int _creatorFetchSize = 200;
  List<Manga> _creatorFiltered = [];

  SearchStatus _status = SearchStatus.idle;
  String? _errorMessage;

  // ── Exposed getters ──────────────────────────────────────────────
  String get keyword => _keyword;
  Creator? get creator => _creator;
  List<Tag> get tags => List.unmodifiable(_tags);
  List<Manga> get results => List.unmodifiable(_results);
  int get resultCount => _resultCount;

  /// 1-based Page_Number for the UI.
  int get currentPage => _currentPage + 1;
  int get totalPages => _totalPages;
  int get pageSize => _pageSize;

  SearchStatus get status => _status;
  bool get isLoading => _status == SearchStatus.loading;
  String? get errorMessage => _errorMessage;

  bool get hasPreviousPage => currentPage > 1;
  bool get hasNextPage => currentPage < _totalPages;
  bool get hasMultiplePages => _totalPages > 1;

  // ── Criteria mutators (do not trigger a request by themselves) ────
  void setKeyword(String value) {
    _keyword = value;
    notifyListeners();
  }

  void setCreator(Creator? creator) {
    _creator = creator;
    notifyListeners();
  }

  void setTags(List<Tag> tags) {
    _tags = List.of(tags);
    notifyListeners();
  }

  // ── Search lifecycle ─────────────────────────────────────────────

  /// Requests the first page with the current Search_Criteria.
  Future<void> submitSearch() => _fetch(0);

  /// Requests the given 1-based page with the unchanged Search_Criteria.
  Future<void> goToPage(int oneBasedPage) {
    if (oneBasedPage < 1 || oneBasedPage > _totalPages) return Future.value();
    return _fetch(oneBasedPage - 1);
  }

  Future<void> nextPage() {
    if (!hasNextPage) return Future.value();
    return _fetch(_currentPage + 1);
  }

  Future<void> previousPage() {
    if (!hasPreviousPage) return Future.value();
    return _fetch(_currentPage - 1);
  }

  /// Re-runs the request for the current page using the current criteria.
  Future<void> retry() => _fetch(_currentPage);

  /// Resets criteria, results, and Result_Count to their empty values.
  void clear() {
    _keyword = '';
    _creator = null;
    _tags = [];
    _results = [];
    _creatorFiltered = [];
    _resultCount = 0;
    _currentPage = 0;
    _totalPages = 0;
    _status = SearchStatus.idle;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> _fetch(int pageIndex) async {
    _status = SearchStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_creator != null) {
        await _fetchWithCreator(pageIndex);
      } else {
        await _fetchServerPaged(pageIndex);
      }
      _status = _results.isEmpty ? SearchStatus.empty : SearchStatus.success;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _status = SearchStatus.error;
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại.';
      _status = SearchStatus.error;
    } finally {
      notifyListeners();
    }
  }

  /// Server-side pagination path (no creator filter).
  Future<void> _fetchServerPaged(int pageIndex) async {
    final paginated = await _apiService.searchMangas(
      keyword: _keyword,
      tagIds: _tags.map((t) => t.id).toList(),
      page: pageIndex,
      size: _pageSize,
    );

    _results = paginated.mangas;
    _resultCount = paginated.totalElements;
    _totalPages = paginated.totalPages;
    _currentPage = paginated.currentPage;
  }

  /// Client-side creator filter path with local pagination.
  ///
  /// The backend exposes no creator filter, so we fetch a larger candidate set
  /// (matching keyword/tags) on the first page request, filter by the selected
  /// creator's name on the client, then slice it into local pages.
  Future<void> _fetchWithCreator(int pageIndex) async {
    // Only refetch the candidate set when starting a fresh search (page 0).
    if (pageIndex == 0) {
      final paginated = await _apiService.searchMangas(
        keyword: _keyword,
        tagIds: _tags.map((t) => t.id).toList(),
        page: 0,
        size: _creatorFetchSize,
      );
      _creatorFiltered = _filterByCreator(paginated.mangas, _creator!);
    }

    _resultCount = _creatorFiltered.length;
    _totalPages = (_creatorFiltered.length / _pageSize).ceil();

    // Clamp the requested page into range.
    final maxIndex = _totalPages == 0 ? 0 : _totalPages - 1;
    final safeIndex = pageIndex.clamp(0, maxIndex);
    _currentPage = safeIndex;

    final start = safeIndex * _pageSize;
    if (start >= _creatorFiltered.length) {
      _results = [];
    } else {
      final end = (start + _pageSize) > _creatorFiltered.length
          ? _creatorFiltered.length
          : (start + _pageSize);
      _results = _creatorFiltered.sublist(start, end);
    }
  }

  /// Keeps only manga whose creator names include the selected creator.
  ///
  /// `Manga.creatorIds` actually holds creator names (mapped from the API's
  /// `creators[].name`), so we match against the creator's name.
  List<Manga> _filterByCreator(List<Manga> mangas, Creator creator) {
    final target = creator.name.trim().toLowerCase();
    if (target.isEmpty) return mangas;
    return mangas.where((m) {
      return m.creatorIds.any(
        (name) => name.trim().toLowerCase() == target,
      );
    }).toList();
  }
}
