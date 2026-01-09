import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case pour récupérer l'utilisateur actuellement connecté
class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  Future<User?> call() async {
    return await repository.getCurrentUser();
  }
}

