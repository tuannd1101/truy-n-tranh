# Design Document: Vietnamize UI

## Overview

This design document outlines the architecture and implementation approach for vietnamizing the MangaFlow Flutter application. The solution uses a centralized constants file approach to replace all English UI text with Vietnamese translations while preserving manga-specific terminology and ensuring proper text rendering within the existing Manga Brutalism design system.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter UI Layer                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ Client       │  │ Admin        │  │ Shared       │  │
│  │ Screens      │  │ Screens      │  │ Widgets      │  │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  │
│         │                  │                  │          │
│         └──────────────────┼──────────────────┘          │
│                            │                             │
│                            ▼                             │
│                ┌───────────────────────┐                 │
│                │  AppStringsVi         │                 │
│                │  Constants File       │                 │
│                └───────────────────────┘                 │
└─────────────────────────────────────────────────────────┘
```

### Component Design

#### 1. String Constants File (`lib/core/constants/app_strings_vi.dart`)

The centralized constants file organizes all Vietnamese strings by functional category:

```dart
class AppStringsVi {
  // Private constructor to prevent instantiation
  AppStringsVi._();
  
  // ═══════════════════════════════════════════════════════
  // AUTHENTICATION
  // ═══════════════════════════════════════════════════════
  static const String loginTitle = 'ĐĂNG NHẬP';
  static const String loginSubtitle = 'Chào mừng trở lại';
  static const String emailLabel = 'Email';
  static const String emailHint = 'otaku@mangaflow.com';
  static const String passwordLabel = 'Mật khẩu';
  static const String passwordHint = '••••••••';
  static const String signInButton = 'ĐĂNG NHẬP';
  static const String forgotPassword = 'Quên mật khẩu?';
  static const String newUserPrompt = 'Người dùng mới? ';
  static const String startJourney = 'Bắt đầu hành trình';
  static const String registerTitle = 'ĐĂNG KÝ';
  static const String registerSubtitle = 'Tạo tài khoản mới';
  static const String confirmPasswordLabel = 'Xác nhận mật khẩu';
  static const String signUpButton = 'ĐĂNG KÝ';
  static const String alreadyHaveAccount = 'Đã có tài khoản? ';
  static const String signInLink = 'Đăng nhập';
  
  // ═══════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════
  static const String homeNav = 'Trang chủ';
  static const String searchNav = 'Tìm kiếm';
  static const String libraryNav = 'Thư viện';
  static const String profileNav = 'Hồ sơ';
  static const String settingsNav = 'Cài đặt';
  static const String adminDashboardNav = 'Bảng điều khiển';
  
  // ═══════════════════════════════════════════════════════
  // HOME SCREEN
  // ═══════════════════════════════════════════════════════
  static const String searchPlaceholder = 'Tìm kiếm truyện, tác giả...';
  static const String allGenres = 'Tất cả';
  static const String featuredToday = 'NỔI BẬT HÔM NAY';
  static const String recentlyUpdated = 'MỚI CẬP NHẬT';
  static const String viewAll = 'XEM TẤT CẢ';
  static const String noMangaAvailable = 'Chưa có truyện nào.';
  static const String hotTag = 'HOT';
  static const String newTag = 'NEW';
  
  // ═══════════════════════════════════════════════════════
  // MANGA DETAIL SCREEN
  // ═══════════════════════════════════════════════════════
  static const String synopsis = 'Tóm tắt';
  static const String chapters = 'Chương';
  static const String readNow = 'ĐỌC NGAY';
  static const String addToLibrary = 'THÊM VÀO THƯ VIỆN';
  static const String share = 'CHIA SẺ';
  static const String author = 'Tác giả';
  static const String artist = 'Họa sĩ';
  static const String status = 'Trạng thái';
  static const String statusOngoing = 'Đang tiến hành';
  static const String statusCompleted = 'Hoàn thành';
  static const String statusHiatus = 'Tạm ngưng';
  static const String genres = 'Thể loại';
  static const String rating = 'Đánh giá';
  
  // ═══════════════════════════════════════════════════════
  // READING SCREEN
  // ═══════════════════════════════════════════════════════
  static const String previousChapter = 'Chương trước';
  static const String nextChapter = 'Chương sau';
  static const String chapterList = 'Danh sách chương';
  static const String settings = 'Cài đặt';
  static const String readingMode = 'Chế độ đọc';
  static const String verticalScroll = 'Cuộn dọc';
  static const String horizontalPage = 'Lật ngang';
  
