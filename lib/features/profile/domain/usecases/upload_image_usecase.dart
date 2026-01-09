import 'dart:io';
import '../repositories/profile_repository.dart';

/// Usecase pour uploader une image de profil
class UploadImageUsecase {
  final ProfileRepository repository;

  UploadImageUsecase(this.repository);

  /// Exécute le usecase et retourne l'URL de l'image uploadée
  /// 
  /// [email] : L'email de l'utilisateur
  /// [imageFile] : Le fichier image à uploader
  Future<String> call({
    required String email,
    required File imageFile,
  }) async {
    if (email.trim().isEmpty) {
      throw Exception('Email cannot be empty');
    }
    if (!await imageFile.exists()) {
      throw Exception('Image file does not exist');
    }
    return await repository.uploadProfileImage(
      email: email.trim(),
      imageFile: imageFile,
    );
  }
}

