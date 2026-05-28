import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

class MangaDetailScreen extends StatefulWidget {
  final int mangaId;

  const MangaDetailScreen({super.key, required this.mangaId});

  @override
  State<MangaDetailScreen> createState() => _MangaDetailScreenState();
}

class _MangaDetailScreenState extends State<MangaDetailScreen> {
  // Mock data
  final Map<String, dynamic> mangaData = {
    'title': 'CRIMSON BLADE',
    'author': 'By M. Shinkai',
    'status': 'ONGOING',
    'rating': '4.8',
    'genres': ['ACTION', 'SEINEN', 'HISTORICAL'],
    'description': 'A masterless samurai seeks vengeance across the Edo period. Blood will flow and blades will clash in this epic tale of honor and betrayal.',
    'chapters': List.generate(24, (index) => {
      'id': 24 - index,
      'title': 'Chương ${24 - index}',
      'date': '12/05/2026',
      'views': '12K',
    })
  };

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: _buildMangaInfo(),
          ),
          SliverToBoxAdapter(
            child: _buildActionButtons(),
          ),
          SliverToBoxAdapter(
            child: _buildDescription(),
          ),
          SliverToBoxAdapter(
            child: _buildChapterHeader(),
          ),
          _buildChapterList(),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.8),
            border: Border.all(color: AppColors.outline),
          ),
          child: const Icon(Icons.arrow_back, color: AppColors.onSurface, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.asset(
              'assets/images/hero_artist.png',
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.saturation,
              color: Colors.grey,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.background.withOpacity(0.5),
                    AppColors.background,
                  ],
                  stops: const [0.3, 0.7, 1.0],
                ),
              ),
            ),
            // Status Badge
            Positioned(
              top: 80,
              right: -10,
              child: Transform.rotate(
                angle: 0.1,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: AppColors.secondaryContainer,
                  child: Text(
                    mangaData['status'],
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      color: AppColors.onSecondaryContainer,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMangaInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  mangaData['title'],
                  style: const TextStyle(
                    fontFamily: 'Anton',
                    color: AppColors.onSurface,
                    fontSize: 40,
                    height: 1.1,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: AppColors.primaryContainer,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mangaData['author'],
                style: const TextStyle(
                  fontFamily: 'Syne',
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.tertiary, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    mangaData['rating'],
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      color: AppColors.tertiary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (mangaData['genres'] as List<String>).map((genre) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.outline),
                  color: AppColors.surfaceContainerHigh,
                ),
                child: Text(
                  genre,
                  style: const TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                // Đọc chương đầu tiên
                Navigator.pushNamed(context, AppRouter.reading);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  border: Border.all(color: AppColors.outline, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.onSurface,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.menu_book, color: AppColors.onPrimaryContainer),
                    SizedBox(width: 8),
                    Text(
                      'ĐỌC TỪ ĐẦU',
                      style: TextStyle(
                        fontFamily: 'Anton',
                        color: AppColors.onPrimaryContainer,
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                // Thêm vào yêu thích
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  border: Border.all(color: AppColors.error, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.errorContainer,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.favorite_border, color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TÓM TẮT',
            style: TextStyle(
              fontFamily: 'Syne',
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            mangaData['description'],
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildChapterHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.list, color: AppColors.primaryContainer),
          SizedBox(width: 8),
          Text(
            'DANH SÁCH CHƯƠNG',
            style: TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurface,
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterList() {
    final chapters = mangaData['chapters'] as List<dynamic>;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final chapter = chapters[index];
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRouter.reading);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter['title'],
                        style: const TextStyle(
                          fontFamily: 'Syne',
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chapter['date'],
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.visibility, color: AppColors.onSurfaceVariant, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        chapter['views'],
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
          );
        },
        childCount: chapters.length,
      ),
    );
  }
}
