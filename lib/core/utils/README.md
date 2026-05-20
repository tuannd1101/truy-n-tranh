# Core Utilities

This directory contains utility classes that provide common functionality across the application.

## Available Utilities

### 1. Validators (`validators.dart`)

Provides form validation functions for common input types.

**Usage Examples:**

```dart
import 'package:prm393_project/core/utils/validators.dart';

// Email validation
String? emailError = Validators.validateEmail('user@example.com');

// Password validation
String? passwordError = Validators.validatePassword('myPass123');

// Username validation
String? usernameError = Validators.validateUsername('john_doe');

// In a form field
TextFormField(
  validator: Validators.validateEmail,
  decoration: InputDecoration(labelText: 'Email'),
)
```

**Available Validators:**

- `validateEmail(String? value)` - Email format validation
- `validatePassword(String? value)` - Password strength validation (min 6 chars, letter + number)
- `validateConfirmPassword(String? value, String? password)` - Password confirmation
- `validateUsername(String? value)` - Username validation (3-20 chars, alphanumeric + underscore)
- `validateName(String? value)` - Name validation (2-50 chars)
- `validatePhone(String? value)` - Vietnamese phone number validation
- `validateRequired(String? value, {String fieldName})` - Required field validation
- `validateMinLength(String? value, int minLength, {String fieldName})` - Minimum length
- `validateMaxLength(String? value, int maxLength, {String fieldName})` - Maximum length
- `validateNumeric(String? value, {String fieldName})` - Numeric validation
- `validateUrl(String? value)` - URL format validation
- `validateAge(String? value)` - Age validation (13+)
- `combine(List<String? Function()> validators)` - Combine multiple validators

### 2. Formatters (`formatters.dart`)

Provides formatting functions for numbers, currency, dates, and text.

**Usage Examples:**

```dart
import 'package:prm393_project/core/utils/formatters.dart';

// Number formatting
String formatted = Formatters.formatNumber(1234567); // "1,234,567"
String compact = Formatters.formatCompactNumber(1500000); // "1.5M"
String percentage = Formatters.formatPercentage(75); // "75%"

// Currency formatting
String vnd = Formatters.formatVND(50000); // "50,000đ"
String compactVnd = Formatters.formatCompactVND(1000000); // "1Mđ"
String usd = Formatters.formatUSD(1234.56); // "$1,234.56"

// Date formatting
String date = Formatters.formatDate(DateTime.now()); // "15/01/2024"
String dateTime = Formatters.formatDateTime(DateTime.now()); // "15/01/2024 14:30"

// Text formatting
String truncated = Formatters.truncateText('Long text here', 10); // "Long te..."
String capitalized = Formatters.capitalize('hello'); // "Hello"
String titleCase = Formatters.toTitleCase('HELLO WORLD'); // "Hello World"

// File size formatting
String fileSize = Formatters.formatFileSize(1048576); // "1.0 MB"

// Duration formatting
String duration = Formatters.formatDuration(90); // "1:30"
String durationText = Formatters.formatDurationMinutes(90); // "1 hour 30 minutes"

// Phone number formatting
String phone = Formatters.formatPhoneNumber('0123456789'); // "012 345 6789"

// Rating formatting
String rating = Formatters.formatRating(4.5); // "4.5"
String ratingWithStar = Formatters.formatRatingWithStar(4.5); // "4.5 ★"

// List formatting
String joined = Formatters.joinList(['A', 'B', 'C'], ', '); // "A, B, C"
String withAnd = Formatters.formatListWithAnd(['A', 'B', 'C']); // "A, B and C"
```

**Available Formatters:**

**Number Formatting:**

- `formatNumber(num value)` - Format with thousand separators
- `formatDecimal(num value, {int decimalPlaces})` - Format with decimal places
- `formatCompactNumber(num value)` - Compact notation (K, M, B)
- `formatPercentage(num value, {int decimalPlaces, bool isDecimal})` - Percentage formatting

**Currency Formatting:**

