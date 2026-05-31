import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_router.dart';
import '../../../providers/auth_provider.dart';

import 'tabs/admin_creator_tab.dart';
import 'tabs/admin_manga_tab.dart';
import 'tabs/admin_tag_tab.dart';
import 'tabs/admin_bundle_tab.dart';
import 'tabs/admin_transaction_tab.dart';
import 'tabs/admin_user_tab.dart';
import 'tabs/admin_role_tab.dart';

// ═══════════════════════════════════════════
// COLORS
// ═══════════════════════════════════════════
class AdminColors {
  static const background = Color(0xFF13131B);
  static const surface = Color(0xFF1F1F27);
  static const surfaceHigh = Color(0xFF292932);
  static const sakuraPink = Color(0xFFFF6B9D);
  static const cyberCyan = Color(0xFF00AFBA);
  static const warningYellow = Color(0xFFFFD600);
  static const shonenPurple = Color(0xFF7701D0);
  static const errorRed = Color(0xFFFFB4AB);
  static const errorRedDark = Color(0xFF93000A);
  static const green = Color(0xFF4ADE80);
  static const onSurface = Color(0xFFE4E1ED);
  static const onSurfaceVariant = Color(0xFFDDBFC5);
  static const outlineVariant = Color(0xFF574146);
}

// ═══════════════════════════════════════════
// ADMIN MAIN SCREEN (WITH BOTTOM NAV)
// ═══════════════════════════════════════════
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    _AdminDashboardTab(),
    AdminUserTab(),
    AdminRoleTab(),
    AdminMangaTab(),
    AdminCreatorTab(),
    AdminTagTab(),
    AdminBundleTab(),
    AdminTransactionTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      appBar: const _AdminAppBar(),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // Speed-line background
          const _SpeedLines(),
          // Main content
          _screens[_selectedIndex],
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AdminColors.surface,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AdminColors.background,
              border: Border(bottom: BorderSide(color: AdminColors.sakuraPink, width: 2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.shield, color: Colors.red, size: 40),
                const SizedBox(height: 10),
                Text('MANGAFLOW ADMIN', style: GoogleFonts.bebasNeue(color: AdminColors.sakuraPink, fontSize: 24, letterSpacing: 2)),
              ],
            ),
          ),
          _drawerItem(icon: Icons.dashboard, title: 'Dashboard', index: 0),
          _drawerItem(icon: Icons.group, title: 'Users', index: 1),
          _drawerItem(icon: Icons.badge, title: 'Roles', index: 2),
          const Divider(color: AdminColors.outlineVariant),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text('MANAGEMENT', style: GoogleFonts.spaceGrotesk(fontSize: 12, color: AdminColors.onSurfaceVariant, fontWeight: FontWeight.bold)),
          ),
          _drawerItem(icon: Icons.menu_book, title: 'Manga Series', index: 3),
          _drawerItem(icon: Icons.person, title: 'Creators', index: 4),
          _drawerItem(icon: Icons.local_offer, title: 'Tags', index: 5),
          _drawerItem(icon: Icons.workspace_premium, title: 'Bundles', index: 6),
          _drawerItem(icon: Icons.receipt_long, title: 'Transactions', index: 7),
          const Divider(color: AdminColors.outlineVariant),
          _buildLogoutDrawerItem(),
        ],
      ),
    );
  }

  Widget _buildLogoutDrawerItem() {
    return ListTile(
      leading: const Icon(Icons.logout, color: AdminColors.errorRed),
      title: const Text(
        'Logout',
        style: TextStyle(color: AdminColors.errorRed, fontWeight: FontWeight.bold),
      ),
      onTap: () => _handleLogout(),
    );
  }

  Future<void> _handleLogout() async {
    Navigator.pop(context); // close drawer
    await context.read<AuthProvider>().logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (route) => false);
    }
  }

  Widget _drawerItem({required IconData icon, required String title, required int index}) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? AdminColors.sakuraPink : AdminColors.onSurfaceVariant),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? AdminColors.sakuraPink : AdminColors.onSurface, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      ),
      selected: isSelected,
      selectedTileColor: AdminColors.sakuraPink.withValues(alpha: 0.1),
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context); // Close drawer
      },
    );
  }
}