  // ═══════════════════════════════════════════════════════
  // PROFILE SCREEN
  // ═══════════════════════════════════════════════════════
  static const String myProfile = 'Hồ sơ của tôi';
  static const String readingHistory = 'Lịch sử đọc';
  static const String favorites = 'Yêu thích';
  static const String subscriptionStatus = 'Trạng thái đăng ký';
  static const String accountSettings = 'Cài đặt tài khoản';
  static const String logout = 'Đăng xuất';
  static const String editProfile = 'Chỉnh sửa hồ sơ';
  
  // ═══════════════════════════════════════════════════════
  // SUBSCRIPTION SCREEN
  // ═══════════════════════════════════════════════════════
  static const String subscriptionTitle = 'ĐĂNG KÝ PREMIUM';
  static const String subscriptionSubtitle = 'Mở khóa toàn bộ nội dung';
  static const String monthlyPlan = 'Gói tháng';
  static const String yearlyPlan = 'Gói năm';
  static const String subscribe = 'ĐĂNG KÝ';
  static const String currentPlan = 'Gói hiện tại';
  static const String renewalDate = 'Ngày gia hạn';
  static const String cancelSubscription = 'Hủy đăng ký';
  
  // ═══════════════════════════════════════════════════════
  // PAYMENT SCREEN
  // ═══════════════════════════════════════════════════════
  static const String paymentTitle = 'THANH TOÁN';
  static const String selectPaymentMethod = 'Chọn phương thức thanh toán';
  static const String creditCard = 'Thẻ tín dụng';
  static const String momo = 'Ví MoMo';
  static const String zalopay = 'ZaloPay';
  static const String bankTransfer = 'Chuyển khoản ngân hàng';
  static const String proceedToPayment = 'TIẾN HÀNH THANH TOÁN';
  static const String orderSummary = 'Tóm tắt đơn hàng';
  static const String total = 'Tổng cộng';
  
  // ═══════════════════════════════════════════════════════
  // PAYMENT RESULT SCREEN
  // ═══════════════════════════════════════════════════════
  static const String paymentSuccess = 'Thanh toán thành công!';
  static const String paymentFailed = 'Thanh toán thất bại';
  static const String paymentPending = 'Đang xử lý thanh toán';
  static const String returnToHome = 'VỀ TRANG CHỦ';
  static const String tryAgain = 'THỬ LẠI';
  static const String transactionId = 'Mã giao dịch';
  
  // ═══════════════════════════════════════════════════════
  // SEARCH SCREEN
  // ═══════════════════════════════════════════════════════
  static const String searchTitle = 'TÌM KIẾM';
  static const String searchHint = 'Nhập tên truyện hoặc tác giả...';
  static const String recentSearches = 'Tìm kiếm gần đây';
  static const String popularSearches = 'Tìm kiếm phổ biến';
  static const String searchResults = 'Kết quả tìm kiếm';
  static const String noResults = 'Không tìm thấy kết quả';
  static const String clearHistory = 'Xóa lịch sử';
  
  // ═══════════════════════════════════════════════════════
  // LIBRARY SCREEN
  // ═══════════════════════════════════════════════════════
  static const String myLibrary = 'Thư viện của tôi';
  static const String reading = 'Đang đọc';
  static const String completed = 'Đã hoàn thành';
  static const String planToRead = 'Dự định đọc';
  static const String dropped = 'Đã bỏ';
  static const String sortBy = 'Sắp xếp theo';
  static const String sortByTitle = 'Tên truyện';
  static const String sortByDate = 'Ngày thêm';
  static const String sortByRating = 'Đánh giá';
  
  // ═══════════════════════════════════════════════════════
  // ADMIN DASHBOARD
  // ═══════════════════════════════════════════════════════
  static const String adminDashboard = 'BẢNG ĐIỀU KHIỂN QUẢN TRỊ';
  static const String manageManga = 'Quản lý Manga';
  static const String manageChapters = 'Quản lý chương';
  static const String manageUsers = 'Quản lý người dùng';
  static const String manageCreators = 'Quản lý tác giả';
  static const String manageTags = 'Quản lý thẻ';
  static const String statistics = 'Thống kê';
  static const String totalManga = 'Tổng số truyện';
  static const String totalUsers = 'Tổng số người dùng';
  static const String totalChapters = 'Tổng số chương';
  static const String recentActivity = 'Hoạt động gần đây';
  
