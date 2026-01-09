import '../../../auth/domain/entities/user.dart';
import 'dart:io';

/// Interface du repository pour les opérations sur le profil utilisateur
abstract class ProfileRepository {
  /// Récupère les détails du profil utilisateur
  /// 
  /// [email] : L'email de l'utilisateur
  /// Retourne les détails de l'utilisateur ou lance une exception
  Future<User> getProfile(String email);

  /// Met à jour le profil utilisateur
  /// 
  /// [email] : L'email de l'utilisateur
  /// [name] : Le nouveau nom (optionnel)
  /// [phoneNumber] : Le nouveau numéro de téléphone (optionnel)
  /// Retourne l'utilisateur mis à jour
  Future<User> updateProfile({
    required String email,
    String? name,
    String? phoneNumber,
  });

  /// Upload une image de profil
  /// 
  /// [email] : L'email de l'utilisateur
  /// [imageFile] : Le fichier image à uploader
  /// Retourne l'URL de l'image uploadée
  Future<String> uploadProfileImage({
    required String email,
    required File imageFile,
  });
}