// ───────────────────────────────────────────
// SPEED LINES BACKGROUND
// ───────────────────────────────────────────
class _SpeedLines extends StatelessWidget {
  const _SpeedLines();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x08FFFFFF), Color(0x00FFFFFF)],
            stops: [0.0, 1.0],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────
// ADMIN TOP APP BAR
// ───────────────────────────────────────────
class _AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AdminAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D15),
        border: Border(
          bottom: BorderSide(color: AdminColors.sakuraPink, width: 2),
        ),
        boxShadow: [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          // Hamburger Icon that opens drawer
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: AdminColors.sakuraPink, size: 28),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          const SizedBox(width: 4),
          // Shield icon + title
          const Icon(Icons.shield, color: Colors.red, size: 24),
          const SizedBox(width: 8),
          Text(
            'MANGAFLOW ADMIN',
            style: GoogleFonts.bebasNeue(
              color: AdminColors.sakuraPink,
              fontSize: 24,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          // Notification bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications, color: Colors.red, size: 24),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AdminColors.sakuraPink,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Center(
                    child: Text(
                      '5',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────
// BOTTOM NAV BAR REMOVED
// ───────────────────────────────────────────

// ═══════════════════════════════════════════
// TAB 1: DASHBOARD
// ═══════════════════════════════════════════
class _AdminDashboardTab extends StatelessWidget {
  const _AdminDashboardTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.1,
              children: const [
                _StatCard(
                  icon: Icons.group,
                  iconColor: AdminColors.sakuraPink,
                  value: '2,841',
                  label: 'TOTAL USERS',
                  badge: '+12 today',
                  borderColor: AdminColors.sakuraPink,
                  shadowColor: AdminColors.sakuraPink,
                ),
                _StatCard(
                  icon: Icons.library_books,
                  iconColor: AdminColors.cyberCyan,
                  value: '1,204',
                  label: 'TOTAL MANGA',
                  badge: '+3 today',
                  borderColor: AdminColors.cyberCyan,
                  shadowColor: AdminColors.cyberCyan,
                ),
                _StatCard(
                  icon: Icons.warning,
                  iconColor: AdminColors.warningYellow,
                  value: '17',
                  label: 'PENDING REVIEW',
                  badge: 'NEED ACTION!',
                  badgeDanger: true,
                  valueColor: AdminColors.errorRed,
                  borderColor: AdminColors.warningYellow,
                  shadowColor: AdminColors.warningYellow,
                ),
                _StatCard(
                  icon: Icons.toll,
                  iconColor: AdminColors.shonenPurple,
                  value: '4.2M',
                  label: 'REVENUE (VND)',
                  badge: '+8% this week',
                  borderColor: AdminColors.shonenPurple,
                  shadowColor: AdminColors.shonenPurple,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Divider: Pending Approval
            _SectionDivider(label: 'PENDING — APPROVAL'),
            const SizedBox(height: 12),
            // Approval Queue
            _ApprovalCard(
              title: 'NEON TOKYO DRIFT',
              author: 'By A. Kurosawa',
              genre: 'ACTION',
              genreColor: AdminColors.cyberCyan,
            ),
            const SizedBox(height: 10),
            _ApprovalCard(
              title: 'STEEL HEARTS',
              author: 'By M. Shinkai',
              genre: 'ROMANCE',
              genreColor: AdminColors.sakuraPink,
            ),
            const SizedBox(height: 16),
            // Divider: User Activity
            _SectionDivider(label: 'USER — ACTIVITY'),
            const SizedBox(height: 12),
            // Activity
            const _ActivityRow(
              initial: 'K',
              avatarColor: AdminColors.cyberCyan,
              borderColor: AdminColors.cyberCyan,
              username: 'Kira99',
              action: 'Registered new account',
              time: '2M AGO',
              actionColor: AdminColors.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            const _ActivityRow(
              initial: 'X',
              avatarColor: AdminColors.errorRed,
              borderColor: AdminColors.errorRed,
              username: 'Xx_Sniper_xX',
              action: 'Reported NSFW content',
              time: '15M AGO',
              actionColor: AdminColors.errorRed,
            ),
            const SizedBox(height: 8),
            const _ActivityRow(
              initial: 'M',
              avatarColor: AdminColors.sakuraPink,
              borderColor: AdminColors.sakuraPink,
              username: 'MangaFan123',
              action: 'Purchased Premium',
              time: '1H AGO',
              actionColor: AdminColors.sakuraPink,
            ),
          ],
        ),
      );
  }
}

// ───────────────────────────────────────────
// STAT CARD
// ───────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String badge;
  final bool badgeDanger;
  final Color? valueColor;
  final Color borderColor;
  final Color shadowColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    required this.badge,
    this.badgeDanger = false,
    this.valueColor,
    required this.borderColor,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: shadowColor, offset: const Offset(4, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 22),
              if (badgeDanger)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: AdminColors.errorRedDark,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.green,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.bebasNeue(
              fontSize: 28,
              color: valueColor ?? AdminColors.onSurface,
              shadows: const [Shadow(color: Colors.black, offset: Offset(2, 2))],
            ),
          ),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AdminColors.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────
// SECTION DIVIDER
// ───────────────────────────────────────────
class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 2, color: AdminColors.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AdminColors.onSurfaceVariant,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(child: Container(height: 2, color: AdminColors.outlineVariant)),
      ],
    );
  }
}