  // ═══════════════════════════════════════════════════════
  // ADMIN CHAPTER SCREEN
  // ═══════════════════════════════════════════════════════
  static const String chapterManagement = 'QUẢN LÝ CHƯƠNG';
  static const String addChapter = 'THÊM CHƯƠNG';
  static const String editChapter = 'CHỈNH SỬA CHƯƠNG';
  static const String deleteChapter = 'XÓA CHƯƠNG';
  static const String chapterNumber = 'Số chương';
  static const String chapterTitle = 'Tiêu đề chương';
  static const String uploadPages = 'Tải lên trang';
  static const String publishDate = 'Ngày xuất bản';
  static const String chapterStatus = 'Trạng thái chương';
  static const String published = 'Đã xuất bản';
  static const String draft = 'Bản nháp';
  
  // ═══════════════════════════════════════════════════════
  // ADMIN CHAPTER DETAIL SCREEN
  // ═══════════════════════════════════════════════════════
  static const String chapterDetails = 'CHI TIẾT CHƯƠNG';
  static const String pageCount = 'Số trang';
  static const String views = 'Lượt xem';
  static const String likes = 'Lượt thích';
  static const String comments = 'Bình luận';
  static const String reorderPages = 'Sắp xếp lại trang';
  static const String replacePages = 'Thay thế trang';
  
  // ═══════════════════════════════════════════════════════
  // COMMON ACTIONS
  // ═══════════════════════════════════════════════════════
  static const String save = 'Lưu';
  static const String cancel = 'Hủy';
  static const String delete = 'Xóa';
  static const String edit = 'Chỉnh sửa';
  static const String add = 'Thêm';
  static const String update = 'Cập nhật';
  static const String confirm = 'Xác nhận';
  static const String close = 'Đóng';
  static const String back = 'Quay lại';
  static const String next = 'Tiếp theo';
  static const String previous = 'Trước';
  static const String submit = 'Gửi';
  static const String reset = 'Đặt lại';
  
  // ═══════════════════════════════════════════════════════
  // STATUS MESSAGES
  // ═══════════════════════════════════════════════════════
  static const String success = 'Thành công';
  static const String error = 'Lỗi';
  static const String loading = 'Đang tải...';
  static const String processing = 'Đang xử lý...';
  static const String saved = 'Đã lưu';
  static const String deleted = 'Đã xóa';
  static const String updated = 'Đã cập nhật';
  
  // ═══════════════════════════════════════════════════════
  // ERROR MESSAGES
  // ═══════════════════════════════════════════════════════
  static const String errorGeneric = 'Đã xảy ra lỗi. Vui lòng thử lại.';
  static const String errorNetwork = 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối của bạn.';
  static const String errorAuth = 'Xác thực thất bại. Vui lòng đăng nhập lại.';
  static const String errorNotFound = 'Không tìm thấy nội dung.';
  static const String errorPermission = 'Bạn không có quyền thực hiện hành động này.';
  static const String errorTimeout = 'Yêu cầu hết thời gian chờ. Vui lòng thử lại.';
  
  // ═══════════════════════════════════════════════════════
  // VALIDATION MESSAGES
  // ═══════════════════════════════════════════════════════
  static const String validationRequired = 'Trường này là bắt buộc';
  static const String validationEmail = 'Email không hợp lệ';
  static const String validationPassword = 'Mật khẩu phải có ít nhất 6 ký tự';
  static const String validationPasswordMatch = 'Mật khẩu không khớp';
  static const String validationMinLength = 'Độ dài tối thiểu là';
  static const String validationMaxLength = 'Độ dài tối đa là';
  static const String validationNumeric = 'Chỉ được nhập số';
  
  // ═══════════════════════════════════════════════════════
  // MANGA TERMINOLOGY (PRESERVED)
  // ═══════════════════════════════════════════════════════
  static const String manga = 'Manga';
  static const String chapter = 'Chapter';
  static const String premium = 'Premium';
  static const String free = 'Free';
  static const String vol = 'VOL';
  
  // ═══════════════════════════════════════════════════════
  // DUAL LABELS (Japanese + Vietnamese)
  // ═══════════════════════════════════════════════════════
  static const String genreShounen = '少年 Thiếu Niên';
  static const String genreShoujo = '少女 Thiếu Nữ';
  static const String genreSeinen = '青年 Thanh Niên';
  static const String genreJosei = '女性 Phụ Nữ';
  static const String genreKodomo = '子供 Trẻ Em';
}
```

**Design Rationale:**
- Private constructor prevents instantiation, enforcing static-only usage
- Logical grouping with visual separators improves maintainability
- Descriptive constant names follow Dart `lowerCamelCase` convention
- Manga terminology preserved as specified
- Dual labels maintain Japanese characters with Vietnamese translations

#### 2. Screen Modification Pattern

Each screen follows this refactoring pattern:

**Before:**
```dart
Text('Search manga, author...')
```

**After:**
```dart
import '../../../core/constants/app_strings_vi.dart';

