import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/utils/error_handler.dart';

/// Use case pour la connexion d'un utilisateur
class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<User> call(String email, String password) async {
    if (email.isEmpty) {
      throw AuthException('Email cannot be empty');
    }
    if (password.isEmpty) {
      throw AuthException('Password cannot be empty');
    }
    
    return await repository.login(email, password);
  }
}

