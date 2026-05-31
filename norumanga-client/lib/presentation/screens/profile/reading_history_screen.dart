import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/reading_history.dart';
import '../../../providers/reading_history_provider.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  State<ReadingHistoryScreen> createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReadingHistoryProvider>().fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Consumer<ReadingHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.history.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryContainer));
          }
          if (provider.errorMessage != null && provider.history.isEmpty) {
            return _buildError(provider);
          }
          if (provider.history.isEmpty) {
            return _buildEmptyState();
          }
          return RefreshIndicator(
            color: AppColors.primaryContainer,
            backgroundColor: AppColors.surfaceContainer,
            onRefresh: () => provider.fetchHistory(),
            child: ListView.builder(
              itemCount: provider.history.length,
              itemBuilder: (context, index) =>
                  _buildHistoryItem(provider.history[index]),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.onSurface),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(color: AppColors.border, height: 2),
      ),
      title: const Text(
        'LỊCH SỬ ĐỌC',
        style: TextStyle(
          fontFamily: 'Anton',
          color: AppColors.onSurface,
          fontSize: 24,
          letterSpacing: 1,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep, color: AppColors.primaryContainer),
          onPressed: _showClearAllDialog,
        ),
      ],
    );
  }

  Widget _buildHistoryItem(ReadingHistoryEntry entry) {
    final manga = entry.manga;
    final title = manga?.title ?? 'Truyện không tồn tại';
    final coverUrl = manga?.coverUrl ?? '';
    final chapterLabel = entry.chapterNumber != null
        ? 'Chương ${_formatChapter(entry.chapterNumber!)}'
        : '';

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
        color: AppColors.background,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (manga != null) {
              Navigator.pushNamed(context, AppRouter.mangaDetail,
                  arguments: manga.id);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    border: Border.all(color: AppColors.border, width: 2),
                  ),
                  child: coverUrl.isNotEmpty
                      ? Image.network(coverUrl, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image,
                              color: AppColors.outline))
                      : const Icon(Icons.image, color: AppColors.outline),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Anton',
                          letterSpacing: 1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      if (chapterLabel.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: AppColors.secondaryContainer.withValues(alpha: 0.2),
                          child: Text(
                            chapterLabel,
                            style: const TextStyle(
                              color: AppColors.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: AppColors.onSurfaceVariant, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            _relativeTime(entry.lastReadAt),
                            style: const TextStyle(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(ReadingHistoryProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.error),
            const SizedBox(height: 16),
            Text(provider.errorMessage ?? 'Đã xảy ra lỗi',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.onSurface)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchHistory(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer),
              child: const Text('THỬ LẠI'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history, size: 80, color: AppColors.outline),
          const SizedBox(height: 24),
          const Text(
            'CHƯA CÓ LỊCH SỬ ĐỌC',
            style: TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurfaceVariant,
              fontSize: 24,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Những truyện bạn đọc sẽ xuất hiện ở đây',
            style: TextStyle(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(color: AppColors.border, width: 2),
              ),
            ),
            child: const Text(
              'KHÁM PHÁ TRUYỆN',
              style: TextStyle(
                fontFamily: 'Syne',
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.primaryContainer, width: 2),
        ),
        title: const Text(
          'XÓA TẤT CẢ?',
          style: TextStyle(fontFamily: 'Anton', color: AppColors.error),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa toàn bộ lịch sử đọc? Hành động này không thể hoàn tác.',
          style: TextStyle(color: AppColors.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('HỦY',
                style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await context.read<ReadingHistoryProvider>().clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorContainer,
              foregroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('XÓA'),
          ),
        ],
      ),
    );
  }

  String _formatChapter(double n) {
    return n == n.roundToDouble() ? n.toInt().toString() : n.toString();
  }

  String _relativeTime(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 30) return '${diff.inDays} ngày trước';
    String two(int x) => x.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year}';
  }
}
