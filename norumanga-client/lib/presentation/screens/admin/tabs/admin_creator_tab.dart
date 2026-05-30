import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/creator.dart';
import '../../../../providers/creator_provider.dart';
import '../admin_dashboard_screen.dart';

class AdminCreatorTab extends StatefulWidget {
  const AdminCreatorTab({super.key});

  @override
  State<AdminCreatorTab> createState() => _AdminCreatorTabState();
}

class _AdminCreatorTabState extends State<AdminCreatorTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreatorProvider>().fetchCreators();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreatorProvider>(
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
                    'CREATOR MANAGEMENT',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 24,
                      color: AdminColors.onSurface,
                      letterSpacing: 1.5,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showCreatorDialog(context, provider),
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text('ADD CREATOR', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.sakuraPink,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (provider.isLoading && provider.creators.isEmpty)
                const Center(child: CircularProgressIndicator(color: AdminColors.sakuraPink))
              else if (provider.errorMessage != null && provider.creators.isEmpty)
                Center(child: Text(provider.errorMessage!, style: const TextStyle(color: AdminColors.errorRed)))
              else if (provider.creators.isEmpty)
                const Center(child: Text('No creators found.', style: TextStyle(color: AdminColors.onSurfaceVariant)))
              else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.paginatedCreators.length,
                  itemBuilder: (context, index) {
                    final creator = provider.paginatedCreators[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AdminColors.surface,
                        border: Border.all(color: AdminColors.outlineVariant),
                        boxShadow: const [BoxShadow(color: AdminColors.sakuraPink, offset: Offset(2, 2))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AdminColors.surfaceHigh,
                              shape: BoxShape.circle,
                              border: Border.all(color: AdminColors.sakuraPink),
                              image: creator.avatarUrl != null && creator.avatarUrl!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(creator.avatarUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: creator.avatarUrl == null || creator.avatarUrl!.isEmpty
                                ? const Icon(Icons.person, color: Colors.white24)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(creator.name, style: GoogleFonts.bebasNeue(fontSize: 18, color: AdminColors.onSurface)),
                                Text(creator.slug, style: const TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: AdminColors.cyberCyan),
                            onPressed: () => _showCreatorDialog(context, provider, existingCreator: creator),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AdminColors.errorRed),
                            onPressed: () => _confirmDelete(context, provider, creator),
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

  void _confirmDelete(BuildContext context, CreatorProvider provider, Creator creator) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AdminColors.surface,
        title: Text('DELETE CREATOR', style: GoogleFonts.bebasNeue(color: AdminColors.errorRed, letterSpacing: 1)),
        content: Text('Are you sure you want to delete the creator "${creator.name}"?', style: const TextStyle(color: AdminColors.onSurface)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: AdminColors.onSurfaceVariant)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.deleteCreator(creator.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success ? 'Creator deleted successfully!' : provider.errorMessage ?? 'Delete failed'),
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

  void _showCreatorDialog(BuildContext context, CreatorProvider provider, {Creator? existingCreator}) {
    final isEdit = existingCreator != null;
    final nameController = TextEditingController(text: existingCreator?.name ?? '');
    final slugController = TextEditingController(text: existingCreator?.slug ?? '');
    final originalNameController = TextEditingController(text: existingCreator?.originalName ?? '');
    final biographyController = TextEditingController(text: existingCreator?.biography ?? '');
    final avatarUrlController = TextEditingController(text: existingCreator?.avatarUrl ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AdminColors.surface,
              title: Text(
                isEdit ? 'EDIT CREATOR' : 'ADD CREATOR',
                style: GoogleFonts.bebasNeue(color: AdminColors.sakuraPink, letterSpacing: 1),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar Preview Header
                    if (avatarUrlController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AdminColors.surfaceHigh,
                              shape: BoxShape.circle,
                              border: Border.all(color: AdminColors.sakuraPink, width: 2),
                              image: DecorationImage(
                                image: NetworkImage(avatarUrlController.text),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {
                                  // Can't show error easily here, but it will fallback gracefully mostly
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: nameController,
                        style: const TextStyle(color: AdminColors.onSurface),
                        decoration: _inputDecoration('Name (Required)'),
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
                        decoration: _inputDecoration('Slug (Required)'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: originalNameController,
                        style: const TextStyle(color: AdminColors.onSurface),
                        decoration: _inputDecoration('Original Name (e.g., Japanese)'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: avatarUrlController,
                        style: const TextStyle(color: AdminColors.onSurface),
                        decoration: _inputDecoration('Avatar URL'),
                        onChanged: (val) {
                          setState(() {}); // Trigger rebuild to show/hide avatar preview
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: biographyController,
                        maxLines: 3,
                        style: const TextStyle(color: AdminColors.onSurface),
                        decoration: _inputDecoration('Biography'),
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name and Slug are required')));
                      return;
                    }
                    
                    final req = CreatorRequest(
                      name: nameController.text.trim(),
                      slug: slugController.text.trim(),
                      originalName: originalNameController.text.trim().isEmpty ? null : originalNameController.text.trim(),
                      biography: biographyController.text.trim().isEmpty ? null : biographyController.text.trim(),
                      avatarUrl: avatarUrlController.text.trim().isEmpty ? null : avatarUrlController.text.trim(),
                    );

                    Navigator.pop(ctx);
                    
                    bool success;
                    if (isEdit) {
                      success = await provider.updateCreator(existingCreator.id, req);
                    } else {
                      success = await provider.addCreator(req);
                    }

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(success ? (isEdit ? 'Creator updated!' : 'Creator added!') : provider.errorMessage ?? 'Operation failed'),
                        backgroundColor: success ? AdminColors.green : AdminColors.errorRed,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AdminColors.sakuraPink),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AdminColors.onSurfaceVariant),
      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AdminColors.outlineVariant)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AdminColors.sakuraPink)),
    );
  }

  String _generateSlug(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
  }
}
