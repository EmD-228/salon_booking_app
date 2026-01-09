import '../entities/time_slot.dart';
import '../repositories/booking_repository.dart';

/// Usecase pour récupérer les créneaux horaires disponibles
class GetTimeSlotsUsecase {
  final BookingRepository repository;

  GetTimeSlotsUsecase(this.repository);

  /// Exécute le usecase et retourne la liste des créneaux horaires disponibles
  /// 
  /// [salonId] : L'identifiant du salon
  Future<List<TimeSlot>> call(int salonId) async {
    if (salonId <= 0) {
      throw Exception('Invalid salon ID');
    }
    return await repository.getTimeSlots(salonId);
  }
}

