import 'package:flutter/material.dart';
import 'package:prm393_project/core/constants/app_colors.dart';

/// Enum representing user roles in the application
enum UserRole { guest, free, premium, manager, admin }

/// User model representing a user in the application
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final UserRole role;
  final DateTime? premiumExpiryDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.role,
    this.premiumExpiryDate,
  });

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['fullName'] as String? ?? json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.toString().toLowerCase() == 'userrole.${json['role']?.toString().toLowerCase()}',
        orElse: () => UserRole.guest,
      ),
      premiumExpiryDate: json['premiumExpiryDate'] != null
          ? DateTime.parse(json['premiumExpiryDate'] as String)
          : null,
    );
  }

  /// Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role.toString().split('.').last,
      'premiumExpiryDate': premiumExpiryDate?.toIso8601String(),
    };
  }

  /// Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    UserRole? role,
    DateTime? premiumExpiryDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
    );
  }

  /// Check if user is premium
  bool get isPremium => role == UserRole.premium;

  /// Check if user is free user
  bool get isFree => role == UserRole.free;

  /// Check if user is guest
  bool get isGuest => role == UserRole.guest;

  /// Check if user is admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is manager
  bool get isManager => role == UserRole.manager;

  /// Get role badge text for display
  String get roleBadgeText {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.premium:
        return 'Premium User';
      case UserRole.free:
        return 'Free User';
      case UserRole.guest:
        return 'Guest';
    }
  }

  /// Get role badge color for display
  Color get roleBadgeColor {
    switch (role) {
      case UserRole.admin:
        return AppColors.warning; // Yellow for admin
      case UserRole.manager:
        return AppColors.secondaryContainer; // Purple for manager
      case UserRole.premium:
        return AppColors.primary;
      case UserRole.free:
      case UserRole.guest:
        return AppColors.grey;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.avatarUrl == avatarUrl &&
        other.role == role &&
        other.premiumExpiryDate == premiumExpiryDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      avatarUrl,
      role,
      premiumExpiryDate,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role)';
  }
}
