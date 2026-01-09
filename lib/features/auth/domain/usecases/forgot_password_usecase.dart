import '../repositories/auth_repository.dart';
import '../../../../core/utils/error_handler.dart';

/// Use case pour la récupération de mot de passe
class ForgotPasswordUsecase {
  final AuthRepository repository;

  ForgotPasswordUsecase(this.repository);

  Future<bool> call(String email) async {
    if (email.isEmpty) {
      throw AuthException('Email cannot be empty');
    }
    
    if (!email.contains('@')) {
      throw AuthException('Invalid email format');
    }
    
    return await repository.forgotPassword(email);
  }
}

