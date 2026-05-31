import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/favorite.dart';
import '../../../providers/favorite_provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteProvider>().fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.favorites.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryContainer));
          }
          if (provider.errorMessage != null && provider.favorites.isEmpty) {
            return _buildError(provider);
          }
          if (provider.favorites.isEmpty) {
            return _buildEmptyState();
          }
          return RefreshIndicator(
            color: AppColors.primaryContainer,
            backgroundColor: AppColors.surfaceContainer,
            onRefresh: () => provider.fetchFavorites(),
            child: _buildFavoritesGrid(provider),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.onSurface),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(color: AppColors.border, height: 2),
      ),
      title: Consumer<FavoriteProvider>(
        builder: (context, provider, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'YÊU THÍCH',
              style: TextStyle(
                fontFamily: 'Anton',
                color: AppColors.onSurface,
                fontSize: 24,
                letterSpacing: 1,
              ),
            ),
            Text(
              '${provider.favorites.length} TRUYỆN',
              style: const TextStyle(
                fontFamily: 'Syne',
                color: AppColors.primaryContainer,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesGrid(FavoriteProvider provider) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: provider.favorites.length,
      itemBuilder: (context, index) {
        return _buildFavoriteItem(provider, provider.favorites[index]);
      },
    );
  }

  Widget _buildFavoriteItem(FavoriteProvider provider, Favorite fav) {
    final manga = fav.manga;
    final title = manga?.title ?? 'Truyện không tồn tại';
    final coverUrl = manga?.coverUrl ?? '';

    return GestureDetector(
      onTap: () {
        if (manga != null) {
          Navigator.pushNamed(context, AppRouter.mangaDetail, arguments: manga.id);
        }
      },
      onLongPress: () => _showItemMenu(provider, fav),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 2),
          color: AppColors.surfaceContainerHigh,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: AppColors.surfaceVariant,
              child: coverUrl.isNotEmpty
                  ? Image.network(coverUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.broken_image,
                              color: AppColors.outline, size: 40)))
                  : const Center(
                      child: Icon(Icons.image, color: AppColors.outline, size: 40)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                  stops: const [0.4, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'Anton',
                      color: AppColors.onSurface,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => provider.removeFavorite(fav.mangaId),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.favorite,
                      color: AppColors.primaryContainer, size: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemMenu(FavoriteProvider provider, Favorite fav) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainer,
          border: Border(top: BorderSide(color: AppColors.primaryContainer, width: 2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              color: AppColors.outline,
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border, color: AppColors.error),
              title: const Text(
                'BỎ YÊU THÍCH',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                provider.removeFavorite(fav.mangaId);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildError(FavoriteProvider provider) {
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
              onPressed: () => provider.fetchFavorites(),
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
          const Icon(Icons.favorite_border, size: 80, color: AppColors.outline),
          const SizedBox(height: 24),
          const Text(
            'CHƯA CÓ TRUYỆN YÊU THÍCH',
            style: TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurfaceVariant,
              fontSize: 24,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Nhấn vào icon ❤️ ở trang chi tiết để thêm truyện yêu thích',
              style: TextStyle(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
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
              'KHÁM PHÁ NGAY',
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
}
