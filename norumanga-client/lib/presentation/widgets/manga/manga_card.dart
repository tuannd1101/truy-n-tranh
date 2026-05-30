import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

class MangaCard extends StatelessWidget {
  final String title;
  final String coverUrl;
  final bool isPremium;
  final double? width;
  final VoidCallback? onTap;

  const MangaCard({
    super.key,
    required this.title,
    required this.coverUrl,
    this.isPremium = false,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    child: Image.network(
                      coverUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.greyLight,
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: AppColors.grey,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppColors.greyLight,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Premium/Free Tag
                  Positioned(
                    top: AppDimensions.paddingS,
                    right: AppDimensions.paddingS,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isPremium
                            ? AppColors.tagPremium
                            : AppColors.tagFree,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                      ),
                      child: Text(
                        isPremium ? 'Premium' : 'Free',
                        style: AppTextStyles.tag.copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            // Title
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
