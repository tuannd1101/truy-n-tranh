import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/main_app_bar.dart';

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MainAppBar(),
      drawer: const MainDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildSectionHeader('IDEAS', 'アイデア', '2'),
            const SizedBox(height: 16),
            _buildTaskCard(
              title: 'Character Design: Rival',
              description:
                  'Initial concepts for the main rival\'s final form armor.',
              tags: ['LOW', 'SKETCH'],
              tagColors: [Colors.grey, Colors.grey.shade300],
            ),
            const SizedBox(height: 16),
            _buildTaskCard(
              title: 'Pacing for Chapter 45',
              description:
                  'Review the transition between the flashback and the current battle.',
              tags: ['MID', 'STORY'],
              tagColors: [Colors.yellow, Colors.blueAccent],
              isMid: true,
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('DRAFTING', '下書き', '2'),
            const SizedBox(height: 16),
            _buildDraftingCard(),
            const SizedBox(height: 16),
            _buildUltraTaskCard(),
            const SizedBox(height: 32),
            _buildSectionHeader('FINISHED', '完了', '1'),
            const SizedBox(height: 16),
            _buildEmptyState(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: const BoxDecoration(color: AppColors.primaryContainer),
          child: const Text(
            '進行中 - IN PROGRESS',
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'SAGA BOARD',
              style: TextStyle(
                fontFamily: 'sans-serif',
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.cyanAccent,
                letterSpacing: 1,
                shadows: [Shadow(color: Colors.cyanAccent, blurRadius: 10)],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                color: const Color(0xFF1B1B23),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add_circle, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'NEW ARC',
                    style: TextStyle(
                      fontFamily: 'sans-serif',
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(color: Colors.grey, thickness: 1),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String jpSubtitle, String count) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'sans-serif',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          jpSubtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: Colors.grey.shade800),
          child: Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String description,
    required List<String> tags,
    required List<Color> tagColors,
    bool isMid = false,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(
          color: isMid ? Colors.yellow : Colors.white,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(painter: _DiagonalStripesPainter()),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(tags.length, (index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: tagColors[index],
                      child: Text(
                        tags[index],
                        style: TextStyle(
                          color: index == 0 && tagColors[index] != Colors.grey
                              ? Colors.black
                              : (tagColors[index] == Colors.grey.shade300
                                    ? Colors.black
                                    : Colors.white),
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.grey,
                      size: 16,
                    ),
                    Spacer(),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 12, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftingCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: AppColors.primaryContainer, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.primaryContainer, offset: Offset(-4, 4)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: AppColors.primaryContainer,
                      child: const Text(
                        'HIGH',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      color: Colors.blueAccent,
                      child: const Text(
                        'INKING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Double Page Spread',
                  style: TextStyle(
                    fontFamily: 'sans-serif',
                    color: AppColors.primaryContainer,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Complete the ink work for the main clash sequence. Needs dynamic speed lines.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progress',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '60%',
                      style: TextStyle(
                        color: AppColors.primaryContainer,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.grey.shade800,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryContainer,
                  ),
                  minHeight: 4,
                ),
              ],
            ),
          ),
          Positioned(
            top: -10,
            right: 10,
            child: Transform.rotate(
              angle: 0.1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.white,
                child: const Text(
                  '#45',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltraTaskCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.orangeAccent, width: 2),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Submit to Publisher',
                  style: TextStyle(
                    fontFamily: 'sans-serif',
                    color: Colors.orangeAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Deadline is tonight! Finish the tones and export PDF.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      'EXECUTE ACTION',
                      style: TextStyle(
                        fontFamily: 'sans-serif',
                        color: Colors.orangeAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ULTRA Tag
          Positioned(
            top: -12,
            left: 10,
            child: Transform.rotate(
              angle: -0.1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                color: Colors.orangeAccent,
                child: const Row(
                  children: [
                    Icon(Icons.flash_on, color: Colors.black, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'ULTRA',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: const Color(0xFF13131B),
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox, size: 48, color: Colors.grey.shade800),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade800),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Nothing here yet!',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..strokeWidth = 2;

    for (double i = -size.height; i < size.width; i += 10) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
