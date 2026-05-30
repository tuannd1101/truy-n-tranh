# Frontend Architecture & Specifications (Flutter)

## 1. State Management & Architecture

- **Pattern**: Provider or BLoC for clean Separation of Concerns (SoC).
- **Network Client**: `Dio` package with Interceptors to automatically attach JWT Bearer tokens to all outbound requests.

## 2. Key Screen Mockups & UI Logic

- **Authentication**: Login/Register screens handling token persistence via `flutter_secure_storage`.
- **Manga Feed**: ListView/GridView with search bar and genre chips filter.
- **Manga Detail Screen**: Shows summary, cover image, and list of chapters. If a chapter is premium and user is free, render a "Lock" icon.
- **Manga Reader Screen**:
  - Uses `ListView.builder` (Vertical scroll) or `PageView.builder` (Horizontal swipe).
  - Uses `cached_network_image` to handle smooth image rendering, error placeholders, and local storage caching.
- **Profile & Upgrade**: Display current role status. Payment section triggers the deep linking/webview flow for VNPay/MoMo.

## 3. Error Handling

- Intercept `403 Forbidden` response globally. If a user tries to access a premium chapter without the role, trigger an alert dialog redirecting them to the Upgrade Screen.
