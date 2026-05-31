import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/user.dart';
import '../../../providers/auth_provider.dart';
import '../../widgets/main_drawer.dart';
import '../../widgets/main_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    // Refresh profile from /api/v1/auth/me
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MainAppBar(),
      drawer: const MainDrawer(),
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.status == AuthStatus.loading && auth.currentUser == null) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryContainer));
          }

          final user = auth.currentUser;
          if (user == null) {
            return _buildNotLoggedIn(context);
          }

          return RefreshIndicator(
            color: AppColors.primaryContainer,
            backgroundColor: AppColors.surfaceContainer,
            onRefresh: () => auth.fetchCurrentUser(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  _buildProfileCard(user),
                  const SizedBox(height: 24),
                  _buildPremiumStatus(user),
                  const SizedBox(height: 24),
                  _buildMenuSection(),
                  const SizedBox(height: 32),
                  _buildLogoutButton(context, auth),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_off, size: 64, color: AppColors.outline),
          const SizedBox(height: 16),
          const Text('Bạn chưa đăng nhập',
              style: TextStyle(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, AppRouter.login, (r) => false),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.primaryContainer),
            child: const Text('ĐĂNG NHẬP'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(User user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Avatar Box
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryContainer, width: 3),
              ),
              child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(user.avatarUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _avatarFallback(user)),
                    )
                  : _avatarFallback(user),
            ),
            const SizedBox(height: 24),
            Text(
              user.name.isEmpty ? 'NGƯỜI DÙNG' : user.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.primaryContainer,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              user.email,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            // Role badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: user.roleBadgeColor,
              child: Text(
                user.roleBadgeText.toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback(User user) {
    final initial =
        user.name.trim().isNotEmpty ? user.name.trim()[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: const TextStyle(
          color: AppColors.primaryContainer,
          fontSize: 48,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildPremiumStatus(User user) {
    final expiry = user.premiumExpiryDate;
    final isActivePremium = user.isPremium && expiry != null && expiry.isAfter(DateTime.now());

    if (isActivePremium) {
      final remaining = expiry.difference(DateTime.now());
      final days = remaining.inDays;
      final hours = remaining.inHours % 24;
      final remainingText = days > 0
          ? 'Còn lại $days ngày $hours giờ'
          : 'Còn lại $hours giờ';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B23),
          border: Border.all(color: AppColors.gold, width: 2),
          boxShadow: const [BoxShadow(color: AppColors.gold, offset: Offset(4, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.workspace_premium, color: AppColors.gold, size: 24),
                SizedBox(width: 8),
                Text(
                  'PREMIUM ĐANG HOẠT ĐỘNG',
                  style: TextStyle(
                    fontFamily: 'Anton',
                    color: AppColors.gold,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.timer, color: AppColors.onSurfaceVariant, size: 16),
                const SizedBox(width: 8),
                Text(
                  remainingText,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Hết hạn: ${_formatDate(expiry)}',
              style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      );
    }

    // Non-premium → upgrade CTA
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: const [BoxShadow(color: AppColors.gold, offset: Offset(4, 4))],
      ),
      child: MaterialButton(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRouter.subscription);
          if (mounted) context.read<AuthProvider>().fetchCurrentUser();
        },
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.workspace_premium, color: AppColors.gold, size: 24),
            SizedBox(width: 8),
            Text(
              'NÂNG CẤP PREMIUM',
              style: TextStyle(
                fontFamily: 'Anton',
                color: AppColors.gold,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.history, 'LỊCH SỬ ĐỌC', () {
            Navigator.pushNamed(context, AppRouter.readingHistory);
          }),
          Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
          _buildMenuItem(Icons.favorite_border, 'TRUYỆN YÊU THÍCH', () {
            Navigator.pushNamed(context, AppRouter.favorites);
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Icon(icon, color: AppColors.onSurface, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider auth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.redAccent, width: 2),
        boxShadow: const [BoxShadow(color: Colors.redAccent, offset: Offset(4, 4))],
      ),
      child: MaterialButton(
        onPressed: () async {
          await auth.logout();
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRouter.login, (route) => false);
          }
        },
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 20),
            SizedBox(width: 8),
            Text(
              'ĐĂNG XUẤT',
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }
}
