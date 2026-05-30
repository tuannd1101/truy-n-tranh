import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/tag.dart';
import '../../../../providers/tag_provider.dart';
import '../admin_dashboard_screen.dart';

class AdminTagTab extends StatefulWidget {
  const AdminTagTab({super.key});

  @override
  State<AdminTagTab> createState() => _AdminTagTabState();
}

class _AdminTagTabState extends State<AdminTagTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TagProvider>().fetchTags();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TagProvider>(
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
                    'TAG MANAGEMENT',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 24,
                      color: AdminColors.onSurface,
                      letterSpacing: 1.5,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showTagDialog(context, provider),
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text('ADD TAG', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.shonenPurple,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (provider.isLoading && provider.tags.isEmpty)
                const Center(child: CircularProgressIndicator(color: AdminColors.shonenPurple))
              else if (provider.errorMessage != null && provider.tags.isEmpty)
                Center(child: Text(provider.errorMessage!, style: const TextStyle(color: AdminColors.errorRed)))
              else if (provider.tags.isEmpty)
                const Center(child: Text('No tags found.', style: TextStyle(color: AdminColors.onSurfaceVariant)))
              else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.paginatedTags.length,
                  itemBuilder: (context, index) {
                    final tag = provider.paginatedTags[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AdminColors.surface,
                        border: Border.all(color: AdminColors.outlineVariant),
                        boxShadow: const [BoxShadow(color: AdminColors.shonenPurple, offset: Offset(2, 2))],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer, color: AdminColors.shonenPurple),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tag.name, style: GoogleFonts.bebasNeue(fontSize: 18, color: AdminColors.onSurface)),
                                Text(tag.slug, style: const TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 12)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AdminColors.shonenPurple),
                                  ),
                                  child: Text(tag.group, style: const TextStyle(fontSize: 9, color: AdminColors.shonenPurple, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: AdminColors.cyberCyan),
                            onPressed: () => _showTagDialog(context, provider, existingTag: tag),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AdminColors.errorRed),
                            onPressed: () => _confirmDelete(context, provider, tag),
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

  void _confirmDelete(BuildContext context, TagProvider provider, Tag tag) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.surface,
        title: Text('DELETE TAG', style: GoogleFonts.bebasNeue(color: AdminColors.errorRed, letterSpacing: 1)),
        content: Text('Are you sure you want to delete the tag "${tag.name}"?', style: const TextStyle(color: AdminColors.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AdminColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.deleteTag(tag.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success ? 'Tag deleted successfully!' : provider.errorMessage ?? 'Delete failed'),
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

  void _showTagDialog(BuildContext context, TagProvider provider, {Tag? existingTag}) {
    final isEdit = existingTag != null;
    final nameController = TextEditingController(text: existingTag?.name ?? '');
    final slugController = TextEditingController(text: existingTag?.slug ?? '');
    String selectedGroup = existingTag?.group ?? 'THEME';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AdminColors.surface,
              title: Text(
                isEdit ? 'EDIT TAG' : 'ADD TAG',
                style: GoogleFonts.bebasNeue(color: AdminColors.shonenPurple, letterSpacing: 1),
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
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.shonenPurple)),
                        ),
                        onChanged: (val) {
                          // Auto-generate slug if it's a new tag and slug is empty
                          if (!isEdit && slugController.text.isEmpty || slugController.text == _generateSlug(val.substring(0, val.length > 1 ? val.length - 1 : 0))) {
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
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.shonenPurple)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DropdownButtonFormField<String>(
                        value: selectedGroup,
                        decoration: const InputDecoration(
                          labelText: 'Tag Group',
                          labelStyle: TextStyle(color: AdminColors.onSurfaceVariant),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.outlineVariant)),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminColors.shonenPurple)),
                        ),
                        dropdownColor: AdminColors.surfaceHigh,
                        style: const TextStyle(color: AdminColors.onSurface),
                        items: ['THEME', 'GENRE', 'FORMAT', 'CONTENT', 'STYLE'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedGroup = val);
                        },
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
                    
                    final req = TagRequest(
                      name: nameController.text.trim(),
                      slug: slugController.text.trim(),
                      group: selectedGroup,
                    );

                    Navigator.pop(ctx);
                    
                    bool success;
                    if (isEdit) {
                      success = await provider.updateTag(existingTag.id, req);
                    } else {
                      success = await provider.addTag(req);
                    }

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(success ? (isEdit ? 'Tag updated!' : 'Tag added!') : provider.errorMessage ?? 'Operation failed'),
                        backgroundColor: success ? AdminColors.green : AdminColors.errorRed,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AdminColors.shonenPurple),
                  child: provider.isLoading 
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('SAVE', style: TextStyle(color: Colors.white)),
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
