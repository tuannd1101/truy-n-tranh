import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _mascotController;
  late Animation<double> _mascotAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _mascotAnimation = Tween<double>(begin: 0, end: -12).animate(
      CurvedAnimation(parent: _mascotController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _mascotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background speed-lines
          Positioned.fill(child: CustomPaint(painter: _SpeedLinesPainter())),
          // Watermark kanji
          _buildKanjiWatermarks(),
          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Hero Panel (manga artist + logo overlay) ──
                  _buildHeroPanel(),
                  const SizedBox(height: 24),
                  // ── Login Card ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildLoginCard(),
                  ),
                  const SizedBox(height: 16),
                  // ── Create account link ──
                  _buildCreateAccountLink(),
                  const SizedBox(height: 100), // space for mascot
                ],
              ),
            ),
          ),
          // ── Mascot fixed bottom-right ──
          _buildMascot(),
        ],
      ),
    );
  }

  // ────────────────────────────────────────────────
  // HERO PANEL: manga clip + cover art + logo overlay
  // ────────────────────────────────────────────────
  Widget _buildHeroPanel() {
    return ClipPath(
      clipper: _MangaPanelClipper(),
      child: Container(
        width: double.infinity,
        height: 260,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFFFE16D), // yellow shadow like Stitch
              offset: Offset(8, 8),
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover art background (grayscale manga artist)
            ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0,      0,      0,      1, 0,
              ]),
              child: Image.asset(
                'assets/images/hero_artist.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceContainerHigh,
                  child: const Icon(Icons.image, color: AppColors.onSurfaceVariant, size: 64),
                ),
              ),
            ),
            // Gradient overlay bottom-to-top
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background.withOpacity(0.85),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Speed-lines overlay on the right
            Positioned.fill(
              child: CustomPaint(painter: _SpeedLinesPainter(opacity: 0.08)),
            ),
            // Center content: logo + title
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo image
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryContainer.withOpacity(0.9),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 96,
                      height: 96,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.auto_stories,
                        size: 80,
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // "MANGAFLOW" large bold title — rotated slightly
                  Transform.rotate(
                    angle: -0.05,
                    child: Text(
                      'MANGAFLOW',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryContainer,
                        letterSpacing: 2,
                        shadows: const [
                          Shadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
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

  // ────────────────────────────────────────────────
  // WATERMARK KANJI
  // ────────────────────────────────────────────────
  Widget _buildKanjiWatermarks() {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -40,
          child: Transform.rotate(
            angle: -0.21,
            child: const Opacity(
              opacity: 0.03,
              child: Text(
                '漫画',
                style: TextStyle(
                  fontSize: 160,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          right: -40,
          child: Transform.rotate(
            angle: 0.21,
            child: const Opacity(
              opacity: 0.03,
              child: Text(
                '創作',
                style: TextStyle(
                  fontSize: 160,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────
  // LOGIN CARD — manga clip polygon style
  // ────────────────────────────────────────────────
  Widget _buildLoginCard() {
    return Transform.rotate(
      angle: 0.017, // ~1 degree tilt
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card body
          ClipPath(
            clipper: _MangaCardClipper(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                border: Border.all(color: Colors.black, width: 4),
              ),
              child: Stack(
                children: [
                  // Halftone overlay
                  Positioned.fill(
                    child: CustomPaint(painter: _HalftonePainter()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Center(
                          child: Text(
                            'ENTER THE FLOW',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.onSurface,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(height: 4, color: Colors.black),
                        const SizedBox(height: 28),
                        // Email
                        _buildMangaField(
                          label: 'Email',
                          hint: 'otaku@mangaflow.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          rotateLabel: -0.035,
                        ),
                        const SizedBox(height: 32),
                        // Password
                        _buildMangaField(
                          label: 'Password',
                          hint: '••••••••',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          rotateLabel: 0.02,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Sign In Button
                        _buildSignInButton(),
                        const SizedBox(height: 16),
                        // Forgot password
                        Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.onSurfaceVariant,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Pink shadow (manual offset box behind)
          Positioned(
            top: 8,
            left: 8,
            right: -8,
            bottom: -8,
            child: ClipPath(
              clipper: _MangaCardClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primaryContainer,
                ),
              ),
            ),
          ),
          // Re-draw card on top
          ClipPath(
            clipper: _MangaCardClipper(),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                border: Border.all(color: Colors.black, width: 4),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: _HalftonePainter()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'ENTER THE FLOW',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.onSurface,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(height: 4, color: Colors.black),
                        const SizedBox(height: 28),
                        _buildMangaField(
                          label: 'Email',
                          hint: 'otaku@mangaflow.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          rotateLabel: -0.035,
                        ),
                        const SizedBox(height: 32),
                        _buildMangaField(
                          label: 'Password',
                          hint: '••••••••',
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          rotateLabel: 0.02,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildSignInButton(),
                        const SizedBox(height: 16),
                        Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.onSurfaceVariant,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // VOL. 1 tag
          Positioned(
            top: -14,
            right: -10,
            child: Transform.rotate(
              angle: -0.21,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Text(
                  'VOL. 1',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMangaField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    double rotateLabel = 0,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -12,
          left: 8,
          child: Transform.rotate(
            angle: rotateLabel,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(color: AppColors.onSurface, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16),
              filled: false,
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 3),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.tertiaryContainer, width: 3),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: suffixIcon,
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleSignIn,
      child: Stack(
        children: [
          // Cyan shadow offset
          Positioned(
            top: 4,
            left: 4,
            right: -4,
            bottom: -4,
            child: Container(
              color: AppColors.tertiaryContainer,
            ),
          ),
          // Actual button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              border: Border.all(color: Colors.black, width: 4),
            ),
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'SIGN IN',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateAccountLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'New creator? ',
          style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRouter.register),
          child: const Text(
            'Start your journey',
            style: TextStyle(
              color: AppColors.tertiaryContainer,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.tertiaryContainer,
              decorationThickness: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMascot() {
    return Positioned(
      bottom: -4,
      right: -4,
      child: AnimatedBuilder(
        animation: _mascotAnimation,
        builder: (context, child) => Transform.translate(
          offset: Offset(0, _mascotAnimation.value),
          child: child,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Manga Buddy mascot
            Image.asset(
              'assets/images/mascot.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.smart_toy,
                size: 80,
                color: AppColors.primaryContainer,
              ),
            ),
            // Speech bubble "Okaeri!"
            Positioned(
              top: -44,
              left: -88,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.primaryContainer,
                          offset: Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Okaeri!',
                      style: TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // Tail
                  Positioned(
                    bottom: -10,
                    right: 20,
                    child: CustomPaint(painter: _BubbleTailPainter()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
      );
      return;
    }
    setState(() => _isLoading = true);
    
    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        if (authProvider.isAdminOrManager) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRouter.adminDashboard, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRouter.home, (route) => false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        final errorMessage = context.read<AuthProvider>().errorMessage ?? e.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// ──────────────────────────────────────────────────────────
// CUSTOM CLIPPERS & PAINTERS
// ──────────────────────────────────────────────────────────

/// manga-clip: polygon(0 0, 100% 5%, 95% 100%, 5% 95%)
class _MangaPanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height * 0.05);
    path.lineTo(size.width * 0.95, size.height);
    path.lineTo(size.width * 0.05, size.height * 0.95);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Same clip for the card
class _MangaCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height * 0.03);
    path.lineTo(size.width * 0.97, size.height);
    path.lineTo(size.width * 0.03, size.height * 0.97);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _SpeedLinesPainter extends CustomPainter {
  final double opacity;
  _SpeedLinesPainter({this.opacity = 0.04});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryContainer.withOpacity(opacity)
      ..strokeWidth = 1;
    const count = 30;
    final cx = size.width * 0.8;
    final cy = size.height * 0.5;
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 3.14159 * 2;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(
          cx + size.width * 2 * _cos(angle),
          cy + size.height * 2 * _sin(angle),
        ),
        paint,
      );
    }
  }

  double _cos(double a) => (a < 1.57) ? 1 - a * 0.6 : (a < 3.14) ? -0.4 + (a - 1.57) * 0.3 : -0.6;
  double _sin(double a) => _cos(a - 1.5708);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HalftonePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.04);
    const spacing = 8.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(10, 0)
      ..lineTo(5, 10)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
