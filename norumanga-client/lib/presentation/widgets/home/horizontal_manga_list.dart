import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../manga/manga_card.dart';

class HorizontalMangaList extends StatelessWidget {
  const HorizontalMangaList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual data from API
    final List<Map<String, dynamic>> mangaList = List.generate(
      10,
      (index) => {
        'id': index,
        'title': 'Tên Truyện ${index + 1}',
        'coverUrl': 'https://via.placeholder.com/150x200/FFC107/000000?text=Manga+${index + 1}',
        'isPremium': index % 3 == 0,
      },
    );

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
        ),
        itemCount: mangaList.length,
        itemBuilder: (context, index) {
          final manga = mangaList[index];
          return Padding(
            padding: EdgeInsets.only(
              right: index < mangaList.length - 1 ? AppDimensions.paddingM : 0,
            ),
            child: MangaCard(
              title: manga['title'],
              coverUrl: manga['coverUrl'],
              isPremium: manga['isPremium'],
              width: 140,
              onTap: () {
                // TODO: Navigate to manga detail screen
                Navigator.pushNamed(
                  context,
                  '/manga-detail',
                  arguments: manga['id'],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
