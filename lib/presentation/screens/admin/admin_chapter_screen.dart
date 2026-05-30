import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/chapter.dart';
import '../../../data/models/manga.dart';
import '../../../providers/chapter_provider.dart';
import '../../../data/network/upload_api_service.dart';
import 'admin_dashboard_screen.dart'; // For AdminColors

class AdminChapterScreen extends StatefulWidget {
  final Manga manga;

  const AdminChapterScreen({super.key, required this.manga});

  @override
  State<AdminChapterScreen> createState() => _AdminChapterScreenState();
}

class _AdminChapterScreenState extends State<AdminChapterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChapterProvider>().fetchChapters(widget.manga.id);
    });
  }

  void _showAddChapterDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _AddChapterDialog(manga: widget.manga),
    );
  }

  void _confirmDelete(Chapter chapter) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.surface,
        title: const Text('Delete Chapter?', style: TextStyle(color: AdminColors.onSurface)),
        content: Text('Are you sure you want to delete Chapter ${chapter.chapterNumber}?', style: const TextStyle(color: AdminColors.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AdminColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.errorRed),
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await context.read<ChapterProvider>().deleteChapter(widget.manga.id, chapter.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success ? 'Chapter deleted successfully' : 'Failed to delete chapter'),
                  backgroundColor: success ? AdminColors.green : AdminColors.errorRed,
                ));
              }
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: AppBar(
        backgroundColor: AdminColors.surface,
        title: Text('Chapters: ${widget.manga.title}', style: const TextStyle(color: AdminColors.cyberCyan)),
        iconTheme: const IconThemeData(color: AdminColors.cyberCyan),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddChapterDialog,
        backgroundColor: AdminColors.cyberCyan,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text('ADD CHAPTER', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Consumer<ChapterProvider>(
        builder: (context, chapterProvider, child) {
          if (chapterProvider.isLoading && chapterProvider.chapters.isEmpty) {
            return const Center(child: CircularProgressIndicator(color: AdminColors.cyberCyan));
          }

          if (chapterProvider.errorMessage != null && chapterProvider.chapters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AdminColors.errorRed, size: 48),
                  const SizedBox(height: 16),
                  Text(chapterProvider.errorMessage!, style: const TextStyle(color: AdminColors.errorRed)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => chapterProvider.fetchChapters(widget.manga.id),
                    style: ElevatedButton.styleFrom(backgroundColor: AdminColors.surfaceHigh),
                    child: const Text('RETRY', style: TextStyle(color: AdminColors.cyberCyan)),
                  ),
                ],
              ),
            );
          }

          if (chapterProvider.chapters.isEmpty) {
            return const Center(
              child: Text('No chapters found. Add one!', style: TextStyle(color: AdminColors.onSurfaceVariant)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: chapterProvider.chapters.length,
            itemBuilder: (context, index) {
              final chapter = chapterProvider.chapters[index];
              return Card(
                color: AdminColors.surface,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: AdminColors.outlineVariant),
                ),
                child: ListTile(
                  title: Text(
                    chapter.displayTitle,
                    style: const TextStyle(color: AdminColors.onSurface, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${chapter.totalPages} pages • ${chapter.isPremium ? "Premium 💎" : "Free"}',
                    style: const TextStyle(color: AdminColors.onSurfaceVariant),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: AdminColors.errorRed),
                        onPressed: () => _confirmDelete(chapter),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AddChapterDialog extends StatefulWidget {
  final Manga manga;

  const _AddChapterDialog({required this.manga});

  @override
  State<_AddChapterDialog> createState() => _AddChapterDialogState();
}

class _AddChapterDialogState extends State<_AddChapterDialog> {
  final _chapterNumberController = TextEditingController();
  bool _isPremium = false;
  
  final List<XFile> _selectedImages = [];
  bool _isUploading = false;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _saveChapter() async {
    final numberText = _chapterNumberController.text.trim();
    if (numberText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Chapter Number')));
      return;
    }
    final number = double.tryParse(numberText);
    if (number == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Chapter Number')));
      return;
    }
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least 1 image')));
      return;
    }

    setState(() => _isUploading = true);

    try {
      // 1. Upload images
      final uploadService = UploadApiService();
      final pageUrls = await uploadService.uploadImages(_selectedImages);

      // 2. Create Chapter
      final data = {
        'chapterNumber': number,
        'isPremium': _isPremium,
        'pages': pageUrls,
      };

      if (!mounted) return;
      final success = await context.read<ChapterProvider>().createChapter(widget.manga.id, data);
      
      if (success) {
        if (mounted) Navigator.pop(context); // Close dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Chapter created successfully!'),
            backgroundColor: AdminColors.green,
          ));
        }
      } else {
        setState(() => _isUploading = false);
      }
    } catch (e) {
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AdminColors.errorRed,
        ));
      }
    }
  }

  Widget _buildImagePreview(XFile file) {
    if (kIsWeb) {
      return Image.network(file.path, fit: BoxFit.cover);
    } else {
      return Image.file(File(file.path), fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AdminColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AdminColors.cyberCyan)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add New Chapter', style: TextStyle(color: AdminColors.cyberCyan, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            TextField(
              controller: _chapterNumberController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: AdminColors.onSurface),
              decoration: const InputDecoration(
                labelText: 'Chapter Number (e.g. 1.5)',
                labelStyle: TextStyle(color: AdminColors.onSurfaceVariant),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.outlineVariant)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.cyberCyan)),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                const Text('Premium Chapter?', style: TextStyle(color: AdminColors.onSurface)),
                const Spacer(),
                Switch(
                  value: _isPremium,
                  activeColor: AdminColors.cyberCyan,
                  onChanged: (val) => setState(() => _isPremium = val),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pages: ${_selectedImages.length}', style: const TextStyle(color: AdminColors.onSurface, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _pickImages,
                  icon: const Icon(Icons.add_photo_alternate, color: AdminColors.cyberCyan),
                  label: const Text('SELECT IMAGES', style: TextStyle(color: AdminColors.cyberCyan)),
                  style: ElevatedButton.styleFrom(backgroundColor: AdminColors.surfaceHigh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: _selectedImages.isEmpty
                  ? Center(child: Text('No images selected.', style: TextStyle(color: AdminColors.onSurfaceVariant.withOpacity(0.5))))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AdminColors.outlineVariant),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: _buildImagePreview(_selectedImages[index]),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _isUploading ? null : () => _removeImage(index),
                                child: Container(
                                  color: Colors.black54,
                                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                color: Colors.black54,
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isUploading ? null : () => Navigator.pop(context),
                  child: const Text('CANCEL', style: TextStyle(color: AdminColors.onSurfaceVariant)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isUploading ? null : _saveChapter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.cyberCyan,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: _isUploading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : const Text('SAVE & UPLOAD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
