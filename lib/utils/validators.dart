class Validators {
  /// Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }

  /// Validate password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    
    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    
    return null;
  }

  /// Validate display name
  static String? validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    
    if (value.length < 2) {
      return 'Display name must be at least 2 characters long';
    }
    
    if (value.length > 50) {
      return 'Display name must be less than 50 characters';
    }
    
    return null;
  }

  /// Validate search query
  static String? validateSearchQuery(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a search term';
    }
    
    if (value.length < 2) {
      return 'Search term must be at least 2 characters long';
    }
    
    return null;
  }
}
