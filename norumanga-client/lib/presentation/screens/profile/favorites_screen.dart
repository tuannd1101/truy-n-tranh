import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _selectedSort = 'Mới thêm';
  final List<String> _sortOptions = ['Mới thêm', 'Tên A-Z', 'Tên Z-A', 'Cập nhật mới nhất'];
  final List<String> _genres = ['Tất cả', 'Shounen', 'Action', 'Romance', 'Fantasy'];
  String _selectedGenre = 'Tất cả';

  // Mock data
  final List<Map<String, dynamic>> _favoritesData = [
    {
      'id': '1',
      'title': 'Neon Drift',
      'isNew': true,
      'image': 'assets/images/hero_artist.png',
    },
    {
      'id': '2',
      'title': 'Crimson Blade',
      'isNew': false,
      'image': 'assets/images/hero_artist.png',
    },
    {
      'id': '3',
      'title': 'Starfall Magic',
      'isNew': true,
      'image': 'assets/images/hero_artist.png',
    },
    {
      'id': '4',
      'title': 'Cyber Samurai',
      'isNew': false,
      'image': 'assets/images/hero_artist.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _favoritesData.isEmpty ? _buildEmptyState() : _buildFavoritesGrid(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.onSurface),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(
          color: AppColors.border,
          height: 2,
        ),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YÊU THÍCH',
            style: TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurface,
              fontSize: 24,
              letterSpacing: 1,
            ),
          ),
          Text(
            '4 TRUYỆN',
            style: TextStyle(
              fontFamily: 'Syne',
              color: AppColors.primaryContainer,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.onSurface),
          onPressed: () {
            // Search in favorites
          },
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: AppColors.surfaceContainerLow,
      child: Column(
        children: [
          // Sort Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'SẮP XẾP:',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.outline),
                    color: AppColors.surface,
                  ),
                  height: 32,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedSort,
                      dropdownColor: AppColors.surfaceContainerHigh,
                      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.onSurface),
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Syne',
                        fontSize: 12,
                      ),
                      items: _sortOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          if (newValue != null) _selectedSort = newValue;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Genre Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _genres.length,
              itemBuilder: (context, index) {
                final genre = _genres[index];
                final isSelected = genre == _selectedGenre;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
                        color: isSelected ? AppColors.primaryContainer : AppColors.surface,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryContainer : AppColors.outline,
                        ),
                      ),
                      child: Text(
                        genre.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Syne',
                          color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(height: 2, color: AppColors.border),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _favoritesData.length,
      itemBuilder: (context, index) {
        return _buildFavoriteItem(_favoritesData[index]);
      },
    );
  }

  Widget _buildFavoriteItem(Map<String, dynamic> item) {
    return GestureDetector(
      onLongPress: () {
        _showItemMenu(item);
      },
      onTap: () {
        // Navigate to detail
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border, width: 2),
          color: AppColors.surfaceContainerHigh,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover Image
            Container(
              color: AppColors.surfaceVariant,
              child: const Center(
                child: Icon(Icons.image, color: AppColors.outline, size: 40),
              ),
            ),
            // Gradient Overlay
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
                    item['title'].toString().toUpperCase(),
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
            // Top Right Heart
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: AppColors.primaryContainer,
                  size: 16,
                ),
              ),
            ),
            // Top Left New Badge
            if (item['isNew'] == true)
              Positioned(
                top: 8,
                left: -8,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  void _showItemMenu(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceContainer,
          border: Border(
            top: BorderSide(color: AppColors.primaryContainer, width: 2),
          ),
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
                // Handle remove favorite
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppColors.onSurface),
              title: const Text(
                'CHIA SẺ',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                // Handle share
              },
            ),
            const SizedBox(height: 16),
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
          const Icon(
            Icons.favorite_border,
            size: 80,
            color: AppColors.outline,
          ),
          const SizedBox(height: 24),
          const Text(
            'CHƯA CÓ TRUYỆN YÊU THÍCH',
            style: TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurfaceVariant,
              fontSize: 24,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Nhấn vào icon ❤️ ở trang chi tiết để thêm truyện yêu thích',
            style: TextStyle(color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimaryContainer,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
                side: BorderSide(color: AppColors.border, width: 2),
              ),
              elevation: 4,
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
