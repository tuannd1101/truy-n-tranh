import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

class PaymentResultScreen extends StatelessWidget {
  final bool success;
  final String method;
  final String? message;

  const PaymentResultScreen({
    super.key,
    this.success = true,
    this.method = 'momo',
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? AppColors.success : AppColors.error,
                size: 100,
              ),
              const SizedBox(height: 24),
              Text(
                success ? 'THANH TOÁN THÀNH CÔNG' : 'THANH TOÁN THẤT BẠI',
                style: TextStyle(
                  fontFamily: 'Anton',
                  fontSize: 28,
                  color: success ? AppColors.success : AppColors.error,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                success 
                  ? 'Chúc mừng! Bạn đã nâng cấp Premium thành công. Tận hưởng các đặc quyền VIP ngay thôi!' 
                  : (message ?? 'Rất tiếc, đã có lỗi xảy ra trong quá trình giao dịch. Vui lòng thử lại sau.'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to home
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      AppRouter.home, 
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'VỀ TRANG CHỦ',
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 18,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
