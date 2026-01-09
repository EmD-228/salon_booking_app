import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../data/providers/auth_data_providers.dart';

/// Provider pour LoginUsecase
final loginUsecaseProvider = FutureProvider<LoginUsecase>((ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return LoginUsecase(repository);
});

/// Provider pour RegisterUsecase
final registerUsecaseProvider = FutureProvider<RegisterUsecase>((ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return RegisterUsecase(repository);
});

/// Provider pour LogoutUsecase
final logoutUsecaseProvider = FutureProvider<LogoutUsecase>((ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return LogoutUsecase(repository);
});

/// Provider pour VerifyEmailUsecase
final verifyEmailUsecaseProvider =
    FutureProvider<VerifyEmailUsecase>((ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return VerifyEmailUsecase(repository);
});

/// Provider pour SendOtpUsecase
final sendOtpUsecaseProvider = FutureProvider<SendOtpUsecase>((ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return SendOtpUsecase(repository);
});

/// Provider pour ForgotPasswordUsecase
final forgotPasswordUsecaseProvider =
    FutureProvider<ForgotPasswordUsecase>((ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return ForgotPasswordUsecase(repository);
});

/// Provider pour ChangePasswordUsecase
final changePasswordUsecaseProvider =
    FutureProvider<ChangePasswordUsecase>((ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return ChangePasswordUsecase(repository);
});

/// Provider pour GetCurrentUserUsecase
final getCurrentUserUsecaseProvider =
    FutureProvider<GetCurrentUserUsecase>((ref) async {
  final repository = await ref.watch(authRepositoryProvider.future);
  return GetCurrentUserUsecase(repository);
});

/// Notifier principal pour l'authentification
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final getCurrentUserUsecase = await ref.read(getCurrentUserUsecaseProvider.future);
      final user = await getCurrentUserUsecase();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Connecte un utilisateur
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();

    try {
      final loginUsecase = await ref.read(loginUsecaseProvider.future);
      final user = await loginUsecase(email, password);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Enregistre un nouvel utilisateur
  Future<void> register({
    required String email,
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      final registerUsecase = await ref.read(registerUsecaseProvider.future);
      final user = await registerUsecase(
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        password: password,
      );
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Déconnecte l'utilisateur
  Future<void> logout() async {
    state = const AsyncValue.loading();

    try {
      final logoutUsecase = await ref.read(logoutUsecaseProvider.future);
      await logoutUsecase();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Vérifie l'email avec OTP
  Future<bool> verifyEmail(String email, String otp) async {
    try {
      final verifyEmailUsecase = await ref.read(verifyEmailUsecaseProvider.future);
      return await verifyEmailUsecase(email, otp);
    } catch (e) {
      return false;
    }
  }

  /// Envoie un code OTP
  Future<bool> sendOtp(String email) async {
    try {
      final sendOtpUsecase = await ref.read(sendOtpUsecaseProvider.future);
      return await sendOtpUsecase(email);
    } catch (e) {
      return false;
    }
  }

  /// Récupère le mot de passe oublié
  Future<bool> forgotPassword(String email) async {
    try {
      final forgotPasswordUsecase = await ref.read(forgotPasswordUsecaseProvider.future);
      return await forgotPasswordUsecase(email);
    } catch (e) {
      return false;
    }
  }

  /// Change le mot de passe
  Future<bool> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final changePasswordUsecase = await ref.read(changePasswordUsecaseProvider.future);
      return await changePasswordUsecase(
        email: email,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      return false;
    }
  }

  /// Rafraîchit l'utilisateur actuel
  Future<void> refreshUser() async {
    try {
      final getCurrentUserUsecase = await ref.read(getCurrentUserUsecaseProvider.future);
      final user = await getCurrentUserUsecase();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Provider pour AuthNotifier
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});
