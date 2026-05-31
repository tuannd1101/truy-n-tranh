/// Admin-facing user model for the User Management screen.
class AdminUser {
  final String id;
  final String fullName;
  final String email;
  final String status;
  final String? roleId;
  final String roleName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdminUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.status,
    this.roleId,
    required this.roleName,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      status: json['status'] as String? ?? 'ACTIVE',
      roleId: json['roleId'] as String?,
      roleName: json['roleName'] as String? ?? 'Free',
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  String get initial =>
      fullName.trim().isNotEmpty ? fullName.trim()[0].toUpperCase() : '?';

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }
}
