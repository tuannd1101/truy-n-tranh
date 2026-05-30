import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings_vi.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  // Title
                  Transform.rotate(
                    angle: -0.05,
                    child: Text(
                      AppStringsVi.joinTheSquad,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: AppColors.secondaryContainer,
                            offset: Offset(0, 0),
                            blurRadius: 15,
                          ),
                          Shadow(
                            color: AppColors.secondaryContainer,
                            offset: Offset(0, 0),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Register Card
                  _buildRegisterCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterCard() {
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
                  Positioned.fill(
                    child: CustomPaint(painter: _HalftonePainter()),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 40, 28, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMangaField(
                          label: AppStringsVi.usernameLabel,
                          hint: AppStringsVi.usernameHint,
                          controller: _usernameController,
                        ),
                        const SizedBox(height: 24),
                        _buildMangaField(
                          label: AppStringsVi.emailLabel,
                          hint: AppStringsVi.emailHint,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 24),
                        _buildMangaField(
                          label: AppStringsVi.passwordLabel,
                          hint: AppStringsVi.passwordHint,
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        _buildMangaField(
                          label: AppStringsVi.confirmPasswordLabel,
                          hint: AppStringsVi.passwordHint,
                          controller: _confirmPasswordController,
                          obscureText: true,
                        ),
                        const SizedBox(height: 40),
                        _buildStartCreatingButton(),
                        const SizedBox(height: 32),
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              AppStringsVi.alreadyMemberSignIn,
                              style: const TextStyle(
                                fontFamily: 'sans-serif',
                                color: AppColors.secondaryContainer,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.secondaryContainer,
                                decorationThickness: 2,
                                letterSpacing: 1,
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
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Solid dark background for input
        Container(
          margin: const EdgeInsets.only(top: 8),
          color: const Color(0xFF1B1B23), // Darker surface for input
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
        // Overlapping label
        Positioned(
          top: 0,
          left: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            color: Colors.white,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'sans-serif',
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartCreatingButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _handleRegister,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Cyan offset shadow
          Positioned(
            top: 6,
            left: 6,
            right: -6,
            bottom: -6,
            child: Container(
              color: AppColors.secondaryContainer,
            ),
          ),
          // Actual button body
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
            ),
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      AppStringsVi.startCreating,
                      style: const TextStyle(
                        fontFamily: 'sans-serif',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStringsVi.fillAllFieldsMessage)),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStringsVi.validationPasswordMatch)),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await context.read<AuthProvider>().register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStringsVi.registerSuccessMessage),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to login
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
// CUSTOM CLIPPERS & PAINTERS (Reused from Login)
// ──────────────────────────────────────────────────────────

class _MangaCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height * 0.02);
    path.lineTo(size.width * 0.98, size.height);
    path.lineTo(size.width * 0.02, size.height * 0.98);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _SpeedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryContainer.withOpacity(0.04)
      ..strokeWidth = 1;
    const count = 30;
    final cx = size.width * 0.5;
    final cy = size.height; // Radiate from bottom center
    for (int i = 0; i < count; i++) {
      final angle = (i / count) * 3.14159 * 2;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(
          cx + size.width * 2 * _cos(angle),
          cy - size.height * 2 * _sin(angle),
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
