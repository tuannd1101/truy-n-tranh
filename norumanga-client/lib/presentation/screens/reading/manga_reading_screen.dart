import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/chapter.dart';
import '../../../providers/chapter_provider.dart';

class MangaReadingScreen extends StatefulWidget {
  final String mangaId;
  final double chapterNumber;

  const MangaReadingScreen({
    super.key,
    required this.mangaId,
    required this.chapterNumber,
  });

  @override
  State<MangaReadingScreen> createState() => _MangaReadingScreenState();
}

class _MangaReadingScreenState extends State<MangaReadingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isUIVisible = false;
  
  Chapter? _chapter;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Bật chế độ Fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchChapter();
    });
  }

  Future<void> _fetchChapter() async {
    final chapterProvider = context.read<ChapterProvider>();
    final chapter = await chapterProvider.getChapterDetail(widget.mangaId, widget.chapterNumber);
    if (mounted) {
      setState(() {
        _chapter = chapter;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Khôi phục UI bình thường khi thoát trang đọc
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleUI() {
    setState(() {
      _isUIVisible = !_isUIVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chapterProvider = context.watch<ChapterProvider>();
    final chapters = chapterProvider.chapters;
    
    final currentIndex = chapters.indexWhere((c) => c.chapterNumber == widget.chapterNumber);
    
    double? prevChapterNum;
    double? nextChapterNum;
    
    if (currentIndex > 0) {
      prevChapterNum = chapters[currentIndex - 1].chapterNumber;
    }
    if (currentIndex != -1 && currentIndex < chapters.length - 1) {
      nextChapterNum = chapters[currentIndex + 1].chapterNumber;
    }

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryContainer)),
      );
    }

    if (_chapter == null || _chapter!.pages.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image, color: AppColors.outline, size: 64),
              const SizedBox(height: 16),
              const Text('Chương này không có nội dung', style: TextStyle(color: AppColors.onSurfaceVariant)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Quay lại'),
              )
            ],
          ),
        ),
      );
    }

    final totalPages = _chapter!.pages.length;

    return Scaffold(
      backgroundColor: Colors.black, // Dark manga background
      body: Stack(
        children: [
          // Reading Content
          GestureDetector(
            onTap: _toggleUI,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: totalPages,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Image.network(
                  _chapter!.pages[index],
                  fit: BoxFit.fitWidth, // Webtoon style fits width
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      color: Colors.black,
                      child: const Center(child: CircularProgressIndicator(color: AppColors.primaryContainer)),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    color: Colors.black,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: AppColors.error, size: 64),
                    ),
                  ),
                );
              },
            ),
          ),

          // Top Overlay (App Bar)
          if (_isUIVisible) _buildTopOverlay(),

          // Bottom Overlay (Page Indicator & Slider)
          if (_isUIVisible) _buildBottomOverlay(totalPages, prevChapterNum, nextChapterNum),
        ],
      ),
    );
  }

  Widget _buildTopOverlay() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.8),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.onSurface,
                    size: 24,
                  ),
                ),
              ),
              // Title
              Expanded(
                child: Column(
                  children: [
                    Text(
                      _chapter!.displayTitle.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Anton',
                        color: AppColors.onSurface,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Settings Button
              GestureDetector(
                onTap: () {}, // Mở popup cài đặt đọc truyện (độ sáng, chiều cuộn)
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.8),
                    border: Border.all(color: AppColors.outline),
                  ),
                  child: const Icon(
                    Icons.settings,
                    color: AppColors.onSurface,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomOverlay(int totalPages, double? prevChapterNum, double? nextChapterNum) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.95),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: prevChapterNum == null ? null : () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRouter.reading,
                  arguments: {
                    'mangaId': widget.mangaId,
                    'chapterNumber': prevChapterNum,
                  },
                );
              },
              icon: Icon(Icons.skip_previous, color: prevChapterNum == null ? AppColors.outline : AppColors.onSurfaceVariant),
              label: Text('CHƯƠNG TRƯỚC', style: TextStyle(color: prevChapterNum == null ? AppColors.outline : AppColors.onSurfaceVariant, fontFamily: 'Syne', fontWeight: FontWeight.bold)),
            ),
            TextButton.icon(
              onPressed: nextChapterNum == null ? null : () {
                Navigator.pushReplacementNamed(
                  context,
                  AppRouter.reading,
                  arguments: {
                    'mangaId': widget.mangaId,
                    'chapterNumber': nextChapterNum,
                  },
                );
              },
              icon: Icon(Icons.skip_next, color: nextChapterNum == null ? AppColors.outline : AppColors.primaryContainer),
              label: Text('CHƯƠNG TIẾP', style: TextStyle(color: nextChapterNum == null ? AppColors.outline : AppColors.primaryContainer, fontFamily: 'Syne', fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
