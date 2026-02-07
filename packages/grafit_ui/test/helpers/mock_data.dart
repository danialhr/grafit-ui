/// Mock and sample data for testing Grafit UI components
///
/// This file provides commonly used test data to keep tests consistent.
library;

import 'package:flutter/material.dart';

// ============================================
// STRING DATA
// ============================================

/// Common test strings
class TestStrings {
  static const String short = 'Hi';
  static const String medium = 'Hello World';
  static const String long = 'This is a longer string that spans more words';
  static const String email = 'test@example.com';
  static const String url = 'https://example.com';
  static const String phone = '+1 234 567 8900';
  static const String password = 'SecurePass123!';
  static const String empty = '';
  static const String whitespace = '   ';
}

// ============================================
// LIST DATA
// ============================================

/// Sample data for lists, tables, etc.
class TestLists {
  static const List<String> simple = ['Item 1', 'Item 2', 'Item 3'];
  static const List<String> long = [
    'First Item',
    'Second Item',
    'Third Item',
    'Fourth Item',
    'Fifth Item',
  ];
  
  static const List<String> numbered = [
    'Option 1',
    'Option 2',
    'Option 3',
    'Option 4',
    'Option 5',
  ];

  static const List<String> withEmojis = [
    '🎉 Party',
    '📊 Analytics',
    '⚙️ Settings',
    '👤 Profile',
  ];
}

// ============================================
// USER DATA
// ============================================

/// Sample user data for profile components
class TestUsers {
  static const Map<String, dynamic> basic = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'avatar': null,
  };

  static const Map<String, dynamic> detailed = {
    'id': '1',
    'name': 'Jane Smith',
    'email': 'jane.smith@example.com',
    'role': 'Administrator',
    'department': 'Engineering',
    'status': 'active',
    'lastLogin': '2024-01-15T10:30:00Z',
  };

  static const List<Map<String, dynamic>> multiple = [
    {'id': '1', 'name': 'Alice', 'status': 'online'},
    {'id': '2', 'name': 'Bob', 'status': 'offline'},
    {'id': '3', 'name': 'Charlie', 'status': 'away'},
  ];
}

// ============================================
// TABLE DATA
// ============================================

/// Sample data for table components
class TestTableData {
  static const List<String> columns = ['Name', 'Email', 'Role', 'Status'];
  
  static const List<Map<String, dynamic>> simple = [
    {'name': 'Alice Johnson', 'email': 'alice@example.com', 'role': 'Admin', 'status': 'Active'},
    {'name': 'Bob Smith', 'email': 'bob@example.com', 'role': 'User', 'status': 'Active'},
    {'name': 'Carol White', 'email': 'carol@example.com', 'role': 'User', 'status': 'Inactive'},
  ];

  static const List<Map<String, dynamic>> large = [
    {'name': 'Alice Johnson', 'email': 'alice@example.com', 'role': 'Admin', 'status': 'Active', 'department': 'Engineering'},
    {'name': 'Bob Smith', 'email': 'bob@example.com', 'role': 'User', 'status': 'Active', 'department': 'Sales'},
    {'name': 'Carol White', 'email': 'carol@example.com', 'role': 'User', 'status': 'Inactive', 'department': 'Marketing'},
    {'name': 'David Brown', 'email': 'david@example.com', 'role': 'Editor', 'status': 'Active', 'department': 'Content'},
    {'name': 'Eve Davis', 'email': 'eve@example.com', 'role': 'User', 'status': 'Pending', 'department': 'HR'},
  ];
}

// ============================================
// FORM DATA
// ============================================

/// Sample data for form components
class TestFormData {
  static const Map<String, String> valid = {
    'firstName': 'John',
    'lastName': 'Doe',
    'email': 'john.doe@example.com',
    'phone': '+1 234 567 8900',
    'password': 'SecurePass123!',
  };

  static const Map<String, String> invalid = {
    'firstName': '',
    'lastName': '',
    'email': 'not-an-email',
    'phone': '123',
    'password': 'short',
  };

  static const Map<String, String?> empty = {
    'firstName': null,
    'lastName': null,
    'email': null,
    'phone': null,
    'password': null,
  };

  static const Map<String, String?> partial = {
    'firstName': 'John',
    'lastName': null,
    'email': null,
    'phone': null,
    'password': null,
  };
}

// ============================================
// NOTIFICATION DATA
// ============================================

/// Sample data for notification/alert components
class TestNotifications {
  static const Map<String, dynamic> info = {
    'type': 'info',
    'title': 'Information',
    'message': 'This is an informational message.',
  };

