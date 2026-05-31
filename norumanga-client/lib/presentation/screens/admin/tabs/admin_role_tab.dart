import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/role.dart';
import '../../../../providers/role_provider.dart';
import '../admin_dashboard_screen.dart';

/// Read-only role list for the admin dashboard.
class AdminRoleTab extends StatefulWidget {
  const AdminRoleTab({super.key});

  @override
  State<AdminRoleTab> createState() => _AdminRoleTabState();
}

class _AdminRoleTabState extends State<AdminRoleTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RoleProvider>().fetchRoles();
    });
  }

  Color _roleColor(String role) {
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

  IconData _roleIcon(String role) {
    switch (role.toUpperCase()) {
      case 'PREMIUM':
        return Icons.workspace_premium;
      case 'FREE':
        return Icons.person_outline;
      case 'MANAGER':
        return Icons.manage_accounts;
      case 'ADMIN':
        return Icons.shield;
      default:
        return Icons.badge;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoleProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'ROLE — VIEWER',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 24,
                      color: AdminColors.onSurface,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: AdminColors.onSurfaceVariant),
                    ),
                    child: const Text('READ-ONLY',
                        style: TextStyle(
                            fontSize: 9,
                            color: AdminColors.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (provider.isLoading && provider.roles.isEmpty)
                const Center(
                    child:
                        CircularProgressIndicator(color: AdminColors.warningYellow))
              else if (provider.errorMessage != null && provider.roles.isEmpty)
                Center(
                    child: Text(provider.errorMessage!,
                        style: const TextStyle(color: AdminColors.errorRed)))
              else if (provider.roles.isEmpty)
                const Center(
                    child: Text('Chưa có vai trò nào.',
                        style: TextStyle(color: AdminColors.onSurfaceVariant)))
              else
                ...provider.roles.map((role) => _buildRoleCard(role)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleCard(Role role) {
    final color = _roleColor(role.name);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border.all(color: AdminColors.outlineVariant),
        boxShadow: [BoxShadow(color: color, offset: const Offset(3, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(_roleIcon(role.name), color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role.name.toUpperCase(),
                    style: GoogleFonts.bebasNeue(
                        fontSize: 20,
                        color: AdminColors.onSurface,
                        letterSpacing: 1)),
                const SizedBox(height: 2),
                Text(
                  role.description.isEmpty ? 'Không có mô tả' : role.description,
                  style: const TextStyle(
                      color: AdminColors.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
