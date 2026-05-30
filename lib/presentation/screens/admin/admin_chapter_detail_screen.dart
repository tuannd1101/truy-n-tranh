import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/chapter.dart';
import 'admin_dashboard_screen.dart'; // For AdminColors

class AdminChapterDetailScreen extends StatelessWidget {
  final Chapter chapter;

  const AdminChapterDetailScreen({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: AppBar(
        backgroundColor: AdminColors.surface,
        title: Text(chapter.displayTitle, style: const TextStyle(color: AdminColors.cyberCyan)),
        iconTheme: const IconThemeData(color: AdminColors.cyberCyan),
      ),
      body: chapter.pages.isEmpty
          ? const Center(
              child: Text(
                'This chapter has no pages yet.',
                style: TextStyle(color: AdminColors.onSurfaceVariant),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: chapter.pages.length,
              itemBuilder: (context, index) {
                final url = chapter.pages[index];
                return Column(
                  children: [
                    Text(
                      'Page ${index + 1}',
                      style: const TextStyle(color: AdminColors.onSurfaceVariant, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    CachedNetworkImage(
                      imageUrl: url,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        height: 300,
                        color: AdminColors.surfaceHigh,
                        child: const Center(child: CircularProgressIndicator(color: AdminColors.cyberCyan)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 300,
                        color: AdminColors.errorRed.withOpacity(0.1),
                        child: const Center(
                          child: Icon(Icons.broken_image, color: AdminColors.errorRed, size: 64),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
    );
  }
}
