import 'package:intl/intl.dart';

/// Utility class for formatting dates in various formats
/// Provides relative date formatting (Today, Yesterday, etc.) and standard date formats
class DateFormatter {
  /// Formats a DateTime to a relative string (Today, Yesterday, or date)
  /// 
  /// Examples:
  /// - Today: "Today"
  /// - Yesterday: "Yesterday"
  /// - This week: "Monday", "Tuesday", etc.
  /// - Older: "Jan 15, 2024"
  static String toRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);
    
    final difference = today.difference(targetDate).inDays;
    
    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == yesterday) {
      return 'Yesterday';
    } else if (difference < 7 && difference > 0) {
      // Return day name for dates within the last week
      return DateFormat('EEEE').format(date);
    } else {
      // Return formatted date for older dates
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }
  
  /// Formats a DateTime to a relative time string
  /// 
  /// Examples:
  /// - "Just now"
  /// - "5 minutes ago"
  /// - "2 hours ago"
  /// - "3 days ago"
  static String toRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
  
  /// Formats a DateTime to a standard date string
  /// Format: "January 15, 2024"
  static String toFullDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }
  
  /// Formats a DateTime to a short date string
  /// Format: "Jan 15, 2024"
  static String toShortDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
  
  /// Formats a DateTime to a date with time string
  /// Format: "Jan 15, 2024 at 3:45 PM"
  static String toDateWithTime(DateTime date) {
    return DateFormat('MMM dd, yyyy \'at\' h:mm a').format(date);
  }
  
  /// Formats a DateTime to time only
  /// Format: "3:45 PM"
  static String toTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }
  
  /// Formats a DateTime to 24-hour time
  /// Format: "15:45"
  static String toTime24(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
  
  /// Groups dates by relative date for list grouping
  /// Returns: "Today", "Yesterday", or "January 15, 2024"
  static String toGroupHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);
    
    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM dd, yyyy').format(date);
    }
  }
  
  /// Checks if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
  
  /// Checks if a date is yesterday
  static bool isYesterday(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
           date.month == yesterday.month &&
           date.day == yesterday.day;
  }
  
  /// Checks if a date is within the last N days
  static bool isWithinDays(DateTime date, int days) {
    final now = DateTime.now();
    final difference = now.difference(date);
    return difference.inDays <= days;
  }
  
  /// Formats duration in minutes to readable string
  /// Examples: "5m", "1h 30m", "2h"
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${remainingMinutes}m';
      }
    }
  }
}
