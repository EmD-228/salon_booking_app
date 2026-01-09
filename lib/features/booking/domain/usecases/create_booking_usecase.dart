import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

/// Usecase pour créer une réservation
class CreateBookingUsecase {
  final BookingRepository repository;

  CreateBookingUsecase(this.repository);

  /// Exécute le usecase et retourne la réservation créée
  /// 
  /// [salonId] : L'identifiant du salon
  /// [customerEmail] : L'email du client
  /// [serviceType] : Le type de service
  /// [timeSlot] : Le créneau horaire sélectionné
  Future<Booking> call({
    required int salonId,
    required String customerEmail,
    required String serviceType,
    required String timeSlot,
  }) async {
    if (salonId <= 0) {
      throw Exception('Invalid salon ID');
    }
    if (customerEmail.trim().isEmpty) {
      throw Exception('Customer email cannot be empty');
    }
    if (serviceType.trim().isEmpty) {
      throw Exception('Service type cannot be empty');
    }
    if (timeSlot.trim().isEmpty) {
      throw Exception('Time slot cannot be empty');
    }

    return await repository.createBooking(
      salonId: salonId,
      customerEmail: customerEmail.trim(),
      serviceType: serviceType.trim(),
      timeSlot: timeSlot.trim(),
    );
  }
}

