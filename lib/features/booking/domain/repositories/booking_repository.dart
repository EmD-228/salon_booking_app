import '../entities/booking.dart';
import '../entities/time_slot.dart';

/// Interface du repository pour les opérations sur les réservations
abstract class BookingRepository {
  /// Récupère les créneaux horaires disponibles pour un salon
  /// 
  /// [salonId] : L'identifiant du salon
  /// Retourne une liste de créneaux horaires disponibles
  Future<List<TimeSlot>> getTimeSlots(int salonId);

  /// Crée une nouvelle réservation
  /// 
  /// [salonId] : L'identifiant du salon
  /// [customerEmail] : L'email du client
  /// [serviceType] : Le type de service ('Haircut', 'Beard', 'Haircut & Beard')
  /// [timeSlot] : Le créneau horaire sélectionné
  /// Retourne la réservation créée
  Future<Booking> createBooking({
    required int salonId,
    required String customerEmail,
    required String serviceType,
    required String timeSlot,
  });

  /// Récupère toutes les réservations d'un client
  /// 
  /// [customerEmail] : L'email du client
  /// Retourne une liste de réservations
  Future<List<Booking>> getBookings(String customerEmail);
}

