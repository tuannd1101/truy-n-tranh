# Flutter Project Structure

## Cấu trúc thư mục đề xuất

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # MaterialApp config
│
├── core/                              # Core functionality
│   ├── constants/
│   │   ├── app_colors.dart           # Color palette
│   │   ├── app_text_styles.dart      # Text styles
│   │   ├── app_dimensions.dart       # Spacing, sizes
│   │   └── api_endpoints.dart        # API URLs
│   ├── theme/
│   │   ├── app_theme.dart            # Light/Dark theme
│   │   └── theme_provider.dart       # Theme state management
│   ├── utils/
│   │   ├── validators.dart           # Form validators
│   │   ├── date_formatter.dart       # Date utilities
│   │   └── image_helper.dart         # Image utilities
│   └── routes/
│       ├── app_routes.dart           # Route names
│       └── route_generator.dart      # Route configuration
│
├── data/                              # Data layer
│   ├── models/
│   │   ├── manga.dart                # Manga model
│   │   ├── chapter.dart              # Chapter model
│   │   ├── user.dart                 # User model
│   │   ├── subscription.dart         # Subscription model
│   │   └── reading_history.dart      # Reading history model
│   ├── repositories/
│   │   ├── manga_repository.dart     # Manga data operations
│   │   ├── auth_repository.dart      # Auth operations
│   │   ├── user_repository.dart      # User operations
│   │   └── payment_repository.dart   # Payment operations
│   └── services/
│       ├── api_service.dart          # Dio HTTP client
│       ├── storage_service.dart      # Local storage (SharedPreferences)
│       └── secure_storage_service.dart # Secure storage (JWT tokens)
│
├── providers/                         # State management (Provider)
│   ├── auth_provider.dart            # Authentication state
│   ├── manga_provider.dart           # Manga list state
│   ├── chapter_provider.dart         # Chapter reading state
│   ├── user_provider.dart            # User profile state
│   ├── favorites_provider.dart       # Favorites state
│   └── theme_provider.dart           # Theme state
│
├── screens/                           # UI Screens
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── banner_carousel.dart
│   │       ├── manga_card.dart
│   │       └── section_header.dart
│   ├── search/
│   │   ├── search_screen.dart
│   │   └── widgets/
│   │       ├── search_bar_widget.dart
│   │       └── filter_chip_list.dart
│   ├── manga/
│   │   ├── manga_detail_screen.dart
│   │   ├── manga_reading_screen.dart
│   │   └── widgets/
│   │       ├── chapter_list_item.dart
│   │       └── reading_controls.dart
│   ├── library/
│   │   ├── library_screen.dart
│   │   └── widgets/
│   │       ├── reading_progress_card.dart
│   │       └── favorite_grid_item.dart
│   ├── profile/
│   │   ├── profile_screen.dart
│   │   ├── reading_history_screen.dart
│   │   ├── favorites_screen.dart
│   │   ├── settings_screen.dart
│   │   └── widgets/
│   │       ├── profile_header.dart
│   │       └── premium_banner.dart
│   └── payment/
│       ├── subscription_screen.dart
│       ├── payment_screen.dart
│       └── widgets/
│           ├── subscription_card.dart
│           └── payment_method_item.dart
│
└── widgets/                           # Shared widgets
    ├── custom_app_bar.dart
    ├── custom_button.dart
    ├── custom_text_field.dart
    ├── loading_indicator.dart
    ├── error_widget.dart
    ├── empty_state_widget.dart
    └── bottom_nav_bar.dart
```

## Naming Conventions

### Files

- **Screens:** `[name]_screen.dart` (ví dụ: `home_screen.dart`)
- **Widgets:** `[name]_widget.dart` hoặc `[name].dart` (ví dụ: `manga_card.dart`)
- **Models:** `[name].dart` (ví dụ: `manga.dart`)
- **Providers:** `[name]_provider.dart` (ví dụ: `auth_provider.dart`)
- **Services:** `[name]_service.dart` (ví dụ: `api_service.dart`)

### Classes

- **Screens:** `[Name]Screen` (ví dụ: `HomeScreen`)
- **Widgets:** `[Name]Widget` hoặc `[Name]` (ví dụ: `MangaCard`)
- **Models:** `[Name]` (ví dụ: `Manga`)
- **Providers:** `[Name]Provider` (ví dụ: `AuthProvider`)

### Variables

- **camelCase** cho biến và hàm: `userName`, `fetchMangaList()`
- **UPPER_CASE** cho constants: `API_BASE_URL`, `MAX_RETRY_COUNT`

## Dependencies cần thiết (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.1

  # Network
  dio: ^5.4.0

  # Local Storage
  shared_preferences: ^2.2.2
  flutter_secure_storage: ^9.0.0

  # UI
  cached_network_image: ^3.3.1
  carousel_slider: ^4.2.1
  smooth_page_indicator: ^1.1.0

  # WebView
  webview_flutter: ^4.4.4

  # Utils
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```
