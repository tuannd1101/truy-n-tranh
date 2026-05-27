import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            _buildGreetingCard(),
            const SizedBox(height: 32),
            _buildStatsBubbles(),
            const SizedBox(height: 40),
            _buildSectionTitle('RECENT PROJECTS'),
            const SizedBox(height: 20),
            _buildRecentProjects(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF13131B),
          border: Border(
            bottom: BorderSide(color: AppColors.primaryContainer, width: 2),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Center(
                        child: Text(
                          'M',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'MANGAFLOW',
                      style: TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRouter.profile),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primaryContainer, width: 2),
                    ),
                    child: const Icon(
                      Icons.face,
                      color: AppColors.primaryContainer,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1B23),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'こんにちは.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    'ARTIST-SAN!',
                    style: TextStyle(
                      fontFamily: 'sans-serif',
                      color: AppColors.primaryContainer,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.sports_score, color: Colors.white, size: 24),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Ready to ink the next chapter?',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Pink tag #01
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            color: AppColors.primaryContainer,
            child: const Text(
              '#01',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ),
        // Yellow action circle
        Positioned(
          bottom: -20,
          right: 20,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Center(
              child: Icon(Icons.brush, color: Colors.black, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBubbles() {
    return Column(
      children: [
        _buildSpeechBubble(
          text: '12\nMANGA',
          borderColor: Colors.white,
          width: 250,
          align: Alignment.centerLeft,
        ),
        const SizedBox(height: 16),
        _buildSpeechBubble(
          text: '458\nCHAPTERS',
          borderColor: Colors.cyanAccent,
          width: 260,
          align: Alignment.centerLeft,
          tailLeft: false, // tail on left but slightly different in design? Both on left.
        ),
        const SizedBox(height: 16),
        _buildSpeechBubble(
          text: '8\nPUBLISHED',
          borderColor: Colors.yellow,
          width: 270,
          align: Alignment.centerLeft,
        ),
      ],
    );
  }

  Widget _buildSpeechBubble({
    required String text,
    required Color borderColor,
    required double width,
    required Alignment align,
    bool tailLeft = true,
  }) {
    return Align(
      alignment: align,
      child: Transform.rotate(
        angle: -0.02,
        child: SizedBox(
          width: width,
          child: CustomPaint(
            painter: _SpeechBubblePainter(color: borderColor, isLeftTail: tailLeft),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'sans-serif',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade800, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                title.split(' ')[0],
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                title.split(' ')[1],
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade800, thickness: 1)),
      ],
    );
  }

  Widget _buildRecentProjects() {
    return SizedBox(
      height: 280,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _buildProjectCard(
            title: 'SHADOW HUNTER',
            subtitle: 'Chapter 34: The Final Slash in the Cyber City.',
            tag: 'VOL. 2',
            tags: ['ACTION', 'SCI-FI'],
            borderColor: AppColors.primaryContainer,
          ),
          const SizedBox(width: 16),
          _buildProjectCard(
            title: 'SILENT ECHO',
            subtitle: 'Chapter 12: Echoes of the past.',
            tag: 'VOL. 1',
            tags: ['MYSTERY'],
            borderColor: Colors.cyanAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard({
    required String title,
    required String subtitle,
    required String tag,
    required List<String> tags,
    required Color borderColor,
  }) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: borderColor,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder with crosshatch pattern look
              Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    image: AssetImage('assets/images/hero_artist.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  ),
                ),
              ),
              const Divider(color: Colors.white, height: 2, thickness: 2),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'sans-serif',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: tags.map((t) => Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Text(
                              t,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Pink Vol tag
          Positioned(
            top: 125,
            right: 12,
            child: Transform.rotate(
              angle: -0.1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: AppColors.primaryContainer,
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF13131B),
        border: Border(top: BorderSide(color: Colors.cyanAccent, width: 2)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, 'HOME', 0, _selectedIndex == 0),
              _buildNavItem(Icons.menu_book, 'READ', 1, _selectedIndex == 1),
              _buildNavItem(Icons.create, 'CREATE', 2, _selectedIndex == 2),
              _buildNavItem(Icons.my_library_books, 'LIBRARY', 3, _selectedIndex == 3),
              _buildNavItem(Icons.person, 'PROFILE', 4, _selectedIndex == 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        if (index == 1) {
          Navigator.pushReplacementNamed(context, AppRouter.reading);
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, AppRouter.create);
        } else if (index == 3) {
          Navigator.pushReplacementNamed(context, AppRouter.library);
        } else if (index == 4) {
          Navigator.pushReplacementNamed(context, AppRouter.profile);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.black : Colors.grey,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: isActive ? Colors.black : Colors.grey,
                fontSize: 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// CUSTOM PAINTER FOR SPEECH BUBBLES
// ──────────────────────────────────────────────────────────

class _SpeechBubblePainter extends CustomPainter {
  final Color color;
  final bool isLeftTail;

  _SpeechBubblePainter({required this.color, this.isLeftTail = true});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..color = const Color(0xFF1B1B23)
      ..style = PaintingStyle.fill;

    final path = Path();
    final tailSize = 15.0;

    // Draw main rectangle
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - tailSize);
    
    if (isLeftTail) {
      path.lineTo(size.width * 0.3, size.height - tailSize);
      path.lineTo(size.width * 0.2, size.height); // tail tip
      path.lineTo(size.width * 0.25, size.height - tailSize);
    } else {
      path.lineTo(size.width * 0.8, size.height - tailSize);
      path.lineTo(size.width * 0.9, size.height); // tail tip
      path.lineTo(size.width * 0.85, size.height - tailSize);
    }
    
    path.lineTo(0, size.height - tailSize);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SpeechBubblePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isLeftTail != isLeftTail;
  }
}
