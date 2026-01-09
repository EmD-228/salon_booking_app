import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

/// Usecase pour mettre à jour le profil utilisateur
class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  /// Exécute le usecase et retourne l'utilisateur mis à jour
  /// 
  /// [email] : L'email de l'utilisateur
  /// [name] : Le nouveau nom (optionnel)
  /// [phoneNumber] : Le nouveau numéro de téléphone (optionnel)
  Future<User> call({
    required String email,
    String? name,
    String? phoneNumber,
  }) async {
    if (email.trim().isEmpty) {
      throw Exception('Email cannot be empty');
    }
    return await repository.updateProfile(
      email: email.trim(),
      name: name?.trim(),
      phoneNumber: phoneNumber?.trim(),
    );
  }
}

