import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String url;
  final dynamic method;

  const PaymentWebViewScreen({
    super.key,
    required this.url,
    required this.method,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // TODO: Initialize WebView
    // Listen for URL changes to detect payment success/failure
    _simulatePayment();
  }

  Future<void> _simulatePayment() async {
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      // Simulate successful payment
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        // Navigate to success screen
        Navigator.pushReplacementNamed(
          context,
          '/payment-result',
          arguments: {
            'success': true,
          },
        );
      }
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
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Hủy thanh toán'),
                content: const Text(
                  'Bạn có chắc chắn muốn hủy thanh toán?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Không'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close webview
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    child: const Text('Hủy'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // TODO: Implement WebView here
          // Use webview_flutter package
          // WebView(
          //   initialUrl: widget.url,
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onPageStarted: (url) {
          //     setState(() {
          //       _isLoading = true;
          //     });
          //   },
          //   onPageFinished: (url) {
          //     setState(() {
          //       _isLoading = false;
          //     });
          //     // Check if URL contains success/failure indicators
          //     if (url.contains('payment-success')) {
          //       Navigator.pushReplacementNamed(
          //         context,
          //         '/payment-result',
          //         arguments: {'success': true},
          //       );
          //     } else if (url.contains('payment-failure')) {
          //       Navigator.pushReplacementNamed(
          //         context,
          //         '/payment-result',
          //         arguments: {'success': false},
          //       );
          //     }
          //   },
          // ),
          
          // Placeholder for WebView
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.payment,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Đang xử lý thanh toán...',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng không đóng màn hình này',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          if (_isLoading)
            Container(
              color: AppColors.surface.withOpacity(0.8),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
