import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../widgets/home/banner_carousel.dart';
import '../../widgets/home/manga_section.dart';
import '../../widgets/home/horizontal_manga_list.dart';
import '../../widgets/home/manga_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Call API to fetch manga data
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // TODO: Call API to reload home data
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingS),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.menu_book, color: AppColors.primary);
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Navigate to search screen
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Navigate to profile screen
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Carousel Section
                    const BannerCarousel(),
                    
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    // New Updates Section
                    MangaSection(
                      title: 'Truyện Mới Cập Nhật',
                      onSeeAllPressed: () {
                        // TODO: Navigate to see all new updates
                      },
                      child: const HorizontalMangaList(),
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingL),
                    
                    // Recommended Section
                    MangaSection(
                      title: 'Đề Cử Cho Bạn',
                      onSeeAllPressed: () {
                        // TODO: Navigate to see all recommendations
                      },
                      child: const MangaGrid(),
                    ),
                    
                    const SizedBox(height: AppDimensions.paddingL),
                  ],
                ),
              ),
            ),
    );
  }
}
