import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

class ChapterListItem extends StatelessWidget {
  final Map<String, dynamic> chapter;
  final VoidCallback onTap;
  final bool isAlternate;

  const ChapterListItem({
    super.key,
    required this.chapter,
    required this.onTap,
    this.isAlternate = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPremium = chapter['isPremium'] ?? false;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isAlternate
            ? AppColors.greyLight.withOpacity(0.3)
            : AppColors.surface,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingM,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter['title'] ?? 'Chapter ${chapter['number']}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chapter['updatedAt'] ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isPremium)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
