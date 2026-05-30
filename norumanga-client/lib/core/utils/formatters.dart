import 'package:intl/intl.dart';

/// Utility class for formatting data (numbers, currency, dates, etc.)
/// Provides formatters for displaying data in user-friendly formats
class Formatters {
  // ==================== Number Formatting ====================
  
  /// Formats a number with thousand separators
  /// 
  /// Examples:
  /// - 1000 -> "1,000"
  /// - 1234567 -> "1,234,567"
  static String formatNumber(num value) {
    final formatter = NumberFormat('#,###', 'en_US');
    return formatter.format(value);
  }
  
  /// Formats a number with decimal places
  /// 
  /// Parameters:
  /// - [value]: The number to format
  /// - [decimalPlaces]: Number of decimal places (default: 2)
  /// 
  /// Examples:
  /// - formatDecimal(3.14159, 2) -> "3.14"
  /// - formatDecimal(1234.5, 1) -> "1,234.5"
  static String formatDecimal(num value, {int decimalPlaces = 2}) {
    final formatter = NumberFormat('#,##0.${'0' * decimalPlaces}', 'en_US');
    return formatter.format(value);
  }
  
  /// Formats a number to compact form (K, M, B)
  /// 
  /// Examples:
  /// - 1000 -> "1K"
  /// - 1500 -> "1.5K"
  /// - 1000000 -> "1M"
  /// - 1234567 -> "1.2M"
  static String formatCompactNumber(num value) {
    if (value < 1000) {
      return value.toString();
    } else if (value < 1000000) {
      final k = value / 1000;
      return k % 1 == 0 ? '${k.toInt()}K' : '${k.toStringAsFixed(1)}K';
    } else if (value < 1000000000) {
      final m = value / 1000000;
      return m % 1 == 0 ? '${m.toInt()}M' : '${m.toStringAsFixed(1)}M';
    } else {
      final b = value / 1000000000;
      return b % 1 == 0 ? '${b.toInt()}B' : '${b.toStringAsFixed(1)}B';
    }
  }
  
  /// Formats a percentage value
  /// 
  /// Parameters:
  /// - [value]: The value to format (0-100 or 0-1 depending on isDecimal)
  /// - [decimalPlaces]: Number of decimal places (default: 0)
  /// - [isDecimal]: Whether the value is in decimal form (0-1) or percentage form (0-100)
  /// 
  /// Examples:
  /// - formatPercentage(75) -> "75%"
  /// - formatPercentage(0.75, isDecimal: true) -> "75%"
  /// - formatPercentage(75.5, decimalPlaces: 1) -> "75.5%"
  static String formatPercentage(
    num value, {
    int decimalPlaces = 0,
    bool isDecimal = false,
  }) {
    final percentage = isDecimal ? value * 100 : value;
    if (decimalPlaces == 0) {
      return '${percentage.round()}%';
    } else {
      return '${percentage.toStringAsFixed(decimalPlaces)}%';
    }
  }
  
  // ==================== Currency Formatting ====================
  
  /// Formats a number as Vietnamese Dong (VND)
  /// 
  /// Examples:
  /// - 50000 -> "50,000đ"
  /// - 1000000 -> "1,000,000đ"
  static String formatVND(num value) {
    final formatter = NumberFormat('#,###', 'en_US');
    return '${formatter.format(value)}đ';
  }
  
  /// Formats a number as Vietnamese Dong with compact notation
  /// 
  /// Examples:
  /// - 50000 -> "50Kđ"
  /// - 1000000 -> "1Mđ"
  static String formatCompactVND(num value) {
    if (value < 1000) {
      return '${value.toInt()}đ';
    } else if (value < 1000000) {
      final k = value / 1000;
      return k % 1 == 0 ? '${k.toInt()}Kđ' : '${k.toStringAsFixed(1)}Kđ';
    } else if (value < 1000000000) {
      final m = value / 1000000;
      return m % 1 == 0 ? '${m.toInt()}Mđ' : '${m.toStringAsFixed(1)}Mđ';
    } else {
      final b = value / 1000000000;
      return b % 1 == 0 ? '${b.toInt()}Bđ' : '${b.toStringAsFixed(1)}Bđ';
    }
  }
  
