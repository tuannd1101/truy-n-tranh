import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/manga_widgets.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScreentoneBg(
        child: SafeArea(
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverToBoxAdapter(child: _characterCard(context)),
            SliverToBoxAdapter(child: _statsGrid(context)),
            SliverToBoxAdapter(child: _actionButtons()),
            SliverToBoxAdapter(child: const SectionDivider(label: 'ARC COMPLETIONS', color: AppColors.gold)),
            SliverToBoxAdapter(child: _arcBadges()),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ]),
        ),
      ),
      bottomNavigationBar: MangaNavBar(current: 0, onTap: (_) {}),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const MangaFlowLogo(),
          const MangaBackButton(shadowColor: AppColors.gold),
        ],
      ),
    );
  }

  Widget _characterCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          border: Border.all(color: AppColors.inkBorder, width: 3),
          boxShadow: const [BoxShadow(offset: Offset(6, 6), color: AppColors.pink, blurRadius: 0)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Cover portrait
          SizedBox(
            height: 180,
            width: double.infinity,
            child: Stack(fit: StackFit.expand, children: [
              Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuD_bgHBjnvrsRji1AGIposuGErpAndwAlg1I5Q7LPDXXGqtRvLfXcR8-2XXMkOBYXDrrT9MzzkuojCkHAz3TbtkCaFP1p-Ej9PmHvaxdIkQIV7d8cyKKY5Bkot1w9gSLXOYzePR4lDfcDwhhDhvEtax5KCjdZ14ze6hNrV-ZzSLwbJZc39peJm5hk55P5Jo3KEst9TDnoikIzFiXDcQZOGTYUcbH8WbGHMoCvjJepGWCDtD1e126OlyT2WozKxhIid7bgB2Hy11mUs',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceDim,
                  child: const Icon(Icons.person, size: 80, color: AppColors.textDisabled)),
              ),
              // Dark overlay bottom
              Container(decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.surfaceCard],
                  stops: const [0.4, 1.0],
                ),
              )),
              // Level badge top left
              Positioned(
                top: 12, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    border: Border.all(color: AppColors.inkBorder, width: 2),
                    boxShadow: const [BoxShadow(offset: Offset(2, 2), color: AppColors.inkBorder, blurRadius: 0)],
                  ),
                  child: Text('Lv.05',
                    style: GoogleFonts.anton(fontSize: 14, color: AppColors.inkBorder, letterSpacing: 1),
                  ),
                ),
              ),
            ]),
          ),
          // User info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("KENJI 'INKSLAYER' SATO",
                style: GoogleFonts.anton(
                  fontSize: 20, color: AppColors.textPrimary,
                  letterSpacing: 1.5,
                  shadows: [const Shadow(offset: Offset(2, 2), color: AppColors.pink)],
                ),
              ),
              const SizedBox(height: 4),
              Text('Master of the G-Pen',
                style: GoogleFonts.sora(fontSize: 12, color: AppColors.textSecondary),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _statsGrid(BuildContext context) {
    final stats = [
      {'label': 'STAMINA', 'value': '8,420', 'color': AppColors.pink},
      {'label': 'SPEED LINES', 'value': '900+', 'color': AppColors.cyan},
      {'label': 'PANELS DRAWN', 'value': '18.48', 'color': AppColors.gold},
      {'label': 'DEADLINES MET', 'value': '09%', 'color': AppColors.red},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
        children: stats.map((s) {
          final color = s['color'] as Color;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              border: Border.all(color: AppColors.inkBorder, width: 2),
              boxShadow: [BoxShadow(offset: const Offset(3, 3), color: color, blurRadius: 0)],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s['label'] as String,
                  style: GoogleFonts.jetBrainsMono(fontSize: 8, color: AppColors.textDisabled, letterSpacing: 1.5),
                ),
                Text(s['value'] as String,
                  style: GoogleFonts.anton(fontSize: 22, color: color),
                ),
              ]),
          );
        }).toList(),
      ),
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(children: [
        Expanded(child: _btn('EDIT STATS', AppColors.surfaceCard, Icons.edit_rounded, AppColors.pink)),
        const SizedBox(width: 10),
        Expanded(child: _btn('SHARE CARD', AppColors.surfaceCard, Icons.ios_share_rounded, AppColors.cyan)),
      ]),
    );
  }

  Widget _btn(String label, Color bg, IconData icon, Color shadow) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: AppColors.inkBorder, width: 2),
        boxShadow: [BoxShadow(offset: const Offset(3, 3), color: shadow, blurRadius: 0)],
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: AppColors.textPrimary, size: 16),
        const SizedBox(width: 8),
        Text(label,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11, fontWeight: FontWeight.w700,
            letterSpacing: 1.5, color: AppColors.textPrimary,
          ),
        ),
      ]),
    );
  }

  Widget _arcBadges() {
    final arcs = [
      {'name': 'ORIGIN\nARC', 'color': AppColors.cyan, 'icon': Icons.star_rounded},
      {'name': 'TOURNAMENT\nARC', 'color': AppColors.gold, 'icon': Icons.emoji_events_rounded},
      {'name': 'REDEMPTION\nARC', 'color': AppColors.pink, 'icon': Icons.favorite_rounded},
      {'name': 'FINAL\nARC', 'color': AppColors.purple, 'icon': Icons.whatshot_rounded},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: arcs.map((arc) {
          final color = arc['color'] as Color;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Column(children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceCard,
                    border: Border.all(color: color, width: 3),
                    boxShadow: [BoxShadow(offset: const Offset(3, 3), color: color, blurRadius: 0)],
                  ),
                  child: Icon(arc['icon'] as IconData, color: color, size: 26),
                ),
                const SizedBox(height: 6),
                Text(arc['name'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 8, fontWeight: FontWeight.w700,
                    letterSpacing: 1, color: AppColors.textSecondary,
                  ),
                ),
              ]),
            ),
          );
        }).toList(),
      ),
    );
  }
}
