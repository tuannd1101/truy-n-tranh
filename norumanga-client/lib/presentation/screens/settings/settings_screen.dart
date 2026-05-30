import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = true;
  bool _autoNextChapter = true;
  bool _notifyNewChapter = true;
  bool _notifyPromo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 40),
        children: [
          _buildSectionHeader('HIỂN THỊ'),
          _buildSwitchTile(
            'Chế độ tối (Dark Mode)',
            Icons.dark_mode,
            _isDarkMode,
            (val) => setState(() => _isDarkMode = val),
          ),
          _buildListTile('Ngôn ngữ', Icons.language, trailingText: 'Tiếng Việt >'),
          
          _buildSectionHeader('ĐỌC TRUYỆN'),
          _buildListTile('Chế độ đọc mặc định', Icons.chrome_reader_mode, trailingText: 'Cuộn dọc >'),
          _buildSwitchTile(
            'Tự động chuyển chapter',
            Icons.auto_stories,
            _autoNextChapter,
            (val) => setState(() => _autoNextChapter = val),
          ),
          _buildListTile('Chất lượng ảnh', Icons.high_quality, trailingText: 'Cao >'),
          
          _buildSectionHeader('THÔNG BÁO'),
          _buildSwitchTile(
            'Thông báo chapter mới',
            Icons.notifications_active,
            _notifyNewChapter,
            (val) => setState(() => _notifyNewChapter = val),
          ),
          _buildSwitchTile(
            'Thông báo khuyến mãi',
            Icons.local_offer,
            _notifyPromo,
            (val) => setState(() => _notifyPromo = val),
          ),
          
          _buildSectionHeader('TÀI KHOẢN'),
          _buildListTile('Đổi mật khẩu', Icons.vpn_key),
          _buildListTile(
            'Xóa tài khoản',
            Icons.person_remove,
            isDestructive: true,
            onTap: _showDeleteAccountDialog,
          ),
          
          _buildSectionHeader('KHÁC'),
          _buildListTile('Điều khoản sử dụng', Icons.description),
          _buildListTile('Chính sách bảo mật', Icons.shield),
          _buildListTile('Liên hệ hỗ trợ', Icons.email),
          _buildListTile('Đánh giá ứng dụng', Icons.star),
          _buildListTile('Phiên bản', Icons.info_outline, trailingText: 'v1.0.0', onTap: () {}),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.onSurface),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Container(color: AppColors.border, height: 2),
      ),
      title: const Text(
        'CÀI ĐẶT',
        style: TextStyle(
          fontFamily: 'Anton',
          color: AppColors.onSurface,
          fontSize: 24,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Anton',
          color: AppColors.primaryContainer,
          fontSize: 16,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildListTile(
    String title,
    IconData icon, {
    String? trailingText,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.onSurface;
    
    return ListTile(
      onTap: onTap,
      tileColor: AppColors.surfaceContainerLow,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Syne',
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      trailing: trailingText != null
          ? Text(
              trailingText,
              style: const TextStyle(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            )
          : Icon(Icons.chevron_right, color: color),
      shape: const Border(bottom: BorderSide(color: AppColors.surfaceVariant)),
    );
  }

  Widget _buildSwitchTile(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      tileColor: AppColors.surfaceContainerLow,
      leading: Icon(icon, color: AppColors.onSurface),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Syne',
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.onPrimaryContainer,
        activeTrackColor: AppColors.primaryContainer,
        inactiveThumbColor: AppColors.onSurfaceVariant,
        inactiveTrackColor: AppColors.surfaceVariant,
      ),
      shape: const Border(bottom: BorderSide(color: AppColors.surfaceVariant)),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.error, width: 2),
        ),
        title: const Text(
          'XÓA TÀI KHOẢN',
          style: TextStyle(
            fontFamily: 'Anton',
            color: AppColors.error,
          ),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa tài khoản? Mọi dữ liệu đọc truyện và giao dịch sẽ bị xóa vĩnh viễn.',
          style: TextStyle(color: AppColors.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'HỦY',
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle account deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorContainer,
              foregroundColor: AppColors.error,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            child: const Text('XÓA VĨNH VIỄN'),
          ),
        ],
      ),
    );
  }
}
