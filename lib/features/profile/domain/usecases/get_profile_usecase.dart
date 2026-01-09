import '../../../auth/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

/// Usecase pour récupérer le profil utilisateur
class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  /// Exécute le usecase et retourne le profil de l'utilisateur
  /// 
  /// [email] : L'email de l'utilisateur
  Future<User> call(String email) async {
    if (email.trim().isEmpty) {
      throw Exception('Email cannot be empty');
    }
    return await repository.getProfile(email.trim());
  }
}

