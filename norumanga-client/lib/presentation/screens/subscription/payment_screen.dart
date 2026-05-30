import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/payment_provider.dart';

class PaymentScreen extends StatefulWidget {
  final String? bundleId;
  final String planName;
  final int price;

  const PaymentScreen({
    super.key,
    this.bundleId,
    this.planName = 'Premium 1 Tháng',
    this.price = 49000,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Currently MoMo is the only supported method.
  final String _selectedMethod = 'momo';

  Future<void> _handlePayment() async {
    final bundleId = widget.bundleId;
    if (bundleId == null || bundleId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không xác định được gói đăng ký.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final paymentProvider = context.read<PaymentProvider>();
    final authProvider = context.read<AuthProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.gold),
      ),
    );

    final payment = await paymentProvider.purchase(
      bundleId: bundleId,
      method: 'MOMO',
    );

    // Refresh the user so the upgraded role is reflected app-wide.
    if (payment != null) {
      await authProvider.fetchCurrentUser();
    }

    if (!mounted) return;
    Navigator.pop(context); // close loading

    Navigator.pushReplacementNamed(
      context,
      AppRouter.paymentResult,
      arguments: {
        'success': payment != null,
        'method': _selectedMethod,
        'message': payment == null ? paymentProvider.errorMessage : null,
      },
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'THANH TOÁN',
          style: TextStyle(
            fontFamily: 'Anton',
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bill Summary
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B23),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryContainer, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THÔNG TIN ĐƠN HÀNG',
                    style: TextStyle(
                      color: AppColors.primaryContainer,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const Divider(color: AppColors.outline, height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Gói đăng ký',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      Flexible(
                        child: Text(
                          widget.planName,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng tiền',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      Text(
                        '${_formatPrice(widget.price)} VNĐ',
                        style: const TextStyle(
                          fontFamily: 'Anton',
                          color: AppColors.gold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Payment Methods
            const Text(
              'PHƯƠNG THỨC THANH TOÁN',
              style: TextStyle(
                fontFamily: 'Anton',
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethod(
              id: 'momo',
              name: 'Ví MoMo',
              color: const Color(0xFFA50064),
              icon: Icons.account_balance_wallet,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: _handlePayment,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'XÁC NHẬN THANH TOÁN',
                  style: TextStyle(
                    fontFamily: 'Anton',
                    fontSize: 20,
                    color: Colors.white,
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

  Widget _buildPaymentMethod({
    required String id,
    required String name,
    required Color color,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == id;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : const Color(0xFF1B1B23),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : AppColors.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
            color: isSelected ? color : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
