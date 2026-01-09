/// Noms des routes de l'application
/// Utilisé pour la navigation avec GoRouter
class RouteNames {
  RouteNames._(); // Private constructor

  // Initial
  static const String splash = '/';
  static const String userTypeSelection = '/user-type-selection';

  // Auth - Customer
  static const String login = '/login';
  static const String register = '/register';
  static const String emailVerify = '/email-verify';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';

  // Auth - Owner
  static const String ownerLogin = '/owner/login';

  // Customer - Main
  static const String home = '/home';
  static const String salonDetail = '/salon/:id';
  static const String searchLocation = '/search-location';
  static const String timeSlot = '/salon/:id/time-slot';
  static const String bookingConfirmation = '/booking/confirmation';
  static const String bookingsList = '/bookings';
  static const String profile = '/profile';

  // Owner - Main
  static const String ownerDashboard = '/owner/dashboard';

  // Helper methods
  static String salonDetailPath(int salonId) => '/salon/$salonId';
  static String timeSlotPath(int salonId) => '/salon/$salonId/time-slot';
}

