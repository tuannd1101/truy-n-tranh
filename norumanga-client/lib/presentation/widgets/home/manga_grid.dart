import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../manga/manga_card.dart';

class MangaGrid extends StatelessWidget {
  const MangaGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from API
    final List<Map<String, dynamic>> mangaList = List.generate(
      6,
      (index) => {
        'id': index + 100,
        'title': 'Đề Cử ${index + 1}',
        'coverUrl': 'https://via.placeholder.com/150x200/FFD54F/000000?text=Rec+${index + 1}',
        'isPremium': index % 2 == 0,
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: AppDimensions.paddingM,
          mainAxisSpacing: AppDimensions.paddingM,
        ),
        itemCount: mangaList.length,
        itemBuilder: (context, index) {
          final manga = mangaList[index];
          return MangaCard(
            title: manga['title'],
            coverUrl: manga['coverUrl'],
            isPremium: manga['isPremium'],
            onTap: () {
              // TODO: Navigate to manga detail screen
              Navigator.pushNamed(
                context,
                '/manga-detail',
                arguments: manga['id'],
              );
            },
          );
        },
      ),
    );
  }
}
