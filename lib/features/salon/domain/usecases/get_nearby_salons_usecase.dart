import '../entities/salon.dart';
import '../repositories/salon_repository.dart';

/// Usecase pour récupérer les salons à proximité
class GetNearbySalonsUsecase {
  final SalonRepository repository;

  GetNearbySalonsUsecase(this.repository);

  /// Exécute le usecase et retourne la liste des salons à proximité
  Future<List<Salon>> call() async {
    return await repository.getNearbySalons();
  }
}

