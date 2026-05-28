import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_router.dart';
import '../../../providers/auth_provider.dart';

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
    _AdminUsersTab(),
    _AdminContentTab(),
    _AdminSettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.background,
      body: Stack(
        children: [
          // Speed-line background
          const _SpeedLines(),
          // Main content
          _screens[_selectedIndex],
        ],
      ),
      bottomNavigationBar: _AdminBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Shield icon + title
          const Icon(Icons.shield, color: Colors.red, size: 28),
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
// BOTTOM NAV BAR
// ───────────────────────────────────────────
class _AdminBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _AdminBottomNav({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      {'icon': Icons.dashboard, 'label': 'DASHBOARD'},
      {'icon': Icons.group, 'label': 'USERS'},
      {'icon': Icons.library_books, 'label': 'CONTENT'},
      {'icon': Icons.settings, 'label': 'SETTINGS'},
    ];

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF1F1F27),
        border: Border(top: BorderSide(color: AdminColors.cyberCyan, width: 2)),
        boxShadow: [BoxShadow(color: Colors.black, offset: Offset(0, -4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabs.length, (i) {
          final isActive = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: isActive
                  ? BoxDecoration(
                      color: AdminColors.sakuraPink,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(2, 2)),
                      ],
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tabs[i]['icon'] as IconData,
                    color: isActive ? Colors.black : AdminColors.onSurfaceVariant,
                    size: 24,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tabs[i]['label'] as String,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.black : AdminColors.onSurfaceVariant.withOpacity(0.7),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// TAB 1: DASHBOARD
// ═══════════════════════════════════════════
class _AdminDashboardTab extends StatelessWidget {
  const _AdminDashboardTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _AdminAppBar(),
      body: SingleChildScrollView(
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

// ═══════════════════════════════════════════
// TAB 2: USERS (Placeholder)
// ═══════════════════════════════════════════
class _AdminUsersTab extends StatelessWidget {
  const _AdminUsersTab();

  final _users = const [
    {'initial': 'K', 'name': 'KiraArtist', 'email': 'kira@mail.com', 'role': 'PREMIUM'},
    {'initial': 'R', 'name': 'RyuReader', 'email': 'ryu@mail.com', 'role': 'FREE'},
    {'initial': 'N', 'name': 'NakamuraEd', 'email': 'naka@mail.com', 'role': 'MANAGER'},
    {'initial': 'A', 'name': 'AdminSan', 'email': 'admin@mangaflow.com', 'role': 'ADMIN'},
    {'initial': 'S', 'name': 'SakuraDraw', 'email': 'sakura@mail.com', 'role': 'PREMIUM'},
    {'initial': 'X', 'name': 'Xx_Sniper', 'email': 'sniper@mail.com', 'role': 'BANNED'},
    {'initial': 'M', 'name': 'MangaFan', 'email': 'fan@mail.com', 'role': 'FREE'},
  ];

  Color _roleColor(String role) {
    switch (role) {
      case 'PREMIUM': return AdminColors.sakuraPink;
      case 'FREE': return AdminColors.cyberCyan;
      case 'MANAGER': return AdminColors.shonenPurple;
      case 'ADMIN': return AdminColors.warningYellow;
      case 'BANNED': return AdminColors.errorRed;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _AdminAppBar(),
      body: Column(
        children: [
          // Page Title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _SectionDivider(label: 'USER — MANAGEMENT'),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AdminColors.surface,
                border: Border.all(color: AdminColors.sakuraPink, width: 2),
                boxShadow: const [BoxShadow(color: AdminColors.sakuraPink, offset: Offset(3, 3))],
              ),
              child: const TextField(
                style: TextStyle(color: AdminColors.onSurface),
                decoration: InputDecoration(
                  hintText: 'SEARCH USER...',
                  hintStyle: TextStyle(color: AdminColors.onSurfaceVariant),
                  prefixIcon: Icon(Icons.search, color: AdminColors.sakuraPink),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['ALL', 'FREE', 'PREMIUM', 'MANAGER', 'ADMIN']
                    .map((r) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _FilterChip(label: r, color: _roleColor(r), isActive: r == 'ALL'),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // User list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final u = _users[i];
                final role = u['role']!;
                final color = _roleColor(role);
                return _UserCard(
                  initial: u['initial']!,
                  name: u['name']!,
                  email: u['email']!,
                  role: role,
                  roleColor: color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;

  const _FilterChip({required this.label, required this.color, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isActive ? color : Colors.transparent,
        border: Border.all(color: color, width: 2),
        boxShadow: isActive ? [BoxShadow(color: color, offset: const Offset(2, 2))] : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isActive ? Colors.black : color,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final String initial;
  final String name;
  final String email;
  final String role;
  final Color roleColor;

  const _UserCard({
    required this.initial,
    required this.name,
    required this.email,
    required this.role,
    required this.roleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border(
          left: BorderSide(color: roleColor, width: 4),
          top: BorderSide(color: Colors.black26, width: 1),
          right: BorderSide(color: Colors.black26, width: 1),
          bottom: BorderSide(color: Colors.black26, width: 1),
        ),
        boxShadow: [BoxShadow(color: roleColor.withOpacity(0.5), offset: const Offset(3, 3))],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: roleColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(
              child: Text(
                initial,
                style: GoogleFonts.bebasNeue(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AdminColors.onSurface)),
                Text(email,
                    style: const TextStyle(fontSize: 11, color: AdminColors.onSurfaceVariant)),
              ],
            ),
          ),
          // Role badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              border: Border.all(color: roleColor, width: 1),
            ),
            child: Text(
              role,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: roleColor,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.more_vert, color: AdminColors.onSurfaceVariant, size: 18),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// TAB 3: CONTENT MODERATION
// ═══════════════════════════════════════════
class _AdminContentTab extends StatelessWidget {
  const _AdminContentTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _AdminAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _SectionDivider(label: 'CONTENT — MODERATION'),
          ),
          // Filter tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _ContentFilterTab(label: 'ALL', isActive: false),
                const SizedBox(width: 8),
                _ContentFilterTab(label: 'PENDING', isActive: true, badge: '17'),
                const SizedBox(width: 8),
                _ContentFilterTab(label: 'APPROVED', isActive: false),
                const SizedBox(width: 8),
                _ContentFilterTab(label: 'REJECTED', isActive: false),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Content list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _ContentCard(
                  title: 'NEON TOKYO DRIFT',
                  author: 'by A. Kurosawa',
                  genres: ['ACTION', 'SCI-FI'],
                  status: 'PENDING',
                  statusColor: AdminColors.warningYellow,
                  uploadTime: 'Uploaded 2h ago',
                ),
                SizedBox(height: 12),
                _ContentCard(
                  title: 'SILENT HEARTS',
                  author: 'by M. Shinkai',
                  genres: ['ROMANCE', 'DRAMA'],
                  status: 'PENDING',
                  statusColor: AdminColors.warningYellow,
                  uploadTime: 'Uploaded 5h ago',
                ),
                SizedBox(height: 12),
                _ContentCard(
                  title: 'ECHOES OF THE FALLEN',
                  author: 'by T. Kazuki',
                  genres: ['ACTION', 'FANTASY'],
                  status: 'APPROVED',
                  statusColor: AdminColors.cyberCyan,
                  uploadTime: 'Uploaded 1d ago',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentFilterTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final String? badge;

  const _ContentFilterTab({required this.label, required this.isActive, this.badge});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isActive ? AdminColors.sakuraPink : AdminColors.onSurfaceVariant,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AdminColors.errorRedDark,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(badge!, style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        if (isActive)
          Container(height: 2, width: 40, color: AdminColors.sakuraPink, margin: const EdgeInsets.only(top: 2)),
      ],
    );
  }
}

class _ContentCard extends StatelessWidget {
  final String title;
  final String author;
  final List<String> genres;
  final String status;
  final Color statusColor;
  final String uploadTime;

  const _ContentCard({
    required this.title,
    required this.author,
    required this.genres,
    required this.status,
    required this.statusColor,
    required this.uploadTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border.all(color: Colors.white24, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: AdminColors.sakuraPink, offset: Offset(4, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Stack(
            children: [
              Container(
                height: 110,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AdminColors.surfaceHigh,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                ),
                child: const Icon(Icons.image, color: Colors.white12, size: 40),
              ),
              // Status badge
              Positioned(
                top: 8,
                right: 8,
                child: Transform.rotate(
                  angle: -0.05,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor,
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2))],
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.bebasNeue(fontSize: 20, color: AdminColors.onSurface, letterSpacing: 1)),
                Text(author, style: const TextStyle(fontSize: 11, color: AdminColors.onSurfaceVariant)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: genres
                      .map((g) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: AdminColors.outlineVariant),
                            ),
                            child: Text(g,
                                style: const TextStyle(fontSize: 9, color: AdminColors.onSurfaceVariant, fontWeight: FontWeight.bold)),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 4),
                Text(uploadTime, style: const TextStyle(fontSize: 10, color: AdminColors.onSurfaceVariant)),
                const SizedBox(height: 10),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _ContentActionBtn(label: 'APPROVE', color: AdminColors.green, filled: true, onTap: () {}),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _ContentActionBtn(label: 'REJECT', color: AdminColors.errorRed, filled: false, onTap: () {}),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _ContentActionBtn(label: 'VIEW', color: AdminColors.onSurfaceVariant, filled: false, onTap: () {}),
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
}

class _ContentActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _ContentActionBtn({required this.label, required this.color, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: filled ? color : AdminColors.surface,
          border: Border.all(color: color, width: 2),
          boxShadow: [BoxShadow(color: color, offset: const Offset(2, 2))],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: filled ? Colors.black : color,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// TAB 4: SETTINGS
// ═══════════════════════════════════════════
class _AdminSettingsTab extends StatelessWidget {
  const _AdminSettingsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const _AdminAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SectionDivider(label: 'SYSTEM — SETTINGS'),
            const SizedBox(height: 16),

            // ACCOUNT section
            _SettingsGroupLabel(label: 'ACCOUNT'),
            _SettingsGroup(children: [
              _SettingsRow(icon: Icons.person, label: 'Admin Profile', trailing: const Icon(Icons.chevron_right, color: AdminColors.onSurfaceVariant)),
              _SettingsRow(icon: Icons.lock, label: 'Change Password', trailing: const Icon(Icons.chevron_right, color: AdminColors.onSurfaceVariant)),
              _SettingsRow(icon: Icons.notifications, label: 'Notifications',
                  trailing: Switch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: AdminColors.sakuraPink,
                    activeTrackColor: AdminColors.sakuraPink.withOpacity(0.3),
                  )),
            ]),
            const SizedBox(height: 16),

            // PLATFORM section
            _SettingsGroupLabel(label: 'PLATFORM'),
            _SettingsGroup(shadowColor: AdminColors.cyberCyan, children: [
              _SettingsRow(icon: Icons.policy, label: 'Content Policy', trailing: const Icon(Icons.chevron_right, color: AdminColors.onSurfaceVariant)),
              _SettingsRow(icon: Icons.group_add, label: 'Registration Mode',
                  trailing: Switch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: AdminColors.cyberCyan,
                    activeTrackColor: AdminColors.cyberCyan.withOpacity(0.3),
                  )),
              _SettingsRow(icon: Icons.star, label: 'Premium Features',
                  trailing: Switch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: AdminColors.shonenPurple,
                    activeTrackColor: AdminColors.shonenPurple.withOpacity(0.3),
                  )),
            ]),
            const SizedBox(height: 16),

            // DANGER ZONE section
            _SettingsGroupLabel(label: 'DANGER ZONE', color: AdminColors.errorRed),
            _SettingsGroup(borderColor: AdminColors.errorRed, shadowColor: AdminColors.errorRed, children: [
              _SettingsRow(
                icon: Icons.warning_amber,
                iconColor: AdminColors.errorRed,
                label: 'Maintenance Mode',
                labelColor: AdminColors.errorRed,
                trailing: Switch(
                  value: false,
                  onChanged: (_) {},
                  activeColor: AdminColors.errorRed,
                ),
                leftBorderColor: AdminColors.errorRed,
              ),
              _SettingsRow(
                icon: Icons.delete_forever,
                iconColor: AdminColors.errorRed,
                label: 'Clear Cache',
                labelColor: AdminColors.errorRed,
                trailing: const Icon(Icons.chevron_right, color: AdminColors.errorRed),
                leftBorderColor: AdminColors.errorRed,
              ),
            ]),
            const SizedBox(height: 24),

            // Logout button
            GestureDetector(
              onTap: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRouter.login, (r) => false);
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AdminColors.surface,
                  border: Border.all(color: AdminColors.errorRed, width: 2),
                  boxShadow: const [BoxShadow(color: AdminColors.errorRed, offset: Offset(4, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: AdminColors.errorRed, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'LOGOUT',
                      style: GoogleFonts.bebasNeue(
                        fontSize: 20,
                        color: AdminColors.errorRed,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroupLabel extends StatelessWidget {
  final String label;
  final Color color;

  const _SettingsGroupLabel({required this.label, this.color = AdminColors.onSurfaceVariant});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  final Color borderColor;
  final Color shadowColor;

  const _SettingsGroup({
    required this.children,
    this.borderColor = AdminColors.outlineVariant,
    this.shadowColor = AdminColors.sakuraPink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [BoxShadow(color: shadowColor, offset: const Offset(3, 3))],
      ),
      child: Column(
        children: children
            .asMap()
            .entries
            .map((e) => Column(children: [
                  e.value,
                  if (e.key < children.length - 1)
                    Divider(height: 1, color: AdminColors.outlineVariant.withOpacity(0.5)),
                ]))
            .toList(),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color labelColor;
  final Widget trailing;
  final Color? leftBorderColor;

  const _SettingsRow({
    required this.icon,
    this.iconColor = AdminColors.sakuraPink,
    required this.label,
    this.labelColor = AdminColors.onSurface,
    required this.trailing,
    this.leftBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: leftBorderColor != null
          ? BoxDecoration(border: Border(left: BorderSide(color: leftBorderColor!, width: 3)))
          : null,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: labelColor, fontWeight: FontWeight.w500),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
