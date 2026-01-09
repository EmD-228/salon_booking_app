import '../repositories/auth_repository.dart';
import '../../../../core/utils/error_handler.dart';

/// Use case pour le changement de mot de passe
class ChangePasswordUsecase {
  final AuthRepository repository;

  ChangePasswordUsecase(this.repository);

  Future<bool> call({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    if (email.isEmpty) {
      throw AuthException('Email cannot be empty');
    }
    if (oldPassword.isEmpty) {
      throw AuthException('Old password cannot be empty');
    }
    if (newPassword.isEmpty) {
      throw AuthException('New password cannot be empty');
    }
    
    if (newPassword.length < 6) {
      throw AuthException('New password must be at least 6 characters');
    }
    
    return await repository.changePassword(
      email: email,
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}

