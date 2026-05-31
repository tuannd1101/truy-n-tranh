import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';

/// Password recovery flow.
///
/// Step 1 (request): user submits their email and the backend sends a reset
/// token to that address.
/// Step 2 (reset): user pastes the token they received and chooses a new
/// password.
///
/// Both steps hit the existing backend endpoints
/// (`POST /auth/forgot-password`, `POST /auth/reset-password`).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

enum _Step { request, reset }

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();

  _Step _step = _Step.request;
  bool _isLoading = false;
  bool _obscurePassword = true;

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
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'QUÊN MẬT KHẨU',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 32),
              if (_step == _Step.request)
                ..._buildRequestStep()
              else
                ..._buildResetStep(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        _stepDot(1, 'NHẬP EMAIL', _step == _Step.request),
        Expanded(
          child: Container(
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: _step == _Step.reset
                ? AppColors.primaryContainer
                : Colors.white24,
          ),
        ),
        _stepDot(2, 'ĐẶT LẠI', _step == _Step.reset),
      ],
    );
  }

  Widget _stepDot(int number, String label, bool active) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primaryContainer
                : AppColors.surfaceContainerHigh,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Text(
            '$number',
            style: TextStyle(
              color: active ? Colors.white : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: active ? AppColors.onSurface : AppColors.onSurfaceVariant,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRequestStep() {
    return [
      const Text(
        'Nhập email tài khoản của bạn. Chúng tôi sẽ gửi mã đặt lại mật khẩu tới email đó.',
        style: TextStyle(
          color: AppColors.onSurfaceVariant,
          fontSize: 14,
          height: 1.4,
        ),
      ),
      const SizedBox(height: 24),
      _buildField(
        label: 'EMAIL',
        controller: _emailController,
        hint: 'otaku@mangaflow.com',
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 32),
      _buildPrimaryButton(
        label: 'GỬI MÃ ĐẶT LẠI',
        icon: Icons.send,
        onTap: _handleRequest,
      ),
    ];
  }

  List<Widget> _buildResetStep() {
    return [
      const Text(
        'Nhập mã đặt lại bạn nhận được qua email và mật khẩu mới.',
        style: TextStyle(
          color: AppColors.onSurfaceVariant,
          fontSize: 14,
          height: 1.4,
        ),
      ),
      const SizedBox(height: 24),
      _buildField(
        label: 'MÃ ĐẶT LẠI',
        controller: _tokenController,
        hint: 'Dán mã từ email',
      ),
      const SizedBox(height: 28),
      _buildField(
        label: 'MẬT KHẨU MỚI',
        controller: _newPasswordController,
        hint: '••••••••',
        obscureText: _obscurePassword,
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _obscurePassword = !_obscurePassword),
          child: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
        ),
      ),
      const SizedBox(height: 32),
      _buildPrimaryButton(
        label: 'ĐẶT LẠI MẬT KHẨU',
        icon: Icons.lock_reset,
        onTap: _handleReset,
      ),
      const SizedBox(height: 16),
      Center(
        child: TextButton(
          onPressed: _isLoading
              ? null
              : () => setState(() => _step = _Step.request),
          child: const Text(
            'Gửi lại mã',
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -12,
          left: 8,
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
        Container(
          padding: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(color: AppColors.onSurface, fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Stack(
        children: [
          Positioned(
            top: 4,
            left: 4,
            right: -4,
            bottom: -4,
            child: Container(color: AppColors.tertiaryContainer),
          ),
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
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRequest() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showSnack('Vui lòng nhập email hợp lệ', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final message = await context.read<AuthProvider>().forgotPassword(email);
      if (!mounted) return;
      _showSnack(message);
      setState(() => _step = _Step.reset);
    } catch (e) {
      if (mounted)
        _showSnack(
          e.toString().replaceFirst('ApiException: ', ''),
          isError: true,
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleReset() async {
    final token = _tokenController.text.trim();
    final newPassword = _newPasswordController.text;
    if (token.isEmpty) {
      _showSnack('Vui lòng nhập mã đặt lại', isError: true);
      return;
    }
    if (newPassword.length < 6) {
      _showSnack('Mật khẩu phải có ít nhất 6 ký tự', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final message = await context.read<AuthProvider>().resetPassword(
        token,
        newPassword,
      );
      if (!mounted) return;
      _showSnack(message);
      Navigator.pop(context);
    } catch (e) {
      if (mounted)
        _showSnack(
          e.toString().replaceFirst('ApiException: ', ''),
          isError: true,
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
