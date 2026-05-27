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
  bool _isUIVisible = true;
  int _currentPage = 11; // 12 in 0-indexed is 11
  final int _totalPages = 24;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
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
      backgroundColor: const Color(0xFF13131B), // Dark manga background
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
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Page ${index + 1}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Top App Bar Overlay
          if (_isUIVisible)
            Positioned(
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
                      Colors.black.withOpacity(0.8),
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
                            color: const Color(0xFF1B1B23),
                            border: Border.all(color: AppColors.primaryContainer, width: 2),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.primaryContainer,
                            size: 20,
                          ),
                        ),
                      ),
                      // Title
                      const Expanded(
                        child: Text(
                          'CH. 42: THE AWAKENI...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'sans-serif',
                            color: AppColors.primaryContainer,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            shadows: [
                              Shadow(color: AppColors.primaryContainer, blurRadius: 4),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Settings Button
                      GestureDetector(
                        onTap: () {}, // Open settings
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1B23),
                            border: Border.all(color: Colors.cyanAccent, width: 2),
                          ),
                          child: const Icon(
                            Icons.settings,
                            color: Colors.cyanAccent,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom Page Indicator Overlay
          if (_isUIVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Pink shadow box
                        Positioned(
                          top: 4,
                          left: 4,
                          right: -4,
                          bottom: -4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              border: Border.all(color: AppColors.primaryContainer, width: 2),
                            ),
                          ),
                        ),
                        // Main box
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B1B23),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            '${_currentPage + 1} / $_totalPages',
                            style: const TextStyle(
                              fontFamily: 'sans-serif',
                              color: Colors.cyanAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
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
}
