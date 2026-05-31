import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/admin_user.dart';
import '../../../../data/models/role.dart';
import '../../../../providers/user_provider.dart';
import '../../../../providers/role_provider.dart';
import '../admin_dashboard_screen.dart';

/// Admin User Management tab — view, view detail, edit (no create/delete).
class AdminUserTab extends StatefulWidget {
  const AdminUserTab({super.key});

  @override
  State<AdminUserTab> createState() => _AdminUserTabState();
}

class _AdminUserTabState extends State<AdminUserTab> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _activeRoleId = ''; // '' = ALL

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoleProvider>().fetchRoles();
      context.read<UserProvider>().fetchUsers(page: 0, resetFilters: true);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      context.read<UserProvider>().search(value.trim());
    });
  }

  static Color roleColor(String role) {
    switch (role.toUpperCase()) {
      case 'PREMIUM':
        return AdminColors.sakuraPink;
      case 'FREE':
        return AdminColors.cyberCyan;
      case 'MANAGER':
        return AdminColors.shonenPurple;
      case 'ADMIN':
        return AdminColors.warningYellow;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Text(
                'USER — MANAGEMENT',
                style: GoogleFonts.bebasNeue(
                  fontSize: 24,
                  color: AdminColors.onSurface,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Consumer<UserProvider>(
                builder: (context, p, _) => Text(
                  '${p.totalElements} users',
                  style: const TextStyle(
                      color: AdminColors.onSurfaceVariant, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: AdminColors.surface,
              border: Border.all(color: AdminColors.sakuraPink, width: 2),
              boxShadow: const [
                BoxShadow(color: AdminColors.sakuraPink, offset: Offset(3, 3))
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: AdminColors.onSurface),
              decoration: const InputDecoration(
                hintText: 'SEARCH USER (tên hoặc email)...',
                hintStyle: TextStyle(color: AdminColors.onSurfaceVariant),
                prefixIcon: Icon(Icons.search, color: AdminColors.sakuraPink),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        // Role filter chips
        _buildRoleFilters(),
        const SizedBox(height: 8),
        // User list
        Expanded(
          child: Consumer<UserProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.users.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AdminColors.sakuraPink));
              }
              if (provider.errorMessage != null && provider.users.isEmpty) {
                return _buildError(provider.errorMessage!);
              }
              if (provider.users.isEmpty) {
                return const Center(
                    child: Text('Không tìm thấy người dùng.',
                        style:
                            TextStyle(color: AdminColors.onSurfaceVariant)));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: provider.users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final user = provider.users[i];
                        return _UserCard(
                          user: user,
                          color: roleColor(user.roleName),
                          onTap: () => _showUserDetail(context, user),
                          onEdit: () => _showEditDialog(context, user),
                        );
                      },
                    ),
                  ),
                  if (provider.totalPages > 1)
                    _buildPagination(provider),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoleFilters() {
    return Consumer<RoleProvider>(
      builder: (context, roleProvider, _) {
        final chips = <Widget>[
          _filterChip('ALL', '', Colors.grey),
          ...roleProvider.roles.map(
            (r) => _filterChip(r.name.toUpperCase(), r.id, roleColor(r.name)),
          ),
        ];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chips
                  .map((c) => Padding(
                      padding: const EdgeInsets.only(right: 8), child: c))
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _filterChip(String label, String roleId, Color color) {
    final isActive = _activeRoleId == roleId;
    return GestureDetector(
      onTap: () {
        setState(() => _activeRoleId = roleId);
        context.read<UserProvider>().filterByRole(roleId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.transparent,
          border: Border.all(color: color, width: 2),
          boxShadow:
              isActive ? [BoxShadow(color: color, offset: const Offset(2, 2))] : null,
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
      ),
    );
  }

  Widget _buildPagination(UserProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AdminColors.onSurface),
            onPressed: provider.currentPage > 1
                ? () => provider.setPage(provider.currentPage - 1)
                : null,
          ),
          Text(
            'PAGE ${provider.currentPage} OF ${provider.totalPages}',
            style: GoogleFonts.spaceGrotesk(
                color: AdminColors.onSurfaceVariant,
                fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AdminColors.onSurface),
            onPressed: provider.currentPage < provider.totalPages
                ? () => provider.setPage(provider.currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AdminColors.errorRed),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AdminColors.errorRed)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  context.read<UserProvider>().fetchUsers(page: 0),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AdminColors.sakuraPink),
              child: const Text('THỬ LẠI', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  // ── detail bottom sheet ────────────────────────────────────────────────────

  void _showUserDetail(BuildContext context, AdminUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AdminColors.surface,
      isScrollControlled: true,
      builder: (_) {
        final color = roleColor(user.roleName);
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Center(
                      child: Text(user.initial,
                          style: GoogleFonts.bebasNeue(
                              fontSize: 26, color: Colors.black)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.fullName,
                            style: GoogleFonts.bebasNeue(
                                fontSize: 22, color: AdminColors.onSurface)),
                        Text(user.email,
                            style: const TextStyle(
                                color: AdminColors.onSurfaceVariant,
                                fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: AdminColors.outlineVariant, height: 28),
              _detailRow('ID', user.id),
              _detailRow('Vai trò', user.roleName),
              _detailRow('Trạng thái', user.status),
              _detailRow('Ngày tạo', _formatDate(user.createdAt)),
              _detailRow('Cập nhật', _formatDate(user.updatedAt)),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showEditDialog(context, user);
                  },
                  icon: const Icon(Icons.edit, color: Colors.black),
                  label: const Text('CHỈNH SỬA',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminColors.cyberCyan,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(
                    color: AdminColors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: AdminColors.onSurface, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // ── edit dialog ────────────────────────────────────────────────────────────

  void _showEditDialog(BuildContext context, AdminUser user) {
    final nameController = TextEditingController(text: user.fullName);
    final roleProvider = context.read<RoleProvider>();
    final userProvider = context.read<UserProvider>();

    String? selectedRoleId = user.roleId ??
        roleProvider.roles
            .where((r) => r.name == user.roleName)
            .map((r) => r.id)
            .cast<String?>()
            .firstWhere((_) => true, orElse: () => null);
    String selectedStatus = user.status.isEmpty ? 'ACTIVE' : user.status;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setLocal) {
            return AlertDialog(
              backgroundColor: AdminColors.surface,
              title: Text('EDIT USER',
                  style: GoogleFonts.bebasNeue(
                      color: AdminColors.cyberCyan, letterSpacing: 1)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Email (read-only)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: TextEditingController(text: user.email),
                        enabled: false,
                        style: const TextStyle(color: AdminColors.onSurfaceVariant),
                        decoration: _decoration('Email (không sửa được)'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: nameController,
                        style: const TextStyle(color: AdminColors.onSurface),
                        decoration: _decoration('Họ tên'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedRoleId,
                        decoration: _decoration('Vai trò'),
                        dropdownColor: AdminColors.surfaceHigh,
                        style: const TextStyle(color: AdminColors.onSurface),
                        items: roleProvider.roles
                            .map((Role r) => DropdownMenuItem(
                                value: r.id, child: Text(r.name)))
                            .toList(),
                        onChanged: (val) =>
                            setLocal(() => selectedRoleId = val),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: selectedStatus,
                      decoration: _decoration('Trạng thái'),
                      dropdownColor: AdminColors.surfaceHigh,
                      style: const TextStyle(color: AdminColors.onSurface),
                      items: const ['ACTIVE', 'BANNED']
                          .map((s) =>
                              DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (val) =>
                          setLocal(() => selectedStatus = val ?? 'ACTIVE'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('CANCEL',
                      style: TextStyle(color: AdminColors.onSurfaceVariant)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Họ tên không được trống')));
                      return;
                    }
                    final data = {
                      'fullName': nameController.text.trim(),
                      if (selectedRoleId != null) 'roleId': selectedRoleId,
                      'status': selectedStatus,
                    };
                    Navigator.pop(ctx);
                    final success =
                        await userProvider.updateUser(user.id, data);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(success
                            ? 'Đã cập nhật người dùng!'
                            : userProvider.errorMessage ?? 'Cập nhật thất bại'),
                        backgroundColor:
                            success ? AdminColors.green : AdminColors.errorRed,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AdminColors.cyberCyan),
                  child: const Text('SAVE',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AdminColors.onSurfaceVariant),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AdminColors.outlineVariant)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AdminColors.cyberCyan)),
      disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AdminColors.outlineVariant)),
    );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '—';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }
}

class _UserCard extends StatelessWidget {
  final AdminUser user;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _UserCard({
    required this.user,
    required this.color,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final banned = user.status.toUpperCase() == 'BANNED';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AdminColors.surface,
          border: Border(
            left: BorderSide(color: color, width: 4),
            top: const BorderSide(color: Colors.black26, width: 1),
            right: const BorderSide(color: Colors.black26, width: 1),
            bottom: const BorderSide(color: Colors.black26, width: 1),
          ),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.5), offset: const Offset(3, 3))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Center(
                child: Text(user.initial,
                    style:
                        GoogleFonts.bebasNeue(fontSize: 18, color: Colors.black)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(user.fullName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AdminColors.onSurface)),
                      ),
                      if (banned) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 1),
                          color: AdminColors.errorRedDark,
                          child: const Text('BANNED',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: AdminColors.errorRed,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ],
                  ),
                  Text(user.email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11, color: AdminColors.onSurfaceVariant)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(border: Border.all(color: color, width: 1)),
              child: Text(
                user.roleName.toUpperCase(),
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 1),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: AdminColors.cyberCyan, size: 18),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
