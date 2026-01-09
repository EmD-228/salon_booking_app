import '../entities/owner.dart';
import '../repositories/owner_repository.dart';

/// Usecase pour connecter un propriétaire
class LoginOwnerUsecase {
  final OwnerRepository repository;

  LoginOwnerUsecase(this.repository);

  /// Exécute le usecase et retourne les informations du propriétaire
  /// 
  /// [id] : L'identifiant du salon
  /// [email] : L'email du propriétaire
  /// [phoneNumber] : Le numéro de téléphone du propriétaire
  Future<Owner> call({
    required String id,
    required String email,
    required String phoneNumber,
  }) async {
    if (id.trim().isEmpty) {
      throw Exception('Salon ID cannot be empty');
    }
    if (email.trim().isEmpty) {
      throw Exception('Email cannot be empty');
    }
    if (phoneNumber.trim().isEmpty) {
      throw Exception('Phone number cannot be empty');
    }

    return await repository.loginOwner(
      id: id.trim(),
      email: email.trim(),
      phoneNumber: phoneNumber.trim(),
    );
  }
}

