/// Utility class for form validation
/// Provides validators for email, password, username, and other form fields
class Validators {
  /// Validates email format
  /// Returns error message if invalid, null if valid
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    // Email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  /// Validates password strength
  /// Returns error message if invalid, null if valid
  /// 
  /// Requirements:
  /// - Minimum 6 characters
  /// - At least one letter
  /// - At least one number
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    // Check for at least one letter
    if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'Password must contain at least one letter';
    }
    
    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    
    return null;
  }
  
  /// Validates password confirmation
  /// Returns error message if passwords don't match, null if valid
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  /// Validates username
  /// Returns error message if invalid, null if valid
  /// 
  /// Requirements:
  /// - 3-20 characters
  /// - Only letters, numbers, and underscores
  /// - Must start with a letter
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    
    if (value.length > 20) {
      return 'Username must not exceed 20 characters';
    }
    
    // Check if starts with a letter
    if (!RegExp(r'^[a-zA-Z]').hasMatch(value)) {
      return 'Username must start with a letter';
    }
    
    // Check for valid characters (letters, numbers, underscores)
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    
    return null;
  }
  
  /// Validates name (full name or display name)
  /// Returns error message if invalid, null if valid
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (value.length > 50) {
      return 'Name must not exceed 50 characters';
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes)
    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    
    return null;
  }
  
  /// Validates phone number (Vietnamese format)
  /// Returns error message if invalid, null if valid
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove spaces and dashes
    final cleanedValue = value.replaceAll(RegExp(r'[\s\-]'), '');
    
    // Vietnamese phone number format: 10 digits starting with 0
    if (!RegExp(r'^0[0-9]{9}$').hasMatch(cleanedValue)) {
      return 'Please enter a valid phone number (10 digits starting with 0)';
    }
    
    return null;
  }
  
  /// Validates required field
  /// Returns error message if empty, null if valid
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  /// Validates minimum length
  /// Returns error message if too short, null if valid
  static String? validateMinLength(String? value, int minLength, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }
    
    return null;
  }
  
  /// Validates maximum length
  /// Returns error message if too long, null if valid
  static String? validateMaxLength(String? value, int maxLength, {String fieldName = 'This field'}) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }
    
    return null;
  }
  
  /// Validates numeric input
  /// Returns error message if not a number, null if valid
  static String? validateNumeric(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    if (double.tryParse(value) == null) {
      return '$fieldName must be a number';
    }
    
    return null;
  }
  
  /// Validates URL format
  /// Returns error message if invalid, null if valid
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    
    return null;
  }
  
  /// Validates age (must be 13 or older)
  /// Returns error message if invalid, null if valid
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    
    if (age < 13) {
      return 'You must be at least 13 years old';
    }
    
    if (age > 120) {
      return 'Please enter a valid age';
    }
    
    return null;
  }
  
  /// Combines multiple validators
  /// Returns the first error message found, or null if all pass
  static String? combine(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}
