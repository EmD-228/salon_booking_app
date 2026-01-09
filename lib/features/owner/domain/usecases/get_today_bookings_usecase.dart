import '../../../booking/domain/entities/booking.dart';
import '../repositories/owner_repository.dart';

/// Usecase pour récupérer les réservations du jour
class GetTodayBookingsUsecase {
  final OwnerRepository repository;

  GetTodayBookingsUsecase(this.repository);

  /// Exécute le usecase et retourne la liste des réservations du jour
  /// 
  /// [ownerId] : L'identifiant du propriétaire
  Future<List<Booking>> call(String ownerId) async {
    if (ownerId.trim().isEmpty) {
      throw Exception('Owner ID cannot be empty');
    }
    return await repository.getTodayBookings(ownerId.trim());
  }
}

