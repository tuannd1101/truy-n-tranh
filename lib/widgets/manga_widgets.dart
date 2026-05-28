import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ==================== SCREENTONE BACKGROUND ====================
class ScreentoneBg extends StatelessWidget {
  final Widget child;
  const ScreentoneBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(child: CustomPaint(painter: _DotPainter())),
      child,
    ]);
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFF252535);
    for (double x = 0; x < size.width; x += 10) {
      for (double y = 0; y < size.height; y += 10) {
        canvas.drawCircle(Offset(x, y), 1, p);
      }
    }
  }
  @override bool shouldRepaint(_) => false;
}

// ==================== MANGAFLOW LOGO HEADER ====================
class MangaFlowLogo extends StatelessWidget {
  const MangaFlowLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.pink,
            border: Border.all(color: AppColors.inkBorder, width: 2),
          ),
          child: Text('MANGAFLOW',
            style: GoogleFonts.anton(fontSize: 14, color: AppColors.inkBorder, letterSpacing: 1.5),
          ),
        ),
      ],
    );
  }
}

// ==================== BOTTOM NAV BAR ====================
class MangaNavBar extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const MangaNavBar({super.key, required this.current, required this.onTap});

  static const _items = [
    {'icon': Icons.home_rounded, 'label': 'HOME'},
    {'icon': Icons.menu_book_rounded, 'label': 'READ'},
    {'icon': Icons.edit_rounded, 'label': 'CREATE'},
    {'icon': Icons.auto_stories_rounded, 'label': 'LIBRARY'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        border: Border(top: BorderSide(color: AppColors.inkBorder, width: 3)),
        boxShadow: [BoxShadow(offset: Offset(0, -3), color: AppColors.cyan, blurRadius: 0)],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_items.length, (i) {
              final sel = i == current;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    decoration: sel
                        ? BoxDecoration(
                            color: AppColors.pink,
                            border: Border.all(color: AppColors.inkBorder, width: 2),
                          )
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_items[i]['icon'] as IconData,
                          color: sel ? AppColors.inkBorder : AppColors.textSecondary, size: 22),
                        const SizedBox(height: 2),
                        Text(_items[i]['label'] as String,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 8, fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: sel ? AppColors.inkBorder : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ==================== MANGA STAT BUBBLE ====================
/// Speech bubble style stat card từ Stitch Home Dashboard
class StatBubble extends StatelessWidget {
  final String value;
  final String label;
  final Color borderColor;
  final Color shadowColor;

  const StatBubble({
    super.key,
    required this.value,
    required this.label,
    required this.borderColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            border: Border.all(color: borderColor, width: 3),
            boxShadow: [BoxShadow(offset: const Offset(4, 4), color: shadowColor, blurRadius: 0)],
          ),
          child: Column(
            children: [
              Text(value,
                style: GoogleFonts.anton(fontSize: 36, color: borderColor, letterSpacing: 1),
              ),
              const SizedBox(height: 4),
              Text(label,
                textAlign: TextAlign.center,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 9, fontWeight: FontWeight.w700,
                  letterSpacing: 2, color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Speech bubble tail
        CustomPaint(
          size: const Size(20, 10),
          painter: _BubbleTailPainter(color: borderColor),
        ),
      ],
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color color;
  _BubbleTailPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, p);
  }
  @override bool shouldRepaint(_) => false;
}

// ==================== MANGA PROJECT CARD (Library style) ====================
class MangaLibraryCard extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  final String genre;
  final String status;
  final String lastEdited;
  final String coverUrl;
  final Color genreColor;
  final Color statusColor;
  final bool isEditable;
  final VoidCallback? onTap;

  const MangaLibraryCard({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.genre,
    required this.status,
    required this.lastEdited,
    required this.coverUrl,
    this.genreColor = AppColors.pink,
    this.statusColor = AppColors.red,
    this.isEditable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          border: Border.all(color: AppColors.inkBorder, width: 3),
          boxShadow: const [BoxShadow(offset: Offset(4, 4), color: AppColors.inkBorder)],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Number badge top right
            Positioned(
              top: -10, right: -10,
              child: Transform.rotate(
                angle: number.isEven ? 0.1 : -0.08,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cyan,
                    border: Border.all(color: AppColors.inkBorder, width: 2),
                  ),
                  child: Text('${number.toString().padLeft(2, '0')}',
                    style: GoogleFonts.anton(fontSize: 14, color: AppColors.inkBorder),
                  ),
                ),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Cover image
                  SizedBox(
                    width: 110,
                    child: Image.network(
                      coverUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceDim,
                        child: const Icon(Icons.image, color: AppColors.textDisabled),
                      ),
                    ),
                  ),
                  Container(width: 3, color: AppColors.inkBorder),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                _badge(genre, genreColor, AppColors.inkBorder),
                                const SizedBox(width: 6),
                                _badge(status, statusColor, AppColors.inkBorder),
                              ]),
                              const SizedBox(height: 8),
                              Text(title.toUpperCase(),
                                style: GoogleFonts.sora(
                                  fontSize: 18, fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary, height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(description,
                                maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.sora(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                const Icon(Icons.schedule, size: 11, color: AppColors.textDisabled),
                                const SizedBox(width: 4),
                                Text(lastEdited,
                                  style: GoogleFonts.jetBrainsMono(fontSize: 9, color: AppColors.textSecondary),
                                ),
                              ]),
                              _actionBtn(isEditable ? 'EDIT' : 'VIEW', isEditable ? AppColors.pink : AppColors.surfaceDim),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border, width: 1.5),
      ),
      child: Text(text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 9, fontWeight: FontWeight.w800,
          letterSpacing: 1, color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _actionBtn(String label, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: AppColors.inkBorder, width: 2),
        boxShadow: [BoxShadow(
          offset: const Offset(2, 2),
          color: bg == AppColors.pink ? AppColors.shadowPink : AppColors.inkBorderSoft,
          blurRadius: 0,
        )],
      ),
      child: Text(label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10, fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: bg == AppColors.pink ? AppColors.inkBorder : AppColors.textSecondary,
        ),
      ),
    );
  }
}

// ==================== SECTION DIVIDER ====================
class SectionDivider extends StatelessWidget {
  final String label;
  final Color color;
  const SectionDivider({super.key, required this.label, this.color = AppColors.pink});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(children: [
        Expanded(child: Container(height: 2, color: AppColors.inkBorderSoft)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
          ),
          child: Text(label,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10, fontWeight: FontWeight.w800,
              letterSpacing: 2, color: color,
            ),
          ),
        ),
        Expanded(child: Container(height: 2, color: AppColors.inkBorderSoft)),
      ]),
    );
  }
}

// ==================== MANGA BACK BUTTON ====================
class MangaBackButton extends StatelessWidget {
  final Color shadowColor;
  const MangaBackButton({super.key, this.shadowColor = AppColors.cyan});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          border: Border.all(color: AppColors.inkBorder, width: 2),
          boxShadow: [BoxShadow(offset: const Offset(3, 3), color: shadowColor, blurRadius: 0)],
        ),
        child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}
