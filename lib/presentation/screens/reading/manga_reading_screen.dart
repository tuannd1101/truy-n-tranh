import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

enum ReadingMode { vertical, horizontal }

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
  final ScrollController _scrollController = ScrollController();
  
  bool _isUIVisible = true;
  bool _isLoading = true;
  ReadingMode _readingMode = ReadingMode.vertical;
  int _currentPage = 0;
  double _brightness = 0.5;
  bool _isDarkMode = false;
  
  // TODO: Replace with actual data from API
  List<String> _pages = [];
  Map<String, dynamic>? _chapterData;
  bool _hasNextChapter = true;
  bool _hasPreviousChapter = true;

  @override
  void initState() {
    super.initState();
    _loadChapterData();
    _loadReadingPreferences();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChapterData() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Call API to fetch chapter pages
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // Mock data
    _chapterData = {
      'id': widget.chapterId,
      'number': 1,
      'title': 'Chapter 1',
    };

    _pages = List.generate(
      15,
      (index) => 'https://via.placeholder.com/800x1200/FFC107/000000?text=Page+${index + 1}',
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _saveReadingProgress();
    }
  }

  void _loadReadingPreferences() {
    // TODO: Load from SharedPreferences
    setState(() {
      _readingMode = ReadingMode.vertical;
      _brightness = 0.5;
      _isDarkMode = false;
    });
  }

  void _saveReadingProgress() {
    // TODO: Save to Local Storage (chapter ID, page number)
  }

  void _toggleUI() {
    setState(() {
      _isUIVisible = !_isUIVisible;
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _saveReadingProgress();
  }

  void _goToNextChapter() {
    if (!_hasNextChapter) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chuyển Chapter'),
        content: const Text('Bạn có muốn chuyển sang chapter tiếp theo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to next chapter
            },
            child: const Text('Tiếp tục'),
          ),
        ],
      ),
    );
  }

  void _goToPreviousChapter() {
    if (!_hasPreviousChapter) return;
    // TODO: Navigate to previous chapter
  }

  void _showSettingsPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cài đặt đọc truyện',
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: AppDimensions.paddingL),
                
                // Reading Mode
                Text(
                  'Chế độ đọc',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: AppDimensions.paddingS),
                Row(
                  children: [
                    Expanded(
                      child: _buildModeButton(
                        'Cuộn dọc',
                        Icons.swap_vert,
                        _readingMode == ReadingMode.vertical,
                        () {
                          setState(() {
                            _readingMode = ReadingMode.vertical;
                          });
                          setModalState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: _buildModeButton(
                        'Vuốt ngang',
                        Icons.swap_horiz,
                        _readingMode == ReadingMode.horizontal,
                        () {
                          setState(() {
                            _readingMode = ReadingMode.horizontal;
                          });
                          setModalState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.paddingL),
                
                // Brightness
                Text(
                  'Độ sáng',
                  style: AppTextStyles.h4,
                ),
                Slider(
                  value: _brightness,
                  onChanged: (value) {
                    setState(() {
                      _brightness = value;
                    });
                    setModalState(() {});
                  },
                  activeColor: AppColors.primary,
                ),
                
                const SizedBox(height: AppDimensions.paddingM),
                
                // Dark Mode
                SwitchListTile(
                  title: Text(
                    'Chế độ ban đêm',
                    style: AppTextStyles.bodyMedium,
                  ),
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                    setModalState(() {});
                  },
                  activeColor: AppColors.primary,
                ),
                
                const SizedBox(height: AppDimensions.paddingL),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildModeButton(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.greyLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.grey,
            ),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : AppColors.surface,
      body: Stack(
        children: [
          // Main Content
          GestureDetector(
            onTap: _toggleUI,
            child: _readingMode == ReadingMode.vertical
                ? _buildVerticalReader()
                : _buildHorizontalReader(),
          ),
          
          // Top App Bar
          if (_isUIVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textLight,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    title: Text(
                      'Chapter ${_chapterData!['number']}',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: AppColors.textLight,
                        ),
                        onPressed: _showSettingsPanel,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Bottom Bar
          if (_isUIVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Progress Slider
                        Row(
                          children: [
                            Text(
                              '${_currentPage + 1}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                            Expanded(
                              child: Slider(
                                value: _currentPage.toDouble(),
                                min: 0,
                                max: (_pages.length - 1).toDouble(),
                                onChanged: (value) {
                                  final page = value.toInt();
                                  if (_readingMode == ReadingMode.horizontal) {
                                    _pageController.jumpToPage(page);
                                  }
                                  setState(() {
                                    _currentPage = page;
                                  });
                                },
                                activeColor: AppColors.primary,
                                inactiveColor: AppColors.grey,
                              ),
                            ),
                            Text(
                              '${_pages.length}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        
                        // Navigation Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.skip_previous,
                                color: _hasPreviousChapter
                                    ? AppColors.primary
                                    : AppColors.grey,
                              ),
                              onPressed: _hasPreviousChapter
                                  ? _goToPreviousChapter
                                  : null,
                            ),
                            Text(
                              'Trang ${_currentPage + 1}/${_pages.length}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textLight,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.skip_next,
                                color: _hasNextChapter
                                    ? AppColors.primary
                                    : AppColors.grey,
                              ),
                              onPressed: _hasNextChapter
                                  ? _goToNextChapter
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVerticalReader() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _pages.length,
      itemBuilder: (context, index) {
        return _buildPageImage(_pages[index]);
      },
    );
  }

  Widget _buildHorizontalReader() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: _pages.length,
      itemBuilder: (context, index) {
        return _buildPageImage(_pages[index]);
      },
    );
  }

  Widget _buildPageImage(String imageUrl) {
    return InteractiveViewer(
      minScale: 1.0,
      maxScale: 3.0,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.greyLight,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Retry loading
                      });
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: _isDarkMode ? Colors.black : AppColors.greyLight,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: AppColors.primary,
              ),
            ),
          );
        },
      ),
    );
  }
}
