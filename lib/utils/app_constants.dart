
class AppConstants {
  // News Categories
  static const String categoryAdministration = 'Administration';
  static const String categoryDepartment = 'Department';
  static const String categoryStudentBody = 'Student Body';

  // List of all available news categories for dropdowns/filters
  static const List<String> newsCategories = [
    categoryAdministration,
    categoryDepartment,
    categoryStudentBody,
  ];

  // Registration Number Prefixes (for AuthService mapping)
  static const String regPrefixCst = 'CST';
  static const String regPrefixCoe = 'COE';

  // Add more constants here as your app grows (e.g., error messages, API endpoints)
}
