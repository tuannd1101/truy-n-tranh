import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/main_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedGenre = 'Tất cả';
  final List<String> _genres = [
    'Tất cả',
    'Shounen',
    'Action',
    'Romance',
    'Fantasy',
    'Sci-fi',
    'Horror'
  ];

  // Mock data cho Featured
  final Map<String, dynamic> _featuredManga = {
    'title': 'NEON DRIFT',
    'chapter': 'Chương 14',
    'tag': 'HOT',
    'genres': ['ACTION', 'SCI-FI'],
    'image': 'assets/images/hero_artist.png'
  };

  // Mock data cho Feed
  final List<Map<String, dynamic>> _latestManga = [
    {
      'id': 1,
      'title': 'CRIMSON BLADE',
      'chapter': 'Chương 42',
      'genres': ['ACTION', 'SEINEN'],
      'isNew': true,
    },
    {
      'id': 2,
      'title': 'STARFALL MAGIC',
      'chapter': 'Chương 5',
      'genres': ['FANTASY', 'SHOUJO'],
      'isNew': false,
    },
    {
      'id': 3,
      'title': 'CYBER SAMURAI',
      'chapter': 'Chương 10',
      'genres': ['ACTION', 'SCI-FI'],
      'isNew': true,
    },
    {
      'id': 4,
      'title': 'SILENT ECHO',
      'chapter': 'Chương 22',
      'genres': ['MYSTERY'],
      'isNew': false,
    },
    {
      'id': 5,
      'title': 'TOKYO GHOUL',
      'chapter': 'Chương 143',
      'genres': ['HORROR', 'ACTION'],
      'isNew': false,
    },
    {
      'id': 6,
      'title': 'SOLO LEVELING',
      'chapter': 'Chương 179',
      'genres': ['ACTION', 'FANTASY'],
      'isNew': true,
    },
  ];

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
      appBar: const MainAppBar(),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildCategories(),
            const SizedBox(height: 24),
            _buildSectionHeader('NỔI BẬT HÔM NAY'),
            const SizedBox(height: 16),
            _buildFeaturedManga(),
            const SizedBox(height: 32),
            _buildSectionHeader('MỚI CẬP NHẬT'),
            const SizedBox(height: 16),
            _buildMangaGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.search);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          border: Border.all(color: AppColors.outline),
          boxShadow: const [
            BoxShadow(
              color: AppColors.onSurface,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: AppColors.onSurfaceVariant),
            SizedBox(width: 12),
            Text(
              'Tìm kiếm truyện, tác giả...',
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontFamily: 'Syne',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _genres.length,
        itemBuilder: (context, index) {
          final genre = _genres[index];
          final isSelected = genre == _selectedGenre;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedGenre = genre;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryContainer
                      : AppColors.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryContainer
                        : AppColors.outline,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          const BoxShadow(
                            color: AppColors.tertiary,
                            offset: Offset(2, 2),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  genre.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Syne',
                    color: isSelected
                        ? AppColors.onPrimaryContainer
                        : AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            color: AppColors.primaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurface,
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          const Text(
            'XEM TẤT CẢ',
            style: TextStyle(
              fontFamily: 'Syne',
              color: AppColors.tertiary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.tertiary, size: 16),
        ],
      ),
    );
  }

  Widget _buildFeaturedManga() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.mangaDetail, arguments: 1);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          border: Border.all(color: AppColors.border, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.primaryContainer,
              offset: Offset(6, 6),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover Image Placeholder
            const Center(
              child: Icon(Icons.image, size: 64, color: AppColors.outline),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.3, 1.0],
                ),
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: (_featuredManga['genres'] as List<String>)
                        .map((genre) => Container(
                              margin: const EdgeInsets.only(right: 8, bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              color: AppColors.tertiary,
                              child: Text(
                                genre,
                                style: const TextStyle(
                                  color: AppColors.onTertiary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  Text(
                    _featuredManga['title'],
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      color: Colors.white,
                      fontSize: 32,
                      letterSpacing: 1.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _featuredManga['chapter'],
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      color: AppColors.primaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // HOT tag
            Positioned(
              top: 12,
              right: -12,
              child: Transform.rotate(
                angle: 0.2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  color: AppColors.errorContainer,
                  child: const Text(
                    'HOT',
                    style: TextStyle(
                      fontFamily: 'Anton',
                      color: AppColors.error,
                      fontSize: 16,
                      letterSpacing: 2,
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

  Widget _buildMangaGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
      ),
      itemCount: _latestManga.length,
      itemBuilder: (context, index) {
        final manga = _latestManga[index];
        return _buildMangaCard(manga);
      },
    );
  }

  Widget _buildMangaCard(Map<String, dynamic> manga) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.mangaDetail,
            arguments: manga['id']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          border: Border.all(color: AppColors.border, width: 2),
          boxShadow: const [
            BoxShadow(
              color: AppColors.tertiary,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image Placeholder
            Container(
              color: AppColors.surfaceVariant,
              child: const Center(
                  child: Icon(Icons.image, color: AppColors.outline, size: 40)),
            ),
            // Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga['title'],
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      color: AppColors.onSurface,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    manga['chapter'],
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      color: AppColors.primaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: (manga['genres'] as List<String>)
                        .take(2)
                        .map((genre) => Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.outline),
                              ),
                              child: Text(
                                genre,
                                style: const TextStyle(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            // NEW badge
            if (manga['isNew'] == true)
              Positioned(
                top: 8,
                left: -8,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: AppColors.secondaryContainer,
                    child: const Text(
                      'NEW',
                      style: TextStyle(
                        fontFamily: 'Anton',
                        color: AppColors.onSecondaryContainer,
                        fontSize: 12,
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
}