Text(AppStringsVi.searchPlaceholder)
```

**Implementation Steps per Screen:**
1. Add import statement for `app_strings_vi.dart`
2. Identify all hardcoded text strings
3. Replace with appropriate constant reference
4. Verify text rendering and layout
5. Test functionality preservation

#### 3. Text Overflow Handling

To prevent text overflow with longer Vietnamese strings:

```dart
// For single-line text with ellipsis
Text(
  AppStringsVi.longText,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
)

// For multi-line text with wrapping
Text(
  AppStringsVi.longText,
  maxLines: 3,
  overflow: TextOverflow.ellipsis,
)

// For buttons with flexible width
ElevatedButton(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(AppStringsVi.buttonText),
  ),
)
```

## Data Models

No new data models are required. The feature modifies presentation layer only.

## Interfaces

### AppStringsVi Interface

```dart
class AppStringsVi {
  AppStringsVi._(); // Private constructor
  
  // All constants are static const String
  static const String constantName = 'Vietnamese text';
}
```

**Usage Contract:**
- All constants are `static const String`
- Constants are accessed via `AppStringsVi.constantName`
- No instantiation allowed
- All strings are compile-time constants

## Error Handling

### Error Scenarios

1. **Missing Constant Reference**
   - **Scenario:** Screen references non-existent constant
   - **Handling:** Compile-time error prevents deployment
   - **Prevention:** Code review and testing

2. **Text Overflow**
   - **Scenario:** Vietnamese text exceeds container width
   - **Handling:** Apply `maxLines` and `overflow` properties
   - **Prevention:** Test with longest expected strings

3. **Inconsistent Translations**
   - **Scenario:** Same English term translated differently
   - **Handling:** Use single constant for each unique term
   - **Prevention:** Code review of constants file

## Implementation Approach

### Phase 1: Create Constants File
1. Create `lib/core/constants/app_strings_vi.dart`
2. Define all Vietnamese string constants
3. Organize by logical grouping
4. Verify naming conventions

### Phase 2: Refactor Client Screens
1. Import constants file in each screen
2. Replace hardcoded strings with constant references
3. Test text rendering and overflow handling
4. Verify functionality preservation

### Phase 3: Refactor Admin Screens
1. Import constants file in each admin screen
2. Replace hardcoded strings with constant references
3. Test text rendering and overflow handling
4. Verify functionality preservation

### Phase 4: Refactor Shared Widgets
1. Update shared widgets (MainDrawer, MainAppBar, etc.)
2. Replace hardcoded strings with constant references
3. Test across all screens using these widgets

### Phase 5: Verification
1. Visual inspection of all screens
2. Test all user flows
3. Verify no hardcoded English strings remain
4. Verify consistent terminology usage

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Constants file contains all required string keys

*For any* required UI text category (authentication, navigation, errors, validation, actions, status, manga terms, dual labels), the String_Constants_File SHALL contain at least one constant definition for that category.

**Validates: Requirements 2.1, 2.4**

### Property 2: All constant names follow Dart naming conventions

*For any* constant defined in the String_Constants_File, the constant name SHALL match the lowerCamelCase pattern (starts with lowercase letter, followed by alphanumeric characters with uppercase letters for word boundaries, no underscores except for private members).

**Validates: Requirements 2.5**

### Property 3: Manga terminology is preserved unchanged

*For any* Manga_Term in the set {"Manga", "Chapter", "Premium", "Free", "VOL"}, the String_Constants_File SHALL contain a constant with that exact English value unchanged.

**Validates: Requirements 3.1, 3.3**

### Property 4: Dual labels maintain correct format

*For any* constant in the String_Constants_File that contains Japanese characters, the value SHALL match the pattern "[Japanese characters] [Vietnamese text]" where Japanese characters are followed by a space and Vietnamese translation.

**Validates: Requirements 3.2, 3.4**

### Property 5: No hardcoded English strings in screen files

*For any* screen file in Client_Screen or Admin_Screen directories, the file SHALL NOT contain hardcoded English string literals (excluding import statements, comments, and constant names).

**Validates: Requirements 7.1, 7.2, 7.3**

### Property 6: All screen files import the constants file

*For any* screen file in Client_Screen or Admin_Screen directories that displays UI text, the file SHALL contain an import statement for `app_strings_vi.dart`.

**Validates: Requirements 2.3**

### Property 7: Common action terms have consistent translations

*For any* common action term in the set {"save", "cancel", "delete", "edit", "add", "update", "confirm", "close", "back", "next", "previous", "submit", "reset"}, the String_Constants_File SHALL define exactly one Vietnamese constant for that action.

**Validates: Requirements 8.2**

### Property 8: Status message terms have consistent translations

*For any* status message term in the set {"success", "error", "loading", "processing", "saved", "deleted", "updated"}, the String_Constants_File SHALL define exactly one Vietnamese constant for that status.

**Validates: Requirements 8.3**

### Property 9: All constant names are unique

*For any* two constants in the String_Constants_File, the constant names SHALL be distinct (no duplicate constant names).

**Validates: Requirements 8.4**

### Property 10: Constants file exists at specified location

The String_Constants_File SHALL exist at the path `lib/core/constants/app_strings_vi.dart`.

**Validates: Requirements 2.2**

## Testing Strategy

### Property-Based Tests

Property-based tests will verify the correctness properties defined above by:
- Parsing the constants file to extract all constant definitions
- Parsing screen files to detect hardcoded strings and imports
- Validating naming conventions using regex patterns
- Verifying format patterns for dual labels
- Checking uniqueness and consistency constraints

### Integration Tests

Integration tests will verify:
- Each screen renders Vietnamese text correctly
- Text overflow handling works as expected
- All user flows function correctly with Vietnamese text
- Admin dashboard displays Vietnamese labels
- Error messages display in Vietnamese

### Manual Testing

Manual verification will include:
- Visual inspection of all screens
- Testing with various screen sizes
- Verifying text readability and layout
- Confirming manga terminology preservation
- Checking dual label formatting

## Code Examples

### Example 1: Home Screen Refactoring

**Before:**
```dart
Text(
  'Tìm kiếm truyện, tác giả...',
  style: TextStyle(
    color: AppColors.onSurfaceVariant,
    fontFamily: 'Syne',
    fontWeight: FontWeight.bold,
  ),
)
```

**After:**
```dart
import '../../../core/constants/app_strings_vi.dart';

