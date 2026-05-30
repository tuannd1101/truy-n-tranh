import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../data/models/chapter.dart';
import '../../../data/models/manga.dart';
import '../../../providers/chapter_provider.dart';
import '../../../data/network/upload_api_service.dart';
import 'admin_dashboard_screen.dart'; 
import 'admin_chapter_detail_screen.dart'; 

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

  void _showChapterDialog({Chapter? existingChapter}) async {
    Chapter? detailChapter = existingChapter;
    
    if (existingChapter != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(color: AdminColors.cyberCyan)),
      );
      
      detailChapter = await context.read<ChapterProvider>().getChapterDetail(widget.manga.id, existingChapter.chapterNumber);
      
      if (mounted) Navigator.pop(context); // Close loading
      
      if (detailChapter == null) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to load chapter details')));
        return;
      }
    }

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _ChapterDialog(manga: widget.manga, existingChapter: detailChapter),
      );
    }
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
        onPressed: () => _showChapterDialog(),
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
                        icon: const Icon(Icons.remove_red_eye, color: AdminColors.cyberCyan),
                        tooltip: 'View Detail',
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(child: CircularProgressIndicator(color: AdminColors.cyberCyan)),
                          );
                          
                          final detailChapter = await context.read<ChapterProvider>().getChapterDetail(widget.manga.id, chapter.chapterNumber);
                          
                          if (mounted) Navigator.pop(context); // Close loading
                          
                          if (detailChapter != null && mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminChapterDetailScreen(chapter: detailChapter),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: AdminColors.sakuraPink),
                        tooltip: 'Edit Chapter',
                        onPressed: () => _showChapterDialog(existingChapter: chapter),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AdminColors.errorRed),
                        tooltip: 'Delete Chapter',
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

class _ChapterDialog extends StatefulWidget {
  final Manga manga;
  final Chapter? existingChapter;

  const _ChapterDialog({required this.manga, this.existingChapter});

  @override
  State<_ChapterDialog> createState() => _ChapterDialogState();
}

class _ChapterDialogState extends State<_ChapterDialog> {
  late TextEditingController _chapterNumberController;
  late bool _isPremium;
  
  // Mảng lưu URL của các ảnh cũ (từ server)
  late List<String> _existingUrls;
  // Mảng lưu các ảnh mới chọn từ thiết bị
  final List<XFile> _selectedNewImages = [];
  
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final chapter = widget.existingChapter;
    _chapterNumberController = TextEditingController(text: chapter?.chapterNumber.toString() ?? '');
    _isPremium = chapter?.isPremium ?? false;
    _existingUrls = chapter != null ? List<String>.from(chapter.pages) : [];
  }

  @override
  void dispose() {
    _chapterNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedNewImages.addAll(images);
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingUrls.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _selectedNewImages.removeAt(index);
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
    
    if (_existingUrls.isEmpty && _selectedNewImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least 1 image')));
      return;
    }

    setState(() => _isUploading = true);

    try {
      List<String> finalPages = List.from(_existingUrls);

      // 1. Nếu có ảnh mới, upload lên Cloudinary
      if (_selectedNewImages.isNotEmpty) {
        final uploadService = UploadApiService();
        final newUrls = await uploadService.uploadImages(_selectedNewImages);
        finalPages.addAll(newUrls);
      }

      // 2. Gửi request Create hoặc Update
      final data = {
        'chapterNumber': number,
        'isPremium': _isPremium,
        'pages': finalPages,
      };

      if (!mounted) return;
      final provider = context.read<ChapterProvider>();
      
      bool success;
      if (widget.existingChapter == null) {
        success = await provider.createChapter(widget.manga.id, data);
      } else {
        success = await provider.updateChapter(widget.manga.id, widget.existingChapter!.id, data);
      }
      
      if (success) {
        if (mounted) Navigator.pop(context); // Đóng dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(widget.existingChapter == null ? 'Chapter created successfully!' : 'Chapter updated successfully!'),
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

  Widget _buildNewImagePreview(XFile file) {
    if (kIsWeb) {
      return Image.network(file.path, fit: BoxFit.cover);
    } else {
      return Image.file(File(file.path), fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingChapter != null;
    final totalPages = _existingUrls.length + _selectedNewImages.length;

    return Dialog(
      backgroundColor: AdminColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AdminColors.cyberCyan)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isEditing ? 'Edit Chapter' : 'Add New Chapter', 
                style: const TextStyle(color: AdminColors.cyberCyan, fontSize: 20, fontWeight: FontWeight.bold)),
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
                Text('Total Pages: $totalPages', style: const TextStyle(color: AdminColors.onSurface, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _pickImages,
                  icon: const Icon(Icons.add_photo_alternate, color: AdminColors.cyberCyan),
                  label: const Text('ADD NEW IMAGES', style: TextStyle(color: AdminColors.cyberCyan)),
                  style: ElevatedButton.styleFrom(backgroundColor: AdminColors.surfaceHigh),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Expanded(
              child: totalPages == 0
                  ? Center(child: Text('No images selected.', style: TextStyle(color: AdminColors.onSurfaceVariant.withOpacity(0.5))))
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: totalPages,
                      itemBuilder: (context, index) {
                        // Xác định ảnh này là ảnh cũ hay mới
                        final isExisting = index < _existingUrls.length;
                        
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: isExisting ? AdminColors.sakuraPink : AdminColors.cyberCyan),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: isExisting 
                                    ? CachedNetworkImage(
                                        imageUrl: _existingUrls[index], 
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(color: AdminColors.surfaceHigh),
                                        errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.white24),
                                      )
                                    : _buildNewImagePreview(_selectedNewImages[index - _existingUrls.length]),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _isUploading 
                                    ? null 
                                    : () {
                                        if (isExisting) {
                                          _removeExistingImage(index);
                                        } else {
                                          _removeNewImage(index - _existingUrls.length);
                                        }
                                      },
                                child: Container(
                                  color: Colors.black87,
                                  child: const Icon(Icons.close, color: AdminColors.errorRed, size: 22),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                color: Colors.black87,
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                child: Text('Page ${index + 1}', style: TextStyle(color: isExisting ? AdminColors.sakuraPink : AdminColors.cyberCyan, fontSize: 11, fontWeight: FontWeight.bold)),
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
                      : Text(isEditing ? 'UPDATE' : 'SAVE & UPLOAD', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
