import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../widgets/detail/chapter_list_item.dart';

class MangaDetailScreen extends StatefulWidget {
  final int mangaId;

  const MangaDetailScreen({
    super.key,
    required this.mangaId,
  });

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = false;
  bool _isFavorite = false;
  bool _isLoading = true;
  
  // TODO: Replace with actual data from API
  Map<String, dynamic>? _mangaData;
  List<Map<String, dynamic>> _chapters = [];

  @override
  void initState() {
    super.initState();
    _loadMangaDetail();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMangaDetail() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Call API to fetch manga detail
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // Mock data
    _mangaData = {
      'id': widget.mangaId,
      'title': 'Tên Truyện Dài Có Thể Xuống Nhiều Dòng',
      'author': 'Tác giả ABC',
      'coverUrl': 'https://via.placeholder.com/300x400/FFC107/000000?text=Cover',
      'genres': ['Hành Động', 'Phiêu Lưu', 'Hài Hước'],
      'description': 'Đây là mô tả chi tiết về truyện. Nội dung có thể rất dài và cần có tính năng xem thêm/thu gọn. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
    };

    _chapters = List.generate(
      20,
      (index) => {
        'id': index,
        'number': index + 1,
        'title': 'Chapter ${index + 1}',
        'updatedAt': '2 ngày trước',
        'isPremium': index > 10,
      },
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    // TODO: Call API to add/remove favorite
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? 'Đã thêm vào yêu thích'
              : 'Đã xóa khỏi yêu thích',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onReadNow() {
    if (_chapters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Truyện chưa có chapter nào'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Navigate to first chapter
    Navigator.pushNamed(
      context,
      '/manga-reading',
      arguments: {
        'mangaId': widget.mangaId,
        'chapterId': _chapters[0]['id'],
      },
    );
  }

  void _onChapterTap(Map<String, dynamic> chapter) {
    if (chapter['isPremium']) {
      // TODO: Check user role
      _showPremiumDialog();
      return;
    }

    Navigator.pushNamed(
      context,
      '/manga-reading',
      arguments: {
        'mangaId': widget.mangaId,
        'chapterId': chapter['id'],
      },
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nội dung Premium'),
        content: const Text(
          'Chapter này yêu cầu tài khoản Premium. Bạn có muốn nâng cấp không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/subscription');
            },
            child: const Text('Nâng cấp'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Sliver App Bar with Cover Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.overlay,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textLight,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _mangaData!['title'],
                style: AppTextStyles.h4.copyWith(
                  color: AppColors.textLight,
                  shadows: [
                    const Shadow(
                      color: Colors.black,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Blurred background
                  Image.network(
                    _mangaData!['coverUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: AppColors.greyLight);
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Main cover image
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 60),
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        child: Image.network(
                          _mangaData!['coverUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: AppColors.greyLight,
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 48,
                                color: AppColors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Section
                  Text(
                    _mangaData!['title'],
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  Text(
                    'Tác giả: ${_mangaData!['author']}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  
                  // Genres
                  Wrap(
                    spacing: AppDimensions.paddingS,
                    runSpacing: AppDimensions.paddingS,
                    children: (_mangaData!['genres'] as List<String>)
                        .map(
                          (genre) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingM,
                              vertical: AppDimensions.paddingS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusRound,
                              ),
                              border: Border.all(
                                color: AppColors.primary,
                              ),
                            ),
                            child: Text(
                              genre,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  
                  const SizedBox(height: AppDimensions.paddingL),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: _onReadNow,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.paddingM,
                            ),
                          ),
                          child: const Text('Đọc ngay'),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: _toggleFavorite,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimensions.paddingM,
                            ),
                            side: BorderSide(
                              color: _isFavorite
                                  ? AppColors.error
                                  : AppColors.border,
                            ),
                          ),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorite
                                ? AppColors.error
                                : AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppDimensions.paddingL),
                  
                  // Description
                  Text(
                    'Mô tả',
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  Text(
                    _mangaData!['description'],
                    style: AppTextStyles.bodyMedium,
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded ? null : TextOverflow.ellipsis,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Text(
                      _isExpanded ? 'Thu gọn' : 'Xem thêm',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.paddingL),
                  
                  // Chapter List Header
                  Text(
                    'Danh sách Chapter',
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                ],
              ),
            ),
          ),
          
          // Chapter List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final chapter = _chapters[index];
                return ChapterListItem(
                  chapter: chapter,
                  onTap: () => _onChapterTap(chapter),
                  isAlternate: index % 2 == 1,
                );
              },
              childCount: _chapters.length,
            ),
          ),
        ],
      ),
    );
  }
}
