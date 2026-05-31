import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/payment.dart';
import '../../../../providers/payment_provider.dart';
import '../admin_dashboard_screen.dart';

/// Read-only view of all users' transaction history (admin).
class AdminTransactionTab extends StatefulWidget {
  const AdminTransactionTab({super.key});

  @override
  State<AdminTransactionTab> createState() => _AdminTransactionTabState();
}

class _AdminTransactionTabState extends State<AdminTransactionTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchAllPayments(page: 0);
    });
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(dt.day)}/${two(dt.month)}/${dt.year} ${two(dt.hour)}:${two(dt.minute)}';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'SUCCESS':
        return AdminColors.green;
      case 'FAILED':
        return AdminColors.errorRed;
      default:
        return AdminColors.warningYellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TRANSACTION HISTORY',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 24,
                      color: AdminColors.onSurface,
                      letterSpacing: 1.5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: AdminColors.cyberCyan),
                    onPressed: () => provider.fetchAllPayments(),
                  ),
                ],
              ),
              if (!provider.isLoading)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Tổng giao dịch: ${provider.totalElements}',
                    style: const TextStyle(
                        color: AdminColors.onSurfaceVariant, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 8),
              if (provider.isLoading && provider.allPayments.isEmpty)
                const Center(
                    child:
                        CircularProgressIndicator(color: AdminColors.cyberCyan))
              else if (provider.errorMessage != null &&
                  provider.allPayments.isEmpty)
                Center(
                    child: Text(provider.errorMessage!,
                        style: const TextStyle(color: AdminColors.errorRed)))
              else if (provider.allPayments.isEmpty)
                const Center(
                    child: Text('Chưa có giao dịch nào.',
                        style: TextStyle(color: AdminColors.onSurfaceVariant)))
              else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.allPayments.length,
                  itemBuilder: (context, index) {
                    return _buildPaymentCard(provider.allPayments[index]);
                  },
                ),
                const SizedBox(height: 16),
                if (provider.totalPages > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left,
                            color: AdminColors.onSurface),
                        onPressed: provider.currentPage > 1
                            ? () => provider.setPage(provider.currentPage - 1)
                            : null,
                      ),
                      Text(
                        'PAGE ${provider.currentPage} OF ${provider.totalPages}',
                        style: GoogleFonts.spaceGrotesk(
                            color: AdminColors.onSurfaceVariant,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right,
                            color: AdminColors.onSurface),
                        onPressed: provider.currentPage < provider.totalPages
                            ? () => provider.setPage(provider.currentPage + 1)
                            : null,
                      ),
                    ],
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        border: Border.all(color: AdminColors.outlineVariant),
        boxShadow: const [
          BoxShadow(color: AdminColors.cyberCyan, offset: Offset(2, 2))
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long, color: AdminColors.cyberCyan),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(payment.bundleName,
                    style: GoogleFonts.bebasNeue(
                        fontSize: 18, color: AdminColors.onSurface)),
                Text(
                  '${_formatPrice(payment.amount)} VNĐ • ${payment.method}',
                  style: const TextStyle(
                      color: AdminColors.onSurfaceVariant, fontSize: 12),
                ),
                Text(
                  'User: ${payment.accountId}',
                  style: const TextStyle(
                      color: AdminColors.onSurfaceVariant, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
                if (payment.createdAt != null)
                  Text(
                    _formatDate(payment.createdAt),
                    style: const TextStyle(
                        color: AdminColors.onSurfaceVariant, fontSize: 10),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: _statusColor(payment.status)),
            ),
            child: Text(
              payment.status,
              style: TextStyle(
                fontSize: 10,
                color: _statusColor(payment.status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
