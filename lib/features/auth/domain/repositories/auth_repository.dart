import '../entities/user.dart';

/// Interface du repository d'authentification
/// Définit les contrats pour les opérations d'authentification
abstract class AuthRepository {
  /// Connecte un utilisateur avec email et mot de passe
  Future<User> login(String email, String password);

  /// Enregistre un nouvel utilisateur
  Future<User> register({
    required String email,
    required String name,
    required String phoneNumber,
    required String password,
  });

  /// Déconnecte l'utilisateur actuel
  Future<void> logout();

  /// Vérifie l'email avec un code OTP
  Future<bool> verifyEmail(String email, String otp);

  /// Envoie un code OTP à l'email
  Future<bool> sendOtp(String email);

  /// Récupère l'utilisateur actuellement connecté
  Future<User?> getCurrentUser();

  /// Vérifie si un utilisateur est connecté
  Future<bool> isLoggedIn();

  /// Récupère le mot de passe oublié
  Future<bool> forgotPassword(String email);

  /// Change le mot de passe
  Future<bool> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  });
}