  /// Formats a number as US Dollar (USD)
  /// 
  /// Examples:
  /// - 50 -> "$50.00"
  /// - 1234.56 -> "$1,234.56"
  static String formatUSD(num value) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
      locale: 'en_US',
    );
    return formatter.format(value);
  }
  
  /// Formats a number as currency with custom symbol
  /// 
  /// Parameters:
  /// - [value]: The amount to format
  /// - [symbol]: Currency symbol (default: 'đ')
  /// - [decimalPlaces]: Number of decimal places (default: 0)
  /// - [symbolPosition]: Position of symbol ('prefix' or 'suffix', default: 'suffix')
  static String formatCurrency(
    num value, {
    String symbol = 'đ',
    int decimalPlaces = 0,
    String symbolPosition = 'suffix',
  }) {
    final pattern = decimalPlaces > 0 ? '#,##0.${'0' * decimalPlaces}' : '#,###';
    final formatter = NumberFormat(pattern, 'en_US');
    final formattedValue = formatter.format(value);
    
    if (symbolPosition == 'prefix') {
      return '$symbol$formattedValue';
    } else {
      return '$formattedValue$symbol';
    }
  }
  
  // ==================== Date Formatting ====================
  
  /// Formats a DateTime to a standard date string
  /// Format: "dd/MM/yyyy"
  /// 
  /// Example: "15/01/2024"
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  /// Formats a DateTime to a date with month name
  /// Format: "dd MMM yyyy"
  /// 
  /// Example: "15 Jan 2024"
  static String formatDateWithMonth(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
  
  /// Formats a DateTime to a full date string
  /// Format: "dd MMMM yyyy"
  /// 
  /// Example: "15 January 2024"
  static String formatFullDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }
  
  /// Formats a DateTime to include time
  /// Format: "dd/MM/yyyy HH:mm"
  /// 
  /// Example: "15/01/2024 14:30"
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
  
  /// Formats a DateTime to time only (24-hour format)
  /// Format: "HH:mm"
  /// 
  /// Example: "14:30"
  static String formatTime24(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
  
  /// Formats a DateTime to time only (12-hour format)
  /// Format: "h:mm a"
  /// 
  /// Example: "2:30 PM"
  static String formatTime12(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }
  
  // ==================== File Size Formatting ====================
  
  /// Formats a file size in bytes to human-readable format
  /// 
  /// Examples:
  /// - 1024 -> "1.0 KB"
  /// - 1048576 -> "1.0 MB"
  /// - 1073741824 -> "1.0 GB"
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    } else {
      final gb = bytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(1)} GB';
    }
  }
  
  // ==================== Duration Formatting ====================
  
  /// Formats a duration in seconds to readable format
  /// 
  /// Examples:
  /// - 90 -> "1:30"
  /// - 3661 -> "1:01:01"
  static String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(1, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(1, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }
  
  /// Formats a duration in minutes to readable string
  /// 
  /// Examples:
  /// - 5 -> "5 minutes"
  /// - 60 -> "1 hour"
  /// - 90 -> "1 hour 30 minutes"
  static String formatDurationMinutes(int minutes) {
    if (minutes < 60) {
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      
      if (remainingMinutes == 0) {
        return '$hours ${hours == 1 ? 'hour' : 'hours'}';
      } else {
        return '$hours ${hours == 1 ? 'hour' : 'hours'} $remainingMinutes ${remainingMinutes == 1 ? 'minute' : 'minutes'}';
      }
    }
  }
  
  // ==================== Text Formatting ====================
  
  /// Truncates text to a maximum length with ellipsis
  /// 
  /// Parameters:
  /// - [text]: The text to truncate
  /// - [maxLength]: Maximum length before truncation
  /// - [ellipsis]: String to append when truncated (default: '...')
  /// 
  /// Example: truncateText("Hello World", 8) -> "Hello..."
  static String truncateText(String text, int maxLength, {String ellipsis = '...'}) {
    if (text.length <= maxLength) {
      return text;
    }
    final truncateLength = maxLength - ellipsis.length;
    return '${text.substring(0, truncateLength)}$ellipsis';
  }
  
  /// Capitalizes the first letter of a string
  /// 
  /// Example: "hello world" -> "Hello world"
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  
  /// Capitalizes the first letter of each word
  /// 
  /// Example: "hello world" -> "Hello World"
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  /// Converts text to title case
  /// 
  /// Example: "HELLO WORLD" -> "Hello World"
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.toLowerCase().split(' ').map((word) => capitalize(word)).join(' ');
  }
  
  // ==================== Phone Number Formatting ====================
  
  /// Formats a Vietnamese phone number
  /// 
  /// Examples:
  /// - "0123456789" -> "012 345 6789"
  /// - "0987654321" -> "098 765 4321"
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    
    if (cleaned.length != 10) {
      return phoneNumber; // Return original if not valid length
    }
    
    // Format as: 0XX XXX XXXX
    return '${cleaned.substring(0, 3)} ${cleaned.substring(3, 6)} ${cleaned.substring(6)}';
  }
  
  // ==================== Rating Formatting ====================
  
  /// Formats a rating value
  /// 
  /// Examples:
  /// - 4.5 -> "4.5"
  /// - 4.0 -> "4.0"
  /// - 3.75 -> "3.8" (rounded to 1 decimal)
  static String formatRating(double rating, {int decimalPlaces = 1}) {
    return rating.toStringAsFixed(decimalPlaces);
  }
  
  /// Formats a rating with star representation
  /// 
  /// Example: 4.5 -> "4.5 ★"
  static String formatRatingWithStar(double rating) {
    return '${formatRating(rating)} ★';
  }
  
  // ==================== List Formatting ====================
  
  /// Joins a list of strings with a separator
  /// 
  /// Examples:
  /// - joinList(["Action", "Adventure"], ", ") -> "Action, Adventure"
  /// - joinList(["A", "B", "C"], " • ") -> "A • B • C"
  static String joinList(List<String> items, String separator) {
    return items.join(separator);
  }
  
  /// Formats a list with "and" for the last item
  /// 
  /// Examples:
  /// - formatListWithAnd(["A"]) -> "A"
  /// - formatListWithAnd(["A", "B"]) -> "A and B"
  /// - formatListWithAnd(["A", "B", "C"]) -> "A, B and C"
  static String formatListWithAnd(List<String> items) {
    if (items.isEmpty) return '';
    if (items.length == 1) return items[0];
    if (items.length == 2) return '${items[0]} and ${items[1]}';
    
    final allButLast = items.sublist(0, items.length - 1).join(', ');
    return '$allButLast and ${items.last}';
  }
}
