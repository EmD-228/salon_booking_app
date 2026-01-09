import '../repositories/auth_repository.dart';
import '../../../../core/utils/error_handler.dart';

/// Use case pour la vérification d'email avec OTP
class VerifyEmailUsecase {
  final AuthRepository repository;

  VerifyEmailUsecase(this.repository);

  Future<bool> call(String email, String otp) async {
    if (email.isEmpty) {
      throw AuthException('Email cannot be empty');
    }
    if (otp.isEmpty) {
      throw AuthException('OTP cannot be empty');
    }
    
    return await repository.verifyEmail(email, otp);
  }
}

