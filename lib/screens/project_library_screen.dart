import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/manga_widgets.dart';
import 'project_detail_screen.dart';

class ProjectLibraryScreen extends StatefulWidget {
  const ProjectLibraryScreen({super.key});
  @override State<ProjectLibraryScreen> createState() => _LibraryState();
}

class _LibraryState extends State<ProjectLibraryScreen> {
  int _filter = 0;
  final _filters = [
    {'jp': 'すべて', 'en': 'All'},
    {'jp': '少年', 'en': 'Shounen'},
    {'jp': '連載中', 'en': 'Ongoing'},
    {'jp': '完結', 'en': 'Complete'},
  ];

  final _projects = [
    {
      'number': 1,
      'title': 'Neon Drift',
      'desc': 'Cybernetic racing leagues in Neo-Tokyo. Chapter 14 in progress.',
      'genre': '少年 Shounen',
      'status': '連載中 Serializing',
      'lastEdited': 'Last edited 2h ago',
      'isEditable': true,
      'genreColor': AppColors.pink,
      'statusColor': AppColors.red,
      'cover': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCDcAZP7xgalLxRDzves_vsP3iiHB16IAvQAYB_ZsRNndZ14e8ltCqivYwIvmGIO_HuOnnGHHNkonsg7xV4NW_UwiofBOh4FFGlMg5Jn-xLmOVnGBkFoNRePFltPRVs709HDwivnf7LIjrVLnCLugNczVC-DRpVtALQ-wGVJtyOElrqJMUEG4B-IxWKbAG4FCQ-7zqUQ_MlYcKhF5fOGf3-VYJHRJnbLu-w2ur-2Uaqb38JZZSyFPi9NseLFqAWo8ql9XT8bdN16ik',
    },
    {
      'number': 2,
      'title': 'Crimson Blade',
      'desc': 'A masterless samurai seeks vengeance across the Edo period.',
      'genre': '青年 Seinen',
      'status': '完結 Completed',
      'lastEdited': 'Last edited 1w ago',
      'isEditable': false,
      'genreColor': AppColors.gold,
      'statusColor': AppColors.surfaceCard,
      'cover': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBPsezFc1vYhdtESlLMwuSPW3GpUernDrlUfu5OB5rVrkC67LWio08DWFYcOd5wzd5WRowhf8lk1FUvaW9WsXTaz_Mf_6jjCeIBiaGJeqLjF12GDvXHIAgDDV4bBbJHrCytCyT0g-9J5g06tTHIS31SjdaM7m2S7d89tMHisvBRsr06gV0QAobAX3UEekCPK47QWxdu7ET3mart_CSttUurEyhetTj98RDSSCDCoGTavZGSx8rZUDM-vmcMXz_vSY1V6EENAf-DG2U',
    },
    {
      'number': 3,
      'title': 'Starfall Magic',
      'desc': 'Middle schoolers protect the galaxy with explosive power.',
      'genre': '少女 Shoujo',
      'status': '連載中 Serializing',
      'lastEdited': 'Last edited 3d ago',
      'isEditable': true,
      'genreColor': AppColors.purple,
      'statusColor': AppColors.red,
      'cover': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDLRNo5dW0RkkA1V1V-laVlv7O120KnfeG3MW1-NtYn8t4U7ka6VbOSQntLw1bedSSKJmSXz_x2G4NayJv-fFhOaGgTVi-_ZbECr4IX-9VMmXzcTr1SkJGu-eCTkQzrsbSwJdgyP8YFxIZsVCUbymQRdDNev2aWnmogkNUiREIQGCoQ85yzVWvL4YRTLDWylCASIoztI_OIfX2Fq8HEaap2YXfao84kod7D_gASMO8lc8UPw0VUFNO9ItxlYm4udecxKXuHhaB9vnY',
    },
    {
      'number': 4,
      'title': 'Shadow Hunter',
      'desc': 'A lone hunter battles demons in a post-apocalyptic Japan.',
      'genre': '少年 Shounen',
      'status': '連載中 Serializing',
      'lastEdited': 'Last edited 5h ago',
      'isEditable': true,
      'genreColor': AppColors.pink,
      'statusColor': AppColors.red,
      'cover': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCDcAZP7xgalLxRDzves_vsP3iiHB16IAvQAYB_ZsRNndZ14e8ltCqivYwIvmGIO_HuOnnGHHNkonsg7xV4NW_UwiofBOh4FFGlMg5Jn-xLmOVnGBkFoNRePFltPRVs709HDwivnf7LIjrVLnCLugNczVC-DRpVtALQ-wGVJtyOElrqJMUEG4B-IxWKbAG4FCQ-7zqUQ_MlYcKhF5fOGf3-VYJHRJnbLu-w2ur-2Uaqb38JZZSyFPi9NseLFqAWo8ql9XT8bdN16ik',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScreentoneBg(
        child: SafeArea(
          child: Column(children: [
            _buildHeader(),
            _buildFilterBar(),
            Expanded(child: _buildList()),
          ]),
        ),
      ),
      floatingActionButton: _fab(),
      bottomNavigationBar: MangaNavBar(current: 3, onTap: (_) {}),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const MangaFlowLogo(),
          const MangaBackButton(shadowColor: AppColors.pink),
        ]),
        const SizedBox(height: 12),
        // Big "LIBRARY" title like poster
        Text('LIBRARY',
          style: GoogleFonts.anton(
            fontSize: 52, letterSpacing: 4,
            color: AppColors.textPrimary,
            shadows: [const Shadow(offset: Offset(4, 4), color: AppColors.pink)],
          ),
        ),
        Text('Your creative archive. Manage, review, and organize your manga projects.',
          style: GoogleFonts.sora(fontSize: 11, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        // Search
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            border: Border.all(color: AppColors.inkBorder, width: 2),
            boxShadow: const [BoxShadow(offset: Offset(3, 3), color: AppColors.cyan, blurRadius: 0)],
          ),
          child: Row(children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.search, color: AppColors.textDisabled, size: 18),
            ),
            Expanded(
              child: TextField(
                style: GoogleFonts.jetBrainsMono(color: AppColors.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  hintStyle: GoogleFonts.jetBrainsMono(color: AppColors.textDisabled, fontSize: 12),
                  border: InputBorder.none, isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_filters.length, (i) {
            final sel = i == _filter;
            return GestureDetector(
              onTap: () => setState(() => _filter = i),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: sel ? AppColors.pink : AppColors.surfaceCard,
                  border: Border.all(color: sel ? AppColors.inkBorder : AppColors.inkBorderSoft, width: 2),
                  boxShadow: sel ? const [BoxShadow(offset: Offset(3, 3), color: AppColors.inkBorder, blurRadius: 0)] : null,
                ),
                child: Row(children: [
                  Text(_filters[i]['jp']!,
                    style: GoogleFonts.sora(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      color: sel ? AppColors.inkBorder : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(_filters[i]['en']!,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9, letterSpacing: 1,
                      color: sel ? AppColors.inkBorder : AppColors.textDisabled,
                    ),
                  ),
                ]),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: _projects.length,
      itemBuilder: (_, i) {
        final p = _projects[i];
        return MangaLibraryCard(
          number: p['number'] as int,
          title: p['title'] as String,
          description: p['desc'] as String,
          genre: p['genre'] as String,
          status: p['status'] as String,
          lastEdited: p['lastEdited'] as String,
          coverUrl: p['cover'] as String,
          genreColor: p['genreColor'] as Color,
          statusColor: p['statusColor'] as Color,
          isEditable: p['isEditable'] as bool,
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => ProjectDetailScreen(title: p['title'] as String),
          )),
        );
      },
    );
  }

  Widget _fab() {
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(
        color: AppColors.pink,
        border: Border.all(color: AppColors.inkBorder, width: 3),
        boxShadow: const [BoxShadow(offset: Offset(4, 4), color: AppColors.inkBorder, blurRadius: 0)],
      ),
      child: const Icon(Icons.add, size: 30, color: AppColors.inkBorder),
    );
  }
}