- `formatVND(num value)` - Vietnamese Dong
- `formatCompactVND(num value)` - Compact VND
- `formatUSD(num value)` - US Dollar
- `formatCurrency(num value, {String symbol, int decimalPlaces, String symbolPosition})` - Custom currency

**Date Formatting:**

- `formatDate(DateTime date)` - Standard date (dd/MM/yyyy)
- `formatDateWithMonth(DateTime date)` - Date with month name
- `formatFullDate(DateTime date)` - Full date string
- `formatDateTime(DateTime date)` - Date with time
- `formatTime24(DateTime date)` - 24-hour time
- `formatTime12(DateTime date)` - 12-hour time

**File Size Formatting:**

- `formatFileSize(int bytes)` - Human-readable file size

**Duration Formatting:**

- `formatDuration(int seconds)` - Time string (H:MM:SS or M:SS)
- `formatDurationMinutes(int minutes)` - Readable duration text

**Text Formatting:**

- `truncateText(String text, int maxLength, {String ellipsis})` - Truncate with ellipsis
- `capitalize(String text)` - Capitalize first letter
- `capitalizeWords(String text)` - Capitalize each word
- `toTitleCase(String text)` - Convert to title case

**Phone Number Formatting:**

- `formatPhoneNumber(String phoneNumber)` - Vietnamese phone format

**Rating Formatting:**

- `formatRating(double rating, {int decimalPlaces})` - Format rating value
- `formatRatingWithStar(double rating)` - Format with star symbol

**List Formatting:**

- `joinList(List<String> items, String separator)` - Join with separator
- `formatListWithAnd(List<String> items)` - Format with "and"

### 3. Date Formatter (`date_formatter.dart`)

Provides date and time formatting with relative time support.

**Usage Examples:**

```dart
import 'package:prm393_project/core/utils/date_formatter.dart';

DateTime now = DateTime.now();
DateTime yesterday = now.subtract(Duration(days: 1));

// Relative date
String relativeDate = DateFormatter.toRelativeDate(yesterday); // "Yesterday"

// Relative time
String relativeTime = DateFormatter.toRelativeTime(now.subtract(Duration(hours: 2))); // "2 hours ago"

// Standard formats
String fullDate = DateFormatter.toFullDate(now); // "January 15, 2024"
String shortDate = DateFormatter.toShortDate(now); // "Jan 15, 2024"
String dateWithTime = DateFormatter.toDateWithTime(now); // "Jan 15, 2024 at 3:45 PM"

// Group header for lists
String groupHeader = DateFormatter.toGroupHeader(yesterday); // "Yesterday"

// Utility checks
bool isToday = DateFormatter.isToday(now); // true
bool isYesterday = DateFormatter.isYesterday(yesterday); // true
bool withinWeek = DateFormatter.isWithinDays(now, 7); // true
```

### 4. Image Helper (`image_helper.dart`)

Provides utilities for loading and caching images with placeholders and error handling.

**Usage Examples:**

```dart
import 'package:prm393_project/core/utils/image_helper.dart';

// Load network image with caching
Widget image = ImageHelper.loadNetworkImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 300,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(8),
);

// Load manga cover with standard styling
Widget cover = ImageHelper.loadMangaCover(
  imageUrl: 'https://example.com/cover.jpg',
  width: 120,
  height: 180,
);

// Load circular avatar
Widget avatar = ImageHelper.loadAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  radius: 24,
);

// Load banner with aspect ratio
Widget banner = ImageHelper.loadBanner(
  imageUrl: 'https://example.com/banner.jpg',
  aspectRatio: 16 / 9,
);

// Load chapter page for reading
Widget page = ImageHelper.loadChapterPage(
  imageUrl: 'https://example.com/page.jpg',
  onTap: () => print('Page tapped'),
);

// Preload images
await ImageHelper.preloadImage(context, 'https://example.com/image.jpg');
await ImageHelper.preloadImages(context, [
  'https://example.com/image1.jpg',
  'https://example.com/image2.jpg',
]);

// Clear cache
await ImageHelper.clearCache();

// Utility functions
bool isValid = ImageHelper.isValidImageUrl('https://example.com/image.jpg');
String placeholder = ImageHelper.getPlaceholderUrl(width: 300, height: 400);
```

