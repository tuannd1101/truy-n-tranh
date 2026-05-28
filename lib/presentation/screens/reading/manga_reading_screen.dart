import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class MangaReadingScreen extends StatefulWidget {
  final int mangaId;
  final int chapterId;

  const MangaReadingScreen({
    super.key,
    required this.mangaId,
    required this.chapterId,
  });

  @override
  State<MangaReadingScreen> createState() => _MangaReadingScreenState();
}

class _MangaReadingScreenState extends State<MangaReadingScreen> {
  final PageController _pageController = PageController();
  bool _isUIVisible = false;
  int _currentPage = 0;
  final int _totalPages = 24; // Mock 24 trang

  @override
  void initState() {
    super.initState();
    // Bật chế độ Fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Khôi phục UI bình thường khi thoát trang đọc
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _pageController.dispose();
    super.dispose();
  }

  void _toggleUI() {
    setState(() {
      _isUIVisible = !_isUIVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark manga background
      body: Stack(
        children: [
          // Reading Content
          GestureDetector(
            onTap: _toggleUI,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _totalPages,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/hero_artist.png'),
                      fit: BoxFit.contain, // Fit để không bị cắt xén nội dung truyện
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Page ${index + 1}',
                      style: TextStyle(
                        fontFamily: 'Anton',
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Top Overlay (App Bar)
          if (_isUIVisible) _buildTopOverlay(),

          // Bottom Overlay (Page Indicator & Slider)
          if (_isUIVisible) _buildBottomOverlay(),
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
              const Expanded(
                child: Column(
                  children: [
                    Text(
                      'CRIMSON BLADE',
                      style: TextStyle(
                        fontFamily: 'Anton',
                        color: AppColors.onSurface,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'CH. 42: THE AWAKENING',
                      style: TextStyle(
                        fontFamily: 'Syne',
                        color: AppColors.primaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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

  Widget _buildBottomOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 140,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Next / Prev Chapter buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {}, // Chuyển chương trước
                    icon: const Icon(Icons.skip_previous, color: AppColors.onSurfaceVariant),
                    label: const Text('CHƯƠNG TRƯỚC', style: TextStyle(color: AppColors.onSurfaceVariant, fontFamily: 'Syne', fontWeight: FontWeight.bold)),
                  ),
                  TextButton.icon(
                    onPressed: () {}, // Chuyển chương tiếp
                    icon: const Icon(Icons.skip_next, color: AppColors.primaryContainer),
                    label: const Text('CHƯƠNG TIẾP', style: TextStyle(color: AppColors.primaryContainer, fontFamily: 'Syne', fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            
            // Slider & Page count
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                children: [
                  Text(
                    '${_currentPage + 1}',
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      color: AppColors.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.primaryContainer,
                        inactiveTrackColor: AppColors.surfaceVariant,
                        thumbColor: AppColors.onPrimaryContainer,
                        trackHeight: 4.0,
                      ),
                      child: Slider(
                        value: _currentPage.toDouble(),
                        min: 0,
                        max: (_totalPages - 1).toDouble(),
                        onChanged: (value) {
                          _pageController.jumpToPage(value.toInt());
                        },
                      ),
                    ),
                  ),
                  Text(
                    '$_totalPages',
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      color: AppColors.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
