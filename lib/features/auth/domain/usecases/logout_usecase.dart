import '../repositories/auth_repository.dart';

/// Use case pour la déconnexion d'un utilisateur
class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<void> call() async {
    return await repository.logout();
  }
}

