import '../entities/owner.dart';
import '../../../booking/domain/entities/booking.dart';

/// Interface du repository pour les opérations sur les propriétaires
abstract class OwnerRepository {
  /// Connecte un propriétaire avec ses identifiants
  /// 
  /// [id] : L'identifiant du salon
  /// [email] : L'email du propriétaire
  /// [phoneNumber] : Le numéro de téléphone du propriétaire
  /// Retourne les informations du propriétaire
  Future<Owner> loginOwner({
    required String id,
    required String email,
    required String phoneNumber,
  });

  /// Récupère les réservations du jour pour un propriétaire
  /// 
  /// [ownerId] : L'identifiant du propriétaire
  /// Retourne la liste des réservations du jour
  Future<List<Booking>> getTodayBookings(String ownerId);
}

