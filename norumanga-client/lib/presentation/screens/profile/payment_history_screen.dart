import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/payment.dart';
import '../../../providers/payment_provider.dart';
import '../../widgets/main_app_bar.dart';
import '../../widgets/main_drawer.dart';

/// Shows the authenticated user's own purchase/transaction history
/// (backend: `GET /api/payments/me`).
class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchMyPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const MainAppBar(),
      drawer: const MainDrawer(),
      body: Consumer<PaymentProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            color: AppColors.primaryContainer,
            backgroundColor: AppColors.surfaceContainer,
            onRefresh: () => provider.fetchMyPayments(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader()),
                if (provider.isLoading && provider.payments.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  )
                else if (provider.errorMessage != null &&
                    provider.payments.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildError(provider.errorMessage!),
                  )
                else if (provider.payments.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmpty(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildPaymentCard(provider.payments[index]),
                        childCount: provider.payments.length,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          Container(width: 4, height: 24, color: AppColors.gold),
          const SizedBox(width: 8),
          const Text(
            'LỊCH SỬ GIAO DỊCH',
            style: TextStyle(
              fontFamily: 'Anton',
              color: AppColors.onSurface,
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    final statusColor = _statusColor(payment.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B23),
        border: Border.all(color: Colors.white24, width: 2),
        boxShadow: const [
          BoxShadow(color: AppColors.gold, offset: Offset(4, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: AppColors.gold,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.bundleName.isEmpty
                            ? 'Gói Premium'
                            : payment.bundleName,
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Phương thức: ${payment.method}',
                        style: const TextStyle(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _statusBadge(payment.status, statusColor),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: Colors.white12),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Số tiền',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                Text(
                  Formatters.formatVND(payment.amount),
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            if (payment.createdAt != null) ...[
              const SizedBox(height: 8),
              _infoRow(
                'Ngày giao dịch',
                Formatters.formatDateTime(payment.createdAt!),
              ),
            ],
            if (payment.expiresAt != null) ...[
              const SizedBox(height: 8),
              _infoRow(
                'Hết hạn',
                Formatters.formatDateTime(payment.expiresAt!),
              ),
            ],
            if (payment.transactionRef != null &&
                payment.transactionRef!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _infoRow('Mã giao dịch', payment.transactionRef!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Text(
        _statusLabel(status),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SUCCESS':
        return Colors.greenAccent;
      case 'FAILED':
        return Colors.redAccent;
      default:
        return AppColors.gold;
    }
  }

  String _statusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'SUCCESS':
        return 'THÀNH CÔNG';
      case 'FAILED':
        return 'THẤT BẠI';
      default:
        return 'ĐANG XỬ LÝ';
    }
  }

  Widget _buildEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.receipt_long, size: 64, color: AppColors.outline),
        const SizedBox(height: 16),
        const Text(
          'Chưa có giao dịch nào',
          style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 15),
        ),
        const SizedBox(height: 8),
        const Text(
          'Nâng cấp Premium để mở khóa toàn bộ truyện',
          style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRouter.subscription),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.gold,
            foregroundColor: Colors.black,
          ),
          icon: const Icon(Icons.workspace_premium),
          label: const Text('NÂNG CẤP NGAY'),
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.onSurfaceVariant),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => context.read<PaymentProvider>().fetchMyPayments(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
          ),
          child: const Text('THỬ LẠI'),
        ),
      ],
    );
  }
}
