import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  State<ReadingHistoryScreen> createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  String _selectedFilter = 'Hôm nay';
  final List<String> _filters = ['Hôm nay', '7 ngày qua', '30 ngày qua', 'Tất cả'];

  // Mock data
  final List<Map<String, dynamic>> _historyData = [
    {
      'date': 'Hôm nay',
      'items': [
        {
          'id': '1',
          'title': 'Neon Drift',
          'chapter': 'Chương 14',
          'time': '2 giờ trước',
          'image': 'assets/images/hero_artist.png', // Fallback to placeholder if asset not found
        },
        {
          'id': '2',
          'title': 'Crimson Blade',
          'chapter': 'Chương 42',
          'time': '5 giờ trước',
          'image': 'assets/images/hero_artist.png',
        },
      ]
    },
    {
      'date': 'Hôm qua',
      'items': [
        {
          'id': '3',
          'title': 'Starfall Magic',
          'chapter': 'Chương 5',
          'time': '1 ngày trước',
          'image': 'assets/images/hero_artist.png',
        },
      ]
    }
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
            child: _historyData.isEmpty ? _buildEmptyState() : _buildHistoryList(),
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
      title: const Text(
        'LỊCH SỬ ĐỌC',
        style: TextStyle(
          fontFamily: 'Anton',
          color: AppColors.onSurface,
          fontSize: 24,
          letterSpacing: 1,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep, color: AppColors.primaryContainer),
          onPressed: () {
            _showClearAllDialog();
          },
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.outline),
              color: AppColors.surface,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFilter,
                dropdownColor: AppColors.surfaceContainerHigh,
                icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.onSurface),
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Syne',
                ),
                items: _filters.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    if (newValue != null) _selectedFilter = newValue;
                  });
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.outline),
              color: AppColors.surface,
            ),
            child: const Icon(Icons.filter_list, color: AppColors.onSurface, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      itemCount: _historyData.length,
      itemBuilder: (context, index) {
        final group = _historyData[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sticky Header equivalent
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.surfaceContainerHigh,
              child: Text(
                group['date'],
                style: const TextStyle(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Syne',
                  letterSpacing: 1,
                ),
              ),
            ),
            // Items
            ...((group['items'] as List).map((item) {
              return Dismissible(
                key: Key(item['id']),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: AppColors.errorContainer,
                  child: const Icon(Icons.delete, color: AppColors.error),
                ),
                onDismissed: (direction) {
                  // TODO: Handle delete item
                },
                child: _buildHistoryItem(item),
              );
            }).toList()),
          ],
        );
      },
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
        color: AppColors.background,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to reader
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Cover
                Container(
                  width: 60,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    border: Border.all(color: AppColors.border, width: 2),
                  ),
                  child: const Icon(Icons.image, color: AppColors.outline), // Placeholder
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'].toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Anton',
                          letterSpacing: 1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: AppColors.secondaryContainer.withOpacity(0.2),
                        child: Text(
                          item['chapter'],
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: AppColors.onSurfaceVariant, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            item['time'],
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
              ],
            ),
          ),
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
            Icons.history,
            size: 80,
            color: AppColors.outline,
          ),
          const SizedBox(height: 24),
          const Text(
            'CHƯA CÓ LỊCH SỬ ĐỌC',
            style: TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurfaceVariant,
              fontSize: 24,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Những truyện bạn đọc sẽ xuất hiện ở đây',
            style: TextStyle(color: AppColors.onSurfaceVariant),
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
              'KHÁM PHÁ TRUYỆN',
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

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.primaryContainer, width: 2),
        ),
        title: const Text(
          'XÓA TẤT CẢ?',
          style: TextStyle(
            fontFamily: 'Anton',
            color: AppColors.error,
          ),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa toàn bộ lịch sử đọc? Hành động này không thể hoàn tác.',
          style: TextStyle(color: AppColors.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'HỦY',
              style: TextStyle(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Clear all logic
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorContainer,
              foregroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('XÓA'),
          ),
        ],
      ),
    );
  }
}