  static const Map<String, dynamic> success = {
    'type': 'success',
    'title': 'Success',
    'message': 'Operation completed successfully.',
  };

  static const Map<String, dynamic> warning = {
    'type': 'warning',
    'title': 'Warning',
    'message': 'Please review before proceeding.',
  };

  static const Map<String, dynamic> error = {
    'type': 'error',
    'title': 'Error',
    'message': 'An error occurred. Please try again.',
  };
}

// ============================================
// CHART DATA
// ============================================

/// Sample data for chart components
class TestChartData {
  static const List<Map<String, dynamic>> simpleLine = [
    {'x': 1, 'y': 10},
    {'x': 2, 'y': 25},
    {'x': 3, 'y': 15},
    {'x': 4, 'y': 30},
    {'x': 5, 'y': 20},
  ];

  static const List<Map<String, dynamic>> bar = [
    {'label': 'Jan', 'value': 65},
    {'label': 'Feb', 'value': 59},
    {'label': 'Mar', 'value': 80},
    {'label': 'Apr', 'value': 81},
    {'label': 'May', 'value': 56},
  ];

  static const List<Map<String, dynamic>> pie = [
    {'label': 'Category A', 'value': 30, 'color': 0xFF3B82F6},
    {'label': 'Category B', 'value': 20, 'color': 0xFF10B981},
    {'label': 'Category C', 'value': 25, 'color': 0xFFF59E0B},
    {'label': 'Category D', 'value': 25, 'color': 0xFFEF4444},
  ];
}

// ============================================
// STATUS DATA
// ============================================

/// Sample status data for badges and indicators
class TestStatuses {
  static const List<String> common = ['Active', 'Inactive', 'Pending', 'Completed'];
  static const List<String> priority = ['Low', 'Medium', 'High', 'Urgent'];
  static const List<String> boolean = ['Yes', 'No'];
  
  static const Map<String, Color> colors = {
    'success': Color(0xFF10B981),
    'warning': Color(0xFFF59E0B),
    'error': Color(0xFFEF4444),
    'info': Color(0xFF3B82F6),
  };
}

// ============================================
// NAVIGATION DATA
// ============================================

/// Sample data for navigation components
class TestNavigation {
  static const List<Map<String, dynamic>> menuItems = [
    {'label': 'Home', 'route': '/', 'icon': Icons.home},
    {'label': 'Dashboard', 'route': '/dashboard', 'icon': Icons.dashboard},
    {'label': 'Settings', 'route': '/settings', 'icon': Icons.settings},
    {'label': 'Profile', 'route': '/profile', 'icon': Icons.person},
  ];

  static const List<Map<String, dynamic>> breadcrumbs = [
    {'label': 'Home', 'route': '/'},
    {'label': 'Products', 'route': '/products'},
    {'label': 'Category', 'route': '/products/category'},
    {'label': 'Item', 'route': '/products/category/item'},
  ];
}

// ============================================
// DATE/TIME DATA
// ============================================

/// Sample date/time data
class TestDates {
  static const String today = '2024-01-15';
  static const String future = '2024-12-31';
  static const String past = '2023-01-01';
  
  static const List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  
  static const List<String> weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
  ];
}

// ============================================
// ERROR MESSAGES
// ============================================

/// Common error messages for testing validation
class TestErrors {
  static const String required = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String tooShort = 'Must be at least 8 characters';
  static const String mismatch = 'Passwords do not match';
  static const String invalidUrl = 'Please enter a valid URL';
  static const String outOfRange = 'Value is out of range';
}

// ============================================
// ICONS
// ============================================

/// Common icons for testing
class TestIcons {
  static const IconData add = Icons.add;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete;
  static const IconData save = Icons.save;
  static const IconData cancel = Icons.cancel;
  static const IconData close = Icons.close;
  static const IconData check = Icons.check;
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_list;
  static const IconData menu = Icons.menu;
  static const IconData home = Icons.home;
  static const IconData settings = Icons.settings;
  static const IconData profile = Icons.person;
  static const IconData notification = Icons.notifications;
  static const IconData download = Icons.download;
  static const IconData upload = Icons.upload;
  static const IconData share = Icons.share;
  static const IconData favorite = Icons.favorite;
  static const IconData bookmark = Icons.bookmark;
}

// ============================================
// THEMES
// ============================================

/// Sample theme colors for testing
class TestColors {
  static const Color primary = Color(0xFF3B82F6);
  static const Color secondary = Color(0xFF64748B);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
}
