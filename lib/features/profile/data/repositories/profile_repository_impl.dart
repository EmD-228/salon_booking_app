import 'dart:io';
import '../../../../core/utils/error_handler.dart';
import '../../../auth/domain/entities/user.dart';
import '../datasources/profile_remote_datasource.dart';
import '../../domain/repositories/profile_repository.dart';

/// Implémentation du repository Profile
/// 
/// Coordonne les appels aux sources de données
/// et convertit les modèles en entités
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> getProfile(String email) async {
    try {
      final model = await remoteDataSource.getProfile(email);
      return model.toEntity();
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<User> updateProfile({
    required String email,
    String? name,
    String? phoneNumber,
  }) async {
    try {
      final model = await remoteDataSource.updateProfile(
        email: email,
        name: name,
        phoneNumber: phoneNumber,
      );
      return model.toEntity();
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<String> uploadProfileImage({
    required String email,
    required File imageFile,
  }) async {
    try {
      return await remoteDataSource.uploadProfileImage(
        email: email,
        imageFile: imageFile,
      );
    } catch (e) {
      throw Exception(ErrorHandler.getErrorMessage(e));
    }
  }
}

