import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/manga_widgets.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String title;
  const ProjectDetailScreen({super.key, this.title = 'Neon Samurai Overdrive'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScreentoneBg(
        child: CustomScrollView(slivers: [
          _heroHeader(context),
          SliverToBoxAdapter(child: _infoCard()),
          SliverToBoxAdapter(child: const SectionDivider(label: 'PRODUCTION WORKFLOW', color: AppColors.pink)),
          SliverToBoxAdapter(child: _workflowSection()),
          SliverToBoxAdapter(child: const SectionDivider(label: 'CHAPTERS', color: AppColors.cyan)),
          SliverToBoxAdapter(child: _chaptersSection()),
          SliverToBoxAdapter(child: _addPageBtn()),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ]),
      ),
      bottomNavigationBar: MangaNavBar(current: 2, onTap: (_) {}),
    );
  }

  Widget _heroHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: MangaBackButton(shadowColor: AppColors.pink),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(fit: StackFit.expand, children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCDcAZP7xgalLxRDzves_vsP3iiHB16IAvQAYB_ZsRNndZ14e8ltCqivYwIvmGIO_HuOnnGHHNkonsg7xV4NW_UwiofBOh4FFGlMg5Jn-xLmOVnGBkFoNRePFltPRVs709HDwivnf7LIjrVLnCLugNczVC-DRpVtALQ-wGVJtyOElrqJMUEG4B-IxWKbAG4FCQ-7zqUQ_MlYcKhF5fOGf3-VYJHRJnbLu-w2ur-2Uaqb38JZZSyFPi9NseLFqAWo8ql9XT8bdN16ik',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceDim),
          ),
          Container(decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Colors.transparent, AppColors.background],
            ),
          )),
          Positioned(
            bottom: 12, left: 16, right: 16,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                _chip('IN PROGRESS', AppColors.pink),
                const SizedBox(width: 8),
                _chip('VOL.3', AppColors.cyan),
              ]),
              const SizedBox(height: 6),
              Text(title.toUpperCase(),
                style: GoogleFonts.anton(
                  fontSize: 26, color: AppColors.textPrimary, letterSpacing: 2,
                  shadows: [const Shadow(offset: Offset(3, 3), color: AppColors.pink)],
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: AppColors.inkBorder, width: 2),
      ),
      child: Text(text,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 9, fontWeight: FontWeight.w800,
          letterSpacing: 1.5, color: AppColors.inkBorder,
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          border: Border.all(color: AppColors.inkBorder, width: 2),
          boxShadow: const [BoxShadow(offset: Offset(4, 4), color: AppColors.cyan, blurRadius: 0)],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Title
          const MangaFlowLogo(),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _infoItem('PRODUCTION MANAGER', 'Yuki Tanaka'),
            _infoItem('STATUS', 'Anti-Colgate'),
          ]),
          const SizedBox(height: 12),
          // Progress bar
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('12 / 24 CHAPTERS',
              style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.textSecondary, letterSpacing: 1),
            ),
            Text('50%',
              style: GoogleFonts.anton(fontSize: 16, color: AppColors.pink),
            ),
          ]),
          const SizedBox(height: 6),
          Stack(children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.surfaceDim,
                border: Border.all(color: AppColors.inkBorder, width: 2),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                height: 8,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [AppColors.pink, AppColors.cyan]),
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
        style: GoogleFonts.jetBrainsMono(fontSize: 9, color: AppColors.textDisabled, letterSpacing: 1),
      ),
      Text(value,
        style: GoogleFonts.sora(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      ),
    ]);
  }

  Widget _workflowSection() {
    final steps = [
      {'jp': 'ネーム', 'en': 'Story', 'done': true},
      {'jp': '下書き', 'en': 'Sketch', 'done': true},
      {'jp': 'ペン入れ', 'en': 'Inking', 'done': false},
      {'jp': 'トーン', 'en': 'Tone', 'done': false},
      {'jp': '完成', 'en': 'Complete', 'done': false},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: steps.asMap().entries.map((entry) {
          final i = entry.key;
          final step = entry.value;
          final isDone = step['done'] as bool;
          return Expanded(
            child: Row(children: [
              Expanded(
                child: Column(children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isDone ? AppColors.pink : AppColors.surfaceCard,
                      border: Border.all(
                        color: isDone ? AppColors.inkBorder : AppColors.inkBorderSoft,
                        width: isDone ? 2.5 : 1.5,
                      ),
                      boxShadow: isDone
                          ? const [BoxShadow(offset: Offset(2, 2), color: AppColors.inkBorder, blurRadius: 0)]
                          : null,
                    ),
                    child: Column(children: [
                      Icon(isDone ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        size: 18,
                        color: isDone ? AppColors.inkBorder : AppColors.textDisabled,
                      ),
                      const SizedBox(height: 4),
                      Text(step['jp'] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.sora(
                          fontSize: 9, fontWeight: FontWeight.w700,
                          color: isDone ? AppColors.inkBorder : AppColors.textSecondary,
                        ),
                      ),
                      Text(step['en'] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 8, color: isDone ? AppColors.inkBorder : AppColors.textDisabled,
                        ),
                      ),
                    ]),
                  ),
                ]),
              ),
              if (i < steps.length - 1)
                Container(width: 3, height: 3, color: AppColors.inkBorderSoft),
            ]),
          );
        }).toList(),
      ),
    );
  }

  Widget _chaptersSection() {
    final chapters = [
      {'num': '01', 'title': 'The Ink Bleeds', 'subtitle': 'Arc: Neon Samurai', 'pages': '24', 'status': 'DONE', 'statusColor': AppColors.green},
      {'num': '02', 'title': 'Neon Shadows', 'subtitle': 'Arc: Neon Samurai', 'pages': '22', 'status': 'INKING', 'statusColor': AppColors.pink},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: chapters.map((ch) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              border: Border(
                left: BorderSide(color: ch['statusColor'] as Color, width: 5),
                top: const BorderSide(color: AppColors.inkBorder, width: 2),
                right: const BorderSide(color: AppColors.inkBorder, width: 2),
                bottom: const BorderSide(color: AppColors.inkBorder, width: 2),
              ),
              boxShadow: const [BoxShadow(offset: Offset(3, 3), color: AppColors.inkBorder, blurRadius: 0)],
            ),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDim,
                  border: Border.all(color: AppColors.inkBorder, width: 2),
                ),
                child: Center(child: Text(ch['num'] as String,
                  style: GoogleFonts.anton(fontSize: 14, color: AppColors.textPrimary),
                )),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(ch['title'] as String,
                  style: GoogleFonts.sora(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                ),
                Text(ch['subtitle'] as String,
                  style: GoogleFonts.sora(fontSize: 11, color: AppColors.textSecondary),
                ),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  color: ch['statusColor'] as Color,
                  child: Text(ch['status'] as String,
                    style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.inkBorder),
                  ),
                ),
                const SizedBox(height: 4),
                Text('${ch['pages']} pages',
                  style: GoogleFonts.jetBrainsMono(fontSize: 9, color: AppColors.textSecondary),
                ),
              ]),
            ]),
          );
        }).toList(),
      ),
    );
  }

  Widget _addPageBtn() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.pink, AppColors.purple]),
          border: Border.all(color: AppColors.inkBorder, width: 3),
          boxShadow: const [BoxShadow(offset: Offset(4, 4), color: AppColors.inkBorder, blurRadius: 0)],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.add, color: AppColors.textPrimary, size: 22),
          const SizedBox(width: 8),
          Text('ADD BLANK PAGE',
            style: GoogleFonts.jetBrainsMono(
              fontSize: 13, fontWeight: FontWeight.w800,
              letterSpacing: 2, color: AppColors.textPrimary,
            ),
          ),
        ]),
      ),
    );
  }
}
