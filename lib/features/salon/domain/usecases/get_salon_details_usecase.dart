import '../entities/salon.dart';
import '../repositories/salon_repository.dart';

/// Usecase pour récupérer les détails d'un salon spécifique
class GetSalonDetailsUsecase {
  final SalonRepository repository;

  GetSalonDetailsUsecase(this.repository);

  /// Exécute le usecase et retourne les détails du salon
  /// 
  /// [salonId] : L'identifiant du salon
  Future<Salon> call(int salonId) async {
    if (salonId <= 0) {
      throw Exception('Invalid salon ID');
    }
    return await repository.getSalonDetails(salonId);
  }
}

