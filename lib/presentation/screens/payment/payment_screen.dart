import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';

enum PaymentMethod { momo, vnpay }

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> plan;

  const PaymentScreen({
    super.key,
    required this.plan,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _selectedMethod;
  bool _isProcessing = false;

  void _onProceedPayment() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn phương thức thanh toán'),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // TODO: Call API to create payment
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      // TODO: Get payment URL from API response
      final paymentUrl = 'https://example.com/payment';

      // Navigate to WebView
      Navigator.pushNamed(
        context,
        '/payment-webview',
        arguments: {
          'url': paymentUrl,
          'method': _selectedMethod,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan Summary
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thông tin gói',
                          style: AppTextStyles.h4,
                        ),
                        const SizedBox(height: AppDimensions.paddingM),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.plan['name'],
                              style: AppTextStyles.bodyMedium,
                            ),
                            Text(
                              '${widget.plan['price']}đ',
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppDimensions.paddingXL),
                  
                  // Payment Method Selection
                  Text(
                    'Chọn phương thức thanh toán',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: AppDimensions.paddingM),
                  
                  // MoMo Option
                  _buildPaymentMethodCard(
                    method: PaymentMethod.momo,
                    title: 'Ví MoMo',
                    subtitle: 'Thanh toán qua ví điện tử MoMo',
                    logoAsset: 'assets/images/momo_logo.png',
                    logoColor: const Color(0xFFD82D8B), // MoMo pink
                  ),
                  
                  const SizedBox(height: AppDimensions.paddingM),
                  
                  // VNPay Option
                  _buildPaymentMethodCard(
                    method: PaymentMethod.vnpay,
                    title: 'VNPay',
                    subtitle: 'Thanh toán qua cổng VNPay',
                    logoAsset: 'assets/images/vnpay_logo.png',
                    logoColor: const Color(0xFF0066B3), // VNPay blue
                  ),
                ],
              ),
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
                  onPressed: _isProcessing ? null : _onProceedPayment,
                  child: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppColors.textPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Thanh toán'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required PaymentMethod method,
    required String title,
    required String subtitle,
    required String logoAsset,
    required Color logoColor,
  }) {
    final isSelected = _selectedMethod == method;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Logo
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: logoColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: Center(
                child: Image.asset(
                  logoAsset,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.payment,
                      color: logoColor,
                      size: 32,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h4,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Radio
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.textPrimary,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
