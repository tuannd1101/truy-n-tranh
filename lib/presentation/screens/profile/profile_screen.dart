import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO: Get from auth provider
  bool _isLoggedIn = true;
  String _userRole = 'FREE_USER'; // GUEST, FREE_USER, PREMIUM_USER

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return _buildGuestView();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Avatar and User Info
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              color: AppColors.surface,
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      'U',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  
                  // User Name
                  Text(
                    'Tên Người Dùng',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppDimensions.paddingS),
                  
                  // Email
                  Text(
                    'user@example.com',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  
                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: _userRole == 'PREMIUM_USER'
                          ? AppColors.primary
                          : AppColors.grey,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                    ),
                    child: Text(
                      _userRole == 'PREMIUM_USER' ? 'Premium User' : 'Free User',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Premium Banner (only show for non-premium users)
            if (_userRole != 'PREMIUM_USER')
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          color: AppColors.primary,
                          size: 32,
                        ),
                        const SizedBox(width: AppDimensions.paddingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nâng cấp Premium',
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'Đọc không giới hạn tất cả truyện',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/subscription');
                        },
                        child: const Text('Nâng cấp ngay'),
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: AppDimensions.paddingM),
            
            // Menu List
            Card(
              margin: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Lịch sử đọc',
                    onTap: () {
                      // TODO: Navigate to reading history
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.favorite,
                    title: 'Truyện yêu thích',
                    onTap: () {
                      // TODO: Navigate to favorites
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: 'Cài đặt',
                    onTap: () {
                      // TODO: Navigate to settings
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    titleColor: AppColors.error,
                    onTap: () {
                      _showLogoutDialog();
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppDimensions.paddingL),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: 100,
                color: AppColors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              Text(
                'Bạn chưa đăng nhập',
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: AppDimensions.paddingS),
              Text(
                'Đăng nhập để trải nghiệm đầy đủ tính năng',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingL),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.paddingL,
                    ),
                  ),
                  child: const Text('Đăng nhập / Đăng ký'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.textPrimary),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: titleColor,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: AppColors.grey),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call logout API
              Navigator.pop(context);
              setState(() {
                _isLoggedIn = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
