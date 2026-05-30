import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/main_app_bar.dart';
import 'package:provider/provider.dart';
import '../../../providers/manga_provider.dart';
import '../../../data/models/manga.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MangaProvider>().fetchMangas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MainAppBar(),
      drawer: const MainDrawer(),
      body: Consumer<MangaProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildSectionHeader('NỔI BẬT HÔM NAY'),
                const SizedBox(height: 16),
                _buildFeaturedManga(provider),
                const SizedBox(height: 32),
                _buildSectionHeader('MỚI CẬP NHẬT'),
                const SizedBox(height: 16),
                _buildMangaGrid(provider),
              ],
            ),
          );
        },
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

  Widget _buildFeaturedManga(MangaProvider provider) {
    if (provider.isLoading && provider.mangas.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryContainer));
    }
    
    if (provider.mangas.isEmpty) {
      return const SizedBox(height: 220, child: Center(child: Text('Chưa có truyện nào.', style: TextStyle(color: AppColors.onSurfaceVariant))));
    }

    final featuredManga = provider.mangas.first;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.mangaDetail, arguments: featuredManga.id);
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
            // Cover Image
            featuredManga.coverUrl.isNotEmpty
                ? Image.network(
                    featuredManga.coverUrl,
                    fit: BoxFit.cover,
                  )
                : const Center(
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
                    children: featuredManga.tags.take(3)
                        .map((genre) => Container(
                              margin: const EdgeInsets.only(right: 8, bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              color: AppColors.tertiary,
                              child: Text(
                                genre.toUpperCase(),
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
                    featuredManga.title.toUpperCase(),
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
                    featuredManga.contentTag,
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

  Widget _buildMangaGrid(MangaProvider provider) {
    if (provider.isLoading && provider.mangas.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryContainer));
    }
    
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
      itemCount: provider.mangas.length,
      itemBuilder: (context, index) {
        final manga = provider.mangas[index];
        return _buildMangaCard(manga);
      },
    );
  }

  Widget _buildMangaCard(Manga manga) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.mangaDetail,
            arguments: manga.id);
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
            // Image
            Container(
              color: AppColors.surfaceVariant,
              child: manga.coverUrl.isNotEmpty
                  ? Image.network(
                      manga.coverUrl,
                      fit: BoxFit.cover,
                    )
                  : const Center(
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
                    manga.title,
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
                    manga.status,
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      color: AppColors.primaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: manga.tags
                        .take(2)
                        .map((genre) => Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.outline),
                              ),
                              child: Text(
                                genre.toUpperCase(),
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
            // NEW badge (Placeholder logic based on isFree)
            if (manga.isFree)
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
