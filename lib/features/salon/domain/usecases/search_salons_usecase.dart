import '../entities/salon.dart';
import '../repositories/salon_repository.dart';

/// Usecase pour rechercher des salons par localisation
class SearchSalonsUsecase {
  final SalonRepository repository;

  SearchSalonsUsecase(this.repository);

  /// Exécute le usecase et retourne la liste des salons correspondant à la recherche
  /// 
  /// [searchQuery] : Le terme de recherche (adresse, ville, etc.)
  Future<List<Salon>> call(String searchQuery) async {
    if (searchQuery.trim().isEmpty) {
      throw Exception('Search query cannot be empty');
    }
    return await repository.searchSalonsByLocation(searchQuery.trim());
  }
}

