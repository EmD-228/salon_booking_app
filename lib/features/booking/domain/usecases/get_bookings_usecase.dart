import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

/// Usecase pour récupérer les réservations d'un client
class GetBookingsUsecase {
  final BookingRepository repository;

  GetBookingsUsecase(this.repository);

  /// Exécute le usecase et retourne la liste des réservations
  /// 
  /// [customerEmail] : L'email du client
  Future<List<Booking>> call(String customerEmail) async {
    if (customerEmail.trim().isEmpty) {
      throw Exception('Customer email cannot be empty');
    }
    return await repository.getBookings(customerEmail.trim());
  }
}

