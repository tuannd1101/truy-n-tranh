import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'ĐĂNG KÝ PREMIUM',
          style: TextStyle(
            fontFamily: 'Anton',
            color: AppColors.gold,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.gold),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Graphic
            const Icon(Icons.workspace_premium, size: 100, color: AppColors.gold),
            const SizedBox(height: 24),
            Text(
              'TRỞ THÀNH VIP',
              style: TextStyle(
                fontFamily: 'Anton',
                fontSize: 36,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(
                    color: AppColors.gold.withValues(alpha: 0.8),
                    blurRadius: 15,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Truy cập không giới hạn. Trải nghiệm tối thượng.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Main Premium Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B23),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.gold, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'GÓI ĐỘC QUYỀN',
                      style: TextStyle(
                        fontFamily: 'Anton',
                        color: AppColors.onGold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Premium 1 Tháng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '49.000',
                        style: TextStyle(
                          fontFamily: 'Anton',
                          fontSize: 48,
                          color: AppColors.gold,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'VNĐ\n/tháng',
                          style: TextStyle(
                            color: AppColors.gold.withValues(alpha: 0.7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildFeatureRow('Không quảng cáo'),
                  _buildFeatureRow('Đọc chương mới trước 7 ngày'),
                  _buildFeatureRow('Tải truyện đọc Offline'),
                  _buildFeatureRow('Ủng hộ trực tiếp tác giả'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRouter.payment, arguments: {
                'plan_name': 'Premium 1 Tháng',
                'price': 49000,
              });
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'TIẾN HÀNH THANH TOÁN',
                  style: TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 20,
                    color: AppColors.onGold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.gold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
