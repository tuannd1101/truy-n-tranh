import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/manga_widgets.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});
  @override State<TaskBoardScreen> createState() => _TaskState();
}

class _TaskState extends State<TaskBoardScreen> {
  final _cols = [
    {
      'title': 'BACKLOG', 'jp': '積み残し', 'color': AppColors.textSecondary, 'count': 4,
      'tasks': [
        {'title': 'Draft Character Sheets for Arc 5', 'priority': 'HIGH', 'date': 'Oct 22', 'pc': AppColors.red},
        {'title': 'Location concepts: The Crystal Spine', 'priority': 'MED', 'date': 'Oct 25', 'pc': AppColors.gold},
      ],
    },
    {
      'title': 'IN PROGRESS', 'jp': '進行中', 'color': AppColors.cyan, 'count': 2,
      'tasks': [
        {'title': 'Inking Ch.42 pages 12-18', 'priority': 'HIGH', 'date': 'Oct 20', 'pc': AppColors.red},
        {'title': 'Screentone pass for Ch.41', 'priority': 'MED', 'date': 'Oct 21', 'pc': AppColors.gold},
      ],
    },
    {
      'title': 'REVIEW', 'jp': 'レビュー', 'color': AppColors.gold, 'count': 1,
      'tasks': [
        {'title': 'Editor check Ch.40 final draft', 'priority': 'ULTRA', 'date': 'Oct 18', 'pc': AppColors.pink},
      ],
    },
    {
      'title': 'DONE', 'jp': '完了', 'color': AppColors.green, 'count': 8,
      'tasks': [
        {'title': 'Storyboard for Arc 4 finale', 'priority': 'LOW', 'date': 'Oct 15', 'pc': AppColors.textDisabled},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ScreentoneBg(
        child: SafeArea(child: Column(children: [
          _header(),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _cols.length,
              itemBuilder: (_, i) => _column(_cols[i]),
            ),
          ),
        ])),
      ),
      bottomNavigationBar: MangaNavBar(current: 2, onTap: (_) {}),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(children: [
        const MangaFlowLogo(),
        const SizedBox(width: 12),
        const MangaBackButton(shadowColor: AppColors.gold),
        const SizedBox(width: 12),
        Text('TASK BOARD',
          style: GoogleFonts.anton(fontSize: 20, color: AppColors.textPrimary, letterSpacing: 2),
        ),
      ]),
    );
  }

  Widget _column(Map<String, dynamic> col) {
    final color = col['color'] as Color;
    final tasks = col['tasks'] as List;

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      child: Column(children: [
        // Column header
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            border: Border.all(color: AppColors.inkBorder, width: 2),
            boxShadow: [BoxShadow(offset: const Offset(4, 4), color: color, blurRadius: 0)],
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(col['title'] as String,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11, fontWeight: FontWeight.w800,
                  letterSpacing: 1.5, color: AppColors.textPrimary,
                ),
              ),
              Text(col['jp'] as String,
                style: GoogleFonts.sora(fontSize: 10, color: AppColors.textSecondary),
              ),
            ]),
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: AppColors.inkBorder, width: 2),
              ),
              child: Center(child: Text('${col['count']}',
                style: GoogleFonts.anton(fontSize: 14, color: AppColors.inkBorder),
              )),
            ),
          ]),
        ),
        const SizedBox(height: 8),
        // Tasks
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, i) => _taskCard(tasks[i] as Map<String, dynamic>, color),
          ),
        ),
      ]),
    );
  }

  Widget _taskCard(Map<String, dynamic> task, Color colColor) {
    final pc = task['pc'] as Color;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        border: Border(
          left: BorderSide(color: colColor, width: 4),
          top: const BorderSide(color: AppColors.inkBorder, width: 2),
          right: const BorderSide(color: AppColors.inkBorder, width: 2),
          bottom: const BorderSide(color: AppColors.inkBorder, width: 2),
        ),
        boxShadow: const [BoxShadow(offset: Offset(2, 2), color: AppColors.inkBorder, blurRadius: 0)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(task['title'] as String,
          style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            color: pc.withValues(alpha: 0.2),
            child: Text(task['priority'] as String,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 9, fontWeight: FontWeight.w800,
                letterSpacing: 1, color: pc,
              ),
            ),
          ),
          Row(children: [
            const Icon(Icons.calendar_today, size: 10, color: AppColors.textDisabled),
            const SizedBox(width: 4),
            Text(task['date'] as String,
              style: GoogleFonts.jetBrainsMono(fontSize: 9, color: AppColors.textSecondary),
            ),
          ]),
        ]),
      ]),
    );
  }
}
