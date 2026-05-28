import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
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
          children: [
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildPremiumButton(),
            const SizedBox(height: 32),
            _buildAttributesSection(),
            const SizedBox(height: 32),
            _buildCompletedArcsSection(),
            const SizedBox(height: 32),
            _buildMenuSection(),
            const SizedBox(height: 32),
            _buildLogoutButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                // Avatar Box
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/hero_artist.png'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.grey, BlendMode.saturation),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'SAKURA_PEN',
                  style: TextStyle(
                    fontFamily: 'sans-serif',
                    color: AppColors.primaryContainer,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '"Drawing the lines between dreams\nand reality."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTag('#Shounen'),
                    const SizedBox(width: 8),
                    _buildTag('#Action'),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  color: Colors.cyanAccent,
                  child: const Text(
                    'PRO CREATOR',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryContainer,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit, color: AppColors.primaryContainer, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'EDIT PROFILE',
                          style: TextStyle(
                            fontFamily: 'sans-serif',
                            color: AppColors.primaryContainer,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Level badge
          Positioned(
            top: 24,
            right: 60,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Colors.white,
              child: const Text(
                'LVL. 99',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          // Ink Master badge
          Positioned(
            top: 156,
            right: 50,
            child: Transform.rotate(
              angle: -0.05,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                color: AppColors.primaryContainer,
                child: const Text(
                  'INK MASTER',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
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

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF13131B),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAttributesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ATTRIBUTES',
            style: TextStyle(
              fontFamily: 'sans-serif',
              color: Colors.cyanAccent,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: Colors.cyanAccent,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildAttributeBar('SPEED LINES', 85, AppColors.primaryContainer),
          const SizedBox(height: 16),
          _buildAttributeBar('INKING PRECISION', 90, Colors.cyanAccent),
          const SizedBox(height: 16),
          _buildAttributeBar('PLOT ARMOR', 40, Colors.yellow),
        ],
      ),
    );
  }

  Widget _buildAttributeBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            Text(
              '$value/100',
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value / 100,
            child: Container(color: color),
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedArcsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'COMPLETED ARCS',
            style: TextStyle(
              fontFamily: 'sans-serif',
              color: AppColors.primaryContainer,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: AppColors.primaryContainer,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildArcCard(
                  id: '01',
                  icon: Icons.local_fire_department,
                  iconColor: AppColors.primaryContainer,
                  title: 'FIRST\nBLOOD',
                  subtitle: 'Published\nChaps',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildArcCard(
                  id: '02',
                  icon: Icons.star,
                  iconColor: Colors.yellow,
                  title: 'RISING\nSTAR',
                  subtitle: '10k Readers',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildArcCard(
                  id: '??',
                  icon: Icons.lock_outline,
                  iconColor: Colors.grey,
                  title: 'GOD TIER',
                  subtitle: 'Secret Arc',
                  isLocked: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Container()), // Empty placeholder
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArcCard({
    required String id,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool isLocked = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF13131B),
            border: Border.all(color: isLocked ? Colors.grey.shade800 : Colors.white),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'sans-serif',
                  color: isLocked ? Colors.grey.shade600 : AppColors.primaryContainer,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isLocked ? Colors.grey.shade800 : Colors.grey,
                  fontSize: 9,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: Container(
            padding: const EdgeInsets.all(4),
            color: Colors.cyanAccent,
            child: Text(
              id,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.history, 'LỊCH SỬ ĐỌC', () {
            Navigator.pushNamed(context, AppRouter.readingHistory);
          }),
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          _buildMenuItem(Icons.favorite_border, 'TRUYỆN YÊU THÍCH', () {
            Navigator.pushNamed(context, AppRouter.favorites);
          }),
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          _buildMenuItem(Icons.settings_outlined, 'CÀI ĐẶT', () {
            Navigator.pushNamed(context, AppRouter.settings);
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

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.redAccent, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.redAccent,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: () {
          // Log out and return to Login screen
          Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
        },
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.redAccent, size: 20),
            SizedBox(width: 8),
            Text(
              'LOGOUT',
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

  Widget _buildPremiumButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.gold,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.subscription);
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
}
