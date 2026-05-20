import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/manga_widgets.dart';
import 'project_library_screen.dart';
import 'task_board_screen.dart';
import 'user_profile_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});
  @override State<HomeDashboardScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeDashboardScreen> {
  int _navIdx = 0;

  void _navigate(int i) {
    if (i == _navIdx) return;
    setState(() => _navIdx = i);
    Widget dest;
    switch (i) {
      case 3: dest = const ProjectLibraryScreen(); break;
      case 1: dest = const TaskBoardScreen(); break;
      case 4: dest = const UserProfileScreen(); break;
      default: return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => dest))
        .then((_) => setState(() => _navIdx = 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScreentoneBg(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _header()),
              SliverToBoxAdapter(child: _greeting()),
              SliverToBoxAdapter(child: _statsSection()),
              SliverToBoxAdapter(child: const SectionDivider(label: 'RECENT PROJECTS')),
              SliverToBoxAdapter(child: _recentProjects()),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MangaNavBar(current: _navIdx, onTap: _navigate),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const MangaFlowLogo(),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserProfileScreen())),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                border: Border.all(color: AppColors.cyan, width: 2),
                boxShadow: const [BoxShadow(offset: Offset(2, 2), color: AppColors.cyan, blurRadius: 0)],
              ),
              child: const Icon(Icons.person_rounded, color: AppColors.textPrimary, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _greeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        RichText(text: TextSpan(
          style: GoogleFonts.sora(fontSize: 14, color: AppColors.textSecondary),
          children: const [
            TextSpan(text: 'こんにちは, '),
            TextSpan(text: 'ARTIST-SAN! ', style: TextStyle(color: AppColors.pink, fontWeight: FontWeight.w800)),
            TextSpan(text: '🎌'),
          ],
        )),
        const SizedBox(height: 4),
        Text('Ready to ink the next chapter',
          style: GoogleFonts.sora(fontSize: 12, color: AppColors.textSecondary),
        ),
      ]),
    );
  }

  Widget _statsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: StatBubble(value: '12', label: 'MANGA', borderColor: AppColors.pink, shadowColor: AppColors.shadowPink)),
          const SizedBox(width: 10),
          Expanded(child: StatBubble(value: '450', label: 'CHAPTERS', borderColor: AppColors.cyan, shadowColor: AppColors.shadowCyan)),
          const SizedBox(width: 10),
          Expanded(child: StatBubble(value: '8', label: 'PUBLISHED', borderColor: AppColors.gold, shadowColor: AppColors.shadowGold)),
        ],
      ),
    );
  }

  Widget _recentProjects() {
    final projects = [
      {
        'title': 'NEON SAMURAI\nOVERDRIVE',
        'vol': 'VOL.3',
        'genre': 'ACTION',
        'chapter': 'Chapter 34: The Final Slash in the Cyber City.',
        'shadow': AppColors.shadowPink,
        'cover': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCDcAZP7xgalLxRDzves_vsP3iiHB16IAvQAYB_ZsRNndZ14e8ltCqivYwIvmGIO_HuOnnGHHNkonsg7xV4NW_UwiofBOh4FFGlMg5Jn-xLmOVnGBkFoNRePFltPRVs709HDwivnf7LIjrVLnCLugNczVC-DRpVtALQ-wGVJtyOElrqJMUEG4B-IxWKbAG4FCQ-7zqUQ_MlYcKhF5fOGf3-VYJHRJnbLu-w2ur-2Uaqb38JZZSyFPi9NseLFqAWo8ql9XT8bdN16ik',
      },
      {
        'title': 'SILENT\nECHOES',
        'vol': 'VOL.1',
        'genre': 'SCI-FI',
        'chapter': 'Chapter 5: Whispers in the Rain.',
        'shadow': AppColors.shadowCyan,
        'cover': 'https://lh3.googleusercontent.com/aida-public/AB6AXuD_bgHBjnvrsRji1AGIposuGErpAndwAlg1I5Q7LPDXXGqtRvLfXcR8-2XXMkOBYXDrrT9MzzkuojCkHAz3TbtkCaFP1p-Ej9PmHvaxdIkQIV7d8cyKKY5Bkot1w9gSLXOYzePR4lDfcDwhhDhvEtax5KCjdZ14ze6hNrV-ZzSLwbJZc39peJm5hk55P5Jo3KEst9TDnoikIzFiXDcQZOGTYUcbH8WbGHMoCvjJepGWCDtD1e126OlyT2WozKxhIid7bgB2Hy11mUs',
      },
    ];

    return SizedBox(
      height: 310,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ...projects.map((p) => _projectCard(p)),
          _newProjectCard(),
        ],
      ),
    );
  }

  Widget _projectCard(Map<String, dynamic> p) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          border: Border.all(color: AppColors.inkBorder, width: 3),
          boxShadow: [BoxShadow(offset: const Offset(5, 5), color: p['shadow'] as Color, blurRadius: 0)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(fit: StackFit.expand, children: [
                Image.network(p['cover'] as String, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceDim),
                ),
                Container(decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.inkBorder, width: 3)),
                )),
              ]),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Expanded(
                        child: Text(p['title'] as String,
                          style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary, height: 1.15),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        color: AppColors.pink,
                        child: Text(p['vol'] as String,
                          style: GoogleFonts.jetBrainsMono(fontSize: 8, fontWeight: FontWeight.w800, color: AppColors.inkBorder),
                        ),
                      ),
                    ]),
                    Text(p['chapter'] as String,
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.sora(fontSize: 10, color: AppColors.textSecondary),
                    ),
                    Wrap(spacing: 4, children: [
                      _genreTag(p['genre'] as String),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genreTag(String genre) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        border: Border.all(color: AppColors.inkBorder, width: 2),
      ),
      child: Text(genre,
        style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.w800,
          letterSpacing: 1.5, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _newProjectCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.surfaceDim,
          border: Border.all(color: AppColors.inkBorderSoft, width: 3,
            style: BorderStyle.solid),
          boxShadow: const [BoxShadow(offset: Offset(4, 4), color: AppColors.inkBorder, blurRadius: 0)],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.inkBorder, width: 3),
              boxShadow: const [BoxShadow(offset: Offset(3, 3), color: AppColors.inkBorder, blurRadius: 0)],
            ),
            child: const Icon(Icons.add, size: 30, color: AppColors.inkBorder),
          ),
          const SizedBox(height: 12),
          Text('NEW PROJECT',
            style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w800,
              color: AppColors.textPrimary, letterSpacing: 1),
          ),
        ]),
      ),
    );
  }
}
