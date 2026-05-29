import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/genre.dart';
import '../../../../providers/genre_provider.dart';
import '../admin_dashboard_screen.dart';

class AdminGenreTab extends StatefulWidget {
  const AdminGenreTab({super.key});

  @override
  State<AdminGenreTab> createState() => _AdminGenreTabState();
}

class _AdminGenreTabState extends State<AdminGenreTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GenreProvider>().fetchGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GenreProvider>(
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
                    'GENRE MANAGEMENT',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 24,
                      color: AdminColors.onSurface,
                      letterSpacing: 1.5,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showGenreDialog(context, provider),
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text('ADD GENRE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.warningYellow,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (provider.isLoading && provider.genres.isEmpty)
                const Center(child: CircularProgressIndicator(color: AdminColors.warningYellow))
              else if (provider.errorMessage != null && provider.genres.isEmpty)
                Center(child: Text(provider.errorMessage!, style: const TextStyle(color: AdminColors.errorRed)))
              else if (provider.genres.isEmpty)
                const Center(child: Text('No genres found.', style: TextStyle(color: AdminColors.onSurfaceVariant)))
              else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.paginatedGenres.length,
                  itemBuilder: (context, index) {
                    final genre = provider.paginatedGenres[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AdminColors.surface,
                        border: Border.all(color: AdminColors.outlineVariant),
                        boxShadow: const [BoxShadow(color: AdminColors.warningYellow, offset: Offset(2, 2))],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.category, color: AdminColors.warningYellow),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(genre.name, style: GoogleFonts.bebasNeue(fontSize: 18, color: AdminColors.onSurface)),
                                Text(genre.slug, style: const TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: AdminColors.cyberCyan),
                            onPressed: () => _showGenreDialog(context, provider, existingGenre: genre),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AdminColors.errorRed),
                            onPressed: () => _confirmDelete(context, provider, genre),
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

  void _confirmDelete(BuildContext context, GenreProvider provider, Genre genre) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.surface,
        title: Text('DELETE GENRE', style: GoogleFonts.bebasNeue(color: AdminColors.errorRed, letterSpacing: 1)),
        content: Text('Are you sure you want to delete the genre "${genre.name}"?', style: const TextStyle(color: AdminColors.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AdminColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.deleteGenre(genre.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success ? 'Genre deleted successfully!' : provider.errorMessage ?? 'Delete failed'),
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

  void _showGenreDialog(BuildContext context, GenreProvider provider, {Genre? existingGenre}) {
    final isEdit = existingGenre != null;
    final nameController = TextEditingController(text: existingGenre?.name ?? '');
    final slugController = TextEditingController(text: existingGenre?.slug ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AdminColors.surface,
              title: Text(
                isEdit ? 'EDIT GENRE' : 'ADD GENRE',
                style: GoogleFonts.bebasNeue(color: AdminColors.warningYellow, letterSpacing: 1),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: nameController,
                        style: const TextStyle(color: AdminColors.onSurface),
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: AdminColors.onSurfaceVariant),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.outlineVariant)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.warningYellow)),
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
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.warningYellow)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('CANCEL', style: TextStyle(color: AdminColors.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: provider.isLoading ? null : () async {
                    if (nameController.text.isEmpty || slugController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
                      return;
                    }
                    
                    final req = GenreRequest(
                      name: nameController.text.trim(),
                      slug: slugController.text.trim(),
                    );

                    Navigator.pop(ctx);
                    
                    bool success;
                    if (isEdit) {
                      success = await provider.updateGenre(existingGenre.id, req);
                    } else {
                      success = await provider.addGenre(req);
                    }

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(success ? (isEdit ? 'Genre updated!' : 'Genre added!') : provider.errorMessage ?? 'Operation failed'),
                        backgroundColor: success ? AdminColors.green : AdminColors.errorRed,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AdminColors.warningYellow),
                  child: provider.isLoading 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : const Text('SAVE', style: TextStyle(color: Colors.black)),
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
