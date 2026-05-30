# Data Models

## 1. User Model

```dart
class User {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? premiumExpiresAt;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    required this.role,
    required this.createdAt,
    this.premiumExpiresAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      role: UserRole.fromString(json['role']),
      createdAt: DateTime.parse(json['created_at']),
      premiumExpiresAt: json['premium_expires_at'] != null
          ? DateTime.parse(json['premium_expires_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'role': role.toString(),
      'created_at': createdAt.toIso8601String(),
      'premium_expires_at': premiumExpiresAt?.toIso8601String(),
    };
  }

  bool get isPremium => role == UserRole.premium;
  bool get isFree => role == UserRole.free;
}

enum UserRole {
  guest,
  free,
  premium,
  admin;

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'guest':
        return UserRole.guest;
      case 'free':
        return UserRole.free;
      case 'premium':
        return UserRole.premium;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.guest;
    }
  }
}
```

## 2. Manga Model

```dart
class Manga {
  final String id;
  final String title;
  final String? author;
  final String? description;
  final String coverImageUrl;
  final List<String> genres;
  final MangaStatus status;
  final int totalChapters;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFeatured;
  final double? rating;

  Manga({
    required this.id,
    required this.title,
    this.author,
    this.description,
    required this.coverImageUrl,
    required this.genres,
    required this.status,
    required this.totalChapters,
    required this.createdAt,
    required this.updatedAt,
    this.isFeatured = false,
    this.rating,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      coverImageUrl: json['cover_image_url'],
      genres: List<String>.from(json['genres'] ?? []),
      status: MangaStatus.fromString(json['status']),
      totalChapters: json['total_chapters'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isFeatured: json['is_featured'] ?? false,
      rating: json['rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'cover_image_url': coverImageUrl,
      'genres': genres,
      'status': status.toString(),
      'total_chapters': totalChapters,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_featured': isFeatured,
      'rating': rating,
    };
  }
}

enum MangaStatus {
  ongoing,
  completed,
  hiatus;

  static MangaStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'ongoing':
        return MangaStatus.ongoing;
      case 'completed':
        return MangaStatus.completed;
      case 'hiatus':
        return MangaStatus.hiatus;
      default:
        return MangaStatus.ongoing;
    }
  }
}
```

## 3. Chapter Model

```dart
class Chapter {
  final String id;
  final String mangaId;
  final int chapterNumber;
  final String title;
  final List<String> imageUrls;
  final bool isPremium;
  final DateTime publishedAt;
  final int viewCount;

  Chapter({
    required this.id,
    required this.mangaId,
    required this.chapterNumber,
    required this.title,
    required this.imageUrls,
    this.isPremium = false,
    required this.publishedAt,
    this.viewCount = 0,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      mangaId: json['manga_id'],
      chapterNumber: json['chapter_number'],
      title: json['title'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      isPremium: json['is_premium'] ?? false,
      publishedAt: DateTime.parse(json['published_at']),
      viewCount: json['view_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'manga_id': mangaId,
      'chapter_number': chapterNumber,
      'title': title,
      'image_urls': imageUrls,
      'is_premium': isPremium,
      'published_at': publishedAt.toIso8601String(),
      'view_count': viewCount,
    };
  }

  int get totalPages => imageUrls.length;
}
```

## 4. Reading Progress Model

```dart
class ReadingProgress {
  final String id;
  final String userId;
  final String mangaId;
  final String chapterId;
  final int currentPage;
  final int totalPages;
  final DateTime lastReadAt;

  ReadingProgress({
    required this.id,
    required this.userId,
    required this.mangaId,
    required this.chapterId,
    required this.currentPage,
    required this.totalPages,
    required this.lastReadAt,
  });

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      id: json['id'],
      userId: json['user_id'],
      mangaId: json['manga_id'],
      chapterId: json['chapter_id'],
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      lastReadAt: DateTime.parse(json['last_read_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'manga_id': mangaId,
      'chapter_id': chapterId,
      'current_page': currentPage,
      'total_pages': totalPages,
      'last_read_at': lastReadAt.toIso8601String(),
    };
  }

  double get progressPercentage => (currentPage / totalPages) * 100;
  bool get isCompleted => currentPage >= totalPages;
}
```

## 5. Subscription Plan Model

```dart
class SubscriptionPlan {
  final String id;
  final String name;
  final int durationMonths;
  final double price;
  final String currency;
  final List<String> features;
  final bool isPopular;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.durationMonths,
    required this.price,
    this.currency = 'VND',
    required this.features,
    this.isPopular = false,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      name: json['name'],
      durationMonths: json['duration_months'],
      price: json['price'].toDouble(),
      currency: json['currency'] ?? 'VND',
      features: List<String>.from(json['features'] ?? []),
      isPopular: json['is_popular'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration_months': durationMonths,
      'price': price,
      'currency': currency,
      'features': features,
      'is_popular': isPopular,
    };
  }

  String get displayPrice => '${price.toStringAsFixed(0)} $currency';
}
```

## 6. Favorite Model

```dart
class Favorite {
  final String id;
  final String userId;
  final String mangaId;
  final DateTime createdAt;
  final Manga? manga; // Optional, populated when fetching with manga details

  Favorite({
    required this.id,
    required this.userId,
    required this.mangaId,
    required this.createdAt,
    this.manga,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'],
      userId: json['user_id'],
      mangaId: json['manga_id'],
      createdAt: DateTime.parse(json['created_at']),
      manga: json['manga'] != null ? Manga.fromJson(json['manga']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'manga_id': mangaId,
      'created_at': createdAt.toIso8601String(),
      'manga': manga?.toJson(),
    };
  }
}
```

## 7. Reading History Model

```dart
class ReadingHistory {
  final String id;
  final String userId;
  final String mangaId;
  final String chapterId;
  final DateTime readAt;
  final Manga? manga; // Optional
  final Chapter? chapter; // Optional

  ReadingHistory({
    required this.id,
    required this.userId,
    required this.mangaId,
    required this.chapterId,
    required this.readAt,
    this.manga,
    this.chapter,
  });

  factory ReadingHistory.fromJson(Map<String, dynamic> json) {
    return ReadingHistory(
      id: json['id'],
      userId: json['user_id'],
      mangaId: json['manga_id'],
      chapterId: json['chapter_id'],
      readAt: DateTime.parse(json['read_at']),
      manga: json['manga'] != null ? Manga.fromJson(json['manga']) : null,
      chapter: json['chapter'] != null ? Chapter.fromJson(json['chapter']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'manga_id': mangaId,
      'chapter_id': chapterId,
      'read_at': readAt.toIso8601String(),
      'manga': manga?.toJson(),
      'chapter': chapter?.toJson(),
    };
  }
}
```
