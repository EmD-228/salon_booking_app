import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../../../core/utils/error_handler.dart';

/// Use case pour l'enregistrement d'un nouvel utilisateur
class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<User> call({
    required String email,
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    if (email.isEmpty) {
      throw AuthException('Email cannot be empty');
    }
    if (name.isEmpty) {
      throw AuthException('Name cannot be empty');
    }
    if (phoneNumber.isEmpty) {
      throw AuthException('Phone number cannot be empty');
    }
    if (password.isEmpty) {
      throw AuthException('Password cannot be empty');
    }
    
    // Validation basique de l'email
    if (!email.contains('@')) {
      throw AuthException('Invalid email format');
    }
    
    return await repository.register(
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      password: password,
    );
  }
}

