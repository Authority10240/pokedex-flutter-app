import 'package:flutter/material.dart';

extension StringExtensions on String {
  /// Capitalize first letter of string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ')
        .map((word) => word.isEmpty ? word : word.capitalize)
        .join(' ');
  }

  /// Replace hyphens with spaces and capitalize
  String get formatName {
    return replaceAll('-', ' ').capitalizeWords;
  }
}

extension ColorExtensions on String {
  /// Convert hex string to Color
  Color toColor() {
    return Color(int.parse(replaceFirst('#', '0xFF')));
  }
}

extension ListExtensions<T> on List<T> {
  /// Get item at index or return null if out of bounds
  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
}

extension ContextExtensions on BuildContext {
  /// Get screen size
  Size get screenSize => MediaQuery.of(this).size;
  
  /// Get screen width
  double get screenWidth => screenSize.width;
  
  /// Get screen height
  double get screenHeight => screenSize.height;
  
  /// Check if device is tablet
  bool get isTablet => screenWidth > 768;
  
  /// Get theme
  ThemeData get theme => Theme.of(this);
  
  /// Get text theme
  TextTheme get textTheme => theme.textTheme;
  
  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
