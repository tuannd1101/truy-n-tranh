import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_project/core/utils/validators.dart';

void main() {
  group('Validators - Email Validation', () {
    test('validateEmail should return null for valid emails', () {
      expect(Validators.validateEmail('test@example.com'), null);
      expect(Validators.validateEmail('user.name@domain.co.uk'), null);
      expect(Validators.validateEmail('user+tag@example.com'), null);
    });

    test('validateEmail should return error for invalid emails', () {
      expect(Validators.validateEmail(''), 'Email is required');
      expect(Validators.validateEmail(null), 'Email is required');
      expect(Validators.validateEmail('invalid'), 'Please enter a valid email address');
      expect(Validators.validateEmail('test@'), 'Please enter a valid email address');
      expect(Validators.validateEmail('@example.com'), 'Please enter a valid email address');
    });
  });

  group('Validators - Password Validation', () {
    test('validatePassword should return null for valid passwords', () {
      expect(Validators.validatePassword('pass123'), null);
      expect(Validators.validatePassword('MyPassword1'), null);
      expect(Validators.validatePassword('abc123def'), null);
    });

    test('validatePassword should return error for invalid passwords', () {
      expect(Validators.validatePassword(''), 'Password is required');
      expect(Validators.validatePassword(null), 'Password is required');
      expect(Validators.validatePassword('short'), 'Password must be at least 6 characters');
      expect(Validators.validatePassword('123456'), 'Password must contain at least one letter');
      expect(Validators.validatePassword('abcdef'), 'Password must contain at least one number');
    });
  });

  group('Validators - Confirm Password Validation', () {
    test('validateConfirmPassword should return null when passwords match', () {
      expect(Validators.validateConfirmPassword('pass123', 'pass123'), null);
    });

    test('validateConfirmPassword should return error when passwords do not match', () {
      expect(Validators.validateConfirmPassword('', 'pass123'), 'Please confirm your password');
      expect(Validators.validateConfirmPassword('pass123', 'pass456'), 'Passwords do not match');
    });
  });

  group('Validators - Username Validation', () {
    test('validateUsername should return null for valid usernames', () {
      expect(Validators.validateUsername('user123'), null);
      expect(Validators.validateUsername('john_doe'), null);
      expect(Validators.validateUsername('Alice'), null);
    });

    test('validateUsername should return error for invalid usernames', () {
      expect(Validators.validateUsername(''), 'Username is required');
      expect(Validators.validateUsername('ab'), 'Username must be at least 3 characters');
      expect(Validators.validateUsername('a' * 21), 'Username must not exceed 20 characters');
      expect(Validators.validateUsername('123user'), 'Username must start with a letter');
      expect(Validators.validateUsername('user-name'), 'Username can only contain letters, numbers, and underscores');
    });
  });

  group('Validators - Name Validation', () {
    test('validateName should return null for valid names', () {
      expect(Validators.validateName('John Doe'), null);
      expect(Validators.validateName("O'Brien"), null);
      expect(Validators.validateName('Mary-Jane'), null);
    });

    test('validateName should return error for invalid names', () {
      expect(Validators.validateName(''), 'Name is required');
      expect(Validators.validateName('A'), 'Name must be at least 2 characters');
      expect(Validators.validateName('a' * 51), 'Name must not exceed 50 characters');
      expect(Validators.validateName('John123'), "Name can only contain letters, spaces, hyphens, and apostrophes");
    });
  });

  group('Validators - Phone Validation', () {
    test('validatePhone should return null for valid Vietnamese phone numbers', () {
      expect(Validators.validatePhone('0123456789'), null);
      expect(Validators.validatePhone('0987654321'), null);
    });

    test('validatePhone should return error for invalid phone numbers', () {
      expect(Validators.validatePhone(''), 'Phone number is required');
      expect(Validators.validatePhone('123456789'), 'Please enter a valid phone number (10 digits starting with 0)');
      expect(Validators.validatePhone('1234567890'), 'Please enter a valid phone number (10 digits starting with 0)');
    });
  });

  group('Validators - Required Field Validation', () {
    test('validateRequired should return null for non-empty values', () {
      expect(Validators.validateRequired('value'), null);
      expect(Validators.validateRequired('  text  '), null);
    });

    test('validateRequired should return error for empty values', () {
      expect(Validators.validateRequired(''), 'This field is required');
      expect(Validators.validateRequired('   '), 'This field is required');
      expect(Validators.validateRequired(null), 'This field is required');
      expect(Validators.validateRequired('', fieldName: 'Email'), 'Email is required');
    });
  });

  group('Validators - Length Validation', () {
    test('validateMinLength should return null for valid length', () {
      expect(Validators.validateMinLength('hello', 3), null);
      expect(Validators.validateMinLength('test', 4), null);
    });

    test('validateMinLength should return error for short values', () {
      expect(Validators.validateMinLength('hi', 3), 'This field must be at least 3 characters');
      expect(Validators.validateMinLength('', 5), 'This field is required');
    });

    test('validateMaxLength should return null for valid length', () {
      expect(Validators.validateMaxLength('hello', 10), null);
      expect(Validators.validateMaxLength(null, 10), null);
    });

    test('validateMaxLength should return error for long values', () {
      expect(Validators.validateMaxLength('hello world', 5), 'This field must not exceed 5 characters');
    });
  });

  group('Validators - Numeric Validation', () {
    test('validateNumeric should return null for valid numbers', () {
      expect(Validators.validateNumeric('123'), null);
      expect(Validators.validateNumeric('45.67'), null);
      expect(Validators.validateNumeric('-10'), null);
    });

    test('validateNumeric should return error for non-numeric values', () {
      expect(Validators.validateNumeric(''), 'This field is required');
      expect(Validators.validateNumeric('abc'), 'This field must be a number');
    });
  });

  group('Validators - URL Validation', () {
    test('validateUrl should return null for valid URLs', () {
      expect(Validators.validateUrl('https://example.com'), null);
      expect(Validators.validateUrl('http://www.example.com'), null);
      expect(Validators.validateUrl('https://example.com/path?query=value'), null);
    });

    test('validateUrl should return error for invalid URLs', () {
      expect(Validators.validateUrl(''), 'URL is required');
      expect(Validators.validateUrl('not-a-url'), 'Please enter a valid URL');
      expect(Validators.validateUrl('example.com'), 'Please enter a valid URL');
    });
  });

  group('Validators - Age Validation', () {
    test('validateAge should return null for valid ages', () {
      expect(Validators.validateAge('13'), null);
      expect(Validators.validateAge('25'), null);
      expect(Validators.validateAge('100'), null);
    });

    test('validateAge should return error for invalid ages', () {
      expect(Validators.validateAge(''), 'Age is required');
      expect(Validators.validateAge('12'), 'You must be at least 13 years old');
      expect(Validators.validateAge('121'), 'Please enter a valid age');
      expect(Validators.validateAge('abc'), 'Please enter a valid age');
    });
  });

  group('Validators - Combine Validators', () {
    test('combine should return first error found', () {
      final result = Validators.combine([
        () => null,
        () => 'Error 1',
        () => 'Error 2',
      ]);
      expect(result, 'Error 1');
    });

    test('combine should return null if all validators pass', () {
      final result = Validators.combine([
        () => null,
        () => null,
        () => null,
      ]);
      expect(result, null);
    });
  });
}
