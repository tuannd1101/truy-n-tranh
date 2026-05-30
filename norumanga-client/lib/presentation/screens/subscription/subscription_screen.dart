import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../data/models/bundle.dart';
import '../../../providers/bundle_provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  Bundle? _selectedBundle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BundleProvider>().fetchBundles();
    });
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String _cycleLabel(String cycle) {
    switch (cycle) {
      case 'MONTHLY':
        return '/tháng';
      case 'QUARTERLY':
        return '/quý';
      case 'YEARLY':
        return '/năm';
      default:
        return '';
    }
  }

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
      body: Consumer<BundleProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.bundles.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.gold));
          }

          if (provider.errorMessage != null && provider.bundles.isEmpty) {
            return _buildError(provider);
          }

          if (provider.bundles.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có gói đăng ký nào.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          // Default selection = first bundle.
          _selectedBundle ??= provider.bundles.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.workspace_premium,
                    size: 100, color: AppColors.gold),
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
                const SizedBox(height: 40),
                ...provider.bundles.map((b) => _buildBundleCard(b)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<BundleProvider>(
        builder: (context, provider, _) {
          if (provider.bundles.isEmpty) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  final bundle = _selectedBundle ?? provider.bundles.first;
                  Navigator.pushNamed(context, AppRouter.payment, arguments: {
                    'bundle_id': bundle.id,
                    'plan_name': bundle.name,
                    'price': bundle.price,
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
          );
        },
      ),
    );
  }

  Widget _buildError(BundleProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'Đã xảy ra lỗi.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchBundles(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.gold),
              child: const Text('THỬ LẠI',
                  style: TextStyle(color: AppColors.onGold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBundleCard(Bundle bundle) {
    final isSelected = _selectedBundle?.id == bundle.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedBundle = bundle),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1B23),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.gold : AppColors.outline,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: isSelected ? AppColors.gold : AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              bundle.name,
              style: const TextStyle(
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
                Text(
                  _formatPrice(bundle.price),
                  style: const TextStyle(
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
                    'VNĐ\n${_cycleLabel(bundle.billingCycle)}',
                    style: TextStyle(
                      color: AppColors.gold.withValues(alpha: 0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ...bundle.features.map(_buildFeatureRow),
          ],
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