Text(
  AppStringsVi.searchPlaceholder,
  style: TextStyle(
    color: AppColors.onSurfaceVariant,
    fontFamily: 'Syne',
    fontWeight: FontWeight.bold,
  ),
)
```

### Example 2: Login Screen Refactoring

**Before:**
```dart
const Text(
  'ENTER THE FLOW',
  style: TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: AppColors.onSurface,
    letterSpacing: 4,
  ),
)
```

**After:**
```dart
import '../../../core/constants/app_strings_vi.dart';

Text(
  AppStringsVi.loginTitle,
  style: const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: AppColors.onSurface,
    letterSpacing: 4,
  ),
)
```

### Example 3: Error Message Handling

**Before:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
);
```

**After:**
```dart
import '../../../core/constants/app_strings_vi.dart';

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(AppStringsVi.validationRequired)),
);
```

### Example 4: Admin Dashboard Refactoring

**Before:**
```dart
Text(
  'BẢNG ĐIỀU KHIỂN QUẢN TRỊ',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)
```

**After:**
```dart
import '../../../core/constants/app_strings_vi.dart';

Text(
  AppStringsVi.adminDashboard,
  style: const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)
```

## Performance Considerations

- **Compile-time constants:** All strings are `const`, resulting in zero runtime overhead
- **No i18n library:** Direct constant references avoid library overhead
- **Memory efficiency:** Single constants file loaded once, shared across all screens
- **Build time:** No impact on build time as constants are resolved at compile time

## Maintenance Considerations

- **Single source of truth:** All Vietnamese strings in one file
- **Easy updates:** Modify constants file to update translations
- **Searchability:** Easy to find all usages of a constant
- **Consistency:** Enforced through single constant per term
- **Extensibility:** Easy to add new constants as needed

## Security Considerations

No security implications. This is a presentation-layer change only.

## Accessibility Considerations

- Vietnamese text improves accessibility for Vietnamese-speaking users
- Screen readers will read Vietnamese text correctly
- Text overflow handling ensures all content is accessible
- Consistent terminology improves cognitive accessibility

## Localization Considerations

While this implementation uses direct constants rather than an i18n library, the architecture supports future localization:
- Constants file can be duplicated for other languages (e.g., `app_strings_en.dart`)
- Screen code remains unchanged, only import statement changes
- Future migration to i18n library is straightforward

## Dependencies

- **Flutter SDK:** Existing dependency
- **Dart:** Existing dependency
- **No new dependencies required**

## Constraints

- Must preserve existing Manga Brutalism design aesthetic
- Must maintain all existing functionality
- Must not introduce performance regression
- Must handle text overflow gracefully
- Must preserve manga-specific terminology
