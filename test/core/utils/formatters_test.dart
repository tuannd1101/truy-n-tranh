import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_project/core/utils/formatters.dart';

void main() {
  group('Formatters - Number Formatting', () {
    test('formatNumber should format with thousand separators', () {
      expect(Formatters.formatNumber(1000), '1,000');
      expect(Formatters.formatNumber(1234567), '1,234,567');
      expect(Formatters.formatNumber(100), '100');
    });

    test('formatDecimal should format with decimal places', () {
      expect(Formatters.formatDecimal(3.14159, decimalPlaces: 2), '3.14');
      expect(Formatters.formatDecimal(1234.5, decimalPlaces: 1), '1,234.5');
      expect(Formatters.formatDecimal(1000, decimalPlaces: 2), '1,000.00');
    });

    test('formatCompactNumber should format to K, M, B notation', () {
      expect(Formatters.formatCompactNumber(500), '500');
      expect(Formatters.formatCompactNumber(1000), '1K');
      expect(Formatters.formatCompactNumber(1500), '1.5K');
      expect(Formatters.formatCompactNumber(1000000), '1M');
      expect(Formatters.formatCompactNumber(1234567), '1.2M');
      expect(Formatters.formatCompactNumber(1000000000), '1B');
    });

    test('formatPercentage should format percentage values', () {
      expect(Formatters.formatPercentage(75), '75%');
      expect(Formatters.formatPercentage(0.75, isDecimal: true), '75%');
      expect(Formatters.formatPercentage(75.5, decimalPlaces: 1), '75.5%');
      expect(Formatters.formatPercentage(0.755, decimalPlaces: 1, isDecimal: true), '75.5%');
    });
  });

  group('Formatters - Currency Formatting', () {
    test('formatVND should format Vietnamese Dong', () {
      expect(Formatters.formatVND(50000), '50,000đ');
      expect(Formatters.formatVND(1000000), '1,000,000đ');
    });

    test('formatCompactVND should format compact Vietnamese Dong', () {
      expect(Formatters.formatCompactVND(500), '500đ');
      expect(Formatters.formatCompactVND(50000), '50Kđ');
      expect(Formatters.formatCompactVND(1000000), '1Mđ');
    });

    test('formatUSD should format US Dollar', () {
      expect(Formatters.formatUSD(50), '\$50.00');
      expect(Formatters.formatUSD(1234.56), '\$1,234.56');
    });

    test('formatCurrency should format with custom symbol', () {
      expect(Formatters.formatCurrency(1000, symbol: '€', symbolPosition: 'prefix'), '€1,000');
      expect(Formatters.formatCurrency(1000, symbol: 'đ', symbolPosition: 'suffix'), '1,000đ');
    });
  });

  group('Formatters - Text Formatting', () {
    test('truncateText should truncate long text', () {
      expect(Formatters.truncateText('Hello World', 8), 'Hello...');
      expect(Formatters.truncateText('Short', 10), 'Short');
    });

    test('capitalize should capitalize first letter', () {
      expect(Formatters.capitalize('hello'), 'Hello');
      expect(Formatters.capitalize('HELLO'), 'HELLO');
      expect(Formatters.capitalize(''), '');
    });

    test('capitalizeWords should capitalize each word', () {
      expect(Formatters.capitalizeWords('hello world'), 'Hello World');
      expect(Formatters.capitalizeWords('the quick brown fox'), 'The Quick Brown Fox');
    });

    test('toTitleCase should convert to title case', () {
      expect(Formatters.toTitleCase('HELLO WORLD'), 'Hello World');
      expect(Formatters.toTitleCase('hello world'), 'Hello World');
    });
  });

  group('Formatters - File Size Formatting', () {
    test('formatFileSize should format bytes to human-readable', () {
      expect(Formatters.formatFileSize(500), '500 B');
      expect(Formatters.formatFileSize(1024), '1.0 KB');
      expect(Formatters.formatFileSize(1048576), '1.0 MB');
      expect(Formatters.formatFileSize(1073741824), '1.0 GB');
    });
  });

  group('Formatters - Duration Formatting', () {
    test('formatDuration should format seconds to time string', () {
      expect(Formatters.formatDuration(90), '1:30');
      expect(Formatters.formatDuration(3661), '1:01:01');
      expect(Formatters.formatDuration(45), '0:45');
    });

    test('formatDurationMinutes should format minutes to readable string', () {
      expect(Formatters.formatDurationMinutes(5), '5 minutes');
      expect(Formatters.formatDurationMinutes(60), '1 hour');
      expect(Formatters.formatDurationMinutes(90), '1 hour 30 minutes');
      expect(Formatters.formatDurationMinutes(120), '2 hours');
    });
  });

  group('Formatters - Phone Number Formatting', () {
    test('formatPhoneNumber should format Vietnamese phone numbers', () {
      expect(Formatters.formatPhoneNumber('0123456789'), '012 345 6789');
      expect(Formatters.formatPhoneNumber('0987654321'), '098 765 4321');
      expect(Formatters.formatPhoneNumber('invalid'), 'invalid');
    });
  });

  group('Formatters - Rating Formatting', () {
    test('formatRating should format rating values', () {
      expect(Formatters.formatRating(4.5), '4.5');
      expect(Formatters.formatRating(4.0), '4.0');
      expect(Formatters.formatRating(3.75, decimalPlaces: 2), '3.75');
    });

    test('formatRatingWithStar should format rating with star', () {
      expect(Formatters.formatRatingWithStar(4.5), '4.5 ★');
    });
  });

  group('Formatters - List Formatting', () {
    test('joinList should join list with separator', () {
      expect(Formatters.joinList(['Action', 'Adventure'], ', '), 'Action, Adventure');
      expect(Formatters.joinList(['A', 'B', 'C'], ' • '), 'A • B • C');
    });

    test('formatListWithAnd should format list with "and"', () {
      expect(Formatters.formatListWithAnd(['A']), 'A');
      expect(Formatters.formatListWithAnd(['A', 'B']), 'A and B');
      expect(Formatters.formatListWithAnd(['A', 'B', 'C']), 'A, B and C');
      expect(Formatters.formatListWithAnd([]), '');
    });
  });
}
