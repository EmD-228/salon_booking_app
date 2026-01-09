import '../repositories/auth_repository.dart';
import '../../../../core/utils/error_handler.dart';

/// Use case pour l'envoi d'un code OTP
class SendOtpUsecase {
  final AuthRepository repository;

  SendOtpUsecase(this.repository);

  Future<bool> call(String email) async {
    if (email.isEmpty) {
      throw AuthException('Email cannot be empty');
    }
    
    if (!email.contains('@')) {
      throw AuthException('Invalid email format');
    }
    
    return await repository.sendOtp(email);
  }
}

