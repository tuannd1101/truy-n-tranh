/// A payment transaction record (the user's transaction history).
class Payment {
  final String id;
  final String accountId;
  final String bundleId;
  final String bundleName;
  final int amount; // VND
  final String method; // MOMO
  final String status; // PENDING / SUCCESS / FAILED
  final String? transactionRef;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  Payment({
    required this.id,
    required this.accountId,
    required this.bundleId,
    required this.bundleName,
    required this.amount,
    required this.method,
    required this.status,
    this.transactionRef,
    this.expiresAt,
    this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String? ?? '',
      accountId: json['accountId'] as String? ?? '',
      bundleId: json['bundleId'] as String? ?? '',
      bundleName: json['bundleName'] as String? ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      method: json['method'] as String? ?? 'MOMO',
      status: json['status'] as String? ?? 'PENDING',
      transactionRef: json['transactionRef'] as String?,
      expiresAt: _parseDate(json['expiresAt']),
      createdAt: _parseDate(json['createdAt']),
    );
  }

  bool get isSuccess => status == 'SUCCESS';

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }
}
