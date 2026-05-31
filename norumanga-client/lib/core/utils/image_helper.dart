import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Utility class for image loading and caching
/// Provides helpers for loading network images with caching, placeholders, and error handling
class ImageHelper {
  /// Loads a network image with caching
  ///
  /// Parameters:
  /// - [imageUrl]: The URL of the image to load
  /// - [width]: Optional width constraint
  /// - [height]: Optional height constraint
  /// - [fit]: How the image should fit in the box (default: BoxFit.cover)
  /// - [borderRadius]: Optional border radius
  static Widget loadNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.high,
      placeholder: (context, url) => _buildPlaceholder(width, height),
      errorWidget: (context, url, error) => _buildErrorWidget(width, height),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius, child: imageWidget);
    }

    return imageWidget;
  }

  /// Loads a manga cover image with standard styling
  ///
  /// Parameters:
  /// - [imageUrl]: The URL of the cover image
  /// - [width]: Width of the cover (default: 120)
  /// - [height]: Height of the cover (default: 180)
  static Widget loadMangaCover({
    required String imageUrl,
    double width = 120.0,
    double height = 180.0,
  }) {
    return loadNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(8.0),
    );
  }

  /// Loads a circular avatar image
  ///
  /// Parameters:
  /// - [imageUrl]: The URL of the avatar image
  /// - [radius]: Radius of the circular avatar (default: 24)
  static Widget loadAvatar({required String imageUrl, double radius = 24.0}) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        placeholder: (context, url) => _buildAvatarPlaceholder(radius),
        errorWidget: (context, url, error) => _buildAvatarPlaceholder(radius),
        fadeInDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  /// Loads a banner image with aspect ratio
  ///
  /// Parameters:
  /// - [imageUrl]: The URL of the banner image
  /// - [aspectRatio]: Aspect ratio of the banner (default: 16/9)
  static Widget loadBanner({
    required String imageUrl,
    double aspectRatio = 16 / 9,
  }) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: loadNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  /// Loads a chapter page image for reading
  ///
  /// Parameters:
  /// - [imageUrl]: The URL of the page image
  /// - [onTap]: Optional callback when image is tapped
  static Widget loadChapterPage({
    required String imageUrl,
    VoidCallback? onTap,
  }) {
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.fitWidth,
      filterQuality: FilterQuality.high,
      placeholder: (context, url) => _buildPagePlaceholder(),
      errorWidget: (context, url, error) => _buildPageErrorWidget(),
      fadeInDuration: const Duration(milliseconds: 200),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: imageWidget);
    }

    return imageWidget;
  }

  /// Preloads an image into cache
  ///
  /// Parameters:
  /// - [context]: Build context
  /// - [imageUrl]: The URL of the image to preload
  static Future<void> preloadImage(
    BuildContext context,
    String imageUrl,
  ) async {
    try {
      await precacheImage(CachedNetworkImageProvider(imageUrl), context);
    } catch (e) {
      debugPrint('Failed to preload image: $imageUrl');
    }
  }

  /// Preloads multiple images into cache
  ///
  /// Parameters:
  /// - [context]: Build context
  /// - [imageUrls]: List of image URLs to preload
  static Future<void> preloadImages(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    await Future.wait(imageUrls.map((url) => preloadImage(context, url)));
  }

  /// Clears the image cache
  static Future<void> clearCache() async {
    await CachedNetworkImage.evictFromCache('');
  }

  /// Builds a loading placeholder widget
  static Widget _buildPlaceholder(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: AppColors.greyLight,
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  /// Builds an error widget for failed image loads
  static Widget _buildErrorWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      color: AppColors.greyLight,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, color: AppColors.grey, size: 32.0),
          SizedBox(height: 4.0),
          Text(
            'Failed to load',
            style: TextStyle(color: AppColors.grey, fontSize: 10.0),
          ),
        ],
      ),
    );
  }

  /// Builds a placeholder for avatar images
  static Widget _buildAvatarPlaceholder(double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: const BoxDecoration(
        color: AppColors.greyLight,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person_outline, color: AppColors.grey, size: radius),
    );
  }

  /// Builds a placeholder for chapter page images
  static Widget _buildPagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 600,
      color: AppColors.greyLight,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            SizedBox(height: 16.0),
            Text(
              'Loading page...',
              style: TextStyle(color: AppColors.grey, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an error widget for chapter page images
  static Widget _buildPageErrorWidget() {
    return Container(
      width: double.infinity,
      height: 600,
      color: AppColors.greyLight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 48.0),
          const SizedBox(height: 16.0),
          const Text(
            'Failed to load page',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton.icon(
            onPressed: () {
              // Retry logic would be handled by parent widget
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  /// Gets a placeholder image URL for testing
  static String getPlaceholderUrl({
    int width = 300,
    int height = 400,
    String text = 'Placeholder',
  }) {
    return 'https://via.placeholder.com/${width}x$height.png?text=$text';
  }

  /// Checks if a URL is a valid image URL
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    final path = uri.path.toLowerCase();

    return validExtensions.any((ext) => path.endsWith(ext)) ||
        url.contains('image') ||
        url.contains('img');
  }
}
