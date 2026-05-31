import 'package:flutter/material.dart';
import '../data/models/reading_history.dart';
import '../data/network/reading_history_api_service.dart';
import '../data/network/api_exception.dart';

class ReadingHistoryProvider extends ChangeNotifier {
  final ReadingHistoryApiService _apiService;

  ReadingHistoryProvider(this._apiService);

  List<ReadingHistoryEntry> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ReadingHistoryEntry> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHistory() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _history = await _apiService.getMyHistory();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Không thể tải lịch sử đọc: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Records reading progress. Fire-and-forget friendly (errors swallowed).
  Future<void> record({
    required String mangaId,
    required double chapterNumber,
  }) async {
    try {
      await _apiService.record(mangaId: mangaId, chapterNumber: chapterNumber);
    } catch (_) {
      // Non-critical: don't disrupt reading flow on failure.
    }
  }

  Future<bool> clear() async {
    try {
      await _apiService.clear();
      _history = [];
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Không thể xóa lịch sử: $e';
      notifyListeners();
      return false;
    }
  }
}
