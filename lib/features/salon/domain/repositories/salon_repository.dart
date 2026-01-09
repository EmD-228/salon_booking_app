import '../entities/salon.dart';

/// Interface du repository pour les opérations sur les salons
/// 
/// Définit le contrat que doit respecter l'implémentation du repository
abstract class SalonRepository {
  /// Récupère la liste de tous les salons à proximité
  /// 
  /// Retourne une liste de salons ou lance une exception en cas d'erreur
  Future<List<Salon>> getNearbySalons();

  /// Recherche des salons par localisation
  /// 
  /// [searchQuery] : Le terme de recherche (adresse, ville, etc.)
  /// Retourne une liste de salons correspondant à la recherche
  Future<List<Salon>> searchSalonsByLocation(String searchQuery);

  /// Récupère les détails d'un salon spécifique
  /// 
  /// [salonId] : L'identifiant du salon
  /// Retourne le salon correspondant ou lance une exception si non trouvé
  Future<Salon> getSalonDetails(int salonId);
}