// ───────────────────────────────────────────
// APPROVAL CARD
// ───────────────────────────────────────────
class _ApprovalCard extends StatelessWidget {
  final String title;
  final String author;
  final String genre;
  final Color genreColor;

  const _ApprovalCard({
    required this.title,
    required this.author,
    required this.genre,
    required this.genreColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border.all(color: Colors.white54, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(color: AdminColors.sakuraPink, offset: Offset(3, 3)),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          Container(
            width: 55,
            height: 75,
            decoration: BoxDecoration(
              color: AdminColors.surfaceHigh,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: const Icon(Icons.image, color: Colors.white24, size: 28),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.bebasNeue(
                    fontSize: 20,
                    color: AdminColors.onSurface,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 11,
                    color: AdminColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                // Genre chip
                Transform(
                  transform: Matrix4.skewX(-0.17),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: genreColor,
                      border: Border.all(color: Colors.black),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(2, 2)),
                      ],
                    ),
                    child: Text(
                      genre,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Column(
            children: [
              _ActionButton(
                icon: Icons.check,
                color: AdminColors.green,
                onTap: () {},
              ),
              const SizedBox(height: 6),
              _ActionButton(
                icon: Icons.close,
                color: AdminColors.errorRed,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(2),
          boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
        ),
        child: Icon(icon, color: Colors.black, size: 20),
      ),
    );
  }
}

// ───────────────────────────────────────────
// ACTIVITY ROW
// ───────────────────────────────────────────
class _ActivityRow extends StatelessWidget {
  final String initial;
  final Color avatarColor;
  final Color borderColor;
  final String username;
  final String action;
  final String time;
  final Color actionColor;

  const _ActivityRow({
    required this.initial,
    required this.avatarColor,
    required this.borderColor,
    required this.username,
    required this.action,
    required this.time,
    required this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
          top: BorderSide(color: Colors.black, width: 1),
          right: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: avatarColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.bebasNeue(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Text info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AdminColors.onSurface,
                  ),
                ),
                Text(
                  action,
                  style: TextStyle(
                    fontSize: 11,
                    color: actionColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Time
          Text(
            time,
            style: const TextStyle(
              fontSize: 10,
              color: AdminColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
