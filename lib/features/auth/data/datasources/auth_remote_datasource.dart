import '../../../../core/network/api_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/error_handler.dart';
import '../models/user_model.dart';

/// Data source pour les opérations d'authentification distantes
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String email,
    required String name,
    required String phoneNumber,
    required String password,
  });
  Future<bool> forgotPassword(String email);
  Future<bool> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final responseData = response.data;
      
      // L'API retourne "Success" en cas de succès
      if (responseData is String && responseData == 'Success') {
        // Si l'API ne retourne pas les données utilisateur, on les récupère séparément
        // Pour l'instant, on retourne un UserModel basique
        // TODO: Adapter selon la réponse réelle de l'API
        return UserModel(
          email: email,
          name: '', // Sera récupéré depuis user_data.php
          phoneNumber: null,
        );
      } else {
        throw AuthException('Login failed: Invalid credentials');
      }
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<UserModel> register({
    required String email,
    required String name,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        data: {
          'email': email,
          'name': name,
          'number': phoneNumber,
          'password': password,
        },
      );

      final responseData = response.data;
      
      if (responseData is String && responseData == 'Success') {
        return UserModel(
          email: email,
          name: name,
          phoneNumber: phoneNumber,
        );
      } else {
        throw AuthException('Registration failed: ${responseData.toString()}');
      }
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.forgetPassword,
        data: {'email': email},
      );

      final responseData = response.data;
      return responseData is String && responseData == 'Success';
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
      final response = await apiClient.post(
        ApiEndpoints.changePassword,
        data: {
          'email': email,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      final responseData = response.data;
      return responseData is String && responseData == 'Success';
    } catch (e) {
      throw AuthException(ErrorHandler.getErrorMessage(e));
    }
  }
}

