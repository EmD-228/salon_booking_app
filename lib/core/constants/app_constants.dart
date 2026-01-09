/// Constantes générales de l'application
class AppConstants {
  AppConstants._(); // Private constructor

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Date/Time formats
  static const String timeFormat = 'HH:mm:ss';
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';

  // Pagination
  static const int defaultPageSize = 20;

  // Cache
  static const Duration cacheExpiration = Duration(hours: 1);
}

