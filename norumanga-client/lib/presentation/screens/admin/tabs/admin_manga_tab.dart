import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:image_picker/image_picker.dart';
import '../../../../data/models/manga.dart';
import '../../../../data/models/tag.dart';
import '../../../../data/models/creator.dart';
import '../../../../data/network/upload_api_service.dart';
import '../../../../providers/manga_provider.dart';
import '../../../../providers/tag_provider.dart';
import '../../../../providers/creator_provider.dart';
import '../admin_dashboard_screen.dart'; // To access AdminColors
import '../admin_chapter_screen.dart';

class AdminMangaTab extends StatefulWidget {
  const AdminMangaTab({super.key});

  @override
  State<AdminMangaTab> createState() => _AdminMangaTabState();
}

class _AdminMangaTabState extends State<AdminMangaTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MangaProvider>().fetchMangas(page: 0);
      context.read<CreatorProvider>().fetchCreators();
      context.read<TagProvider>().fetchTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    final creators = context.watch<CreatorProvider>().creators;
    final tags = context.watch<TagProvider>().tags;

    return Consumer<MangaProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MANGA SERIES MANAGEMENT',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 24,
                      color: AdminColors.onSurface,
                      letterSpacing: 1.5,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showMangaDialog(context, provider, creators, tags),
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text('ADD MANGA', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.cyberCyan,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (provider.isLoading && provider.mangas.isEmpty)
                const Center(child: CircularProgressIndicator(color: AdminColors.cyberCyan))
              else if (provider.errorMessage != null && provider.mangas.isEmpty)
                Center(child: Text(provider.errorMessage!, style: const TextStyle(color: AdminColors.errorRed)))
              else if (provider.mangas.isEmpty)
                const Center(child: Text('No manga series found.', style: TextStyle(color: AdminColors.onSurfaceVariant)))
              else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.mangas.length,
                  itemBuilder: (context, index) {
                    final manga = provider.mangas[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AdminColors.surface,
                        border: Border.all(color: AdminColors.outlineVariant),
                        boxShadow: const [BoxShadow(color: AdminColors.cyberCyan, offset: Offset(2, 2))],
                      ),
                      child: Row(
                        children: [
                          // Cover Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: CachedNetworkImage(
                              imageUrl: manga.coverUrl,
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 50,
                                height: 70,
                                color: AdminColors.surfaceHigh,
                                child: const Icon(Icons.image, color: Colors.white24),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 50,
                                height: 70,
                                color: AdminColors.surfaceHigh,
                                child: const Icon(Icons.broken_image, color: Colors.white24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Title & Slug
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  manga.title,
                                  style: GoogleFonts.bebasNeue(fontSize: 18, color: AdminColors.onSurface, letterSpacing: 0.5),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(manga.slug, style: const TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 12)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      color: manga.status.toUpperCase() == 'ONGOING' ? AdminColors.green : AdminColors.warningYellow,
                                      child: Text(
                                        manga.status.toUpperCase(),
                                        style: const TextStyle(fontSize: 9, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      color: manga.isPremium ? AdminColors.sakuraPink : AdminColors.cyberCyan,
                                      child: Text(
                                        manga.contentTag.toUpperCase(),
                                        style: const TextStyle(fontSize: 9, color: Colors.black, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Actions
                          IconButton(
                            icon: const Icon(Icons.list_alt, color: AdminColors.green),
                            tooltip: 'Manage Chapters',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminChapterScreen(manga: manga),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline, color: AdminColors.cyberCyan),
                            onPressed: () => _showMangaDetailDialog(context, manga, creators, tags),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: AdminColors.sakuraPink),
                            onPressed: () => _showMangaDialog(context, provider, creators, tags, existingManga: manga),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AdminColors.errorRed),
                            onPressed: () => _confirmDelete(context, provider, manga),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Pagination Controls
                if (provider.totalPages > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left, color: AdminColors.onSurface),
                        onPressed: provider.currentPage > 1
                            ? () => provider.setPage(provider.currentPage - 1)
                            : null,
                      ),
                      Text(
                        'PAGE ${provider.currentPage} OF ${provider.totalPages}',
                        style: GoogleFonts.spaceGrotesk(color: AdminColors.onSurfaceVariant, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, color: AdminColors.onSurface),
                        onPressed: provider.currentPage < provider.totalPages
                            ? () => provider.setPage(provider.currentPage + 1)
                            : null,
                      ),
                    ],
                  ),
              ]
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, MangaProvider provider, Manga manga) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.surface,
        title: Text('DELETE MANGA', style: GoogleFonts.bebasNeue(color: AdminColors.errorRed, letterSpacing: 1)),
        content: Text('Are you sure you want to delete the manga series "${manga.title}"? This will delete all its chapters as well.', style: const TextStyle(color: AdminColors.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AdminColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.deleteManga(manga.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success ? 'Manga deleted successfully!' : provider.errorMessage ?? 'Delete failed'),
                  backgroundColor: success ? AdminColors.green : AdminColors.errorRed,
                ));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.errorRed),
            child: const Text('DELETE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showMangaDetailDialog(BuildContext context, Manga manga, List<Creator> allCreators, List<Tag> allTags) {
    // Map IDs to Names
    final mangaCreators = manga.creatorIds.map((id) {
      final creator = allCreators.firstWhere((c) => c.id == id, orElse: () => Creator(id: id, name: 'Unknown Creator', slug: ''));
      return creator.name;
    }).toList();

    // Map tagIds, grouping them
    final mangaTags = manga.tags.map((id) {
      return allTags.firstWhere((t) => t.id == id, orElse: () => Tag(id: id, name: 'Unknown Tag', slug: '', group: 'THEME'));
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AdminColors.surface,
          contentPadding: const EdgeInsets.all(16),
          title: Text(
            'MANGA DETAILS',
            style: GoogleFonts.bebasNeue(color: AdminColors.cyberCyan, letterSpacing: 1.5),
          ),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Large Cover Preview
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: manga.coverUrl,
                          width: 100,
                          height: 140,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            width: 100,
                            height: 140,
                            color: AdminColors.surfaceHigh,
                            child: const Icon(Icons.broken_image, color: Colors.white24, size: 40),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              manga.title,
                              style: GoogleFonts.bebasNeue(fontSize: 22, color: AdminColors.onSurface),
                            ),
                            const SizedBox(height: 6),
                            Text('Slug: ${manga.slug}', style: const TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 13)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: manga.status.toUpperCase() == 'ONGOING' ? AdminColors.green : AdminColors.warningYellow,
                                  child: Text(
                                    manga.status.toUpperCase(),
                                    style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  color: manga.isPremium ? AdminColors.sakuraPink : AdminColors.cyberCyan,
                                  child: Text(
                                    manga.contentTag.toUpperCase(),
                                    style: const TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('DESCRIPTION', style: TextStyle(color: AdminColors.cyberCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AdminColors.background,
                      border: Border.all(color: AdminColors.outlineVariant),
                    ),
                    child: Text(
                      manga.description.isNotEmpty ? manga.description : 'No description provided.',
                      style: const TextStyle(color: AdminColors.onSurface, fontSize: 13, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('CREATORS', style: TextStyle(color: AdminColors.cyberCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  if (mangaCreators.isEmpty)
                    const Text('No creators assigned.', style: TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 13))
                  else
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: mangaCreators.map((name) => Chip(
                        label: Text(name, style: const TextStyle(fontSize: 11, color: Colors.black)),
                        backgroundColor: AdminColors.warningYellow,
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      )).toList(),
                    ),
                  const SizedBox(height: 16),
                  const Text('TAGS & GENRES', style: TextStyle(color: AdminColors.cyberCyan, fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 6),
                  if (mangaTags.isEmpty)
                    const Text('No tags assigned.', style: TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 13))
                  else
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: mangaTags.map((tag) {
                        final isGenre = tag.group.toUpperCase() == 'GENRE';
                        return Chip(
                          label: Text(tag.name, style: TextStyle(fontSize: 11, color: isGenre ? Colors.white : Colors.black)),
                          backgroundColor: isGenre ? AdminColors.shonenPurple : AdminColors.cyberCyan,
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE', style: TextStyle(color: AdminColors.cyberCyan, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showMangaDialog(
    BuildContext context, 
    MangaProvider provider, 
    List<Creator> allCreators, 
    List<Tag> allTags, 
    {Manga? existingManga}
  ) {
    final isEdit = existingManga != null;
    final titleController = TextEditingController(text: existingManga?.title ?? '');
    final slugController = TextEditingController(text: existingManga?.slug ?? '');
    final descController = TextEditingController(text: existingManga?.description ?? '');
    
    // Manage local State in dialog
    String selectedStatus = existingManga?.status ?? 'ONGOING';
    bool isPremium = existingManga?.isPremium ?? false;
    String coverUrl = existingManga?.coverUrl ?? '';
    
    List<String> selectedCreatorIds = List.from(existingManga?.creatorIds ?? []);
    List<String> selectedTagIds = List.from(existingManga?.tags ?? []);

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Group tags for better structure on form
            final Map<String, List<Tag>> groupedTags = {};
            for (var tag in allTags) {
              groupedTags.putIfAbsent(tag.group, () => []).add(tag);
            }

            return AlertDialog(
              backgroundColor: AdminColors.surface,
              title: Text(
                isEdit ? 'EDIT MANGA SERIES' : 'ADD MANGA SERIES',
                style: GoogleFonts.bebasNeue(color: AdminColors.cyberCyan, letterSpacing: 1.5),
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TextFields
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          controller: titleController,
                          style: const TextStyle(color: AdminColors.onSurface),
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            labelStyle: TextStyle(color: AdminColors.onSurfaceVariant),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.outlineVariant)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.cyberCyan)),
                          ),
                          onChanged: (val) {
                            if (!isEdit && (slugController.text.isEmpty || slugController.text == _generateSlug(val.substring(0, val.length > 1 ? val.length - 1 : 0)))) {
                              setState(() {
                                slugController.text = _generateSlug(val);
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          controller: slugController,
                          style: const TextStyle(color: AdminColors.onSurface),
                          decoration: const InputDecoration(
                            labelText: 'Slug',
                            labelStyle: TextStyle(color: AdminColors.onSurfaceVariant),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.outlineVariant)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.cyberCyan)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          controller: descController,
                          style: const TextStyle(color: AdminColors.onSurface),
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: AdminColors.onSurfaceVariant),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.outlineVariant)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.cyberCyan)),
                          ),
                        ),
                      ),
                      
                      // Cover URL & Image Preview
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                style: const TextStyle(color: AdminColors.onSurface),
                                decoration: const InputDecoration(
                                  labelText: 'Cover Image URL',
                                  labelStyle: TextStyle(color: AdminColors.onSurfaceVariant),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.outlineVariant)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.cyberCyan)),
                                ),
                                controller: TextEditingController(text: coverUrl),
                                onChanged: (val) {
                                  setState(() {
                                    coverUrl = val.trim();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  try {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uploading image...')));
                                    final url = await UploadApiService().uploadImage(image);
                                    setState(() {
                                      coverUrl = url;
                                    });
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image uploaded successfully!'), backgroundColor: AdminColors.green));
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: $e'), backgroundColor: AdminColors.errorRed));
                                    }
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AdminColors.surfaceHigh,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                              ),
                              child: const Icon(Icons.upload_file, color: AdminColors.cyberCyan),
                            ),
                            if (coverUrl.isNotEmpty) ...[
                              const SizedBox(width: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: CachedNetworkImage(
                                  imageUrl: coverUrl,
                                  width: 45,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(width: 45, height: 60, color: AdminColors.surfaceHigh),
                                  errorWidget: (context, url, error) => Container(
                                    width: 45,
                                    height: 60,
                                    color: AdminColors.surfaceHigh,
                                    child: const Icon(Icons.broken_image, color: Colors.white24, size: 20),
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),

                      // Status Dropdown & VIP Switch
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: selectedStatus,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                                labelStyle: TextStyle(color: AdminColors.onSurfaceVariant),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.outlineVariant)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.cyberCyan)),
                              ),
                              dropdownColor: AdminColors.surfaceHigh,
                              style: const TextStyle(color: AdminColors.onSurface),
                              items: ['ONGOING', 'COMPLETED'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => selectedStatus = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const Text('Premium VIP', style: TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 13)),
                              Switch(
                                value: isPremium,
                                activeColor: AdminColors.sakuraPink,
                                onChanged: (val) {
                                  setState(() => isPremium = val);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Multi-select Creators
                      Text('CREATORS (AUTHORS/ARTISTS)', style: GoogleFonts.spaceGrotesk(fontSize: 12, color: AdminColors.cyberCyan, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      if (allCreators.isEmpty)
                        const Text('No creators available. Please create creators first.', style: TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 12))
                      else
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: allCreators.map((creator) {
                            final isSelected = selectedCreatorIds.contains(creator.id);
                            return FilterChip(
                              label: Text(creator.name, style: TextStyle(color: isSelected ? Colors.black : AdminColors.onSurface, fontSize: 12)),
                              selected: isSelected,
                              selectedColor: AdminColors.warningYellow,
                              checkmarkColor: Colors.black,
                              backgroundColor: AdminColors.surfaceHigh,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectedCreatorIds.add(creator.id);
                                  } else {
                                    selectedCreatorIds.remove(creator.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 16),

                      // Multi-select Tags (Grouped)
                      Text('TAGS & GENRES', style: GoogleFonts.spaceGrotesk(fontSize: 12, color: AdminColors.cyberCyan, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      if (allTags.isEmpty)
                        const Text('No tags available. Please create tags first.', style: TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 12))
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: groupedTags.entries.map((entry) {
                            final groupName = entry.key;
                            final groupTags = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    groupName.toUpperCase(),
                                    style: TextStyle(fontSize: 10, color: groupName.toUpperCase() == 'GENRE' ? AdminColors.shonenPurple : AdminColors.onSurfaceVariant, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: groupTags.map((tag) {
                                      final isSelected = selectedTagIds.contains(tag.id);
                                      final isGenre = tag.group.toUpperCase() == 'GENRE';
                                      return FilterChip(
                                        label: Text(tag.name, style: TextStyle(color: isSelected ? Colors.white : AdminColors.onSurface, fontSize: 11)),
                                        selected: isSelected,
                                        selectedColor: isGenre ? AdminColors.shonenPurple : AdminColors.cyberCyan,
                                        checkmarkColor: Colors.white,
                                        backgroundColor: AdminColors.surfaceHigh,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              selectedTagIds.add(tag.id);
                                            } else {
                                              selectedTagIds.remove(tag.id);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('CANCEL', style: TextStyle(color: AdminColors.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: provider.isLoading ? null : () async {
                    if (titleController.text.isEmpty || slugController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title and Slug are required.')));
                      return;
                    }

                    final Map<String, dynamic> mangaData = {
                      'title': titleController.text.trim(),
                      'slug': slugController.text.trim(),
                      'description': descController.text.trim(),
                      'coverUrl': coverUrl,
                      'creatorIds': selectedCreatorIds,
                      'tagIds': selectedTagIds,
                      'status': selectedStatus,
                      'isPremium': isPremium,
                    };

                    Navigator.pop(ctx);

                    bool success;
                    if (isEdit) {
                      success = await provider.updateManga(existingManga.id, mangaData);
                    } else {
                      success = await provider.addManga(mangaData);
                    }

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(success ? (isEdit ? 'Manga updated!' : 'Manga added!') : provider.errorMessage ?? 'Operation failed'),
                        backgroundColor: success ? AdminColors.green : AdminColors.errorRed,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AdminColors.cyberCyan),
                  child: provider.isLoading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          }
        );
      },
    );
  }

  String _generateSlug(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
