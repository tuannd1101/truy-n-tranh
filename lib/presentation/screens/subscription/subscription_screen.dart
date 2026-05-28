import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int? _selectedPlanIndex;
  bool _isLoading = true;
  
  // TODO: Replace with actual data from API
  List<Map<String, dynamic>> _plans = [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Call API to fetch subscription plans
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    _plans = [
      {
        'id': 1,
        'name': 'Gói 1 Tháng',
        'duration': '1 tháng',
        'price': 49000,
        'features': [
          'Đọc không giới hạn',
          'Không quảng cáo',
          'Tải truyện offline',
        ],
      },
      {
        'id': 2,
        'name': 'Gói 6 Tháng',
        'duration': '6 tháng',
        'price': 249000,
        'originalPrice': 294000,
        'discount': '15%',
        'features': [
          'Đọc không giới hạn',
          'Không quảng cáo',
          'Tải truyện offline',
          'Ưu tiên hỗ trợ',
        ],
        'isPopular': true,
      },
      {
        'id': 3,
        'name': 'Gói 1 Năm',
        'duration': '12 tháng',
        'price': 449000,
        'originalPrice': 588000,
        'discount': '24%',
        'features': [
          'Đọc không giới hạn',
          'Không quảng cáo',
          'Tải truyện offline',
          'Ưu tiên hỗ trợ',
          'Badge đặc biệt',
        ],
      },
    ];

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onProceedToPayment() {
    if (_selectedPlanIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn một gói trước khi tiếp tục'),
        ),
      );
      return;
    }

    final selectedPlan = _plans[_selectedPlanIndex!];
    Navigator.pushNamed(
      context,
      '/payment',
      arguments: selectedPlan,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nâng cấp Premium'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingL),
                  color: AppColors.primary.withOpacity(0.1),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppDimensions.paddingM),
                      Text(
                        'Đọc truyện không giới hạn',
                        style: AppTextStyles.h2,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.paddingS),
                      Text(
                        'Mở khóa toàn bộ chapter Premium và trải nghiệm đọc truyện tốt nhất',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Plans List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppDimensions.paddingM),
                    itemCount: _plans.length,
                    itemBuilder: (context, index) {
                      final plan = _plans[index];
                      final isSelected = _selectedPlanIndex == index;
                      final isPopular = plan['isPopular'] ?? false;
                      
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.paddingM,
                        ),
                        child: _buildPlanCard(
                          plan: plan,
                          isSelected: isSelected,
                          isPopular: isPopular,
                          onTap: () {
                            setState(() {
                              _selectedPlanIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom Button
                Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _onProceedToPayment,
                        child: const Text('Tiến hành thanh toán'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPlanCard({
    required Map<String, dynamic> plan,
    required bool isSelected,
    required bool isPopular,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan['name'],
                            style: AppTextStyles.h3,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plan['duration'],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.textPrimary,
                          size: 20,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingM),
                
                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${plan['price']}đ',
                      style: AppTextStyles.price,
                    ),
                    if (plan['originalPrice'] != null) ...[
                      const SizedBox(width: AppDimensions.paddingS),
                      Text(
                        '${plan['originalPrice']}đ',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    if (plan['discount'] != null) ...[
                      const SizedBox(width: AppDimensions.paddingS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusS,
                          ),
                        ),
                        child: Text(
                          '-${plan['discount']}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingM),
                
                // Features
                ...((plan['features'] as List<String>).map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.paddingS,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                        const SizedBox(width: AppDimensions.paddingS),
                        Text(
                          feature,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          
          // Popular Badge
          if (isPopular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppDimensions.radiusL),
                    bottomLeft: Radius.circular(AppDimensions.radiusL),
                  ),
                ),
                child: Text(
                  'PHỔ BIẾN',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
