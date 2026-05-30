import 'package:flutter/foundation.dart';
import '../data/models/chapter.dart';
import '../data/network/chapter_api_service.dart';

class ChapterProvider with ChangeNotifier {
  final ChapterApiService _apiService;
  
  List<Chapter> _chapters = [];
  bool _isLoading = false;
  String? _errorMessage;

  ChapterProvider(this._apiService);

  List<Chapter> get chapters => _chapters;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchChapters(String mangaId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _chapters = await _apiService.getChaptersByManga(mangaId);
      // Sort ascending by chapterNumber
      _chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
    } catch (e) {
      _errorMessage = e.toString();
      _chapters = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Chapter?> getChapterDetail(String mangaId, double chapterNumber) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final chapter = await _apiService.getChapterDetail(mangaId, chapterNumber);
      _isLoading = false;
      notifyListeners();
      return chapter;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> createChapter(String mangaId, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newChapter = await _apiService.createChapter(mangaId, data);
      _chapters.add(newChapter);
      _chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
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

  Future<bool> updateChapter(String mangaId, String chapterId, Map<String, dynamic> data) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedChapter = await _apiService.updateChapter(mangaId, chapterId, data);
      final index = _chapters.indexWhere((c) => c.id == chapterId);
      if (index != -1) {
        _chapters[index] = updatedChapter;
        _chapters.sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));
      }
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

  Future<bool> deleteChapter(String mangaId, String chapterId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _apiService.deleteChapter(mangaId, chapterId);
      _chapters.removeWhere((c) => c.id == chapterId);
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
}
