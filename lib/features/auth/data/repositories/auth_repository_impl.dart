import 'package:email_auth/email_auth.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../../../../core/utils/error_handler.dart';

/// Implémentation du repository d'authentification
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final EmailAuth emailAuth;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    EmailAuth? emailAuth,
  }) : emailAuth = emailAuth ?? EmailAuth(sessionName: "Salon App Session");

  @override
  Future<User> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      
      // Sauvegarder l'utilisateur localement
      await localDataSource.saveUser(userModel);
      
      return userModel.toEntity();
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<User> register({
    required String email,
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        password: password,
      );
      
      // Sauvegarder l'utilisateur localement
      await localDataSource.saveUser(userModel);
      
      return userModel.toEntity();
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Nettoyer les données locales
      await localDataSource.clearUser();
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<bool> verifyEmail(String email, String otp) async {
    try {
      final result = emailAuth.validateOtp(
        recipientMail: email,
        userOtp: otp,
      );
      return result;
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<bool> sendOtp(String email) async {
    try {
      final result = await emailAuth.sendOtp(
        recipientMail: email,
        otpLength: 5,
      );
      return result;
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userModel = await localDataSource.getSavedUser();
      return userModel?.toEntity();
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return await localDataSource.isUserLoggedIn();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      return await remoteDataSource.forgotPassword(email);
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<bool> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      return await remoteDataSource.changePassword(
        email: email,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }
}

