import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../admin_dashboard_screen.dart'; // To access AdminColors

class AdminMangaTab extends StatelessWidget {
  const AdminMangaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MANGA MANAGEMENT',
                style: GoogleFonts.bebasNeue(
                  fontSize: 24,
                  color: AdminColors.onSurface,
                  letterSpacing: 1.5,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showMangaDialog(context),
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
          // Sample Manga List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, // Mock data
            itemBuilder: (context, index) {
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
                    Container(
                      width: 50,
                      height: 70,
                      color: AdminColors.surfaceHigh,
                      child: const Icon(Icons.image, color: Colors.white24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Mock Manga Title $index', style: GoogleFonts.bebasNeue(fontSize: 18, color: AdminColors.onSurface)),
                          const Text('slug-title', style: TextStyle(color: AdminColors.onSurfaceVariant, fontSize: 12)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            color: AdminColors.green,
                            child: const Text('ONGOING', style: TextStyle(fontSize: 9, color: Colors.black, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AdminColors.sakuraPink),
                      onPressed: () => _showMangaDialog(context, isEdit: true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AdminColors.errorRed),
                      onPressed: () {}, // Handle delete
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showMangaDialog(BuildContext context, {bool isEdit = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AdminColors.surface,
          title: Text(
            isEdit ? 'EDIT MANGA' : 'ADD MANGA',
            style: GoogleFonts.bebasNeue(color: AdminColors.cyberCyan, letterSpacing: 1),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField('Title'),
                _buildTextField('Slug'),
                _buildTextField('Description', maxLines: 3),
                _buildTextField('Cover URL'),
                _buildTextField('Banner URL'),
                // Dropdowns for Status, Content Rating, etc. can go here
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL', style: TextStyle(color: AdminColors.onSurfaceVariant)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: AdminColors.cyberCyan),
              child: const Text('SAVE', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        maxLines: maxLines,
        style: const TextStyle(color: AdminColors.onSurface),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AdminColors.onSurfaceVariant),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: AdminColors.outlineVariant)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AdminColors.cyberCyan)),
        ),
      ),
    );
  }
}
