import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header Drawer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  bottom: BorderSide(color: AppColors.primaryContainer, width: 2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.onSurface, width: 2),
                    ),
                    child: const Icon(Icons.face, color: AppColors.onSurface, size: 28),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MANGAFLOW',
                          style: TextStyle(
                            fontFamily: 'Anton',
                            color: AppColors.onSurface,
                            fontSize: 20,
                            letterSpacing: 1.5,
                          ),
                        ),
                        Text(
                          'Reader Mode',
                          style: TextStyle(
                            fontFamily: 'Syne',
                            color: AppColors.primaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home,
                    title: 'TRANG CHỦ',
                    route: AppRouter.home,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.my_library_books,
                    title: 'THƯ VIỆN',
                    route: AppRouter.library,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.history,
                    title: 'LỊCH SỬ ĐỌC',
                    route: AppRouter.readingHistory,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.favorite,
                    title: 'YÊU THÍCH',
                    route: AppRouter.favorites,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(color: AppColors.border, thickness: 2),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person,
                    title: 'TÀI KHOẢN',
                    route: AppRouter.profile,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings,
                    title: 'CÀI ĐẶT',
                    route: AppRouter.settings,
                  ),
                ],
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 2),
                ),
              ),
              child: const Text(
                'MangaFlow v1.0.0',
                style: TextStyle(
                  fontFamily: 'Syne',
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(icon, color: AppColors.onSurface, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Anton',
          color: AppColors.onSurface,
          fontSize: 16,
          letterSpacing: 1,
        ),
      ),
      onTap: () {
        // Pop drawer
        Navigator.pop(context);
        
        // Push route
        final currentRoute = ModalRoute.of(context)?.settings.name;
        if (currentRoute != route) {
          if (route == AppRouter.home) {
            Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
          } else {
            Navigator.pushNamed(context, route);
          }
        }
      },
    );
  }
}
