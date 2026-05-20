import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

class PaymentResultScreen extends StatelessWidget {
  final bool success;

  const PaymentResultScreen({
    super.key,
    required this.success,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: success
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  success ? Icons.check_circle : Icons.cancel,
                  size: 80,
                  color: success ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              
              // Title
              Text(
                success ? 'Thanh toán thành công!' : 'Thanh toán thất bại',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingM),
              
              // Message
              Text(
                success
                    ? 'Chúc mừng bạn đã nâng cấp tài khoản Premium thành công. Bây giờ bạn có thể đọc tất cả truyện không giới hạn!'
                    : 'Đã có lỗi xảy ra trong quá trình thanh toán. Vui lòng thử lại sau.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              
              // Buttons
              if (success) ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Reload profile to update role
                      // Navigate to home
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    child: const Text('Về trang chủ'),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/profile',
                        (route) => false,
                      );
                    },
                    child: const Text('Xem hồ sơ'),
                  ),
                ),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Go back to payment screen to retry
                      Navigator.pop(context);
                    },
                    child: const Text('Thử lại'),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    },
                    child: const Text('Về trang chủ'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
