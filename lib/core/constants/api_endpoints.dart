/// Endpoints API de l'application
/// 
/// Les URLs sont chargées depuis les variables d'environnement
/// via flutter_dotenv pour éviter le hardcoding
class ApiEndpoints {
  ApiEndpoints._(); // Private constructor

  // Base URL - sera chargée depuis .env
  static String get baseUrl => _baseUrl;
  static String _baseUrl = 'https://salonappmysql.000webhostapp.com';
  
  // Images base URL
  static String get imagesBaseUrl => '$baseUrl/salon_image/';

  // Authentication
  static String get register => '$baseUrl/register.php';
  static String get login => '$baseUrl/login.php';
  static String get logout => '$baseUrl/logout.php';
  static String get forgetPassword => '$baseUrl/forgetpassword.php';
  static String get changePassword => '$baseUrl/changepassword.php';

  // User
  static String get userDetail => '$baseUrl/user_data.php';
  static String get uploadImage => '$baseUrl/uploadimage.php';

  // Salon
  static String get nearbySalons => '$baseUrl/nearby.php';
  static String get searchLocation => '$baseUrl/searched_location.php';
  static String get timeSlots => '$baseUrl/Timeslot.php';

  // Booking
  static String get booking => '$baseUrl/booking.php';
  static String get checkBooking => '$baseUrl/checkbooking.php';

  // Owner
  static String get ownerDetail => '$baseUrl/ownerdetail.php';
  static String get todayBookings => '$baseUrl/owner_booking_data.php';

  /// Initialise la base URL depuis les variables d'environnement
  static void initialize(String baseUrl) {
    _baseUrl = baseUrl;
  }
}

