/// Subscription bundle (package) a user can purchase to upgrade their role.
class Bundle {
  final String id;
  final String name;
  final String description;
  final int price; // VND, no decimals
  final String billingCycle; // MONTHLY / QUARTERLY / YEARLY
  final int durationDays;
  final String roleName; // role granted on purchase, e.g. "Premium"
  final List<String> features;
  final bool active;

  Bundle({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.billingCycle,
    required this.durationDays,
    required this.roleName,
    required this.features,
    required this.active,
  });

  factory Bundle.fromJson(Map<String, dynamic> json) {
    return Bundle(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      billingCycle: json['billingCycle'] as String? ?? 'MONTHLY',
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 30,
      roleName: json['roleName'] as String? ?? 'Premium',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      active: json['active'] as bool? ?? true,
    );
  }

  /// Request body for create/update (admin).
  Map<String, dynamic> toRequestJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'billingCycle': billingCycle,
      'roleName': roleName,
      'features': features,
      'active': active,
    };
  }

  Bundle copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    String? billingCycle,
    int? durationDays,
    String? roleName,
    List<String>? features,
    bool? active,
  }) {
    return Bundle(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      durationDays: durationDays ?? this.durationDays,
      roleName: roleName ?? this.roleName,
      features: features ?? this.features,
      active: active ?? this.active,
    );
  }
}