### 5. Navigation Helper (`navigation_helper.dart`)

Provides wrapper functions for navigation operations with error handling.

**Usage Examples:**

```dart
import 'package:prm393_project/core/utils/navigation_helper.dart';

// Basic navigation
await NavigationHelper.push(context, DetailScreen());
await NavigationHelper.pushNamed(context, '/detail', arguments: {'id': '123'});

// Replace current screen
await NavigationHelper.pushReplacement(context, HomeScreen());
await NavigationHelper.pushReplacementNamed(context, '/home');

// Clear stack and navigate
await NavigationHelper.pushAndRemoveUntil(context, LoginScreen());
await NavigationHelper.pushNamedAndRemoveUntil(context, '/login');

// Pop operations
NavigationHelper.pop(context);
NavigationHelper.pop(context, 'result');
NavigationHelper.popToRoot(context);
NavigationHelper.popUntil(context, '/home');

// Check if can pop
bool canPop = NavigationHelper.canPop(context);

// Dialogs
bool confirmed = await NavigationHelper.showConfirmDialog(
  context,
  title: 'Delete Item',
  message: 'Are you sure you want to delete this item?',
  confirmText: 'Delete',
  cancelText: 'Cancel',
);

await NavigationHelper.showAlertDialog(
  context,
  title: 'Success',
  message: 'Item deleted successfully',
);

// Bottom sheets
await NavigationHelper.showBottomSheetHelper(
  context,
  builder: (context) => SettingsBottomSheet(),
  isScrollControlled: true,
);

// Snackbars
NavigationHelper.showSnackbar(context, message: 'Action completed');
NavigationHelper.showSuccessSnackbar(context, message: 'Saved successfully');
NavigationHelper.showErrorSnackbar(context, message: 'Failed to save');
NavigationHelper.showWarningSnackbar(context, message: 'Please check your input');
NavigationHelper.showInfoSnackbar(context, message: 'New update available');

// Loading dialog
NavigationHelper.showLoadingDialog(context, message: 'Loading...');
// ... perform async operation
NavigationHelper.hideLoadingDialog(context);

// Route information
String? routeName = NavigationHelper.getCurrentRouteName(context);
Object? args = NavigationHelper.getRouteArguments(context);
```

## Error Handling

All utility functions include comprehensive error handling:

- **Validators**: Return `null` for valid input, error message string for invalid input
- **Formatters**: Handle null/empty values gracefully, return formatted strings
- **Date Formatter**: Handle edge cases for relative dates and times
- **Image Helper**: Show placeholders during loading, error widgets on failure
- **Navigation Helper**: Wrap navigation calls in try-catch, log errors to debug console

## Null Safety

All utilities are fully null-safe and follow Dart's sound null safety principles:

- Required parameters are non-nullable
- Optional parameters use nullable types with default values
- Return types clearly indicate nullability

## Testing

Unit tests are provided for all utility classes:

- `test/core/utils/validators_test.dart` - Validator tests
- `test/core/utils/formatters_test.dart` - Formatter tests

Run tests with:

```bash
flutter test test/core/utils/
```

## Best Practices

1. **Use validators in forms**: Always validate user input using the provided validators
2. **Format display data**: Use formatters to ensure consistent data presentation
3. **Cache images**: Use ImageHelper for all network images to benefit from caching
4. **Centralize navigation**: Use NavigationHelper for consistent navigation patterns
5. **Handle errors**: All utilities include error handling, but always check return values

## Dependencies

These utilities depend on the following packages:

- `intl` - Internationalization and formatting
- `cached_network_image` - Image caching
- `flutter/material.dart` - Flutter framework

Make sure these are included in your `pubspec.yaml`.
